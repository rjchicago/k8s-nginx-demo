#!/bin/sh
set -Eeuo pipefail

unset KUBECONFIG

k3d cluster create --config $(dirname $0s)/k3d.yaml
