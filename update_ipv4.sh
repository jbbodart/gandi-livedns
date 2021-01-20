#!/bin/bash
API_URL="https://ote-api.nameshield.net/v1"
IP_SERVICE="http://me.gandi.net"

if [[ -z "${FORCE_IPV4}" ]]; then                                                                                
  WAN_IPV4=$(curl -s4 ${IP_SERVICE})                                                                           
  if [[ -z "${WAN_IPV4}" ]]; then                                                                                
    echo "$(date "+[%Y-%m-%d %H:%M:%S]") [ERROR] Something went wrong. Can not get your IPv4 from ${IP_SERVICE}" 
    exit 1
  fi
else
  WAN_IPV4="${FORCE_IPV4}"
fi

for RECORD in ${RECORD_LIST//;/ }; do
  if [ "${RECORD}" = "@" ] || [ "${RECORD}" = "*" ]; then
    SUBDOMAIN="${DOMAIN}"
  else
    SUBDOMAIN="${RECORD}.${DOMAIN}"
  fi

  CURRENT_IPV4=$(dig A ${SUBDOMAIN} +short)

  if [ "${CURRENT_IPV4}" = "${WAN_IPV4}" ]; then
    echo "$(date "+[%Y-%m-%d %H:%M:%S]") [INFO] Current DNS A record for ${RECORD} matches WAN IP (${CURRENT_IPV4}). Nothing to do."
    continue
  fi

  DATA='{"name":"", "type": "A", "data": ["'${WAN_IPV4}'"] , "ttl": '${TTL}'}'

  status=$(curl --location --request "${API_URL}/zones/${DOMAIN}/records" \
    -H"Authorization: Bearer ${APIKEY}" \
    -H"Content-Type: application/json" \
    --data-raw "${DATA}"

  if [ "${status}" = '201' ] ; then
    echo "$(date "+[%Y-%m-%d %H:%M:%S]") [OK] Updated ${RECORD} to ${WAN_IPV4}"
  else
    echo "$(date "+[%Y-%m-%d %H:%M:%S]") [ERROR] API POST returned status ${status}"
  fi
done
