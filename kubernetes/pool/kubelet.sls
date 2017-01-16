{%- from "kubernetes/map.jinja" import pool with context %}
{%- if pool.enabled %}

/etc/kubernetes/kubelet.kubeconfig:
  file.managed:
    - source: salt://kubernetes/files/kubelet/kubelet.kubeconfig
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true

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

{%- endif %}
