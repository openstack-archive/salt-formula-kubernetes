{%- from "kubernetes/map.jinja" import pool with context %}
{%- if pool.enabled %}

/usr/bin/calicoctl:
  file.managed:
     - source: https://github.com/projectcalico/calico-containers/releases/download/{{ pool.network.version }}/calicoctl
     - source_hash: md5={{ pool.network.hash }}
     - mode: 751
     - user: root
     - group: root

/opt/cni/bin/calico:
  file.managed:
     - source: https://github.com/projectcalico/calico-cni/releases/download/v1.0.0/calico
     - source_hash: md5=c829450f7e9d7abe81b3a8b37fc787a4
     - mode: 751
     - makedirs: true
     - user: root
     - group: root

/opt/cni/bin/calico-ipam:
  file.managed:
     - source: https://github.com/projectcalico/calico-cni/releases/download/v1.0.0/calico-ipam
     - source_hash: md5=a40d4db5b3acbb6dc93330b84d25d936
     - mode: 751
     - makedirs: true
     - user: root
     - group: root

/etc/cni/net.d/10-calico.conf:
  file.managed:
    - source: salt://kubernetes/files/calico/calico.conf
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - dir_mode: 755
    - template: jinja

/etc/calico/network-environment:
  file.managed:
    - source: salt://kubernetes/files/calico/network-environment.pool
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

calico_node:
  service.running:
  - name: calico-node
  - enable: True
  - watch:
    - file: /etc/systemd/calico-node.service

{%- endif %}