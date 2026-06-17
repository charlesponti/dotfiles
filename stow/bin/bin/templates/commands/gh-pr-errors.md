---
name: gh-pr-errors
kind: command
tags:
  - git
  - debugging
description: Fetch the latest GitHub Actions errors for the open pull request on the current branch.
group: specialist
backedBySkill: kernel-git
allowedTools:
  - Bash
  - Read
  - Grep
  - Glob
---

Check the latest GitHub Actions errors for the open pull request on the current branch.

Use the `kernel-git` skill.

After running the skill:

- Report the latest run metadata in a compact summary.
- If the run is still in progress, say that there are no completed errors yet.
- If the run failed, summarize the first actionable error from the failed logs.
- If the run succeeded, say that clearly.
