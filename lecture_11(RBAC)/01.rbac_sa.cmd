# role 생성
k create ns wordpress
k apply full-namespace-role.yml
k get role -n wordpress

# sa 생성
k apply -f namespace-sa.yml
k get sa -n wordpress

# rolebinding 설정
k apply -f namespace-rolebinding.yml
k get rolebindings -n wordpress
k describe rolebindings.rbac.authorization.k8s.io wordpress-namespace-full-access-rb -n wordpress

# create token
k describe sa wordpress-sa -n wordpress
k create token wordpress-sa --duration=99999h -n wordpress
---
eyJhbGciOiJSUzI1NiIsImtpZCI6InlfcFFGcWtVUklXWXlnWWhTWEZNZFVWOUpMck9wTWpUN0NBdFJscGF5aXMifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjLmNsdXN0ZXIubG9jYWwiLCJya2UyIl0sImV4cCI6MjA4ODM2MTUzMSwiaWF0IjoxNzI4MzY1MTMxLCJpc3MiOiJodHRwczovL2t1YmVybmV0ZXMuZGVmYXVsdC5zdmMuY2x1c3Rlci5sb2NhbCIsImt1YmVybmV0ZXMuaW8iOnsibmFtZXNwYWNlIjoid29yZHByZXNzIiwic2VydmljZWFjY291bnQiOnsibmFtZSI6IndvcmRwcmVzcy1zYSIsInVpZCI6Ijc5ZmQ0YTBlLWZkNzUtNDkxMS04YjMzLTU4NWRhZDQwZWQ4YiJ9fSwibmJmIjoxNzI4MzY1MTMxLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6d29yZHByZXNzOndvcmRwcmVzcy1zYSJ9.IsQ4TfzX7UeSp8GXUM9rckQbCubaEACJ7nV_v7wcAroJz7qKvB5U-ZpkT-XSwi90jbh4eGgb2j1URf4_boYmUNivRRZ4_BmokmD5dKwzfwsGJIEnVxpk_PyesrFSRz8kw9p0ngQ0Ehk4Dkm6_zGERv5ttaQFF3QY2ynSHIjIqAMfCKagfXntIzNEw9Tl3ppGZ1lzT_UuOBbbW_QWnm8na1TPh7Jkdbz1BjHIWf8t1G5CvKBL0eVvM4EMct1Aov9vfyfm-EF_2i3iOri2G3B6Le-ttC7LPLUHhHqPOnszlINyfjZgqlxD5q0fdPq-4xmOdgBDH1XD2JzCgHqz2-5Amg
---
[2nd node]
kubectx
k create deployment nginx --image=nginx -n wordpress
k get pod
k get pod -n wordpress
k create deployment nginx --image=nginx -n default
k get pv
k get ns