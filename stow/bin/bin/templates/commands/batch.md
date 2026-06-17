---
name: batch
kind: command
tags:
  - workflow
description: Orchestrate large-scale changes across a codebase in parallel — decompose, plan, get approval, then execute each unit in isolation.
group: specialist
argumentHint: description of the change to make at scale (e.g., 'rename all occurrences of UserModel to User')
---

Orchestrate large-scale changes across this codebase in parallel.

1. Research the codebase to understand its structure, patterns, and conventions.
2. Decompose the work described in $ARGUMENTS into 5 to 30 independent units of work.
3. Present a plan listing each unit, the files it touches, and the approach.
4. Wait for approval before proceeding.
5. Once approved, implement each unit in isolation, run relevant tests, and open a pull request per unit.

Requires a git repository. Do not start implementation until the plan is approved.
