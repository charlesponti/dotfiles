---
name: kernel-task-status
kind: command
tags: [workflow]
description: Show task status, progress, next item, and .kernel location.
group: workflow
target: task status
argumentHint: optional task id
---

Use this to inspect the active task without changing state. The next unchecked checklist item is included in the output, and the active task pointer comes from `.kernel/state.json` when no task id is provided.
