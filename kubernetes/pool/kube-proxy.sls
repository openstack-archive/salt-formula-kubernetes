{%- from "kubernetes/map.jinja" import pool with context %}
{%- if pool.enabled %}

{%- if pool.get('container', 'true') %}

/etc/kubernetes/manifests/kube-proxy.manifest:
  file.managed:
    - source: salt://kubernetes/files/manifest/kube-proxy.manifest.pool
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - dir_mode: 755

{%- else %}

/etc/kubernetes/proxy.kubeconfig:
  file.managed:
    - source: salt://kubernetes/files/kube-proxy/proxy.kubeconfig
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true

/etc/systemd/system/kube-proxy.service:
  file.managed:
  - source: salt://kubernetes/files/systemd/kube-proxy.service
  - template: jinja
  - user: root
  - group: root
  - mode: 644

/etc/default/kube-proxy:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: DAEMON_ARGS=" --logtostderr=true --v=2 --kubeconfig=/etc/kubernetes/proxy.kubeconfig --master={%- if pool.apiserver.insecure.enabled %}http://{{ pool.apiserver.host }}:8080{%- else %}https://{{ pool.apiserver.host }}{%- endif %}{%- if pool.network.engine == 'calico' %} --proxy-mode=iptables{% endif %}"

pool_services:
  service.running:
  - names: {{ pool.services }}
  - enable: True
  - watch:
    - file: /etc/default/kube-proxy

{%- endif %}

{%- endif %}
