{%- from "kubernetes/map.jinja" import master with context %}
{%- from "kubernetes/map.jinja" import common with context %}
{%- from "linux/map.jinja" import system with context %}
{%- if master.enabled %}

include:
- kubernetes._common

kubernetes_master_pkgs:
  pkg.installed:
  - names: {{ master.pkgs }}

{%- endif %}