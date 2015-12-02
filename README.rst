
==================
Kubernetes Formula
==================


Based on official Kubernetes salt
https://github.com/kubernetes/kubernetes/tree/master/cluster/saltbase

Extended on Contrail contribution https://github.com/Juniper/kubernetes/blob/opencontrail-integration/docs/getting-started-guides/opencontrail.md


Sample pillars
==============

.. code-block:: yaml

    kubernetes:
      master:

    kubernetes:
      pool:


Kubernetes with OpenContrail
----------------------------

On Master:

.. code-block:: yaml

    kubernetes:
      master:
        network:
          engine: opencontrail
          host: 10.0.170.70
          port: 8082
          default_domain: default-domain
          default_project: default-domain:default-project
          public_network: default-domain:default-project:Public
          public_ip_range: 185.22.97.128/26
          private_ip_range: 10.150.0.0/16
          service_cluster_ip_range: 10.254.0.0/16
          network_label: name
          service_label: uses
          cluster_service: kube-system/default
          network_manager:
            image: pupapaik/opencontrail-kube-network-manager
            tag: release-1.1-jpa-final-1

On pools:

.. code-block:: yaml

    kubernetes:
      pool:
        network:
          engine: opencontrail

Kubernetes with Flannel
-----------------------

On Master:

.. code-block:: yaml

    kubernetes:
      master:
        network:
          engine: flannel
      common:
        network:
          engine: flannel

On pools:

.. code-block:: yaml

    kubernetes:
      pool:
        network:
          engine: flannel
      common:
        network:
          engine: flannel

Kubernetes with Calico
-----------------------

On Master:

.. code-block:: yaml

    kubernetes:
      master:
        network:
          engine: calico

On pools:

.. code-block:: yaml

    kubernetes:
      pool:
        network:
          engine: calico

Kubernetes Service Definitions
------------------------------

.. code-block:: yaml

  salt:
    control:
      enabled: True
      hostNetwork: True
      service:
        memcached:
          privileged: True
          service: memcached
          role: server
          type: LoadBalancer
          replicas: 3
          kind: Deployment
          apiVersion: extensions/v1beta1
          ports:
          - port: 8774
            name: nova-api
          - port: 8775
            name: nova-metadata
          volume:
            volume_name:
              type: hostPath
              mount: /certs
              path: /etc/certs
          container:
            memcached:
              image: memcached
              tag:2
              ports:
              - port: 8774
                name: nova-api
              - port: 8775
                name: nova-metadata
              variables:
              - name: HTTP_TLS_CERTIFICATE:
                value: /certs/domain.crt
              - name: HTTP_TLS_KEY
                value: /certs/domain.key
              volumes:
              - name: /etc/certs
                type: hostPath
                mount: /certs
                path: /etc/certs

Volumes
-------

hostPath
===========

.. code-block:: yaml

  container:
    memcached:
      ...
      volumes:
      - name: /etc/certs
        mount: /certs
        type: hostPath
        path: /etc/certs

emptyDir
===========

.. code-block:: yaml

  container:
    memcached:
      ...
      volumes:
      - name: /etc/certs
        mount: /certs
        type: emptyDir