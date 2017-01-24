{%- from "kubernetes/map.jinja" import pool with context %}
{%- if pool.enabled %}

{%- if pool.host.label is defined %}

{%- for name,label in pool.host.label.iteritems() %}

{%- if label.enabled %}

{{ name }}:
  k8s.label_present:
    - name: {{ name }}
    - value: {{ label.value }}
    - node: {{ pool.host.name }}
    - apiserver: http://{{ pool.apiserver.host }}:8080

{%- else %}

{{ name }}:
  k8s.label_absent:
    - name: {{ name }}
    - node: {{ pool.host.name }}
    - apiserver: http://{{ pool.apiserver.host }}:8080

{%- endif %}

{%- endfor %}

{%- endif %}

{%- endif %}
