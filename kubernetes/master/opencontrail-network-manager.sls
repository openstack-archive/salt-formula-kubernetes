{%- from "kubernetes/map.jinja" import master with context %}
{%- if master.enabled %}

/etc/kubernetes/manifests/kube-network-manager.manifest:
  file.managed:
    - source: salt://kubernetes/files/manifest/kube-network-manager.manifest
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - dir_mode: 755

/etc/kubernetes/network.conf:
  file.managed:
    - source: salt://kubernetes/files/opencontrail/network.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true

/etc/kubernetes/namespace-opencontrail.yml:
  file.managed:
    - source: salt://kubernetes/files/opencontrail/namespace-opencontrail.yml
    - user: root
    - group: root
    - file_mode: 644

{%- endif %}