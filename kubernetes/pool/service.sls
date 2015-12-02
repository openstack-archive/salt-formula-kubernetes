{%- from "kubernetes/map.jinja" import pool with context %}
{%- from "kubernetes/map.jinja" import common with context %}
{%- if pool.enabled %}

include:
- kubernetes._common

kubernetes_pool_binaries:
  cmd.run:
  - names: 
    - "cp /root/apt.tcpcloud.eu/kubernetes/bin/{{ common.binaries_version }}/kube-proxy /usr/local/bin/"
    - "cp /root/apt.tcpcloud.eu/kubernetes/bin/{{ common.binaries_version }}/kubectl /usr/bin/"
    - "cp /root/apt.tcpcloud.eu/kubernetes/bin/{{ common.binaries_version }}/kubelet /usr/local/bin/"
  - unless: test -f /usr/local/bin/kubelet && test -f /usr/local/bin/kube-proxy && test -f /usr/bin/kubectl
  - require:
    - cmd: kubernetes_binaries

{%- endif %}