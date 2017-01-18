{%- from "kubernetes/map.jinja" import pool with context %}
include:
- kubernetes.pool.cni
{%- if pool.network.engine == "calico" %}
- kubernetes.pool.calico
{%- endif %}
- kubernetes.pool.service
- kubernetes.pool.kubelet
{%- if pool.network.engine == "flannel" %}
- kubernetes.pool.flannel
{%- endif %}
- kubernetes.pool.kube-proxy
