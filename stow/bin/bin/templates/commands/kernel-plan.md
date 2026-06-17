---
name: kernel-plan
kind: command
tags:
  - workflow
  - planning
description: Turn a spark into goals, tasks, and knowledge.
group: workflow
argumentHint: spark, optional goal/task ref, or empty for interactive intake
backedBySkill: kernel-plan
---

Use this to turn an unstructured idea, bug, feature request, or strategic direction into durable work in `.kernel`.

Start with a spark, not a record type.

Kernel investigates the repo and `.kernel` first, asks only necessary questions, then decides the right structure and breaks the work into concrete tasks.

Plans live in `.kernel`, not chat:

- Goals live in `.kernel/work/goals/<id>/goal.md` (outcome containers)
- Tasks live in `.kernel/work/tasks/active/<id>/task.md` (executable work units)
- Knowledge lives in `.kernel/knowledge/notes/<id>/note.md` (observations and research findings)
- Guides live in `.kernel/knowledge/guides/<id>/guide.md` (procedures and runbooks)
- Reference lives in `.kernel/knowledge/reference/<id>/reference.md` (canonical concepts and stable explanations)
- Learnings live in `.kernel/knowledge/learnings/<slug>.md` (captured after task completion)
- Local runtime state lives in `.kernel/state.json`

Each record has one markdown file with frontmatter. Link knowledge instead of duplicating rationale across work records.

Goals group tasks.
