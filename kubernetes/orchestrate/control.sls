kubernetes.control:
  salt.state:
    - tgt: 'kubernetes:control'
    - tgt_type: pillar
    - queue: True
    - sls: kubernetes.control
    - batch: 1

# TODO: introduce unless condition for function runs

config.create:
  salt.function:
    - tgt: 'kubernetes:control'
    - tgt_type: pillar
    - name: cmd.run
    - arg:
      - hyperkube kubectl create -f /srv/kubernetes/configmap/
    - batch: 1

service.create:
  salt.function:
    - tgt: 'kubernetes:control'
    - tgt_type: pillar
    - name: cmd.run
    - arg:
      - hyperkube kubectl create -f /srv/kubernetes/services/
    - batch: 1

deployment.create:
  salt.function:
    - tgt: 'kubernetes:control'
    - tgt_type: pillar
    - name: cmd.run
    - arg:
      - hyperkube kubectl create -f /srv/kubernetes/deployment/
    - batch: 1

job.create:
  salt.function:
    - tgt: 'kubernetes:control'
    - tgt_type: pillar
    - name: cmd.run
    - arg:
      - hyperkube kubectl create -f /srv/kubernetes/jobs/
    - batch: 1

petset.create:
  salt.function:
    - tgt: 'kubernetes:control'
    - tgt_type: pillar
    - name: cmd.run
    - arg:
      - hyperkube kubectl create -f /srv/kubernetes/petset/
    - batch: 1

