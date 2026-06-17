---
name: kernel-execute
kind: skill
tags:
  - workflow
profile: core
description: Execute work from .kernel tasks by implementing acceptance criteria,
  validating results, and updating state. Use when a task is ready for implementation
  or when users say start, build, implement, or do this.
license: MIT
metadata:
  author: project
  version: "4.0"
  category: Workflow
  tags:
    - workflow
    - execute
    - implement
when:
  - user wants to implement work from a .kernel task
  - there is an unblocked task ready for implementation
  - user has finished planning and is ready to execute
termination:
  - Task implementation completed or validated
  - Task markdown and state reflect reality
  - Results verified against acceptance criteria
  - Next action is clear (continue, close, or re-plan)
outputs:
  - Implemented code changes
  - Updated .kernel task state and journal
  - Validated results
dependencies:
  - kernel-plan
disableModelInvocation: true
argumentHint: task ID or goal ref to execute
allowedTools:
  - bash
---

# kernel-execute

Work from `.kernel` tasks one at a time until done.

You are the execution guide. The user picks a task (or you resolve the next one), and you guide them through implementation, validation, and closure.

## Execution Loop

### 1. Resolve the task
- If no task is specified, find the next actionable one
- Read the task's `.kernel/work/tasks/active/<task-id>/task.md`
- Note the acceptance criteria, plan, dependencies, validation steps

### 2. Understand the context
- Read linked goal if present
- Review linked knowledge notes
- Identify dependencies and blockers
- Confirm the task is not blocked by upstream work

### 3. Implement acceptance criteria
Work through the task's acceptance criteria one at a time:
- State the observable completion criterion
- Implement that criterion
- Verify it works (tests, manual checks, observable behavior)
- Move to the next criterion

### 4. Validate
Confirm:
- All acceptance criteria are met
- Tests pass (if applicable)
- No new issues were introduced
- The task's success condition is objectively true

### 5. Update task state
- Record completion in the task markdown
- Add journal notes if the work was non-obvious or produced learnings
- Note any deferred work or follow-up tasks
- Link any new knowledge discovered during implementation

### 6. Decide next action
- **Continue**: move to the next task (use `kernel status`)
- **Archive**: the task is complete (use `kernel task archive`)
- **Done**: the goal is complete (use `kernel goal done`)
- **Re-plan**: scope changed or blockers emerged (use `kernel plan`)

## Guardrails

- Do not start implementation before reading the task markdown
- Do not skip validation before marking work complete
- Do not improvise scope changes; re-plan instead
- Do not duplicate investigation or findings; link knowledge records
- Do not leave durable insights only in code comments; capture them as knowledge notes or learnings
- If the task becomes unclear or blocked, stop and re-plan with `kernel plan`

## When to re-plan

Pause and re-plan if:
- acceptance criteria become ambiguous or change
- dependencies become blocked
- scope expands significantly
- a key assumption proves false
- implementation reveals a simpler or better approach that changes the strategy

Re-planning is not a failure; it is keeping `.kernel` and reality in sync.
