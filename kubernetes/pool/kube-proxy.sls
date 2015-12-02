{%- from "kubernetes/map.jinja" import pool with context %}
{%- if pool.enabled %}

{% if pillar.get('is_systemd') %}
{% set environment_file = '/etc/sysconfig/kube-proxy' %}
{% else %}
{% set environment_file = '/etc/default/kube-proxy' %}
{% endif %}

{{ environment_file }}:
  file.managed:
    - source: salt://kubernetes/files/kube-proxy/default
    - template: jinja
    - user: root
    - group: root
    - mode: 644

kube-proxy:
  group.present:
    - system: True
  user.present:
    - system: True
    - gid_from_name: True
    - shell: /sbin/nologin
    - home: /var/kube-proxy
    - require:
      - group: kube-proxy

{% if pillar.get('is_systemd') %}

{{ pillar.get('systemd_system_path') }}/kube-proxy.service:
  file.managed:
    - source: salt://kubernetes/files/kube-proxy/kube-proxy.service
    - user: root
    - group: root
  cmd.wait:
    - name: /opt/kubernetes/helpers/services bounce kube-proxy
    - watch:
      - file: {{ environment_file }}
      - file: {{ pillar.get('systemd_system_path') }}/kube-proxy.service
      - file: /var/lib/kube-proxy/kubeconfig

{% else %}

/etc/init.d/kube-proxy:
  file.managed:
    - source: salt://kubernetes/files/kube-proxy/initd
    - user: root
    - group: root
    - mode: 755

{% endif %}

kube-proxy-service:
  service.running:
    - name: kube-proxy
    - enable: True
    - watch:
      - file: {{ environment_file }}
{% if pillar.get('is_systemd') %}
      - file: {{ pillar.get('systemd_system_path') }}/kube-proxy.service
{% else %}
      - file: /etc/init.d/kube-proxy
{% endif %}
      - file: /etc/kubernetes/proxy.kubeconfig

/var/lib/kube-proxy/kubeconfig:
  file.managed:
    - source: salt://kubernetes/files/kube-proxy/proxy.kubeconfig
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true

/etc/kubernetes/manifests/kube-proxy.manifest:
  file.managed:
    - source: salt://kubernetes/files/manifest/kube-proxy.manifest
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

{% endif %}