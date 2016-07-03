{%- from "kubernetes/map.jinja" import pool with context %}
{%- if pool.enabled %}

flannel-tar:
  archive:
    - extracted
    - user: root
    - name: /opt/flannel
    - source: https://storage.googleapis.com/kubernetes-release/flannel/flannel-0.5.5-linux-amd64.tar.gz
    - tar_options: v
    - source_hash: md5=972c717254775bef528f040af804f2cc
    - archive_format: tar
    - if_missing: /usr/local/src/flannel/flannel-0.5.5/

flannel-symlink:
  file.symlink:
    - name: /usr/local/bin/flanneld
    - target: /usr/local/src/flannel-0.5.5/flanneld
    - force: true
    - watch:
        - archive: flannel-tar

/etc/default/flannel:
  file.managed:
    - source: salt://kubernetes/files/flannel/default.pool
    - template: jinja
    - user: root
    - group: root
    - mode: 644

{%- endif %}