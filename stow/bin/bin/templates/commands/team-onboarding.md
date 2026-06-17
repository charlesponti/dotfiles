---
name: team-onboarding
kind: command
tags:
  - docs
description: Generate a team onboarding guide for this repository — setup, conventions, entry points, and gotchas — written for a new contributor's first day.
group: specialist
argumentHint: optional audience or focus (e.g., 'for a backend engineer', 'focus on the deployment pipeline')
---

Generate a team onboarding guide for this repository.

1. Explore the codebase: read the package files, CI configuration, directory structure, existing docs, and recent git history.
2. Identify the key things a new contributor needs to know:
   - How to set up the local development environment from scratch
   - How to run the application and its dependencies
   - How to run tests and the linter
   - How branches, commits, and PRs are expected to be structured
   - Where the main entry points and core abstractions live
   - Any non-obvious conventions or gotchas in the codebase
3. Write the guide as a markdown document a new teammate could paste as their first prompt or follow step-by-step.
4. Keep it concise — prefer bullet points and code blocks over prose.

Output the guide to `docs/onboarding.md`, or to stdout if that path already exists.
