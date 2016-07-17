{%- from "kubernetes/map.jinja" import master with context %}
{%- if master.enabled %}

/etc/kubernetes/glusterfs/glusterfs-endpoints.yml:
  file.managed:
    - source: salt://kubernetes/files/glusterfs/glusterfs-endpoints.yml
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/etc/kubernetes/glusterfs/glusterfs-svc.yml:
  file.managed:
    - source: salt://kubernetes/files/glusterfs/glusterfs-svc.yml
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - template: jinja

{%- endif %}