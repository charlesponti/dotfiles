---
name: kernel-review
kind: command
tags:
  - review
description: Review completed work against the active .kernel task and changed code.
group: workflow
backedBySkill: kernel-review
argumentHint: optional task id or changed files
---

Compare implementation against `.kernel/work/tasks/active/<task-id>/task.md`, especially acceptance criteria and checklist state.

Report findings only. Do not mark checklist items or archive — that is `kernel-do`'s job.
