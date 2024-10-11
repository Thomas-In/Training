[curl 명령어로 부하]
./curl-get.sh 192.168.31.51:30763

[HPA status]
k get hpa -w
watch -n1 "kubectl top pod |grep hpa"