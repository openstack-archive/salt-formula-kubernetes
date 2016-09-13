{%- from "kubernetes/map.jinja" import pool with context %}
{%- if pool.enabled %}

/usr/bin/calicoctl:
  file.managed:
     - source: {{ pool.network.get('source', 'https://github.com/projectcalico/calico-containers/releases/download/') }}{{ pool.network.version }}/calicoctl
     - source_hash: md5={{ pool.network.hash }}
     - mode: 751
     - user: root
     - group: root

/opt/cni/bin/calico:
  file.managed:
     - source: {{ pool.network.cni.get('source', 'https://github.com/projectcalico/calico-cni/releases/download/') }}{{ pool.network.cni.version }}/calico
     - source_hash: md5={{ pool.network.cni.hash }}
     - mode: 751
     - makedirs: true
     - user: root
     - group: root

/opt/cni/bin/calico-ipam:
  file.managed:
     - source: {{ pool.network.ipam.get('source', 'https://github.com/projectcalico/calico-cni/releases/download/') }}{{ pool.network.ipam.version }}/calico-ipam
     - source_hash: md5={{ pool.network.ipam.hash }}
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

# /etc/systemd/system/calico-node.service:
#   file.managed:
#     - source: salt://kubernetes/files/calico/calico-node.service
#     - user: root
#     - group: root

# calico_node:
#   service.running:
#   - name: calico-node
#   - enable: True
#   - watch:
#     - file: /etc/systemd/system/calico-node.service

{%- endif %}