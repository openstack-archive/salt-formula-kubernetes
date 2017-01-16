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

{%- if master.get('container', 'true') %}

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

/etc/kubernetes/manifests/kube-controller-manager.manifest:
  file.managed:
    - source: salt://kubernetes/files/manifest/kube-controller-manager.manifest
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - dir_mode: 755

/var/log/kube-controller-manager.log:
  file.managed:
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/manifests/kube-scheduler.manifest:
  file.managed:
    - source: salt://kubernetes/files/manifest/kube-scheduler.manifest
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - dir_mode: 755

/var/log/kube-scheduler.log:
  file.managed:
    - user: root
    - group: root
    - mode: 644

{%- else %}

/etc/default/kube-apiserver:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: DAEMON_ARGS=" --insecure-bind-address={{ master.apiserver.insecure_address }} --etcd-servers={% for member in master.etcd.members %}http://{{ member.host }}:4001{% if not loop.last %},{% endif %}{% endfor %} --admission-control=NamespaceLifecycle,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota --service-cluster-ip-range={{ master.service_addresses }} --client-ca-file=/etc/kubernetes/ssl/ca-{{ master.ca }}.crt --basic-auth-file=/srv/kubernetes/basic_auth.csv --tls-cert-file=/etc/kubernetes/ssl/kubernetes-server.crt --tls-private-key-file=/etc/kubernetes/ssl/kubernetes-server.key --secure-port={{ master.apiserver.get('secure_port', '443') }} --bind-address={{ master.apiserver.address }} --token-auth-file=/srv/kubernetes/known_tokens.csv --v=2 --allow-privileged=True"

/etc/default/kube-controller-manager:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: DAEMON_ARGS=" --master={{ master.apiserver.insecure_address }}:8080 --cluster-name=kubernetes --service-account-private-key-file=/etc/kubernetes/ssl/kubernetes-server.key --v=2 --root-ca-file=/etc/kubernetes/ssl/ca-{{ master.ca }}.crt --leader-elect=true"

/etc/default/kube-scheduler:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: DAEMON_ARGS=" --master={{ master.apiserver.insecure_address }}:8080 --v=2 --leader-elect=true"

/etc/systemd/system/kube-apiserver.service:
  file.managed:
  - source: salt://kubernetes/files/systemd/kube-apiserver.service
  - template: jinja
  - user: root
  - group: root
  - mode: 644

/etc/systemd/system/kube-scheduler.service:
  file.managed:
  - source: salt://kubernetes/files/systemd/kube-scheduler.service
  - template: jinja
  - user: root
  - group: root
  - mode: 644

/etc/systemd/system/kube-controller-manager.service:
  file.managed:
  - source: salt://kubernetes/files/systemd/kube-controller-manager.service
  - template: jinja
  - user: root
  - group: root
  - mode: 644

master_services:
  service.running:
  - names: {{ master.services }}
  - enable: True
  - watch:
    - file: /etc/default/kube-apiserver
    - file: /etc/default/kube-scheduler
    - file: /etc/default/kube-controller-manager

{%- endif %}

{%- if not pillar.kubernetes.pool is defined %}

/usr/bin/hyperkube:
  file.managed:
     - source: {{ master.hyperkube.get('source', 'http://apt.tcpcloud.eu/kubernetes/bin/') }}{{ master.version }}/hyperkube
     - source_hash: md5={{ master.hyperkube.hash }}
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

/etc/kubernetes/config:
  file.absent

/etc/default/kubelet:
  file.managed:
  - source: salt://kubernetes/files/kubelet/default.master
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

{%- for name,namespace in master.namespace.iteritems() %}

{%- if namespace.enabled %}

/registry/namespaces/{{ name }}:
  etcd.set:
    - value: '{"kind":"Namespace","apiVersion":"v1","metadata":{"name":"{{ name }}"},"spec":{"finalizers":["kubernetes"]},"status":{"phase":"Active"}}'

{%- else %}

/registry/namespaces/{{ name }}:
  etcd.rm

{%- endif %}

{%- endfor %}

{%- if master.registry.secret is defined %}

{%- for name,registry in master.registry.secret.iteritems() %}

{%- if registry.enabled %}

/registry/secrets/{{ registry.namespace }}/{{ name }}:
  etcd.set:
    - value: '{"kind":"Secret","apiVersion":"v1","metadata":{"name":"{{ name }}","namespace":"{{ registry.namespace }}"},"data":{".dockerconfigjson":"{{ registry.key }}"},"type":"kubernetes.io/dockerconfigjson"}'

{%- else %}

/registry/secrets/{{ registry.namespace }}/{{ name }}:
  etcd.rm

{%- endif %}

{%- endfor %}

{%- endif %}

{%- endif %}