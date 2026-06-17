---
name: simplify
kind: command
tags:
  - quality
description: Review recently changed files for code quality issues — duplication, unclear naming, inefficiency — and fix them without speculative refactoring.
group: specialist
argumentHint: optional focus area (e.g., 'focus on clarity', 'look for duplicate logic in the API layer')
---

Review the recently changed files in this repository and fix code quality issues.

Focus: $ARGUMENTS

1. Identify changed files using `git diff` and `git status`.
2. Analyze the changes across three dimensions:
   - **Reuse**: duplicated logic, missed opportunities to call existing utilities, copy-paste patterns
   - **Clarity**: unclear naming, overly complex logic, missing or wrong error handling
   - **Efficiency**: unnecessary allocations, redundant computation, avoidable re-renders or re-queries
3. Apply fixes directly, keeping each change minimal and scoped to a clear problem.
4. Show a summary of what was changed and why.

Do not refactor code outside the diff. Do not add abstractions speculatively.
