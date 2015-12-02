
{%- if pillar.kubernetes is defined %}
include:
{%- if pillar.kubernetes.master is defined %}
- kubernetes.master
{%- endif %}
{%- if pillar.kubernetes.pool is defined %}
- kubernetes.pool
{%- endif %}
{%- if pillar.kubernetes.control is defined %}
- kubernetes.control
{%- endif %}
{%- endif %}
