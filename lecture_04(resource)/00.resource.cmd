k apply -f same_selector_rs.yml
k get pod -A |grep manual
k get replicaset 
k apply -f replicaset.yml
k get pod -A | egrep 'manual|ubuntu'
k get replicaset ubuntu