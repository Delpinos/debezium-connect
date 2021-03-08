#!/bin/bash

mkdir -p /connectors

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

for i in {1..100}
do
    env | grep "^REGISTER_${i}_CONFIG" |
    {
        JO_OPTS=()
        register_variable_name="REGISTER_${i}_NAME" 
        if [[ ! "${!register_variable_name}x" = "x" ]] ; then
            JO_OPTS+=("name=${!register_variable_name}")
            while read -r VAR;
            do
                env_var=`echo "$VAR" | sed -r "s/(.*)=.*/\1/g"`
                prop_name=`echo "$VAR" | sed -r "s/^REGISTER_${i}_CONFIG_(.*)=.*/\1/g" | tr '[:upper:]' '[:lower:]' | tr _ .`
                prop_value=`echo "$VAR" | sed -r "s/^REGISTER_${i}_CONFIG_.*=(.*)/\1/g"`
                JO_OPTS+=("config[${prop_name}]=${prop_value}")
            done
            if (( ${#JO_OPTS[@]} )); then  
                connector_url="http://${REST_HOST_NAME}:${REST_PORT}/connectors"
                status_command="curl -s -k -o /dev/null -Isw %{http_code} ${connector_url}/${!register_variable_name}"
                status_code=$($status_command)
                jo "${JO_OPTS[@]}" | jq > "/connectors/${!register_variable_name}.json"
                if [ "$status_code" == "404" ]; then                    
                    curl -i -X POST \
                        -H "Accept:application/json" \
                        -H  "Content-Type:application/json" \
                        $connector_url -d @"/connectors/${!register_variable_name}.json" | jq > "/connectors/${!register_variable_name}_response.json"
                        cat "/connectors/${!register_variable_name}_response.json"
                fi               
            fi        
        fi       
    }
done