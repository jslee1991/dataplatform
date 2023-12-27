#!/usr/bin/env bash
set -uo pipefail

NAMESPACE=common-datastore
NOW=$(date +%Y%m%d-%H%M%S)

INITIALIZED=$(kubectl exec pod/vault-0 -n $NAMESPACE -- vault status | grep -i "Initialized." | awk '{print $2}');

if [ "$INITIALIZED" = "true" ];then
    echo "already initialized"
    #kubectl exec vault-1 -n $NAMESPACE -- vault operator raft join http://vault-0.vault-internal.common-datastore:8200
    #kubectl exec vault-2 -n $NAMESPACE -- vault operator raft join http://vault-0.vault-internal.common-datastore:8200
else
    echo "initializing..."
    ###seal type을 transit으로 설정하는 경우에는 secret_shares,secret_threshold 쓰지 않아야 함!
    kubectl exec vault-0 -n $NAMESPACE -- vault operator init -format=json > vault_init_$NOW.json

    sleep 5;
    ROOT_TOKEN=$(cat vault_init_$NOW.json | jq -r ".root_token");
    # UNSEAL_TOKEN=$(cat vault_init_$NOW.json | jq -r ".unseal_keys_b64[]");
    
    # ROOT_TOKEN=$(cat vault_init_$NOW.json | grep -o '"root_token": "[^"]*' | grep -o '[^"]*$');
    # UNSEAL_TOKEN=$(cat vault_init_$NOW.json | grep -o -A1 '"unseal_keys_b64"' |tail -n 1 | grep -o '"[^"]*' | grep -o '[^"]*$');

    #kubectl delete secret vault-token -n $NAMESPACE
    #kubectl delete secret vault-token -n viola
    #kubectl delete secret vault-token -n cmp
    #kubectl delete secret vault-token -n ncp
    #kubectl delete secret vault-token -n contrabass

    kubectl create secret generic vault-token --from-literal=token=$ROOT_TOKEN -n $NAMESPACE
    kubectl create secret generic vault-token --from-literal=token=$ROOT_TOKEN -n viola
    kubectl create secret generic vault-token --from-literal=token=$ROOT_TOKEN -n cmp
    kubectl create secret generic vault-token --from-literal=token=$ROOT_TOKEN -n ncp
    kubectl create secret generic vault-token --from-literal=token=$ROOT_TOKEN -n contrabass

    sleep 10;
    kubectl exec vault-1 -n $NAMESPACE -- vault operator raft join http://vault-0.vault-internal.common-datastore:8200
    kubectl exec vault-2 -n $NAMESPACE -- vault operator raft join http://vault-0.vault-internal.common-datastore:8200


    sleep 10;
    kubectl exec vault-0 -n $NAMESPACE -- vault login $ROOT_TOKEN;
    kubectl exec vault-0 -n $NAMESPACE -- vault secrets enable -version=2 -path="secret" kv;
    kubectl exec vault-0 -n $NAMESPACE -- vault kv put -mount=secret prd/portal/paas test=test
fi