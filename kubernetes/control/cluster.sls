{% from "kubernetes/map.jinja" import control with context %}
{%- if control.enabled %}

/srv/kubernetes:
  file.directory:
  - makedirs: true

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

{%- endif %}