#!/usr/bin/env bash

set -e
set -u

mkdir -p /var/log/supervisor/
chmod 711 /var/log/supervisor/

chown -R kafka:kafka /kafka

echo "Starting Supervisor"

/usr/local/bin/supervisord -n