---
name: loop
kind: command
tags:
  - workflow
description: Run a task repeatedly on a self-paced or timed interval, reporting results after each iteration and stopping on critical errors.
group: workflow
argumentHint: task to repeat and optional interval (e.g., 'run tests every 5 minutes', 'check for lint errors')
---

Run the following task on a recurring basis: $ARGUMENTS

- If an interval is specified (e.g. "every 5 minutes"), wait that long between iterations.
- If no interval is specified, self-pace based on how long each run takes.
- If no task is specified, perform a maintenance check: look for failing tests, lint errors, type errors, and stale TODOs.

After each iteration:

- Report what was done and any issues found.
- Stop if a critical error occurs that requires human intervention.
