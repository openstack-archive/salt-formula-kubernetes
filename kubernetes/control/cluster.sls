{% from "kubernetes/map.jinja" import control with context %}
{%- if control.enabled %}

/srv/kubernetes:
  file.directory:
  - makedirs: true

{%- if control.job is defined %}

{%- for job_name, job in control.job.iteritems() %}

/srv/kubernetes/jobs/{{ job_name }}-job.yml:
  file.managed:
  - source: salt://kubernetes/files/job.yml
  - user: root
  - group: root
  - template: jinja
  - makedirs: true
  - require:
    - file: /srv/kubernetes
  - defaults:
      job: {{ job|yaml }}

{%- endfor %}

{%- endif %}

{%- for service_name, service in control.service.iteritems() %}

{%- if service.enabled %}

/srv/kubernetes/services/{{ service.cluster }}/{{ service_name }}-svc.yml:
  file.managed:
  - source: salt://kubernetes/files/svc.yml
  - user: root
  - group: root
  - template: jinja
  - makedirs: true
  - require:
    - file: /srv/kubernetes
  - defaults:
      service: {{ service|yaml }}

{%- endif %}

/srv/kubernetes/{{ service.kind|lower }}/{{ service_name }}-{{ service.kind }}.yml:
  file.managed:
  - source: salt://kubernetes/files/rc.yml
  - user: root
  - group: root
  - template: jinja
  - makedirs: true
  - require:
    - file: /srv/kubernetes
  - defaults:
      service: {{ service|yaml }}

{%- endfor %}

{%- for node_name, node_grains in salt['mine.get']('*', 'grains.items').iteritems() %}

{%- if node_grains.get('kubernetes', {}).service is defined %}

{%- set service = node_grains.get('kubernetes', {}).get('service', {}) %}

{%- if service.enabled %}

/srv/kubernetes/services/{{ node_name }}-svc.yml:
  file.managed:
  - source: salt://kubernetes/files/svc.yml
  - user: root
  - group: root
  - template: jinja
  - makedirs: true
  - require:
    - file: /srv/kubernetes
  - defaults:
      service: {{ service|yaml }}

{%- endif %}
/srv/kubernetes/{{ service.kind|lower }}/{{ node_name }}-{{ service.kind }}.yml:
  file.managed:
  - source: salt://kubernetes/files/rc.yml
  - user: root
  - group: root
  - template: jinja
  - makedirs: true
  - require:
    - file: /srv/kubernetes
  - defaults:
      service: {{ service|yaml }}

{%- endif %}

{%- endfor %}

{%- for configmap_name, configmap in control.get('configmap', {}).iteritems() %}
{%- if configmap.enabled|default(True) %}

{%- if configmap.pillar is defined %}
{%- if control.config_type == "default" %}
  {%- for service_name in configmap.pillar.keys() %}
    {%- if pillar.get(service_name, {}).get('_support', {}).get('config', {}).get('enabled', False) %}

      {%- set support_fragment_file = service_name+'/meta/config.yml' %}
      {% macro load_support_file(pillar, grains) %}{% include support_fragment_file %}{% endmacro %}

      {%- set service_config_files = load_support_file(configmap.pillar, configmap.get('grains', {}))|load_yaml %}
      {%- for service_config_name, service_config in service_config_files.config.iteritems() %}

/srv/kubernetes/configmap/{{ configmap_name }}/{{ service_config_name }}:
  file.managed:
  - source: {{ service_config.source }}
  - user: root
  - group: root
  - template: {{ service_config.template }}
  - makedirs: true
  - require:
    - file: /srv/kubernetes
  - defaults:
      pillar: {{ configmap.pillar|yaml }}
      grains: {{ configmap.get('grains', {}) }}

      {%- endfor %}
    {%- endif %}
  {%- endfor %}

{%- else %}

/srv/kubernetes/configmap/{{ configmap_name }}.yml:
  file.managed:
  - source: salt://kubernetes/files/configmap.yml
  - user: root
  - group: root
  - template: jinja
  - makedirs: true
  - require:
    - file: /srv/kubernetes
  - defaults:
      configmap_name: {{ configmap_name }}
      configmap: {{ configmap|yaml }}
      grains: {{ configmap.get('grains', {}) }}

{%- endif %}

{%- else %}
{# TODO: configmap not using support between formulas #}
{%- endif %}

{%- endif %}
{%- endfor %}

{%- endif %}
