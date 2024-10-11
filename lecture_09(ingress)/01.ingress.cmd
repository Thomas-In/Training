[create secret]
k create secret tls openmsa --key=privkey.pem --cert fullchain.pem

[apply deployment, svc]
k apply -f cafe-svc-deploy.yml

[apply ingress]
k apply -f cafe-ingress.yml
k get ingress

[update hosts]
192.168.31.51		coffee.openmsa.monster
192.168.31.51		tea.openmsa.monster
192.168.31.51		www.openmsa.monster

curl https://coffee.openmsa.monster
https://tea.openmsa.monster
https://www.openmsa.monster/juice
https://www.openmsa.monster/water