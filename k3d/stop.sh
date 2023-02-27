#!/bin/sh
set -Eeuo pipefail

unset KUBECONFIG

k3d cluster delete local
