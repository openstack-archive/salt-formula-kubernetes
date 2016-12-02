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

{%- if master.addons.dashboard.enabled %}

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
