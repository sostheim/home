#!/bin/bash 

# run with "create" or "delete" as the argument.  Then I just "tail -f 
# /tmp/kube-proxy.log" (since I'm doing local-up-cluster.sh) and watched 
# for the "syncProxyRules() took XXXX seconds" messages. 

for i in {1..2000}; do

   YAML="apiVersion: v1 
kind: Service 
metadata: 
  labels: 
    name: nginxservice${i} 
  name: nginxservice${i} 
spec: 
  ports: 
    - port: $(expr 82 + ${i}) 
      targetPort: 80 
      protocol: TCP 
  selector: 
    app: nginx 
  type: LoadBalancer" 

    echo "${YAML}" | cluster/kubectl.sh $1 -f - || exit 0 

done 

# You'll need to increase your services CIDR to a /22 or something to cover this. 
# I also needed to: 
#    `prlimit --pid <pidof kube-proxy> --nofile=20000:20000`
