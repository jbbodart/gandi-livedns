#!/bin/sh

if [[ -z "${GANDI_PAT}" && ! -z ${APIKEY} ]]; then
  GANDI_PAT=${APIKEY}
fi

if [[ -z "${GANDI_PAT}" || -z "${RECORD_LIST}" || -z "${DOMAIN}" ]]; then
  echo "[ERROR] Mandatory variable GANDI_PAT, DOMAIN or RECORD_LIST not defined."
  exit 1
fi

if [[ -z "${REFRESH_INTERVAL}" ]]; then
  REFRESH_INTERVAL=600
fi

while true; do
  if [ "${SET_IPV4}" = 'yes' ] ; then
    update_ipv4.sh
  fi
  if [ "${SET_IPV6}" = 'yes' ] ; then
    update_ipv6.sh
  fi
  sleep ${REFRESH_INTERVAL} & wait
done
