---
name: kernel-sync
kind: skill
tags:
  - workflow
  - kernel
profile: core
description: Reconcile .kernel project memory records with what actually happened in
  the codebase. Use when task state, linked knowledge, or documentation has drifted.
license: MIT
metadata:
  author: project
  version: "3.0"
  category: Workflow
  tags:
    - workflow
    - sync
disableModelInvocation: true
userInvocable: false
allowedTools:
  - bash
---

# kernel-sync

Audit `.kernel` against the repo. Present a drift report before changing records.

Check active tasks, archived tasks, goals, linked knowledge, and `.kernel/state.json` when task pointers matter. Mark checklist items done only after verifying code or tests. Capture durable findings as linked knowledge notes.
