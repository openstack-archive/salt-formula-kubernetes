{%- from "kubernetes/map.jinja" import master with context %}
{%- if master.enabled %}

{%- if master.get('container', 'true') %}

/var/log/etcd.log:
  file.managed:
  - user: root
  - group: root
  - mode: 644

/etc/kubernetes/manifests/etcd.manifest:
  file.managed:
    - source: salt://kubernetes/files/manifest/etcd.manifest
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - dir_mode: 755

{%- else %}

etcd_pkg:
  pkg.installed:
  - name: etcd

/etc/default/etcd:
  file.managed:
    - source: salt://kubernetes/files/etcd/default
    - template: jinja
    - user: root
    - group: root
    - mode: 644

etcd_service:
  service.running:
  - name: etcd
  - enable: True
  - watch:
    - file: /etc/default/etcd

{%- endif %}

{%- endif %}