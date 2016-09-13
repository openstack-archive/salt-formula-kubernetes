{%- from "kubernetes/map.jinja" import master with context %}
{%- if master.enabled %}

/etc/calico/network-environment:
  file.managed:
    - source: salt://kubernetes/files/calico/network-environment.master
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

/usr/bin/calicoctl:
  file.managed:
     - source: {{ master.network.get('source', 'https://github.com/projectcalico/calico-containers/releases/download/') }}{{ master.network.version }}/calicoctl
     - source_hash: md5={{ master.network.hash }}
     - mode: 751
     - user: root
     - group: root

# calico_node:
#   service.running:
#   - name: calico-node
#   - enable: True
#   - watch:
#     - file: /etc/systemd/system/calico-node.service

{%- endif %}