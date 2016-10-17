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

/srv/kubernetes/{{ service.cluster }}/{{ service_name }}-{{ service.kind }}.yml:
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
/srv/kubernetes/{{ service.cluster }}/{{ node_name }}-{{ service.kind }}.yml:
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

{%- else %}
{# TODO: configmap not using support between formulas #}
{%- endif %}

{%- endif %}
{%- endfor %}

{%- endif %}
