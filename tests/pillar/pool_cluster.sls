kubernetes:
  common:
    network:
      engine: none
  pool:
    enabled: true
    version: v1.2.0
    host:
      name: ${linux:system:name}
    master:
      host: 127.0.0.1
      apiserver:
        members:
          - host: 127.0.0.1
          - host: 127.0.0.1
          - host: 127.0.0.1
      etcd:
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
      engine: calico
      version: v0.19.0
      hash: fb5e30ebe6154911a66ec3fb5f1195b2