#!/bin/bash

echo "Starting Registration of the Kafka connector"

if [ "$1" ]; then
    REST_HOST_NAME="$1"
else
    REST_DEFAULT_HOST_NAME=$(ip addr | grep 'BROADCAST' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
    REST_HOST_NAME="${REST_HOST_NAME:=${ADVERTISED_HOST_NAME:=$REST_DEFAULT_HOST_NAME}}"
fi

if [ "$2" ]; then
    REST_PORT="$2"
else
    REST_DEFAULT_PORT="${PORT:="8083"}"
    REST_PORT="${REST_PORT:=${ADVERTISED_PORT:=$REST_DEFAULT_PORT}}"
fi

while true
do
    /scripts/httpcheck.sh "http://${REST_HOST_NAME}:${REST_PORT}/" 200 20 "Waiting for the Kafka Connector REST service to start"
    /scripts/register_generate_json.sh "${REST_HOST_NAME}" "${REST_PORT}"
    /scripts/httpcheck.sh "http://${REST_HOST_NAME}:${REST_PORT}/" 200 120 "Kafka Connector REST service is down"
done