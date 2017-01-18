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

{%- if common.hyperkube %}
/root/.bashrc:
  file.append:
    - text: alias kubectl="hyperkube kubectl"
    - makedirs: True

/tmp/hyperkube:
  file.directory:
    - user: root
    - group: root

hyperkube-copy:
  dockerng.running:
    - image: {{ common.hyperkube.image }}
    - command: cp -v /hyperkube /tmp/hyperkube
    - binds:
      - /tmp/hyperkube/:/tmp/hyperkube/
    - force: True
    - require:
      - file: /tmp/hyperkube

/usr/bin/hyperkube:
  file.managed:
     - source: /tmp/hyperkube/hyperkube
     - mode: 751
     - makedirs: true
     - user: root
     - group: root
     - require:
       - dockerng: hyperkube-copy

/etc/systemd/system/kubelet.service:
  file.managed:
  - source: salt://kubernetes/files/systemd/kubelet.service
  - template: jinja
  - user: root
  - group: root
  - mode: 644

/etc/kubernetes/config:
  file.absent

/etc/kubernetes/manifests:
  file.directory:
    - user: root
    - group: root
    - mode: 0751

{%- if not pillar.kubernetes.pool is defined %}

/etc/default/kubelet:
  file.managed:
  - source: salt://kubernetes/files/kubelet/default.master
  - template: jinja
  - user: root
  - group: root
  - mode: 644

{%- else %}

/etc/default/kubelet:
  file.managed:
  - source: salt://kubernetes/files/kubelet/default.pool
  - template: jinja
  - user: root
  - group: root
  - mode: 644

{%- endif %}


kubelet_service:
  service.running:
  - name: kubelet
  - enable: True
  - watch:
    - file: /etc/default/kubelet
    - file: /usr/bin/hyperkube

{% endif %}
