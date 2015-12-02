{%- from "kubernetes/map.jinja" import master with context %}
{%- from "kubernetes/map.jinja" import common with context %}
{%- from "linux/map.jinja" import system with context %}
{%- if master.enabled %}

include:
- kubernetes._common

kubernetes_master_binaries:
  cmd.run:
  - names: 
    - "cp /root/apt.tcpcloud.eu/kubernetes/bin/{{ common.binaries_version }}/kubectl /usr/bin/"
    - "cp /root/apt.tcpcloud.eu/kubernetes/bin/{{ common.binaries_version }}/kubelet /usr/local/bin/"
    - "cp /root/etcd-v2.2.1-linux-amd64/etcdctl /usr/bin/"
  - unless: test -f /usr/local/bin/kubelet && test -f /usr/bin/kubectl && test -f /usr/bin/etcdctl
  - require:
    - cmd: kubernetes_binaries

kubernetes_master_cert_group:
  group.present:
  - name: kube-cert
  - system: True

kubernetes_master_cert_dir:
  file.directory:
  - name: /srv/kubernetes/
  - mode: 750
  - group: kube-cert
  - makedirs: True
  - requires:
    - group: kubernetes_master_cert_group

{%- endif %}