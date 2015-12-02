{%- from "kubernetes/map.jinja" import master with context %}
{%- if master.enabled %}

/etc/kubernetes/glusterfs/glusterfs-endpoints.manifest:
  file.managed:
    - source: salt://kubernetes/files/manifest/glusterfs-endpoints.manifest
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/etc/kubernetes/glusterfs/glusterfs-svc.manifest:
  file.managed:
    - source: salt://kubernetes/files/manifest/glusterfs-svc.manifest
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - template: jinja

{%- endif %}