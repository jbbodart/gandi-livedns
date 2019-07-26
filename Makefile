run: build
	docker run -e "APIKEY=none" -e "RECORD_LIST=test" -e "DOMAIN=notavalid.domain" gandi-livedns:snapshot

run:
	docker build -t gandi-livedns:snapshot .
