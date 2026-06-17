---
name: kernel-status
kind: skill
tags:
  - workflow
profile: core
description: "Report current state from the repo .kernel project memory: goals,
  tasks, blockers, and recommended next actions. Use when asking where things
  stand, what is blocking progress, or what comes next."
license: MIT
metadata:
  author: project
  version: "4.0"
  category: Workflow
  tags:
    - workflow
    - status
when:
  - user asks where things stand, what is blocking, or what comes next
  - user wants to inspect current work state
  - user wants to find the next actionable task
termination:
  - Status report delivered from verifiable .kernel records
  - Next action is unambiguous
  - Blockers and risks are identified
outputs:
  - Status report with progress and recommendations
disableModelInvocation: false
userInvocable: false
argumentHint: optional goal, task, or knowledge ref
allowedTools:
  - bash
---

# kernel-status

Read `.kernel` and report what is true right now.

You are the state inspector. Read durable records from `.kernel/work/` and `.kernel/knowledge/`, and consult `.kernel/state.json` for the current task pointer when relevant. Then deliver a clear status report focused on what should happen next.

## Without a reference

Show a dashboard:
- Active goals and progress
- Next actionable tasks (unblocked, highest priority)
- Blocked tasks and their blockers
- Recent or stale items needing attention
- Key risks or assumptions that have surfaced

The question: "What matters right now?"

## With a goal reference

Show:
- Goal summary and success criteria
- Current progress (tasks complete, in progress, blocked)
- Task breakdown and status
- Linked knowledge
- Risks and constraints
- Recommended next task

The question: "What is the status of this goal and what should happen next?"

## With a task reference

Show:
- Task summary and acceptance criteria
- Current status (active, blocked, ready to close)
- Dependencies (upstream and downstream)
- Validation expectations
- Linked goal and knowledge
- Implementation notes if relevant
- Recommended next action

The question: "What is the status of this task and what should I do?"

## With a knowledge reference

Show:
- Knowledge summary
- Kind (note or learning)
- Linked work (which goals/tasks reference this)
- Relevance and when it was captured

The question: "What does this knowledge say and where is it used?"

## Guardrails

- Report only what is true from `.kernel` records
- If a record is stale or unclear, call that out explicitly
- Recommend the next concrete action, not abstract direction
- Distinguish between blockers (preventing progress) and risks (might cause problems)
- Surface missing knowledge or unresolved dependencies
