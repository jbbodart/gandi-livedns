#!/bin/sh
#
# Updates a zone record using Gandi's LiveDNS.

API="https://dns.api.gandi.net/api/v5/"
IP_SERVICE="http://me.gandi.net"

CURRENT_IPV6=$(dig AAAA ${DOMAIN} +short)

if [[ -z "${FORCE_IPV6}" ]]; then
  WAN_IPV6=$(curl -s6 ${IP_SERVICE})
  if [[ -z "${WAN_IPV6}" ]]; then
    echo "$(date "+[%Y-%m-%d %H:%M:%S]") [ERROR] Something went wrong. Can not get your IPv6 from ${IP_SERVICE}"
    exit 1
  fi
else
  WAN_IPV6="${FORCE_IPV6}"
fi

if [ "${CURRENT_IPV6}" = "${WAN_IPV6}" ] ; then
    echo "$(date "+[%Y-%m-%d %H:%M:%S]") [INFO] Current DNS AAAA record matches WAN IP (${CURRENT_IPV6}). Nothing to do."
    exit 0
fi

for RECORD in ${RECORD_LIST//;/ } ; do
  DATA='{"rrset_ttl": '${TTL}', "rrset_values": ["'${WAN_IPV6}'"]}'
  status=$(curl -s -w %{http_code} -o /dev/null -XPUT -d "${DATA}" \
    -H"X-Api-Key: ${APIKEY}" \
    -H"Content-Type: application/json" \
    "${API}/domains/${DOMAIN}/records/${RECORD}/AAAA")
  if [ "${status}" = '201' ] ; then
    echo "$(date "+[%Y-%m-%d %H:%M:%S]") [OK] Updated ${RECORD} to ${WAN_IPV6}"
  else
    echo "$(date "+[%Y-%m-%d %H:%M:%S]") [ERROR] API POST returned status ${status}"
  fi
done
