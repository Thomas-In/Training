[job1]
kubectl apply -f job1.yml
kubectl describe job sleepy
kubectl get job sleepy -o yaml | grep -A 5 -B 1 ^spec
kubectl delete job sleepy

[job2]
kubectl apply -f job2.yml
kubectl get job,pod -l job-name=sleepy
kubectl delete job sleepy

[job3]
kubectl apply -f job3.yml
kubectl get job sleepy
kubectl get job sleepy -ojsonpath='{.status.conditions}' | jq
kubectl delete job sleepy

[job4]
kubectl apply -f cronjob1.yml
kubectl get cronjob sleepy
kubectl get job
kubectl get pod
kubectl delete cronjob sleepy

[job5]
kubectl apply -f cronjob2.yml
kubectl get cronjob sleepy
kubectl get job
kubectl delete cronjob sleepy