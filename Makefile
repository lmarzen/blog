.PHONY: all build preview publish server clean

all: server

build:
	hugo --gc --minify

publish:
	hugo --gc --minify --baseURL $(DEPLOY_PRIME_URL)

preview:
	hugo --gc --minify --buildFuture --baseURL $(DEPLOY_PRIME_URL)

server:
	hugo server
	# hugo server --buildDrafts --buildExpired --buildFuture

clean:
	rm -rf public resources avif

