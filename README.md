# gandi-livedns

The purpose of this container is to update DNS zone records using Gandi's LiveDNS (http://doc.livedns.gandi.net/) with your WAN IP.

Mandatory variables:
* APIKEY: your Gandi API key
* DOMAIN: your Gandi domain
* RECORD_LIST: DNS records to update separated by ";"

Optional variables :
* REFRESH_INTERVAL: Delay between updates (default: 10mn)
* TTL: Set Time To Live for records (default: 300)
* SET_IPV4: Update A record (default: yes)
* SET_IPV6: Update AAAA record (default: no)
* FORCE_IPV4: Force the IPv4 address to be used in DNS A records
* FORCE_IPV6: Force the IPv6 address to be used in DNS AAAA records
