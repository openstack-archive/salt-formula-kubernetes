{%- from "kubernetes/map.jinja" import master with context %}
{%- if master.enabled %}

addon-dir-create:
  file.directory:
    - name: /etc/kubernetes/addons
    - user: root
    - group: root
    - mode: 0755

{%- if master.addons.dns.enabled %}

/etc/kubernetes/addons/dns/skydns-svc.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/dns/skydns-svc.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/dns/skydns-rc.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/dns/skydns-rc.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

{% endif %}

{%- if master.addons.ui.enabled %}

{%- if master.version == "v1.1.1" %}

/etc/kubernetes/addons/kube-ui/kube-ui-svc.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/kube-ui/kube-ui-svc.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/kube-ui/kube-ui-rc.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/kube-ui/kube-ui-rc.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/kube-ui/kube-ui-address.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/kube-ui/kube-ui-address.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/kube-ui/kube-ui-endpoint.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/kube-ui/kube-ui-endpoint.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

{% endif %}

/etc/kubernetes/addons/dashboard/dashboard-service.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/dashboard/dashboard-service.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/dashboard/dashboard-controller.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/dashboard/dashboard-controller.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

create_dashboard:
  cmd.run:
  - name: hyperkube kubectl create -f /etc/kubernetes/addons/dashboard/
  - unless: hyperkube kubectl describe rc kubernetes-dashboard-v1.1.0 --namespace=kube-system
  - require:
    - service: kubelet

{%- if master.network.engine == "opencontrail" %}

/etc/kubernetes/addons/dashboard/dashboard-address.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/dashboard/dashboard-address.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/dashboard/dashboard-endpoint.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/dashboard/dashboard-endpoint.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True
{% endif %}

{% endif %}

{%- if master.addons.heapster_influxdb.enabled %}

/etc/kubernetes/addons/heapster-influxdb/heapster-address.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/heapster-influxdb/heapster-address.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/heapster-influxdb/heapster-controller.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/heapster-influxdb/heapster-controller.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/heapster-influxdb/heapster-endpoint.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/heapster-influxdb/heapster-endpoint.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/heapster-influxdb/heapster-service.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/heapster-influxdb/heapster-service.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/heapster-influxdb/influxdb-controller.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/heapster-influxdb/influxdb-controller.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/heapster-influxdb/influxdb-service.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/heapster-influxdb/influxdb-service.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

{% endif %}

{% endif %}