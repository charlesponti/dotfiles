---
name: kernel-task-done
kind: command
tags: [workflow]
description: Mark a checklist item complete in the active task. When all items are done, archives the task and writes a learnings essay automatically.
group: workflow
target: task done
argumentHint: checklist item id or title
---

Mark a checklist item complete, then check if all items are now done.

Pass the checklist item id or title slug. Use `--task <taskId>` to override the active task pointer in `.kernel/state.json`.

## Steps

1. **Mark the item complete.** Update the checklist item in `task.md` to `[x]`.

2. **Check for completion.** Count remaining unchecked items (`[ ]`) in the task's checklist.

3. **If items remain** — report progress (e.g. "3 of 7 items complete") and stop.

4. **If all items are complete** — proceed with archiving:

   a. **Run the archive CLI.**
      ```
      kernel task archive [taskId]
      ```
      Note any warnings from the output.

   b. **Read the archived task record.** Open `task.md` from `.kernel/work/tasks/archived/<taskId>/`. Read linked knowledge and goal IDs from the frontmatter.

   c. **Write a learnings essay.** Create `.kernel/knowledge/learnings/<slug>.md` where `<slug>` is a short kebab-case summary of the task's core insight (not the task ID). Use this exact structure — every section is required:

```markdown
---
id: <learning-slug>
title: <Descriptive Title: What Was Done and the Central Insight>
taskId: <taskId>
archivedAt: <YYYY-MM-DD>
linkedGoalIds:
  - <goal-id>
linkedKnowledgeIds:
  - <knowledge-id>
---

# <Descriptive Title: What Was Done and the Central Insight>

## Abstract

One paragraph. What was the scope of the work, what was the core problem solved, and what was the outcome. Written for someone who has never seen the task.

## Problem

What was broken, missing, or unclear before this task started? Be specific about symptoms and scope.

## Background

Context a reader needs to understand why this problem existed and why the chosen approach made sense. Include relevant prior decisions, constraints, or knowledge records.

## Approach

How was the problem tackled? Document key decision points, alternatives considered, and why the chosen path was taken over others.

## Implementation

Concrete specifics: what files or modules changed, what was added or removed, what contracts were established. Include code snippets only when they clarify a non-obvious decision.

## Outcomes

What is measurably different now? List what works, what was confirmed correct, and what was explicitly deferred.

## Lessons Learned

**Bold claim per lesson, followed by a sentence explaining why it matters or what evidence supports it.** Aim for 3–5 lessons. Each should be generalisable beyond this task — something a future engineer could apply to a different problem.

## References

- Task: `<taskId>` (archived <YYYY-MM-DD>)
- Link any relevant goals, research, or concept records by ID.
```

   d. **Ensure the learnings directory exists** before writing:
      ```
      mkdir -p .kernel/knowledge/learnings
      ```

   e. **Report** the path of the written essay and any archive warnings.

To reopen an archived task, move the archived record back to `.kernel/work/tasks/active/` and update its frontmatter.
