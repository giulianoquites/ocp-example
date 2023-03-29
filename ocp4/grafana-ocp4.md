```
oc new-project grafana-monitoring 
```
oc get secrets grafana-datasources -n openshift-monitoring --export -o yaml > grafana-datasources.yaml 
```
cat grafana-datasources.yaml
```
oc create -f grafana-datasources.yaml
```
oc new-app --name=mydashboard docker.io/grafana/grafana 
```
oc get all
```
oc get pods -o wide
```
oc set volume dc/mydashboard --add --name=grafana-dashsources --type=secret --secret-name=grafana-datasources --mount-path=/etc/grafana/provisioning/datasources --namespace=grafana-monitoring 
```
#Create pvc with name: grafana-storage
```
oc set volume dc/mydashboard --add --name=grafana-storage --mount-path=/var/lib/grafana --namespace=grafana-monitoring
```
oc expose svc/mydashboard
```
oc adm pod-network join-projects --to=grafana-monitoring openshift-monitoring
```
oc get route
```
