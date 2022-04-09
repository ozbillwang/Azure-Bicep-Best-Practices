### Set environment variables
define HELP_TEXT
Usage: make [TARGET]
Available targets:
endef

export HELP_TEXT

help: ## help target
	@echo "$$HELP_TEXT"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / \
		{printf "\033[36m%-30s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

dryRun: ## dry run, sample: make dryRun env=dev
	dryRun=true bash -x scalesets.sh $(env)

deploy: ## deploy, sample:  make deploy env=dev
	dryRun=false bash -x scalesets.sh $(env)
