set shell := ["/usr/bin/env", "sh", "-c"]

# Dotfiles commands. Script implementations live in ./stow/bin/bin.

setup:
    brew bundle check --file ./Brewfile || brew bundle install --file ./Brewfile
    ./stow/bin/bin/tmux-maintain.sh
    ./stow/bin/bin/shell-maintain.sh
    ./stow/bin/bin/runtime-verify.sh

doctor:
    ./stow/bin/bin/status.sh health

perf:
    ./stow/bin/bin/bench-shell.sh --runs 20

runtime-check:
    ./stow/bin/bin/runtime-verify.sh

brew-sync:
    brew bundle check --file ./Brewfile || brew bundle install --file ./Brewfile
    brew bundle cleanup --file ./Brewfile --force

install:
    ./stow/bin/bin/install.sh

bootstrap:
    ./stow/bin/bin/install.sh --bootstrap

update:
    ./stow/bin/bin/update.sh

symlinks:
    ./stow/bin/bin/symlinks.sh

status:
    ./stow/bin/bin/status.sh

lint:
    find ./stow/bin/bin -maxdepth 1 -type f -name '*.sh' -print0 | xargs -0 -n1 bash -n

shell-audit:
    ./stow/bin/bin/shell-surface-audit.sh

bench-shell:
    ./stow/bin/bin/bench-shell.sh

tmux-init session="main" dir="":
    ./stow/bin/bin/tmux-init.sh {{session}} {{dir}}

resource-scan:
    ./stow/bin/bin/resource-scan.sh

resource-guard max_swap_gb="2.0":
    ./stow/bin/bin/resource-guard.sh {{max_swap_gb}}
