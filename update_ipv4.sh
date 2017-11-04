#!/bin/sh
#
# Updates domain A zone record with WAN IP using Gandi's LiveDNS.

API="https://dns.api.gandi.net/api/v5/"
IP_SERVICE="http://me.gandi.net"

CURRENT_IPV4=$(dig A ${DOMAIN} +short)

if [[ -z "${FORCE_IPV4}" ]]; then
  WAN_IPV4=$(curl -s4 ${IP_SERVICE})
  if [[ -z "${WAN_IPV4}" ]]; then
    echo "$(date "+[%Y-%m-%d %H:%M:%S]") [ERROR] Something went wrong. Can not get your IPv4 from ${IP_SERVICE}"
    exit 1
  fi
else
  WAN_IPV4="${FORCE_IPV4}"
fi

if [ "${CURRENT_IPV4}" = "${WAN_IPV4}" ] ; then
    echo "$(date "+[%Y-%m-%d %H:%M:%S]") [INFO] Current DNS A record matches WAN IP (${CURRENT_IPV4}). Nothing to do."
    exit 0
fi

for RECORD in ${RECORD_LIST//;/ } ; do
  DATA='{"rrset_ttl": '${TTL}', "rrset_values": ["'${WAN_IPV4}'"]}'
  status=$(curl -s -w %{http_code} -o /dev/null -XPUT -d "${DATA}" \
    -H"X-Api-Key: ${APIKEY}" \
    -H"Content-Type: application/json" \
    "${API}/domains/${DOMAIN}/records/${RECORD}/A")
  if [ "${status}" = '201' ] ; then
    echo "$(date "+[%Y-%m-%d %H:%M:%S]") [OK] Updated ${RECORD} to ${WAN_IPV4}"
  else
    echo "$(date "+[%Y-%m-%d %H:%M:%S]") [ERROR] API POST returned status ${status}"
  fi
done
