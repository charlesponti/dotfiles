---
name: kernel-git
kind: command
tags:
  - git
description: Git specialist for branch strategy, commit hygiene, merge conflict resolution, and history analysis.
group: specialist
argumentHint: git operation or question (e.g., 'resolve merge conflict', 'rebase feature branch')
backedBySkill: kernel-git
---

Use this when you need expert guidance on git operations and strategies.

What this command is for:

- Branch strategy and naming
- Commit hygiene and message quality
- Merge conflict resolution
- History analysis and understanding why changes were made
- Cherry-picking and rebasing decisions
- Cleaning up messy history safely

Git safety principles:

- Never rewrite public history without explicit permission
- Keep changes small and isolated
- Explain why a rebase, merge, cherry-pick, or stash is the best tool
- If history is already messy, identify the least risky cleanup path

Common operations:

- `kernel git resolve merge conflict` — analyze conflicts and recommend merge strategy
- `kernel git rebase feature-branch` — evaluate rebase safety and implications
- `kernel git cleanup history` — identify and resolve messy commits safely
- `kernel git analyze branch-state` — report on current branch structure and risks

Quality checks:

- The advice matches your current repository state
- Recommendations are practical, not theoretical
- Risks are identified before suggesting action
- The response names specific files and commit hashes when relevant

What to do next:

- Follow the recommended git strategy step by step
- If you hit an unexpected state, run this command again with more context
