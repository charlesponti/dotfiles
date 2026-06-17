---
name: debug
kind: command
tags:
  - debugging
description: Investigate an issue and propose a fix — traces root cause through source, git history, and execution path before applying a verified solution.
group: specialist
argumentHint: "error message, stack trace, or symptom description (e.g., 'TypeError in auth middleware', 'tests fail after migration')"
---

Investigate the issue described in $ARGUMENTS.

1. Read the error message, stack trace, or symptom carefully.
2. Identify the most likely root cause by reading the relevant source files and tracing the execution path.
3. Check recent commits (`git log --oneline -20`) for changes that may have introduced the issue.
4. Summarize what is wrong, where it is, and why it is happening.
5. Propose a concrete fix. If multiple fixes are possible, compare the tradeoffs.
6. Apply the fix and verify it resolves the issue without breaking related functionality.

If no issue is described, scan for obvious errors: failing tests, unhandled exceptions, type errors, or broken imports.
