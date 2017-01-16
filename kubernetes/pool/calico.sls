{%- from "kubernetes/map.jinja" import pool with context %}
{%- if pool.enabled %}

/tmp/calico/:
  file.directory:
      - user: root
      - group: root

copy-calico-ctl:
  dockerng.running:
    - image: {{ pool.network.calicoctl.image }}

copy-calico-ctl-cmd:
  cmd.run:
    - name: docker cp copy-calico-ctl:calicoctl /tmp/calico/
    - require:
      - dockerng: copy-calico-ctl

# available from Salt 2016.3.4
#copy-calico-ctl-from-container:
#  dockerng.copy_from:
#    - name: calico-ctl-container
#    - source: calicoctl
#    - dest: /tmp/calico/calicoctl
#    - overwrite: True
#    - makedirs: True

/usr/bin/calicoctl:
  file.managed:
     - source: /tmp/calico/calicoctl
     - mode: 751
     - user: root
     - group: root
     - require:
       - cmd: copy-calico-ctl-cmd

copy-calico-cni:
  dockerng.running:
    - image: {{ pool.network.cni.image }}
    - command: cp -vr /opt/cni/bin/ /tmp/calico/
    - binds:
      - /tmp/calico/:/tmp/calico/
    - force: True

{%- for filename in ['calico', 'calico-ipam'] %}

/opt/cni/bin/{{ filename }}:
  file.managed:
     - source: /tmp/calico/bin/{{ filename }}
     - mode: 751
     - makedirs: true
     - user: root
     - group: root
     - require:
       - dockerng: copy-calico-cni
     - require_in:
       - service: calico_node
{%- endfor %}

/etc/cni/net.d/10-calico.conf:
  file.managed:
    - source: salt://kubernetes/files/calico/calico.conf
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - dir_mode: 755
    - template: jinja

/etc/calico/network-environment:
  file.managed:
    - source: salt://kubernetes/files/calico/network-environment.pool
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - dir_mode: 755
    - template: jinja

{%- if pool.network.get('systemd', true) %}

/etc/systemd/system/calico-node.service:
  file.managed:
    - source: salt://kubernetes/files/calico/calico-node.service.pool
    - user: root
    - group: root
    - template: jinja

calico_node:
  service.running:
    - name: calico-node
    - enable: True
    - watch:
      - file: /etc/systemd/system/calico-node.service
{%- endif %}

{%- endif %}
