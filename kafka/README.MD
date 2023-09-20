
#1. OPERATOR
kubectl apply -f ./operator/


#2. CRD
kubectl apply -f ./crds/

#3 cluster
edit ./cluster/kafka.cluster.yaml

kubectl apply -f ./cluster/
