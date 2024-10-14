1. RMS 접속
Cluster Create
> CNI : cilium
> copy registration command & paste on downstream nodes (check etcd/control plane/worker)

2. 사전작업 (ALL)
cat << EOF >> /etc/rancher/rke2/config.yaml
kubelet-arg:
  - "max-pods=220"
  - "container-log-max-files=5"
  - "container-log-max-size=10Mi"
  - "image-gc-high-threshold=80"
  - "image-gc-low-threshold=60"
EOF

systemctl restart rke2-server

3. bashrc 설정
mkdir ~/.kube/
cp /etc/rancher/rke2/rke2.yaml ~/.kube/config
export PATH=$PATH:/var/lib/rancher/rke2/bin/
echo 'export PATH=/usr/local/bin:/var/lib/rancher/rke2/bin:$PATH' >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc
echo "export PATH=/usr/local/bin:/var/lib/rancher/rke2/bin:$PATH" >> ~/.bashrc
echo "export CRI_CONFIG_FILE=/var/lib/rancher/rke2/agent/etc/crictl.yaml" >> ~/.bashrc
echo 'alias ctr="ctr --address /run/k3s/containerd/containerd.sock --namespace k8s.io"' >> ~/.bashrc
source ~/.bashrc

4. helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm version --client --short
 
5. k9s
curl -sL https://github.com/derailed/k9s/releases/download/v0.26.3/k9s_Linux_x86_64.tar.gz | tar xfz - -C /usr/local/bin k9s

6. longhorn 사전작업 (ALL)
dnf install iscsi-initiator-utils -y
systemctl start iscsid.service
systemctl status iscsid.service
