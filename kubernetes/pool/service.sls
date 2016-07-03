{%- from "kubernetes/map.jinja" import pool with context %}
{%- from "kubernetes/map.jinja" import common with context %}
{%- if pool.enabled %}

include:
- kubernetes._common

{%- endif %}