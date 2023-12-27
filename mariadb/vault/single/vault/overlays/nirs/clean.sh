#!/usr/bin/env bash

kubectl delete -k ./

kubectl delete secret vault-token -n common-datastore;
kubectl delete secret vault-token -n viola;
kubectl delete secret vault-token -n cmp;
kubectl delete secret vault-token -n contrabass;
kubectl delete secret unsealer-secret -n common-datastore;

kubectl delete pvc data-vault-0 -n common-datastore;
