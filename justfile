set shell := ["/usr/bin/env", "sh", "-c"]

# POSIX-shell operational commands

doctor:
    ./bin/doctor.sh

brew-sync:
    brew bundle check --file ./Brewfile || brew bundle install --file ./Brewfile
    brew bundle cleanup --file ./Brewfile --force

snapshot-baseline:
    ./bin/snapshot-baseline.sh

bench-shell:
    ./bin/bench-shell.sh

bench-git repo=".":
    ./bin/bench-git.sh --repo {{repo}}

bench-fs path=".":
    ./bin/bench-fs.sh --path {{path}}

bench-corpus runs="20":
    ./bin/bench-corpus.sh --runs {{runs}}

watch-test cmd="npm test":
    ./bin/watch-test.sh "{{cmd}}"

watch-lint cmd="npm run lint && npm run typecheck":
    ./bin/watch-lint.sh "{{cmd}}"

resource-scan:
    ./bin/resource-scan.sh

resource-guard max_swap_gb="2.0":
    ./bin/resource-guard.sh {{max_swap_gb}}

lane-core:
    ./bin/lane-core.sh

lane-advanced:
    ./bin/lane-advanced.sh
