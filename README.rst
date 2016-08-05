
==================
Kubernetes Formula
==================

Kubernetes is an open-source system for automating deployment, scaling, and management of containerized applications.

This formula deploys production ready Kubernetes and generate Kubernetes manifests as well.

Based on official Kubernetes salt
https://github.com/kubernetes/kubernetes/tree/master/cluster/saltbase

Extended on Contrail contribution https://github.com/Juniper/kubernetes/blob/opencontrail-integration/docs/getting-started-guides/opencontrail.md


Sample pillars
==============

Containers on pool definitions in pool.service.local

.. code-block:: yaml

    parameters:
      kubernetes:
        pool:
          service:
            local:
              enabled: False
              service: libvirt
              cluster: openstack-compute
              namespace: default
              role: ${linux:system:name}
              type: LoadBalancer
              kind: Deployment
              apiVersion: extensions/v1beta1
              replicas: 1
              host_pid: True
              nodeSelector:
              - key: openstack
                value: ${linux:system:name}
              hostNetwork: True
              container:
                libvirt-compute:
                  privileged: True
                  image: ${_param:docker_repository}/libvirt-compute
                  tag: ${_param:openstack_container_tag}

Master definition

.. code-block:: yaml

    kubernetes:
        master:
          addons:
            dns:
              domain: cluster.local
              enabled: true
              replicas: 1
              server: 10.254.0.10
            heapster_influxdb:
              enabled: true
              public_ip: 185.22.97.132
            ui:
              enabled: true
              public_ip: 185.22.97.131
          admin:
            password: password
            username: admin
          apiserver:
            address: 10.0.175.100
            port: 8080
          ca: kubernetes
          enabled: true
          etcd:
            host: 127.0.0.1
            members:
            - host: 10.0.175.100
              name: node040
            name: node040
            token: ca939ec9c2a17b0786f6d411fe019e9b
          kubelet:
            allow_privileged: true
          network:
            engine: calico
            hash: fb5e30ebe6154911a66ec3fb5f1195b2
            private_ip_range: 10.150.0.0/16
            version: v0.19.0
          service_addresses: 10.254.0.0/16
          storage:
            engine: glusterfs
            members:
            - host: 10.0.175.101
              port: 24007
            - host: 10.0.175.102
              port: 24007
            - host: 10.0.175.103
              port: 24007
            port: 24007
          token:
            admin: DFvQ8GJ9JD4fKNfuyEddw3rjnFTkUKsv
            controller_manager: EreGh6AnWf8DxH8cYavB2zS029PUi7vx
            dns: RAFeVSE4UvsCz4gk3KYReuOI5jsZ1Xt3
            kube_proxy: DFvQ8GelB7afH3wClC9romaMPhquyyEe
            kubelet: 7bN5hJ9JD4fKjnFTkUKsvVNfuyEddw3r
            logging: MJkXKdbgqRmTHSa2ykTaOaMykgO6KcEf
            monitoring: hnsj0XqABgrSww7Nqo7UVTSZLJUt2XRd
            scheduler: HY1UUxEPpmjW4a1dDLGIANYQp1nZkLDk
          version: v1.2.4


    kubernetes:
        pool:
          address: 0.0.0.0
          allow_privileged: true
          ca: kubernetes
          cluster_dns: 10.254.0.10
          cluster_domain: cluster.local
          enabled: true
          kubelet:
            allow_privileged: true
            config: /etc/kubernetes/manifests
            frequency: 5s
          master:
            apiserver:
              members:
              - host: 10.0.175.100
            etcd:
              members:
              - host: 10.0.175.100
            host: 10.0.175.100
          network:
            engine: calico
            hash: fb5e30ebe6154911a66ec3fb5f1195b2
            version: v0.19.0
          token:
            kube_proxy: DFvQ8GelB7afH3wClC9romaMPhquyyEe
            kubelet: 7bN5hJ9JD4fKjnFTkUKsvVNfuyEddw3r
          version: v1.2.4



Kubernetes with OpenContrail network plugin
------------------------------------------------

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

Kubernetes control plane running in systemd
-------------------------------------------

By default kube-apiserver, kube-scheduler, kube-controllermanager, kube-proxy, etcd running in docker containers through manifests. For stable production environment this should be run in systemd. 

.. code-block:: yaml

    kubernetes:
      master:
        container: false

    kubernetes:
      pool:
        container: false

Because k8s services run under kube user without root privileges, there is need to change secure port for apiserver.

.. code-block:: yaml

    kubernetes:
      master:
        apiserver:
          secure_port: 8081

Kubernetes with Flannel
-----------------------

On Master:

.. code-block:: yaml

    kubernetes:
      master:
        network:
          engine: flannel
    # If you don't register master as node:
          etcd:
            members:
              - host: 10.0.175.101
                port: 4001
              - host: 10.0.175.102
                port: 4001
              - host: 10.0.175.103
                port: 4001
      common:
        network:
          engine: flannel

On pools:

.. code-block:: yaml

    kubernetes:
      pool:
        network:
          engine: flannel
          etcd:
            members:
              - host: 10.0.175.101
                port: 4001
              - host: 10.0.175.102
                port: 4001
              - host: 10.0.175.103
                port: 4001
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
    # If you don't register master as node:
          etcd:
            members:
              - host: 10.0.175.101
                port: 4001
              - host: 10.0.175.102
                port: 4001
              - host: 10.0.175.103
                port: 4001

On pools:

.. code-block:: yaml

    kubernetes:
      pool:
        network:
          engine: calico
          etcd:
            members:
              - host: 10.0.175.101
                port: 4001
              - host: 10.0.175.102
                port: 4001
              - host: 10.0.175.103
                port: 4001

Post deployment configuration

.. code-block:: bash

    # set ETCD
    export ETCD_AUTHORITY=10.0.111.201:4001

    # Set NAT for pods subnet
    calicoctl pool add 192.168.0.0/16 --nat-outgoing

    # Status commands
    calicoctl status
    calicoctl node show

Kubernetes with GlusterFS for storage
---------------------------------------------

.. code-block:: yaml

    kubernetes:
      master
        ...
        storage:
          engine: glusterfs
          port: 24007
          members:
          - host: 10.0.175.101
            port: 24007
          - host: 10.0.175.102
            port: 24007
          - host: 10.0.175.103
            port: 24007
         ...

Kubernetes namespaces
---------------------

Create namespace:

.. code-block:: yaml

    kubernetes:
      master
        ...
        namespace:
          kube-system:
            enabled: True
          namespace2:
            enabled: True
          namespace3:
            enabled: False
         ...

Kubernetes labels
-----------------

Create namespace:

.. code-block:: yaml

    kubernetes:
      pool
        ...
        host:
          label:
            key01:
              value: value01
              enable: True
            key02:
              value: value02
              enable: False
          name: ${linux:system:name}
         ...

Pull images from private registries
-----------------------------------

.. code-block:: yaml

    kubernetes:
      master
        ...
        registry:
          secret:
            registry01:
              enabled: True
              key: (get from `cat /root/.docker/config.json | base64`)
              namespace: default
         ...
      control:
        ...
        service:
          service01:
          ...
          image_pull_secretes: registry01
          ...

Kubernetes Service Definitions in pillars
==========================================

Following samples show how to generate kubernetes manifest as well and provide single tool for complete infrastructure management.

Deployment manifest
---------------------

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
==========

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
========

.. code-block:: yaml

  container:
    memcached:
      ...
      volumes:
      - name: /etc/certs
        mount: /certs
        type: emptyDir

Documentation and Bugs
============================

To learn how to deploy OpenStack Salt, consult the documentation available
online at:

    https://wiki.openstack.org/wiki/OpenStackSalt

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate bug tracker. If you obtained the software from a 3rd party
operating system vendor, it is often wise to use their own bug tracker for
reporting problems. In all other cases use the master OpenStack bug tracker,
available at:

    http://bugs.launchpad.net/openstack-salt

Developers wishing to work on the OpenStack Salt project should always base
their work on the latest formulas code, available from the master GIT
repository at:

    https://git.openstack.org/cgit/openstack/salt-formula-kubernetes

Developers should also join the discussion on the IRC list, at:

    https://wiki.openstack.org/wiki/Meetings/openstack-salt
