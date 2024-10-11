[head - clusterIP]
k describe svc head-nginx
k get pod -o wide |grep deploy-head-nginx
curl head-nginx.default.svc.cluster.local
nslookup head-nginx.default.svc.cluster.local          # clusterIP 주소 반환

[headless]
k describe svc hdl-nginx                               # IP, IPs: none, Endpoints: 10.42.104.34:80,10.42.135.4:80,10.42.166.147:80
k get pod -o wide |grep deploy-nginx
[netshoot] curl hdl-nginx.default.svc.cluster.local    # netshoot
[netshoot] dig hdl-nginx.default.svc.cluster.local     # netshoot
nslookup hdl-nginx.default.svc.cluster.local 
