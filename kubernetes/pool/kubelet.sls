{%- from "kubernetes/map.jinja" import pool with context %}
{%- if pool.enabled %}

/etc/default/kubelet:
  file.managed:
  - source: salt://kubernetes/files/kubelet/default.pool
  - template: jinja
  - user: root
  - group: root
  - mode: 644

/etc/kubernetes/kubelet.kubeconfig:
  file.managed:
    - source: salt://kubernetes/files/kubelet/kubelet.kubeconfig
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true

/etc/kubernetes/config:
  file.absent

pool_services:
  service.running:
  - names: {{ pool.services }}
  - enable: True
  - watch:
    - file: /etc/default/kubelet

{%- endif %}