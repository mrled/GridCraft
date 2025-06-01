# GridCraft.spoon Makefile

# Ignore built-in inference rules
.SUFFIXES:
# Warn on undefined variables
MAKEFLAGS += --warn-undefined-variables
# Fail if any command fails.
.SHELLFLAGS := -euc

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

LUASRCS := $(wildcard spoon/*.lua)
dist/GridCraft.spoon/version.txt: $(LUASRCS) dist/GridCraft.spoon/phosphor/assets/.installed ## Build the Spoon package
	mkdir -p dist/GridCraft.spoon
	cp -r spoon/*.lua spoon/*.css spoon/*.js readme.md dist/GridCraft.spoon/
	./getversion.sh > dist/GridCraft.spoon/version.txt

dist/GridCraft.spoon.zip: dist/GridCraft.spoon/version.txt ## Create the Spoon package zip file
	cd dist && zip -r GridCraft.spoon.zip GridCraft.spoon

# Docs generation requires a running Hammerspoon instance.
# It looks recursively for all *.lua files,
# so we want to do this on the .spoon directory,
# not in the root of the project which has other Lua files that don't have Spoon-style doc comments.
# Process the resulting JSON with jq to sort the keys so that the output is deterministic.
site/data/docs.json: dist/GridCraft.spoon/version.txt ## Generate documentation JSON
	mkdir -p site/data
	hs -A -c "hs.doc.builder.genJSON(\"$(CURDIR)/dist/GridCraft.spoon\")" > dist/docsoutput.txt
	grep -v "^--" < dist/docsoutput.txt | \
		jq -S . > site/data/docs.json
	@jq empty site/data/docs.json || (echo "Error generating docs.json, see dist/docsoutput.txt" && exit 1)

dist/hammerspoon/.git/HEAD:
	mkdir -p dist
	cd dist && git clone https://github.com/Hammerspoon/hammerspoon

.venv/bin/activate: dist/hammerspoon/.git/HEAD
	python3 -m venv .venv
	.venv/bin/pip install -U pip
	.venv/bin/pip install -r dist/hammerspoon/requirements.txt

# Build the spoon docs the way https://hammerspoon.org/Spoons/ does it.
# Includes a bunch stuff that assumes it's posted on https://hammerspoon.org/Spoons/ and https://github.com/hammerspoon/Spoons
# so it isn't really suitable for us to use directly, but it's a good way to test our docstrings.
dist/docs/.generated: $(LUASRCS) site/data/docs.json dist/GridCraft.spoon/version.txt .venv/bin/activate
	mkdir -p dist/docs
	.venv/bin/python3 dist/hammerspoon/scripts/docs/bin/build_docs.py --standalone --templates dist/hammerspoon/scripts/docs/templates --output_dir dist --json --html --markdown --standalone dist/GridCraft.spoon
	touch dist/docs/.generated
