{% from "kubernetes/map.jinja" import common with context %}

kubernetes_pkgs:
  pkg.installed:
  - names: {{ common.pkgs }}

kubernetes_binaries:
  cmd.run:
  - name: 'wget -r --no-parent --reject "index.html*" http://apt.tcpcloud.eu/kubernetes/bin/{{ common.binaries_version }}/ && chmod +x -R /root/apt.tcpcloud.eu/kubernetes/bin/{{ common.binaries_version }}/*'
  - pwd: /root
  - unless: test -d /root/apt.tcpcloud.eu/kubernetes/bin/

etcdctl_binaries:
  cmd.run:
  - name: "curl -L  https://github.com/coreos/etcd/releases/download/v2.2.1/etcd-v2.2.1-linux-amd64.tar.gz -o etcd-v2.2.1-linux-amd64.tar.gz;tar -zxvf etcd-v2.2.1-linux-amd64.tar.gz"
  - pwd: /root
  - unless: test -f /root/etcd-v2.2.1-linux-amd64.tar.gz

{%- if common.network.get('engine', 'none') == 'flannel' %}
flannel-tar:
  archive:
    - extracted
    - user: root
    - name: /usr/local/src
    - makedirs: True
    - source: https://storage.googleapis.com/kubernetes-release/flannel/flannel-0.5.5-linux-amd64.tar.gz
    - tar_options: v
    - source_hash: md5=972c717254775bef528f040af804f2cc
    - archive_format: tar
    - if_missing: /usr/local/src/flannel/flannel-0.5.5/
{%- endif %}