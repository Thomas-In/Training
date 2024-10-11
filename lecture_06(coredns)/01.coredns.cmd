k exec -it busybox -- sh
cat /etc/resolv.conf

# 신규 busybox 생성
k create ns busybox
k run busybox --image=busybox --restart=Never -n busybox -- sleep 1d
k  exec -it -n busybox busybox -- sh
more /etc/resolv.conf
nslookup nginx-svc
nslookup nginx-svc.default.svc.cluster.local
