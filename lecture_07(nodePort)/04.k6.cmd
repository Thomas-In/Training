[rocky package]
dnf update
dnf install golang -y
git clone https://github.com/udhos/update-golang
cd update-golang
sudo ./update-golang.sh
go version

[k6 operator install - make]
git clone https://github.com/grafana/k6-operator && cd k6-operator
make deploy
k get all -n k6-operator-system

[k6 operator install - helm]
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install k6-operator grafana/k6-operator

[sample performance test - crocodile]
kubectl create configmap crocodile-stress-test --from-file crocodile-stress-test.js
kubectl apply -f custom-resource.yml
kubectl get k6 
kubectl get jobs 
kubectl delete -f custom-resource.yml

[sample performance test - hello-rancher]
kubectl create configmap hello-rancher-stress-test --from-file hello-rancher.js
kubectl apply -f hello-rancher-cr.yaml
kubectl get k6 
kubectl get jobs 
kubectl delete -f hello-rancher-cr.yaml

[k6 operator delete]
make delete

---

[참고]
https://grafana.com/blog/2022/06/23/running-distributed-load-tests-on-kubernetes/
[rocky k6 binary install]
sudo dnf install https://dl.k6.io/rpm/repo.rpm
sudo dnf install k6

[Prometheus+Grafana 연동]
prometheus:
  enabled: true
  prometheusSpec:
    ## enable --web.enable-remote-write-receiver flag on prometheus-server
    enableRemoteWriteReceiver: true

    # EnableFeatures API enables access to Prometheus disabled features.
    # ref: https://prometheus.io/docs/prometheus/latest/disabled_features/
    enableFeatures:
      - native-histograms

https://grafana.com/grafana/dashboards/18030-k6-prometheus-native-histograms/
https://grafana.com/docs/k6/latest/results-output/real-time/prometheus-remote-write/
https://ddii.dev/kubernetes/k6-prometheus/
[Grafana JSON]
18030