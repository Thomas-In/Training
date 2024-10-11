k get pod -A |grep rke2-metrics-server
k logs -n kube-system -l app=rke2-metrics-server
k get nodes
k get pod
k describe node node1