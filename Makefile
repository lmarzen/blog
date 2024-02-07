.PHONY: all build gen-avif init preview publish server clean

# Check if NETLIFY is set to true and run install.sh if it is
# ifeq ($(NETLIFY),true)
# $(info NETLIFY environment variable is set to true. Running install.sh...)
# $(shell bash scripts/build-avifenc.sh)
# endif

all: server

init:
	hugo --gc --minify

gen-avif: init
	bash scripts/gen-avif.sh

build: gen-avif
	hugo --gc --minify


publish: gen-avif
	hugo --gc --minify --baseURL $(DEPLOY_PRIME_URL)

preview: gen-avif
	hugo --gc --minify --buildFuture --baseURL $(DEPLOY_PRIME_URL)

server: gen-avif
	hugo server
	# hugo server --buildDrafts --buildExpired --buildFuture

clean:
	rm -rf public resources avif

