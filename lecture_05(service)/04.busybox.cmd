k run busybox --image=busybox:1.28 --restart=Never -- sleep 1d
k exec -it busybox -- sh
nslookup nginx-svc
wget -O- nginx-svc |grep nginx-svc
wget -O- nginx-svc |grep nginx

# nginx replicas 1 ->3 으로 변경
k get endpoints # endpoints 추가됨을 확인
k exec -it busybox -- sh
for i in $(seq 1 10); do wget -O- nginx-svc |grep nginx; done