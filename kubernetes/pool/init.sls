{%- from "kubernetes/map.jinja" import pool with context %}
include:
- kubernetes.pool.cni
- kubernetes.pool.service
{%- if pool.network.engine == "calico" %}
- kubernetes.pool.calico
{%- endif %}
- kubernetes.pool.kubelet
{%- if pool.network.engine == "flannel" %}
- kubernetes.pool.flannel
{%- endif %}
- kubernetes.pool.kube-proxy
