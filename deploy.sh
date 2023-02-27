#!/bin/sh
set -Eeuo pipefail

: ${CONTEXT:=k3d-local}
kubectl config use-context ${CONTEXT}

export NAMESPACE=${NAMESPACE:-nginx-demo}

source $(dirname $0s)/scripts/utils.sh

# create namespace
kubectl create ns $NAMESPACE -o yaml --dry-run=client | kubectl apply -f -

echo "\nCREATE CONFIGMAPS:"
for FILE in $(find ./nginx/config -maxdepth 1 -not -type d); do
    echo "${FILE/#/ * }"
    eval "export $(config_key $FILE)=$(config_name $FILE)"
    config_map $FILE | kubectl apply -f -
done

echo "\nINSTALLING NGINX DEMO:"
for FILE in $(find ./nginx/k8s/*.y*ml -maxdepth 1 -not -type d); do
    echo "${FILE/#/ * }"
    cat $FILE | envsubst | kubectl apply -f -
done

echo "\nMONITORING ROLLOUT:"
timeout 30s kubectl rollout status ds/demo -n $NAMESPACE && echo_passed || echo_failed

# verification
timeout 20s $(dirname $0)/scripts/verify-health.sh && echo_passed || echo_failed

echo "\nDONE!\n"
