[job1] 단일 JOB
kubectl apply -f job1.yml
kubectl describe job sleepy
kubectl get job sleepy -o yaml | grep -A 5 -B 1 ^spec
kubectl delete job sleepy

[job2] 다중 JOB completion (5) 직렬 수행
kubectl apply -f job2.yml
kubectl describe job sleepy
kubectl get job,pod -l job-name=sleepy
kubectl delete job sleepy

[job3] 병렬 다중 JOB parallelism (2) 병렬 수행
kubectl apply -f job3.yml
kubectl describe job sleepy
kubectl get job sleepy
kubectl get job sleepy -ojsonpath='{.sampletatus.conditions}' | jq
kubectl delete job sleepy

[cronjob1] cronjob은 scheduling 된 주기마다 한번씩 POD를 생성하고 Job을 실행하고 Completion하는 과정을 반복
kubectl apply -f cronjob1.yml
kubectl get cronjob hello
kubectl get job
k get pod -A |grep hello
kubectl delete cronjob hello

[cronjob2] 작업을 중지하기 전에 작업의 최대 기간(10초) 설정 테스트
kubectl apply -f cronjob2.yml
kubectl get cronjob hello
kubectl get job
k get pod -A |grep hello
kubectl delete cronjob hello