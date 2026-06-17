---
name: kernel-sync
kind: command
tags:
  - kernel
  - sync
description: Sync the Kernel catalog into every enabled agent host so commands,
  skills, and agents stay current.
group: system
target: sync
backedBySkill: kernel-sync
---

Use this after changing Kernel templates or host configuration.

What this does:

- Rebuilds the canonical `.agents` catalog.
- Writes the current command, skill, and agent set.
- Refreshes the generated files in each enabled host directory.
- Cleans up stale generated host files that are no longer part of the catalog.

When to use it:

- After editing templates in this repo.
- After changing host configuration.

What to do next:

- Run `kernel-doctor` if the synced host output still looks wrong.
