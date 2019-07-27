all: test-sigint

test-sigint: build
	docker run -d --rm --name gandi-livedns-test-sigint \
		-e "REFRESH_INTERVAL=100" \
		-e "APIKEY=none" \
		-e "RECORD_LIST=test" \
		-e "DOMAIN=notavalid.domain" \
		gandi-livedns:snapshot
	sleep 5 # Give enough time to reach sleep instruction
	docker kill --signal="SIGINT" gandi-livedns-test-sigint
	sleep 1 # Give it a second to stop
	! docker container inspect gandi-livedns-test-sigint &> /dev/null || ! docker kill gandi-livedns-test-sigint &> /dev/null

build:
	docker build --rm -t gandi-livedns:snapshot .
