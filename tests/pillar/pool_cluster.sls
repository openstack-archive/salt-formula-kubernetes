kubernetes:
  common:
    network:
      engine: none
  pool:
    enabled: true
    version: v1.2.0
    host:
      name: ${linux:system:name}
    apiserver:
      host: 127.0.0.1
      insecure:
        enabled: True
      members:
        - host: 127.0.0.1
        - host: 127.0.0.1
        - host: 127.0.0.1
    address: 0.0.0.0
    cluster_dns: 10.254.0.10
    cluster_domain: cluster.local
    kubelet:
      config: /etc/kubernetes/manifests
      allow_privileged: True
      frequency: 5s
    token:
      kubelet: 7bN5hJ9JD4fKjnFTkUKsvVNfuyEddw3r
      kube_proxy: DFvQ8GelB7afH3wClC9romaMPhquyyEe
    ca: kubernetes
    network:
      cni:
        hash: 06550617ec199e89a57c94c88c891422
        version: v1.3.1
      engine: calico
      hash: c15ae251b633109e63bf128c2fbbc34a
      ipam:
        hash: 6e6d7fac0567a8d90a334dcbfd019a99
        version: v1.3.1
      version: v0.20.0
      etcd:
        members:
        - host: 127.0.0.1
          port: 4001
        - host: 127.0.0.1
          port: 4001
        - host: 127.0.0.1
          port: 4001
    hyperkube:
      hash: hnsj0XqABgrSww7Nqo7UVTSZLJUt2XRd
    cni:
      version: v0.3.0
      hash: 58237532e1b2b1be1fb3d12457da85f5