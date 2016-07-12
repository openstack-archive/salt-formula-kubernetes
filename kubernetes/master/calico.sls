{%- from "kubernetes/map.jinja" import master with context %}
{%- if master.enabled %}

/etc/kubernetes/manifests/calico-etcd.manifest:
  file.managed:
    - source: salt://kubernetes/files/manifest/calico-etcd.manifest
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - dir_mode: 755
    - template: jinja

{%- if not pillar.kubernetes.pool is defined %}

/etc/calico/network-environment:
  file.managed:
    - source: salt://kubernetes/files/calico/network-environment.master
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - dir_mode: 755
    - template: jinja

/etc/systemd/calico-node.service:
  file.managed:
    - source: salt://kubernetes/files/calico/calico-node.service
    - user: root
    - group: root

/usr/bin/calicoctl:
  file.managed:
     - source: https://github.com/projectcalico/calico-containers/releases/download/{{ master.network.version }}/calicoctl
     - source_hash: md5={{ master.network.hash }}
     - mode: 751
     - user: root
     - group: root

calico_node:
  service.running:
  - name: calico-node
  - enable: True
  - watch:
    - file: /etc/systemd/calico-node.service

{%- endif %}

{%- endif %}