#!/bin/sh
set -Eeuo pipefail
echo

URL="http://${IP:-127.0.0.1}:${PORT:-8080}/health"
: ${TIMEOUT:=2}
: ${SLEEP:=1}

echo "VERIFY HEALTH: $URL"
while true; do
    curl -f -s -m $TIMEOUT --output /dev/null $URL && exit 0
    echo " ..."
    sleep $SLEEP
done
