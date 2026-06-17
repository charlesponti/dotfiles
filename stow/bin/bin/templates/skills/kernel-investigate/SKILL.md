---
name: kernel-investigate
kind: skill
tags:
  - workflow
  - exploration
profile: core
description: Investigate unknowns, tradeoffs, and risks for .kernel tasks, goals,
  or knowledge records. Write durable findings back to linked knowledge.
license: MIT
metadata:
  author: project
  version: "3.0"
  category: Workflow
when:
  - planning or execution needs deeper investigation
termination:
  - Findings are written or linked in .kernel
outputs:
  - Research records linked to work
disableModelInvocation: true
userInvocable: false
allowedTools:
  - bash
---

# kernel-investigate

Investigate unknowns and route findings to the right `.kernel` home.

- If the finding changes execution, update the relevant `task.md` or `goal.md`.
- If the finding is reusable, create a knowledge note and link it from the work record.
- Keep evidence grounded in source files, command output, or existing `.kernel` records.
