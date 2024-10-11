---
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: pod-lifecycle-always
  name: pod-lifecycle-always
spec:
  containers:
  - image: sysnet4admin/net-tools
    name: net-tools
    command: ["/bin/sh", "-c"]
    args:
    - nslookup kubernetes
  restartPolicy: Always
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: pod-lifecycle-never
  name: pod-lifecycle-never
spec:
  containers:
  - image: sysnet4admin/net-tools
    name: net-tools
    command: ["/bin/sh", "-c"]
    args:
    - nslookup kubernetes
  restartPolicy: Never 
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: pod-lifecycle-onfailure-retry
  name: pod-lifecycle-onfailure-retry
spec:
  containers:
  - image: sysnet4admin/net-tools
    name: net-tools
    command: ["/bin/sh", "-c"]
    args:
    - nslook kubernetes # typo issue
  restartPolicy: OnFailure
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: pod-lifecycle-onfailure
  name: pod-onfailure
spec:
  containers:
  - image: sysnet4admin/net-tools
    name: net-tools
    command: ["/bin/sh", "-c"]
    args:
    - nslookup kubernetes
  restartPolicy: OnFailure 