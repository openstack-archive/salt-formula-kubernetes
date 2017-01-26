{%- from "kubernetes/map.jinja" import master with context %}
include:
- kubernetes.master.service
- kubernetes.master.kube-addons
{%- if master.network.engine == "opencontrail" %}
- kubernetes.master.opencontrail-network-manager
{%- endif %}
{%- if master.network.engine == "flannel" %}
- kubernetes.master.flannel
{%- endif %}
{%- if master.network.engine == "calico" %}
{%- if not pillar.kubernetes.pool is defined %}
- kubernetes.master.calico
{%- endif %}
{%- endif %}
{%- if master.storage.get('engine', 'none') == 'glusterfs' %}
- kubernetes.master.glusterfs
{%- endif %}
- kubernetes.master.controller
- kubernetes.master.setup
