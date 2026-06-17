---
name: kernel-plan
kind: skill
tags:
  - workflow
  - planning
profile: core
description: "Turn a spark into structured work in repo-local .kernel: investigate,
  clarify, decide structure, and break down into concrete tasks. The primary planning
  entrypoint for goals, tasks, and knowledge records."
license: MIT
metadata:
  author: project
  version: "4.0"
  category: Workflow
  tags:
    - workflow
    - plan
    - planning
    - local
    - spark-first
when:
  - user describes a spark, idea, bug, feature request, or strategic direction
  - user wants to plan new work but is unclear on scope
  - project knowledge needs investigation and capture
termination:
  - Spark is investigated from repo, .kernel, and web as needed
  - Only necessary clarifying questions answered
  - Goal and/or task records created in .kernel/work/
  - Reusable knowledge linked or created under .kernel/knowledge/
  - Work is broken down into concrete, actionable tasks
  - "`.kernel/state.json` is updated only when a current task pointer is needed"
  - Next action is unambiguous
outputs:
  - Goal or task records under .kernel/work/
  - Knowledge records linked or created under .kernel/knowledge/
  - Single canonical markdown file per record
  - Concrete executable tasks
  - Local runtime state captured in `.kernel/state.json` only when needed
disableModelInvocation: false
userInvocable: false
argumentHint: spark, optional goal/task ref for context, or empty for interactive intake
allowedTools:
  - bash
---

# kernel-plan

Turn an unstructured spark into a structured, executable plan in the repo-local `.kernel` project memory.

You are the spark-to-tasks orchestrator. The user provides a natural-language spark (idea, bug, feature, direction), and you investigate, clarify, decide on structure, and produce concrete work.

## Core Principles

### 1. User starts with a spark, not a record type
Examples of sparks:
- "Onboarding feels clunky"
- "Fix the flaky build"
- "Add SSO"
- "How does auth session refresh work?"
- "We should improve reliability"

Users should **not** decide goal vs task vs knowledge kind.
You decide.

### 2. Investigate before interrogating
Before asking the user anything, gather:
- relevant `.kernel/work/` and `.kernel/knowledge/` records
- repository structure, docs, tests, recent changes
- external context if needed (APIs, frameworks, standards)

Stop investigating when additional research won't change:
- the main problem framing
- the next questions to ask
- the likely decomposition

### 3. Ask only necessary, high-leverage questions
Questions must:
- be specific
- be answerable
- tie to a decision
- avoid asking what the code/docs already answer

Ask in small batches (3–5 questions).
Default to reasonable assumptions if the answer is non-critical.

### 4. Work records are goals and tasks only

- **Goal**: outcome with context, success criteria, and grouped tasks
- **Task**: executable unit of work

### 5. Knowledge is reusable memory

Create or link when findings should persist:
- **Research**: investigations and findings
- **Runbook**: repeatable procedures
- **Concept**: domain language
- **Learning**: post-task lessons (written during task archive)

### 6. Planning ends in tasks
Planning is incomplete until the work is broken down into concrete, independently actionable tasks.

## Planning Flow

### Stage 1. Capture the spark
Record the raw natural-language request.

### Stage 2. Investigate
Gather signal from:
- `.kernel/work/` — existing goals and tasks
- `.kernel/knowledge/notes/` — observations and research findings
- `.kernel/knowledge/guides/` — procedures and runbooks
- `.kernel/knowledge/reference/` — canonical concepts and stable explanations
- repository — relevant code, docs, tests, configs, changelogs
- external sources — official docs, frameworks, standards, security/compliance requirements

Determine:
- what likely subsystem is affected
- whether related work already exists
- likely scope (single task vs multiple tasks vs strategic effort)
- key technical constraints
- known risks
- what remains unknown

### Stage 3. Interrogate
Ask the user only the most valuable unresolved questions.

Focus on:
- **Product/business**: desired outcome, user segment, deadline, priority, non-goals
- **Technical**: constraints, compatibility, rollout limits, acceptable risk
- **Delivery**: whether to patch vs redesign, scope for first version, verification expectations

Propose defaults when possible. Do not block on non-critical gaps.

### Stage 4. Synthesize
Combine spark + investigation + user answers to decide:
- Does this belong under an existing goal?
- Does this need a new goal?
- Is this a single standalone task?
- What knowledge records are needed or missing?
- What is the minimum task graph that makes the work executable?

### Stage 5. Structure
Create or update `.kernel` records:

**Create a goal if:**
- more than one task is needed, or
- the work has an outcome-level success condition, or
- the work spans subsystems/phases, or
- durable framing is useful for future work

**Create a standalone task if:**
- the work reduces to one bounded executable unit, or
- no broader framing is needed, or
- no coordinated multi-step rollout is needed

**Reuse an existing goal if:**
- it already captures the same outcome, or
- this is a new task stream within the goal, or
- success criteria substantially overlap

**Create or link knowledge if:**
- findings are reusable beyond one task, or
- the answer is investigative/conceptual, or
- it is a repeatable procedure

### Stage 6. Decompose into tasks
Break the work into concrete tasks, where each:
- is independently actionable
- is bounded and verifiable
- has clear acceptance criteria
- may depend on other tasks
- is roughly one coherent change, research spike, validation, rollout, or cleanup effort

### Stage 7. Output
Always deliver:
1. **What I found** — investigation summary
2. **What I asked the user** — clarifying questions and answers
3. **My synthesis** — problem framing and approach
4. **Created/updated goals** — outcome containers if needed
5. **Concrete tasks** — executable work units
6. **Key risks/assumptions** — what could go wrong or change
7. **Recommended next task** — explicit next action

## Scenario Examples

### Vague strategic spark
> "Onboarding should be effortless."

Investigate → ask who, what, when → create a goal "Improve Onboarding" → break into:
- Map current journey
- Identify friction
- Improve docs/setup
- Add verification

Result: **goal + multiple tasks**

### Concrete feature request
> "Add SSO."

Investigate → ask provider and rollout scope → likely create goal "SSO Integration" → break into:
- Research provider constraints
- Implement backend
- Implement UI
- Test and rollout

Result: **goal + tasks** (or task only if very small)

### Bug or regression
> "Export is broken."

Investigate → reproduce → ask impact/scope → if narrow, create one task "Fix export function"; if systemic, create goal "Improve export reliability" with multiple tasks

Result: **task only** (narrow) or **goal + tasks** (systemic)

### Research-heavy request
> "Should we move from X to Y?"

Investigate → research Y and tradeoffs → ask decision criteria → create knowledge note → decide if work follows or is deferred

Result: **investigate first**, then **goal/tasks** only if work proceeds

## Markdown Contract

Each record has exactly one markdown file with frontmatter:

**Goal** (`.kernel/work/goals/<id>/goal.md`):
- Title, summary, context
- Problem / opportunity statement
- Success criteria
- Scope and non-goals
- Constraints and risks
- Task groups (presentation view only, not records)
- Linked knowledge
- Journal

**Task** (`.kernel/work/tasks/active/<id>/task.md`):
- Title, summary, context
- Goal link if applicable
- Acceptance criteria
- Plan / implementation notes
- Dependencies
- Validation steps
- Linked knowledge
- Journal

**Knowledge** (`.kernel/knowledge/notes/<id>/note.md`):
- Summary, context, findings, or decisions
- Linked work if relevant

**Guides** (`.kernel/knowledge/guides/<id>/guide.md`):
- Procedures, runbooks, verification steps, or repeatable workflows

**Reference** (`.kernel/knowledge/reference/<id>/reference.md`):
- Stable concepts, glossary entries, and canonical explanations

**Learning** (`.kernel/knowledge/learnings/<slug>.md`):
- Written during task archive
- Captures abstract, problem, background, approach, implementation, outcomes, lessons learned, references

## Guardrails

- Do not ask the user to classify work as goal/task
- Do not create duplicate goals when similar work already exists
- Do not ask questions that the code, docs, or `.kernel` can answer
- Do not stop at abstract planning without concrete tasks
- Do not keep key rationale only in chat
- Do not duplicate knowledge across multiple work records
