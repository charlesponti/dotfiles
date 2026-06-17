---
name: kernel-doctor
kind: command
tags:
  - kernel
  - diagnostics
description: Diagnose Kernel configuration, generated host files, and sync drift.
group: system
target: doctor
---

Use this when the generated command, skill, or agent surface does not match expectations.

What this checks:

- Kernel configuration and catalog layout.
- Enabled host directories.
- Generated file drift between `.agents` and host outputs.
- Common setup problems that block sync.

When to use it:

- A host is missing commands or skills.
- Generated files look stale after a sync.
- You need a quick health check before debugging deeper.

What to do next:

- Run `kernel-sync` if the issue is simple drift.
- Update the underlying template or config if the doctor output points to a real mismatch.
