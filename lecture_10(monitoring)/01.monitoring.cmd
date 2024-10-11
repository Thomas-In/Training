k get pod -A |grep rke2-metrics-server
k logs -n kube-system -l app=rke2-metrics-server
k top nodes
k top pod
k top pod --sort-by memory
k top pod --sort-by cpu
k describe node node1