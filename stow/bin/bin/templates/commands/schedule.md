---
name: schedule
kind: command
tags:
  - workflow
  - devops
description: Set up a scheduled or recurring task using the right mechanism for this project — cron, queue worker, GitHub Actions, or in-process scheduler.
group: specialist
argumentHint: task to schedule and how often (e.g., 'run nightly database cleanup every day at 2am', 'send weekly digest on Mondays')
---

Help set up the scheduled task described in $ARGUMENTS.

1. Clarify the task: what runs, how often, and what triggers it (cron, event, webhook).
2. Identify the right mechanism for this project: GitHub Actions workflow, system cron, a queue worker, or an in-process scheduler.
3. Write the configuration or code needed, following the conventions already used in this repository.
4. Add error handling and alerting so failures are visible.
5. Document the schedule in the relevant config file or README.

If the project already has a scheduling mechanism, extend it rather than introducing a new one.
