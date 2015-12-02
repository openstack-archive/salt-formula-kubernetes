{%- from "kubernetes/map.jinja" import master with context %}
{%- if master.enabled %}

{% if pillar.get('is_systemd') %}
{% set environment_file = '/etc/sysconfig/kubelet' %}
{% else %}
{% set environment_file = '/etc/default/kubelet' %}
{% endif %}

{{ environment_file }}:
  file.managed:
  - source: salt://kubernetes/files/kubelet/default.master
  - template: jinja
  - user: root
  - group: root
  - mode: 644

/usr/local/bin/kubelet:
  file.managed:
    - user: root
    - group: root
    - mode: 755

{% if pillar.get('is_systemd') %}

{{ pillar.get('systemd_system_path') }}/kubelet.service:
  file.managed:
    - source: salt://kubernetes/files/kubelet/kubelet.service
    - user: root
    - group: root

fix-service-kubelet:
  cmd.wait:
    - name: /opt/kubernetes/helpers/services bounce kubelet
    - watch:
      - file: /usr/local/bin/kubelet
      - file: {{ pillar.get('systemd_system_path') }}/kubelet.service
      - file: {{ environment_file }}
      - file: /var/lib/kubelet/kubeconfig

{% else %}

/etc/init.d/kubelet:
  file.managed:
    - source: salt://kubernetes/files/kubelet/initd
    - user: root
    - group: root
    - mode: 755

{% endif %}

kubelet:
  service.running:
    - enable: True
    - watch:
      - file: /usr/local/bin/kubelet
{% if pillar.get('is_systemd') %}
      - file: {{ pillar.get('systemd_system_path') }}/kubelet.service
{% else %}
      - file: /etc/init.d/kubelet
{% endif %}
{% if grains['os_family'] == 'RedHat' %}
      - file: /usr/lib/systemd/system/kubelet.service
{% endif %}
      - file: {{ environment_file }}

{%- endif %}