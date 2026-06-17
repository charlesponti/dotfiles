---
name: kernel-git
kind: skill
tags:
  - git
profile: core
description: Guides advanced git workflows, branch management, history
  rewriting, and collaboration patterns. Also inspects GitHub Actions CI status
  for the current pull request. Use when branching, merging, rebasing, resolving
  merge conflicts, cleaning up commit history, checking CI failures, or when
  users ask about git collaboration.
license: MIT
compatibility: Works with any git repository. CI Status section requires gh CLI
  with an authenticated session.
metadata:
  author: project
  version: "2.0"
  category: Version Control
  tags:
    - git
    - workflow
    - collaboration
    - ci
    - github-actions
when:
  - user asks about branching, merging, or rebasing
  - there are merge conflicts to resolve
  - user wants to clean up commit history before a PR
  - user needs help with git collaboration workflows
  - user asks why the current pull request is failing in CI
  - user wants the latest GitHub Actions errors for the active branch
applicability:
  - Use when working with git history, branches, or remote repositories
  - Use for commit hygiene, rebase workflows, and conflict resolution
  - Use when CI is failing on the active branch and you need the first actionable error
termination:
  - Git operation described and commands provided
  - Conflict resolved or branch strategy defined
  - CI status surfaced with first actionable error identified
outputs:
  - Git commands and workflow guidance
  - Branch strategy or commit message recommendations
  - Compact CI status summary and first actionable GitHub Actions failure
userInvocable: false
---

Advanced git workflows, history management, and collaboration patterns.

## Principles

- **Never rewrite public history** — rebase is for local branches only; use `--force-with-lease`, never `--force`
- **Small, focused commits** — one logical change per commit; easier to review, bisect, and revert
- **Commit messages explain why** — the diff shows what changed; the message explains the reason
- **Feature branches always** — no direct commits to `main`
- **Integrate often** — rebase onto `main` before opening a PR; long-lived branches diverge and become painful

## Commit Messages

```
type(scope): short imperative summary (≤72 chars)

Optional body explaining WHY, not WHAT. Wrap at 72 chars.
Reference issues: Closes #123
```

Types: `feat`, `fix`, `chore`, `refactor`, `test`, `docs`, `perf`, `ci`

## Interactive Rebase

Clean history before opening a PR:

```bash
git rebase -i main
```

Common fixup operations:

- `squash` / `s` — merge into previous commit, combine messages
- `fixup` / `f` — merge into previous commit, discard this message
- `reword` / `r` — keep commit, edit message
- `drop` / `d` — remove commit entirely

```bash
# After rebase, force-push the branch (never main)
git push --force-with-lease origin feature/my-branch
```

`--force-with-lease` fails if someone else pushed since your last fetch — safe by default.

## Resolving Merge Conflicts

```bash
# Update and rebase onto main
git fetch origin
git rebase origin/main

# If conflicts occur:
# 1. Open conflicted files — resolve each <<<<< marker
# 2. Stage resolved files
git add <file>
# 3. Continue the rebase
git rebase --continue

# To abort and return to pre-rebase state
git rebase --abort
```

For complex conflicts, use a 3-way merge tool:

```bash
git mergetool
```

## Cherry-Picking

Apply a specific commit to another branch:

```bash
git cherry-pick <commit-sha>

# Cherry-pick a range
git cherry-pick A..B

# Cherry-pick without committing (stage only)
git cherry-pick --no-commit <commit-sha>
```

## Stash

```bash
# Stash with a message
git stash push -m "WIP: description"

# List stashes
git stash list

# Apply most recent stash (keep it in the list)
git stash apply

# Apply and drop
git stash pop

# Apply a specific stash
git stash apply stash@{2}

# Drop a stash
git stash drop stash@{0}
```

## Recovering Lost Work

```bash
# Find a lost commit via reflog
git reflog

# Restore a commit
git checkout <sha>
# or create a branch from it
git checkout -b recovery/<sha> <sha>

# Undo the last commit but keep changes staged
git reset --soft HEAD~1

# Undo the last commit and unstage changes
git reset HEAD~1
```

## Bisect — Finding the Commit That Introduced a Bug

```bash
git bisect start
git bisect bad                  # current commit is broken
git bisect good <known-good-sha>

# Git checks out a midpoint — test it, then mark:
git bisect good   # or: git bisect bad

# Git narrows it down; repeat until it identifies the culprit
git bisect reset  # return to HEAD when done
```

## CI Status

Check GitHub Actions results for the current branch's pull request.

**Requires**: `gh` CLI with an authenticated session (`gh auth login`).

### Workflow

1. Run `.claude/skills/kernel-git/scripts/check-last-gh-actions-errors.sh` from the repo root.
2. If `gh` is missing or unauthenticated, stop and tell the user exactly what is missing.
3. If the current branch has no open pull request, stop and report that.
4. If no pull request workflow runs exist yet, stop and report that.
5. Surface the PR URL, branch pair, workflow name, status, conclusion, commit, and start time.
6. If the latest run is still in progress, report that — no completed errors to show yet.
7. If the latest run succeeded, say so clearly.
8. If the latest run failed, summarize the failed step logs and call out the first actionable error.

Prefer the bundled script over reimplementing the `gh` query flow in ad hoc shell. Fall back from `gh run view --log-failed` to `gh run view --log` when GitHub cannot scope failed logs.

---

## Guardrails

- Never `git push --force` to `main` or any shared branch — use `--force-with-lease` on personal branches only
- Never rebase a branch that others are working on
- Never commit directly to `main` — always via a PR
- Never use `git add .` without reviewing what's staged — use `git add -p` for fine-grained control
- Always verify `git status` before committing
