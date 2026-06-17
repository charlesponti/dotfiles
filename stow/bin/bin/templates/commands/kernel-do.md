---
name: kernel-do
kind: command
tags:
  - workflow
description: Resolve and execute the next actionable task from .kernel.
group: workflow
argumentHint: optional goal or task ref
backedBySkill: kernel-execute
---

Use this to pick the next task to work on and get the context you need to execute it.

Without arguments: Kernel resolves the highest-priority next actionable task and shows you its context.

With a goal ref: Kernel finds the next unblocked task within that goal.

With a task ref: Kernel loads that specific task directly.

Before you start:
1. Read the task's acceptance criteria
2. Read linked knowledge
3. Note dependencies and validation steps

Execute the task by working through its acceptance criteria. If the scope changes or clarification is needed, pause and re-plan with `kernel plan`.
