.PHONY: h help \
	image \
	local \
	multiarch

HUB_USER=unixorn
PLATFORMS=linux/arm64,linux/amd64
TALOS_VERSION="1.11.5"
VERSION_STAMP=$(shell date +%F-%H%M)

h: help
help:
	@echo "Options:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

local: image
image: Makefile ## Makes a debian-based docker image with talosctl in it
	docker buildx build \
		--pull \
		--load \
		-t ${HUB_USER}/talosctl-backup \
		-f Dockerfile .

multiarch: build-latest-tag build-talosversion-tag  ## Makes a multi-architecture docker image
build-talosversion-tag:
	@echo "Building ${HUB_USER}/talosctl-backup:$(TALOS_VERSION).$(VERSION_STAMP)"
	docker buildx build --platform ${PLATFORMS} \
		--no-cache \
		--pull \
		--push -t ${HUB_USER}/talosctl-backup:$(TALOS_VERSION).$(VERSION_STAMP) \
		-f Dockerfile .

# dockerhub doesn't automatically set latest tag on the last thing
# uploaded, so do this dirty hack to set it ourselves
build-latest-tag: build-talosversion-tag
	@echo "Building ${HUB_USER}/talosctl-backup:latest"
	docker buildx build --platform ${PLATFORMS} \
		--pull \
		--push \
		-t ${HUB_USER}/talosctl-backup:latest \
		-f Dockerfile .
	docker pull ${HUB_USER}/talosctl-backup:latest
