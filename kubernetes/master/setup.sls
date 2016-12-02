{%- from "kubernetes/map.jinja" import master with context %}
{%- if master.enabled %}

{%- for addon_name, addon in master.addons.iteritems() %}
{%- if addon.enabled %}

kubernetes_addons_{{ addon_name }}:
  cmd.run:
    - name: |
        hyperkube kubectl create -f /etc/kubernetes/addons/{{ addon_name }}
    - unless: "hyperkube kubectl get rc {{ addon.get('name', addon_name) }} --namespace=kube-system"

{%- endif %}
{%- endfor %}
{%- endif %}