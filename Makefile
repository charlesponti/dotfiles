.PHONY: help install update symlinks status lint doctor brew-sync snapshot-baseline bench-shell bench-git bench-fs bench-corpus watch-test watch-lint resource-scan resource-guard shell-audit

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

doctor: ## Run doctor checks
	./bin/doctor.sh
	@if [ "$(SHELL_AUDIT)" = "1" ]; then ./bin/shell-surface-audit.sh; else echo "Skipping shell surface audit (set SHELL_AUDIT=1 or run make shell-audit)"; fi

brew-sync: ## Enforce Brewfile as canonical package state
	brew bundle check --file ./Brewfile || brew bundle install --file ./Brewfile
	brew bundle cleanup --file ./Brewfile --force

snapshot-baseline: ## Capture machine baseline versions into reports/machine-baseline.md
	./bin/snapshot-baseline.sh

bench-shell: ## Benchmark zsh startup latency
	./bin/bench-shell.sh

bench-git: ## Benchmark git and search latency in current repo
	./bin/bench-git.sh --repo .

bench-fs: ## Benchmark filesystem search latency in current directory
	./bin/bench-fs.sh --path .

bench-corpus: ## Benchmark git/search across fixed repo corpus
	./bin/bench-corpus.sh

watch-test: ## Watch files and run test loop
	./bin/watch-test.sh

watch-lint: ## Watch files and run lint/typecheck loop
	./bin/watch-lint.sh

resource-scan: ## Print memory/swap/thermal resource telemetry snapshot
	./bin/resource-scan.sh

resource-guard: ## Fail if resource pressure exceeds thresholds
	./bin/resource-guard.sh

shell-audit: ## Audit shell command surface and required aliases/functions
	./bin/shell-surface-audit.sh

help-commands: ## Show command reference (alias for status help)
	./bin/status.sh help
