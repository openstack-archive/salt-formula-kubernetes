{%- from "kubernetes/map.jinja" import master with context %}
{%- if master.enabled %}

{%- if not pillar.kubernetes.pool is defined %}

/etc/default/kubelet:
  file.managed:
  - source: salt://kubernetes/files/kubelet/default.master
  - template: jinja
  - user: root
  - group: root
  - mode: 644

/etc/kubernetes/config:
  file.absent

master_services:
  service.running:
  - names: {{ master.services }}
  - enable: True
  - watch:
    - file: /etc/default/kubelet

{%- endif %}

{%- for name,namespace in master.namespace.iteritems() %}

{%- if namespace.enabled %}

/registry/namespaces/{{ name }}:
  etcd.set:
    - value: '{"kind":"Namespace","apiVersion":"v1","metadata":{"name":"{{ name }}"},"spec":{"finalizers":["kubernetes"]},"status":{"phase":"Active"}}'

{%- else %}

/registry/namespaces/{{ name }}:
  etcd.rm

{%- endif %}

{%- endfor %}

{%- if master.registry.secret is defined %}

{%- for name,registry in master.registry.secret.iteritems() %}

{%- if registry.enabled %}

/registry/secrets/{{ registry.namespace }}/{{ name }}:
  etcd.set:
    - value: '{"kind":"Secret","apiVersion":"v1","metadata":{"name":"{{ name }}","namespace":"{{ registry.namespace }}"},"data":{".dockerconfigjson":"{{ registry.key }}"},"type":"kubernetes.io/dockerconfigjson"}'

{%- else %}

/registry/secrets/{{ registry.namespace }}/{{ name }}:
  etcd.rm

{%- endif %}

{%- endfor %}

{%- endif %}

{%- endif %}