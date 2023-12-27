#!/usr/bin/env bash
set -uo pipefail

NAMESPACE=common-datastore
NOW=$(date +%Y%m%d-%H%M%S)

INITIALIZED=$(kubectl exec pod/vault-0 -n $NAMESPACE -- vault status | grep -i "Initialized." | awk '{print $2}');

if [ "$INITIALIZED" = "true" ];then
    echo "already initialized"

else
    echo "initializing..."
    kubectl exec vault-0 -n $NAMESPACE -- vault operator init -key-shares=1 -key-threshold=1 -format=json > vault_init_$NOW.json
    ROOT_TOKEN=$(cat vault_init_$NOW.json | jq -r ".root_token");
    UNSEAL_TOKEN=$(cat vault_init_$NOW.json | jq -r ".unseal_keys_b64[]");
    sleep 5;
    # ROOT_TOKEN=$(cat vault_init_$NOW.json | grep -o '"root_token": "[^"]*' | grep -o '[^"]*$');
    # UNSEAL_TOKEN=$(cat vault_init_$NOW.json | grep -o -A1 '"unseal_keys_b64"' |tail -n 1 | grep -o '"[^"]*' | grep -o '[^"]*$');

    echo "ROOT_TOKEN: $ROOT_TOKEN"
    echo "UNSEAL_TOKEN: $UNSEAL_TOKEN"

    echo "unsealing..."
    kubectl exec vault-0 -n $NAMESPACE -- vault operator unseal $UNSEAL_TOKEN


    sleep 5;
    echo "creating vault-token secrets..."
    kubectl create secret generic vault-token --from-literal=token=$ROOT_TOKEN -n $NAMESPACE
    kubectl create secret generic vault-token --from-literal=token=$ROOT_TOKEN -n viola
    kubectl create secret generic vault-token --from-literal=token=$ROOT_TOKEN -n cmp
    kubectl create secret generic vault-token --from-literal=token=$ROOT_TOKEN -n ncp
    kubectl create secret generic vault-token --from-literal=token=$ROOT_TOKEN -n trombone
    kubectl create secret generic vault-token --from-literal=token=$ROOT_TOKEN -n vista
    kubectl create secret generic vault-token --from-literal=token=$ROOT_TOKEN -n contrabass

    kubectl create secret generic unsealer-secret --from-literal=token=$UNSEAL_TOKEN -n $NAMESPACE


    # sleep 10;
    # kubectl exec vault-1 -n $NAMESPACE -- vault operator raft join http://vault-0.vault-internal.common-datastore:8200
    # kubectl exec vault-2 -n $NAMESPACE -- vault operator raft join http://vault-0.vault-internal.common-datastore:8200

    echo "creating vault path..."
    kubectl exec vault-0 -n $NAMESPACE -- vault login $ROOT_TOKEN;
    kubectl exec vault-0 -n $NAMESPACE -- vault secrets enable -version=2 -path="secret" kv;
    kubectl exec vault-0 -n $NAMESPACE -- vault kv put -mount=secret prd/portal/paas test=test;
    kubectl exec vault-0 -c vault -n $NAMESPACE -- vault auth enable kubernetes;

fi

