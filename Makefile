export NODE_ENV := production
export APP_NAME := $(shell npm pkg get name | xargs)# Get project name from package.json config
export TAG :=# Latest Version Tag
export DOCKER_HOST_PORT :=3000
export DOCKER_CONTAINER_PORT :=3000

DOCKER_ACCOUNT :=$(DOCKER_ACCOUNT)# Docker account name when push the image to registry
GIT_COMMIT :=$(shell git rev-parse --short HEAD)# Get latest commit hash code
DOCKER_IMAGE :=# Latest Docker Image
RECEIPT :=# Used for echo

.PHONY: all build run push commit dev test

all: build push commit ## All in one when release: build a new image, push to the registry, commit the version upda
	@$(MAKE) echo RECEIPT=all

build: version-update variable-update ## Build a latest docker image
	@echo Building Image for: ${DOCKER_IMAGE}
	@docker compose -f docker/$(NODE_ENV)/docker-compose.yml build \
		--build-arg GIT_COMMIT=$(GIT_COMMIT) \
		--build-arg TAG=$(TAG) \
		--build-arg ENV=$(NODE_ENV) \
		--build-arg DOCKER_CONTAINER_PORT=$(DOCKER_CONTAINER_PORT)
	@docker images | grep ${APP_NAME}
	@$(MAKE) echo RECEIPT=build

push: variable-update ## Tag and push the latest image to the docker registry
	@echo "Pushing this image to registry $(DOCKER_ACCOUNT)/$(DOCKER_IMAGE)"
	@docker tag $(DOCKER_IMAGE) $(DOCKER_ACCOUNT)/$(DOCKER_IMAGE)
	@docker push $(DOCKER_ACCOUNT)/$(DOCKER_IMAGE)
	@docker image rm $(DOCKER_ACCOUNT)/$(DOCKER_IMAGE)
	@$(MAKE) echo RECEIPT=push

dev: export NODE_ENV = development
dev: ## Start the dev mode
# just `@pnpm install` if pnpm enabled already
	@corepack enable pnpm && pnpm install 
	@pnpm run dev

run: variable-update ## Run the latest docker image in local
	@docker container run -it -p $(DOCKER_HOST_PORT):$(DOCKER_CONTAINER_PORT) $(DOCKER_IMAGE)

commit: variable-update ## Git commit the changes 
	@if git status --porcelain; then \
		git add .; \
		git commit -m "chore: $(TAG)"; \
		git push; \
	else \
		echo "[commit] No files to commit."; \
	fi
	@$(MAKE) echo RECEIPT=commit

# helper section
.PHONY: version-update variable-update echo help

version-update: # Update project version
	@sh -c "npx cross-env NODE_ENV=${NODE_ENV} npm run version:update || (echo 'Version update failed!' && exit 1)"

variable-update: # Get latest variables
	$(eval TAG := v$(shell npm pkg get version | xargs))
	$(eval DOCKER_IMAGE :=$(APP_NAME)-$(NODE_ENV):$(TAG))

echo:
	@echo [🚀 $(RECEIPT)] Succeed!
# @echo $(TAG)
# @echo DOCKER_IMAGE: $(DOCKER_IMAGE)

# this tells Make to run 'make help' if the user runs 'make'
# without this, Make would use the first target as the default
.DEFAULT_GOAL := help

# here we have a simple way of outputting documentation
# the @-sign tells Make to not output the command before running it
help: ## Make Helper
	@echo "Available commands:"
	@awk -F ':|##' '/^[a-zA-Z\-\_0-9]+:.*?##/ { \
		printf "  %-20s %s\n", $$1, $$NF \
	}' $(MAKEFILE_LIST) | sort
