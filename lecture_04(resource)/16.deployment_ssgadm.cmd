# Deployment 생성 
kubectl create deploy webserver --image quay.io/travelping/nettools:v1.11.0 --replicas=2
# 생성된 Deployment 및 Pod 확인 
kubectl get deploy,pod -l app=webserver
# 생성된 Pod의 컨테이너 이미지 확인
kubectl get pod -l app=webserver \
-o=custom-columns=NAME:.metadata.name,IMAGE:.spec.containers[*].image

# Deployment의 배포 전략 확인 
kubectl get deploy webserver -o jsonpath='{.spec.strategy}' | jq

# Rollingupdate to Recreate 으로 전략 변경 및 확인
kubectl patch deploy webserver --type strategic \
--patch '{"spec":{"strategy":{"$retainKeys":["type"],"type":"Recreate"}}}'
kubectl get deploy webserver -o jsonpath='{.spec.strategy}' | jq

# Image 변경으로 인한 Recreate 정책 적용확인
kubectl set image deploy webserver quay.io/travelping/nettools:v1.12.0
kubectl get pod -l app=webserver
kubectl get pod -l app=webserver \
-o=custom-columns=NAME:.metadata.name,IMAGE:.spec.containers[*].image

# 히스토리
kubectl rollout history deploy webserver

# R1, R2 비교
diff <(kubectl rollout history deploy webserver --revision=1) \
<(kubectl rollout history deploy webserver --revision=2) -y

# 이전버전으로 Rollback
kubectl rollout undo deploy webserver
kubectl get pod -l app=webserver \
-o=custom-columns=NAME:.metadata.name,IMAGE:.spec.containers[*].image

# Deployment 삭제
kubectl delete deployment webserver