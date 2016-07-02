{%- from "kubernetes/map.jinja" import master with context %}
{%- if master.enabled %}

/etc/default/kubelet:
  file.managed:
  - source: salt://kubernetes/files/kubelet/default.master
  - template: jinja
  - user: root
  - group: root
  - mode: 644

/etc/kubernetes/config:
  file.absent

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

master_services:
  service.running:
  - names: {{ master.services }}
  - enable: True
  - watch:
    - file: /etc/default/kubelet

{%- endif %}