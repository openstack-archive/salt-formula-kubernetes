{%- from "kubernetes/map.jinja" import master with context %}
{%- if master.enabled %}

/etc/kubernetes/network.json:
  file.managed:
    - source: salt://kubernetes/files/flannel/network.json
    - makedirs: True
    - user: root
    - group: root
    - mode: 755
    - template: jinja

/etc/kubernetes/manifests/flannel-server.manifest:
  file.managed:
    - source: salt://kubernetes/files/manifest/flannel-server.manifest
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - dir_mode: 755
    - template: jinja

/var/log/etcd-flannel.log:
  file.managed:
    - user: root
    - group: root
    - mode: 644

/var/log/flannel.log:
  file.managed:
    - user: root
    - group: root
    - mode: 644

{%- if not pillar.kubernetes.pool is defined %}

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
    - source: salt://kubernetes/files/flannel/default.master
    - template: jinja
    - user: root
    - group: root
    - mode: 644

{%- endif %}

{%- endif %}