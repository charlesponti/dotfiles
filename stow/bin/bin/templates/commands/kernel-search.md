---
name: kernel-search
kind: command
tags:
  - exploration
description: Search specialist — locates code, traces history, reads documentation, and retrieves prior context. Use when you need targeted research before acting.
group: specialist
argumentHint: what to find (e.g., 'where is auth middleware defined', 'why did the migration fail', 'how does the retry logic work')
backedBySkill: kernel-locate
---

Use this when information is required that is not already in context. Do not guess when a search can answer the question. Return exact locations, not paraphrases.

## When to Use This

- You need to find where something is defined, called, or configured before touching it.
- You need to understand why a behavior exists before changing it.
- You need documentation or prior art before committing to an approach.
- A planning choice depends on information that is not yet in the conversation.

Do not use this as a substitute for reading code you are already about to change. Use it when the scope is unknown or the location is uncertain.

## Search Modes

### Codebase Search

Find symbols, files, and call paths:

- Search for function or class definitions by name
- Trace where a module is imported or a function is called
- Find all usages of a type, constant, or configuration key
- Locate test files for a given module

Use `Grep` with exact patterns. Use `Glob` when searching by filename pattern. Use `Read` to read specific files once located.

### Documentation Research

Find official guidance and examples:

- Language or framework documentation for a specific API
- Official migration guides or changelogs
- RFC or specification documents for a protocol or format

Cite the exact source. Do not summarize documentation — quote the relevant section directly.

### History Analysis

Understand why code is the way it is:

- Use `git log -- <file>` to find when a file changed and by whom
- Use `git show <commit>` to read the commit that introduced a behavior
- Use `git blame <file>` to trace individual line authorship
- Check commit messages for the reason behind a decision

History answers "why" — use it when the code itself does not explain its own existence.

### Prior Context

Find information already in the project:

- Check `.kernel/work/tasks/active/<id>/task.md` for current task context
- Check `.kernel/work/tasks/archived/` for completed similar work
- Check `.kernel/knowledge/notes/` for observations and research, `.kernel/knowledge/guides/` for procedures, `.kernel/knowledge/reference/` for stable concepts, and `.kernel/knowledge/learnings/` for post-task essays

## How to Report

For every finding:

```
**Found** — [what was found]
Location: [path]:[line] or [URL]
Excerpt: [relevant lines or quote]
Relevance: [why this matters for the current task]
```

If nothing relevant is found:

```
**Not found** — [what was searched for]
Searched: [what locations or sources were checked]
Implication: [what this means for the next step]
```

## Guardrails

- Cite exact locations for every finding — never paraphrase without a source.
- Prefer primary sources (code, git history, official docs) over secondary summaries.
- Keep the scope tight: answer the search question, then stop.
- If the search question is ambiguous, ask one clarifying question before expanding the search.
- Do not make implementation decisions in a search response — return findings, let the caller decide.

## What to Do Next

- Hand findings back to `kernel-plan` if the result changes the plan.
- Hand findings back to `kernel-do` if the result unblocks an executing task.
- Run this command again with a narrower or different query if the first pass did not answer the question.
