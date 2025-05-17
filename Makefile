.PHONY: build run runc

APP_PORT   ?= 3210
DOMAIN     ?= app.local
SSL_PORT   := $(shell expr $(APP_PORT) + 1)
IMAGE      := sanixdarker/localhost.https

# to build
build:
	@docker build -t $(IMAGE) .

# to run on Linux (host networking)
# Usage: make run APP_PORT=<port> DOMAIN=<domain>
run:
	@docker run --rm -d \
		--network host \
		-e APP_PORT=$(APP_PORT) \
		-e DOMAIN=$(DOMAIN) \
		$(IMAGE)

# to run on macOS/Windows (port mapping)
# Usage: make runc APP_PORT=<port> DOMAIN=<domain>
runc:
	@docker run --rm -d \
		-p $(SSL_PORT):$(SSL_PORT) \
		-e APP_PORT=$(APP_PORT) \
		-e DOMAIN=$(DOMAIN) \
		$(IMAGE)

# to set the automatic forward
set-forward:
	echo "127.0.0.1 app.local" | sudo tee -a /etc/hosts

# just to print usage examples
usage:
	@echo "Usage :"
	@echo "  make build                                        # To docker build the localhost.https image"
	@echo "  make run   APP_PORT=3001 DOMAIN=myapp.local       # APP_PORT and DOMAIN are optionals, defaults will be use if not provided"
	@echo "  make runc  APP_PORT=3001 DOMAIN=myapp.local       # for windows and mac"
	@echo "  make set-forward                                  # To set in /etc/hosts app.local"
