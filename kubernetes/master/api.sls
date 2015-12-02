{%- from "kubernetes/map.jinja" import master with context %}
{%- if master.enabled %}

/srv/kubernetes/known_tokens.csv:
  file.managed:
  - source: salt://kubernetes/files/known_tokens.csv
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - makedirs: true

/srv/kubernetes/basic_auth.csv:
  file.managed:
  - source: salt://kubernetes/files/basic_auth.csv
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - makedirs: true

/var/log/kube-apiserver.log:
  file.managed:
  - user: root
  - group: root
  - mode: 644

/etc/kubernetes/manifests/kube-apiserver.manifest:
  file.managed:
  - source: salt://kubernetes/files/manifest/kube-apiserver.manifest
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - makedirs: true
  - dir_mode: 755

{%- endif %}