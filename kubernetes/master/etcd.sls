{%- from "kubernetes/map.jinja" import master with context %}
{%- if master.enabled %}

/var/log/etcd-events.log:
  file.managed:
  - user: root
  - group: root
  - mode: 644

/var/log/etcd.log:
  file.managed:
  - user: root
  - group: root
  - mode: 644

/var/etcd:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 700
    - recurse:
      - user
      - group
      - mode

/etc/kubernetes/manifests/etcd.manifest:
  file.managed:
    - source: salt://kubernetes/files/manifest/etcd.manifest
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - dir_mode: 755

{%- endif %}