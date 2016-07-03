{%- from "kubernetes/map.jinja" import pool with context %}
{%- if pool.enabled %}

/etc/kubernetes/manifests/kube-proxy.manifest:
  file.managed:
    - source: salt://kubernetes/files/manifest/kube-proxy.manifest.pool
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - dir_mode: 755

/etc/kubernetes/proxy.kubeconfig:
  file.managed:
    - source: salt://kubernetes/files/kube-proxy/proxy.kubeconfig
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true


{%- endif %}