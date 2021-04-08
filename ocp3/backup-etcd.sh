#Create by Giuliano Quites 
#Date: 08/04/2021 

#!/bin/bash
mkdir -p /backup/etcd-config-$(date +%Y%m%d)/              
cp -R /etc/etcd/ /backup/etcd-config-$(date +%Y%m%d)/      
ETCD_POD_MANIFEST="/etc/origin/node/pods/etcd.yaml"         
ETCD_EP=$(grep https ${ETCD_POD_MANIFEST} | cut -d '/' -f3) 
oc login -u system:admin
ETCD_POD=$(oc get pods -n kube-system | grep -o -m 1 "master-etcd-$HOSTNAME")
oc project kube-system
oc exec ${ETCD_POD} -c etcd -- /bin/bash -c "ETCDCTL_API=3 etcdctl \
    --cert /etc/etcd/peer.crt \
    --key /etc/etcd/peer.key \
    --cacert /etc/etcd/ca.crt \
    --endpoints $ETCD_EP \
    snapshot save /var/lib/etcd/snapshot.db"

cp /var/lib/etcd/snapshot.db /backup/etcd-config-$(date +%Y%m%d)/snapshot.db
tar -zcvf /backup/$(hostname)-$(date +%Y%m%d).tar.gz /backup/etcd-config-$(date +%Y%m%d)
find /backup/ -mtime +10 -delete

