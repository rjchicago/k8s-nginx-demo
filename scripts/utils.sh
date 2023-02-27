#!/bin/sh
set -Eeuo pipefail

echo_passed() { echo " ✅ ${1:-PASSED}"; }
echo_failed() { echo " 💀 ${1:-FAILED}" && exit 1; }

config_key() { 
    local FILE=${1:?FILE not provided}
    local FILENAME="$(basename $FILE)"
    echo "CONFIG_${FILENAME//./_}"
}
config_name() {
    local FILE=${1:?FILE not provided}
    local CHECKSUM="$(md5sum $FILE)"
    echo "$(basename $FILE)-${CHECKSUM:0:10}"
}
config_map() {
    local FILE=${1:?FILE not provided}
    local NAMESPACE=${NAMESPACE:-default}
    echo "apiVersion: v1
kind: ConfigMap
metadata:
  name: $(config_name $FILE)
  namespace: $NAMESPACE
data:
  $(basename $FILE): |
$(cat $FILE | sed 's/^/    /')
immutable: true"
}
