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

master_services:
  service.running:
  - names: {{ master.services }}
  - enable: True
  - watch:
    - file: /etc/default/kubelet

{%- endif %}