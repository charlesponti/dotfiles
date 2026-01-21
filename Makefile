.PHONY: help install update symlinks doctor test-performance

# Colors
BLUE := \033[0;34m
NC := \033[0m

help: ## Show this help message
	@echo "$(BLUE)Available commands:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[32m%-20s\033[0m %s\n", $$1, $$2}'

lint: ## Run shellcheck on all shell scripts
	./bin/lint.sh

install: ## Run fresh installation
	./bootstrap.sh

update: ## Update dotfiles and packages
	./update.sh

symlinks: ## Re-link all dotfiles
	./bin/symlinks.sh

doctor: ## Run system health check
	./bin/doctor.sh

test-performance: ## Run terminal performance benchmarks
	./bin/terminal-performance.sh
