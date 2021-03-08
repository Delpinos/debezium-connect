#!/bin/bash

if [ "$1" ]; then
    HTTP_CHECK_CURL_URL="$1"
fi

if [ "$2" ]; then
    HTTP_CHECK_STATUS_OK="$2"
fi

if [ "$3" ]; then
    HTTP_CHECK_INTERVAL=$3
fi

if [ "$4" ]; then
    HTTP_CHECK_ERROR_MESSAGE="$4"
fi

HTTP_CHECK_CURL_URL=${HTTP_CHECK_CURL_URL:=$(ip addr | grep 'BROADCAST' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')}
HTTP_CHECK_STATUS_OK=${HTTP_CHECK_STATUS_OK:=200}
HTTP_CHECK_INTERVAL=${HTTP_CHECK_INTERVAL:=3}
HTTP_CHECK_ERROR_MESSAGE=${HTTP_CHECK_ERROR_MESSAGE:="Service is down: ${HTTP_CHECK_CURL_URL}"}
HTTP_CHECK_CURL_COMMAND=${HTTP_CHECK_CURL_COMMAND:="curl -s -k -o /dev/null -Isw %{http_code} ${HTTP_CHECK_CURL_URL}"}

export HTTP_CHECK_STATUS=$($HTTP_CHECK_CURL_COMMAND)

while [ "$HTTP_CHECK_STATUS" != "$2" ]
do
	echo -e "${HTTP_CHECK_ERROR_MESSAGE}"
	sleep $HTTP_CHECK_INTERVAL	
	export HTTP_CHECK_STATUS=$($HTTP_CHECK_CURL_COMMAND)
done