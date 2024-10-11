# HELM 설치
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm version --client --short

# Bitnami Helm Chart
helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo bitnami
helm search repo nginx
helm pull bitnami/nginx --untar
helm install nginx .

# helm command
helm ls
kgp
k get deploy,svc,configmap
helm get manifest nginx
k describe pod nginx-769977999d-c8drk |grep ness