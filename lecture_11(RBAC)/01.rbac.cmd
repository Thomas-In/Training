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
