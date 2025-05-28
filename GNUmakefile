# GridCraft.spoon Makefile

# Ignore built-in inference rules
.SUFFIXES:
# Warn on undefined variables
MAKEFLAGS += --warn-undefined-variables
# Fail if any command fails.
.SHELLFLAGS := -eu

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

dist/GridCraft.spoon/phosphor/assets/.installed: phosphor/node_modules/@phosphor-icons/core/assets/regular/x.svg
	mkdir -p dist/GridCraft.spoon/phosphor
	cp -r "phosphor/node_modules/@phosphor-icons/core/assets" dist/GridCraft.spoon/phosphor
	touch dist/GridCraft.spoon/phosphor/assets/.installed

dist/GridCraft.spoon: dist/GridCraft.spoon/phosphor/assets/.installed ## Build the Spoon package
	mkdir -p dist/GridCraft.spoon
	cp -r *.lua *.css README.md dist/GridCraft.spoon/

dist/GridCraft.spoon.zip: dist/GridCraft.spoon ## Create the Spoon package zip file
	cd dist && zip -r GridCraft.spoon.zip GridCraft.spoon
