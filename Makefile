MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
ARGS :=
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

.PHONY: $(shell egrep -oh ^[a-zA-Z0-9][a-zA-Z0-9_-]+: $(MAKEFILE_LIST) | sed 's/://')

help: ## Print this help
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9][a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

version := $(shell git rev-parse --abbrev-ref HEAD)

#------

clean-package:
	@rm -rf slackego src/nimcache

package: clean-package
	@nim c -d:ssl -d:release -d:quick --opt:size src/slackego.nim
	@mv src/slackego .

release: package
	@echo '1. Staging and commit'
	git add slackego.nimble
	git commit -m ':package: Version $(version)'

	@echo '2. Tags'
	git tag v$(version) -m v$(version)

	@echo '3. Push'
	git push

	@echo 'Success All!!'
	@echo 'Create a pull request and merge to master!!'
	@echo 'https://github.com/tadashi-aikawa/slackego/compare/$(version)?expand=1'
	@echo '..And deploy package!!'

