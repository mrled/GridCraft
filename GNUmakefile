# GridCraft.spoon Makefile

# Ignore built-in inference rules
.SUFFIXES:
# Warn on undefined variables
MAKEFLAGS += --warn-undefined-variables
# Fail if any command fails.
SHELL := /bin/sh
.SHELLFLAGS := -ec

# Build configuration
VERSION ?= 0.1.0-devel
ARTIFACT_SUFFIX ?=
ifeq ($(ARTIFACT_SUFFIX),)
	ZIP_NAME := GridCraft.spoon.zip
else
	ZIP_NAME := GridCraft.spoon$(ARTIFACT_SUFFIX).zip
endif

# Show a nice table of Make targets
.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: clean
clean: ## Clean up build artifacts
	@echo "Cleaning up build artifacts..."
	@rm -rf dist

phosphor/node_modules/@phosphor-icons/core/assets/regular/x.svg:
	cd phosphor && npm install

.PHONY: phosphor
phosphor: phosphor/node_modules/@phosphor-icons/core/assets/regular/x.svg ## Install Phosphor icons

dist/GridCraft.spoon/phosphor/assets/.installed: 
	mkdir -p dist/GridCraft.spoon/phosphor/assets
	if [ -d "phosphor/node_modules/@phosphor-icons/core/assets" ]; then \
		cp -r "phosphor/node_modules/@phosphor-icons/core/assets" dist/GridCraft.spoon/phosphor; \
	fi
	touch dist/GridCraft.spoon/phosphor/assets/.installed

dist/GridCraft.spoon: dist/GridCraft.spoon/phosphor/assets/.installed ## Build the Spoon package
	mkdir -p dist/GridCraft.spoon
	cp -r *.lua *.css readme.md dist/GridCraft.spoon/
	echo "$(VERSION)" > dist/GridCraft.spoon/version.txt

dist/$(ZIP_NAME): dist/GridCraft.spoon ## Create the Spoon package zip file
	cd dist && zip -r $(ZIP_NAME) GridCraft.spoon
