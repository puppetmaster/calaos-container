GOCMD=go
GOTEST=$(GOCMD) test
GOVET=$(GOCMD) vet
BINARY_NAME=calaos-container
BINARY_NAME_TOOL=calaos-os
VERSION?=1.0.0

TOP_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
SUBDIRS := apt

SERVER_LDFLAGS := -L$(pwd)/bin -L. -L./bin -lcalaos-apt

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

.PHONY: all test build $(SUBDIRS)
.ONESHELL:

all: build

## Help:
help: ## Show this help.
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)

## Build:
build: build-lib build-server build-tools ## Build the project and put the output binary in bin/
	@mkdir -p bin

build-tools:
	@mkdir -p bin
	@cd cmd/calaos-os
	$(GOCMD) build -v -o $(TOP_DIR)/bin/$(BINARY_NAME_TOOL) .
	@cd $(TOP_DIR)

build-server: build-lib
	@mkdir -p bin
	CGO_LDFLAGS="$(SERVER_LDFLAGS)" $(GOCMD) build -v -o bin/$(BINARY_NAME) .

build-lib: $(SUBDIRS)
	@mkdir -p bin
	@mv apt/libcalaos-apt.so bin/

$(SUBDIRS):
	$(MAKE) -C $@

clean: ## Remove build related file
	rm -fr ./bin
	rm -fr ./out
	rm -f ./junit-report.xml checkstyle-report.xml ./coverage.xml ./profile.cov yamllint-checkstyle.xml

## Test:
test: ## Run the tests of the project
#	$(GOTEST) -v -race ./... $(OUTPUT_OPTIONS)
	@echo test disabled

coverage: ## Run the tests of the project and export the coverage
	$(GOTEST) -cover -covermode=count -coverprofile=profile.cov ./...
	$(GOCMD) tool cover -func profile.cov