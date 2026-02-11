.PHONY: help install update symlinks status lint

# Colors
BLUE := \033[0;34m
NC := \033[0m

help: ## Show this help message
	@echo "$(BLUE)Available commands:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[32m%-20s\033[0m %s\n", $$1, $$2}'

lint: ## Run shellcheck on all shell scripts
	./bin/lint.sh

install: ## Run fresh installation
	./install.sh

bootstrap: ## Bootstrap fresh system (clone and install)
	./install.sh --bootstrap

update: ## Update dotfiles and packages
	./update.sh

symlinks: ## Re-link all dotfiles
	./bin/symlinks.sh

status: ## Show dotfiles status (use ./bin/status.sh for more options)
	./bin/status.sh

doctor: ## Run system health check (alias for status health)
	./bin/status.sh health

help-commands: ## Show command reference (alias for status help)
	./bin/status.sh help
