1. 방화벽 비활성화
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/sysconfig/selinux
setenforce 0
swapoff -a
systemctl stop firewalld && systemctl disable firewalld && iptables -F

2. sftp daemon 활성화
systemctl enable sftpd.service
systemctl start sftpd.service

3. RMS
# install
VERSION=v1.28.10+rke2r1
curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_VERSION=$VERSION INSTALL_RKE2_TYPE=server sh -
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="server" sh -

mkdir -p /etc/rancher/rke2
cat << EOF >> /etc/rancher/rke2/config.yaml
cni: "cilium"
disable-kube-proxy: true
kubelet-arg:
  - "container-log-max-files=5"
  - "container-log-max-size=10Mi"
etcd-disable-snapshots: false
etcd-snapshot-schedule-cron: "0 0 * * *"
etcd-snapshot-retention: 7
EOF

mkdir -p /var/lib/rancher/rke2/server/manifests
cat << EOF >> /var/lib/rancher/rke2/server/manifests/rke2-cilium-config.yaml
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: rke2-cilium
  namespace: kube-system
spec:
  valuesContent: |-
    kubeProxyReplacement: true
    k8sServiceHost: "10.206.39.10"
    k8sServicePort: "6443"
    ingressController:
      enabled: false
    gatewayAPI:
      enabled: true
EOF

4. RKE2 시작
systemctl enable rke2-server.service
systemctl start rke2-server.service

5. bashrc 설정
mkdir ~/.kube/
cp /etc/rancher/rke2/rke2.yaml ~/.kube/config
export PATH=$PATH:/var/lib/rancher/rke2/bin/
echo 'export PATH=/usr/local/bin:/var/lib/rancher/rke2/bin:$PATH' >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc
echo "export PATH=/usr/local/bin:/var/lib/rancher/rke2/bin:$PATH" >> ~/.bashrc
echo "export CRI_CONFIG_FILE=/var/lib/rancher/rke2/agent/etc/crictl.yaml" >> ~/.bashrc
echo 'alias ctr="ctr --address /run/k3s/containerd/containerd.sock --namespace k8s.io"' >> ~/.bashrc
source ~/.bashrc

6. cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.0/cert-manager.yaml

7. helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm version --client --short
 
8. k9s
curl -sL https://github.com/derailed/k9s/releases/download/v0.26.3/k9s_Linux_x86_64.tar.gz | tar xfz - -C /usr/local/bin k9s

9. cilium operator replicas 2 -> 1
k scale --replicas=1 deployment/cilium-operator -n kube-system

10. rancher 설치
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm install rancher rancher-stable/rancher --namespace cattle-system --set hostname=10.206.39.10.nip.io --set replicas=1 --version 2.8.3 --create-namespace

# 참조
password-min-length 값 수정
# kubectl edit settings.management.cattle.io password-min-length