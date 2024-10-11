# HELM 설치
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm version --client --short

# Bitnami Helm Chart
helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo bitnami
helm search repo nginx
helm pull bitnami/nginx --untar
helm install nginx .