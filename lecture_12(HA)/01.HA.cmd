# The guestbook application uses Redis to store its data
k apply -f guestbook-all-in-one
k get pod
k drain node1 --delete-emptydir-data --ignore-daemonsets --force