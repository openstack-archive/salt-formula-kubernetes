{%- from "kubernetes/map.jinja" import pool with context %}
{%- if pool.enabled %}

/etc/default/kubelet:
  file.managed:
  - source: salt://kubernetes/files/kubelet/default.pool
  - template: jinja
  - user: root
  - group: root
  - mode: 644

/etc/kubernetes/kubelet.kubeconfig:
  file.managed:
    - source: salt://kubernetes/files/kubelet/kubelet.kubeconfig
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true

/etc/kubernetes/config:
  file.absent

manifest-dir-create:
  file.directory:
    - name: /etc/kubernetes/manifests
    - user: root
    - group: root
    - mode: 0751

{%- if pool.host.label is defined %}

{%- for name,label in pool.host.label.iteritems() %}

{%- if label.enabled %}

{{ name }}:
  k8s.label_present:
    - name: {{ name }}
    - value: {{ label.value }}
    - node: {{ pool.host.name }}
    - apiserver: http://{{ pool.apiserver.host }}:8080

{%- else %}

{{ name }}:
  k8s.label_absent:
    - name: {{ name }}
    - node: {{ pool.host.name }}
    - apiserver: http://{{ pool.apiserver.host }}:8080

{%- endif %}

{%- endfor %}

{%- endif %}

/usr/bin/hyperkube:
  file.managed:
     - source: {{ pool.hyperkube.get('source', {}).get('url', 'http://apt.tcpcloud.eu/kubernetes/bin/') }}{{ pool.version }}/hyperkube
     - source_hash: md5={{ pool.hyperkube.hash }}
     - mode: 751
     - makedirs: true
     - user: root
     - group: root

/etc/systemd/system/kubelet.service:
  file.managed:
  - source: salt://kubernetes/files/systemd/kubelet.service
  - template: jinja
  - user: root
  - group: root
  - mode: 644

kubelet_service:
  service.running:
  - name: kubelet
  - enable: True
  - watch:
    - file: /etc/default/kubelet

{%- endif %}
