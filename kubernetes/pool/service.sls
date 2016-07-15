{%- from "kubernetes/map.jinja" import pool with context %}
{%- from "kubernetes/map.jinja" import common with context %}
{%- if pool.enabled %}

include:
- kubernetes._common

kubernetes_pool_container_grains_dir:
  file.directory:
  - name: /etc/salt/grains.d
  - mode: 700
  - makedirs: true
  - user: root

kubernetes_pool_container_grain:
  file.managed:
  - name: /etc/salt/grains.d/kubernetes
  - source: salt://kubernetes/files/kubernetes.grain
  - template: jinja
  - mode: 600
  - require:
    - file: kubernetes_pool_container_grains_dir

{%- endif %}