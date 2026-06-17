---
name: kernel-status
kind: command
tags:
  - workflow
description: Show current goals, tasks, blockers, and recommended next actions from .kernel.
group: workflow
argumentHint: optional goal, task, or knowledge ref
backedBySkill: kernel-status
---

Use this to inspect the current state of work and find what should happen next.

Without arguments: show a dashboard of active goals, next actionable tasks, blockers, and stale items.

With a goal or task ref: show detailed status including progress, acceptance criteria, dependencies, linked knowledge, and recommended next task.

All status comes from durable `.kernel` records, not ephemeral state.
