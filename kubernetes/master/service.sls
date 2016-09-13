{%- from "kubernetes/map.jinja" import master with context %}
{%- from "kubernetes/map.jinja" import common with context %}
{%- if master.enabled %}

include:
- kubernetes._common

{%- endif %}
