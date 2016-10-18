{%- from "kubernetes/map.jinja" import pool with context %}
{%- if pool.enabled %}

cni-tar:
  archive:
    - extracted
    - user: root
    - name: /opt/cni/bin
    - source: https://github.com/containernetworking/cni/releases/download/{{ pool.cni.version }}/cni-{{ pool.cni.version }}.tgz
    - tar_options: v
    - source_hash: md5={{ pool.cni.hash }}
    - archive_format: tar
    - if_missing: /usr/local/src/cni/cni-{{ pool.cni.version }}/

{%- endif %}