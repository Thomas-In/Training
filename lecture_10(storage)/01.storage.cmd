[no volume]
k apply -f date-busybox-pod.yml
k exec busybox -- tail -f /home/pod-out.txt
k delete pod busybox
k apply -f date-busybox-pod.yml
k exec busybox -- cat /home/pod-out.txt

[emptyDir]
k apply -f empty-dir.yml
k get pod -A |grep pod-emptydir
kubectl exec -i -t pod-emptydir --container web-page -- cat /usr/share/nginx/html/index.html
kubectl exec -i -t pod-emptydir --container html-builder -- cat /html-dir/index.html

[hostPath]
k apply -f hostPath.yml
k get pod -A |grep hostpath
k exec -i -t deploy-hostpath-6fd9b9b69b-9dr5d -- ls -l /host-log
k exec -i -t deploy-hostpath-6fd9b9b69b-9dr5d -- touch /host-log/sample-file
ls -l /var/log              # check the log file, node

[local path provisioner]
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.29/deploy/local-path-storage.yaml
k apply -f local-path-pvc.yml
k get pvc
k get pv
k describe pv    
k apply -f date-pvc-deploy.yml
k get pod |grep date-pod
k exec date-pod-f7b5875c6-nprzc -- cat /data/pod-out.txt
k delete pod date-pod-f7b5875c6-nprzc
k exec date-pod-f7b5875c6-vrdkk -- cat /data/pod-out.txt
tail -f /opt/local-path-provisioner/XXX/pod-out.txt

[Reclaim Policy]
k get pv    # check delete policy
kubectl patch pv <your-pv-name> -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'
kubectl patch pv pvc-85adabb8-bad3-4275-98ae-423b98536522 -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'
k get pv    # updated Retain(보존) recliam policy