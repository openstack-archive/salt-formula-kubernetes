{% from "kubernetes/map.jinja" import common with context %}

kubernetes_pkgs:
  pkg.installed:
  - names: {{ common.pkgs }}

{%- if common.network.get('engine', 'none') == 'flannel' %}
flannel-tar:
  archive:
    - extracted
    - user: root
    - name: /usr/local/src
    - makedirs: True
    - source: https://storage.googleapis.com/kubernetes-release/flannel/flannel-0.5.5-linux-amd64.tar.gz
    - tar_options: v
    - source_hash: md5=972c717254775bef528f040af804f2cc
    - archive_format: tar
    - if_missing: /usr/local/src/flannel/flannel-0.5.5/
{%- endif %}