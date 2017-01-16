{%- from "kubernetes/map.jinja" import pool with context %}
{%- from "kubernetes/map.jinja" import common with context %}
{%- if pool.enabled %}

{%- if common.hyperkube %}

/tmp/cni/:
  file.directory:
    - user: root
    - group: root

copy-network-cni:
  dockerng.running:
    - image: {{ common.hyperkube.image }}
    - command: cp -vr /opt/cni/bin/ /tmp/cni/
    - binds:
      - /tmp/cni/:/tmp/cni/
    - force: True
    - require:
        - file: /tmp/cni/

{%- for filename in ['cnitool', 'flannel', 'tuning', 'bridge', 'ipvlan', 'loopback', 'macvlan', 'ptp', 'dhcp', 'host-local', 'noop'] %}
/opt/cni/bin/{{ filename }}:
  file.managed:
    - source: /tmp/cni/bin/{{ filename }}
    - user: root
    - group: root
    - mode: 755
    - watch_in:
      - service: kubelet_service
    - require:
      - dockerng: copy-network-cni

{%- endfor %}

{%- endif %}

{%- endif %}
