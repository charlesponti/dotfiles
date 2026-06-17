---
name: kernel-unblock
kind: skill
tags:
  - workflow
profile: core
description: Diagnose blocked .kernel tasks and decide whether to resolve, defer,
  split, or re-plan them.
license: MIT
metadata:
  author: project
  version: "3.0"
  category: Workflow
when:
  - implementation is blocked
termination:
  - Blocker resolution is captured in .kernel
outputs:
  - Updated task, follow-up task, or linked knowledge record
disableModelInvocation: true
userInvocable: false
allowedTools:
  - bash
---

# kernel-unblock

Read the blocked task's `.kernel/work/tasks/active/<task-id>/task.md`, inspect linked goals/knowledge, and classify the blocker.

Outcomes:

- Resolve and continue
- Update the task plan/checklist
- Create a follow-up task
- Capture missing context as a knowledge note
- Re-plan if scope changed
