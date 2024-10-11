# Create a Custom Resource Definition

# 클러스터에 이미 생성된 CRD 확인 
kubectl get crd --all-namespaces

# Sample CRD 생성 (crontabs.stable.example.com)
cat <<EOF | kubectl create -f -
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  # name must match the spec fields below, and be in the form: <plural>.<group>
  name: crontabs.stable.example.com
spec:
  # group name to use for REST API: /apis/<group>/<version>
  group: stable.example.com
  # list of versions supported by this CustomResourceDefinition
  versions:
    - name: v1
      # Each version can be enabled/disabled by Served flag.
      served: true
      # One and only one version must be marked as the storage version.
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                cronSpec:
                  type: string
                image:
                  type: string
                replicas:
                  type: integer
  # either Namespaced or Cluster
  scope: Namespaced
  names:
    # plural name to be used in the URL: /apis/<group>/<version>/<plural>
    plural: crontabs
    # singular name to be used as an alias on the CLI and for display
    singular: crontab
    # kind is normally the CamelCased singular type. Your resource manifests use this.
    kind: CronTab
    # shortNames allow shorter string to match your resource on the CLI
    shortNames:
    - ct
EOF

# 생성된 CRD 확인 
{
    kubectl get crd crontabs.stable.example.com 
    kubectl describe crd crontabs.stable.example.com
}

# 위에서 생성한 CRD의 객체 생성
cat <<EOF | kubectl create -f -
apiVersion: "stable.example.com/v1"
    # This is from the group and version of new CRD
kind: CronTab
    # The kind from the new CRD
metadata:
  name: new-cron-object
spec:
  cronSpec: "*/5 * * * *"
  image: some-cron-image
    #Does not exist
EOF

# 생성된 CronTab 확인 
{
    kubectl get crontab
    kubectl get ct 
    kubectl describe ct
}

# 생성한 CRD 삭제 
kubectl delete crd crontabs.stable.example.com 