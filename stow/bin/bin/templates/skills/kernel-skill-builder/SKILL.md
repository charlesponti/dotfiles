---
name: kernel-skill-builder
kind: skill
tags:
  - meta
  - kernel
profile: extended
description: Creates, audits, and improves kernel skills against established
  quality standards. Use when creating a new skill, auditing existing skills for
  quality, identifying merge candidates across a skill directory, or when a
  skill's description, body structure, or behavioral fields need improvement.
license: MIT
compatibility: Works with kernel skills in this repository.
metadata:
  author: project
  version: "1.0"
  category: Ecosystem
  tags:
    - skills
    - quality
    - audit
    - standards
    - meta
    - skill-builder
when:
  - user is creating a new kernel skill
  - user wants to audit one or more existing skills for quality
  - user asks whether two skills should be merged
  - a skill description is not in third-person or lacks trigger language
  - a skill body exceeds 300 lines and needs reference files extracted
  - a skill contains project-specific package names or proprietary commands
applicability:
  - Use when authoring any new skill in the kernel template system
  - Use when reviewing an existing skill for description quality, body length,
    or behavioral field coverage
  - Use when scanning a directory of skills to find merge candidates or
    systematic issues
termination:
  - Each audited skill has a specific, actionable finding or a pass
  - Merge candidates identified with a concrete action plan
  - New skill has a passing description, correct body structure, and appropriate
    behavioral fields set
outputs:
  - Per-skill audit report with findings in standard format
  - Merge candidate report with reason and action plan
  - Improved skill with updated description, body, and template.ts
argumentHint: skill name or directory path to audit
allowedTools:
  - Read
  - Grep
  - Glob
---

# Skill Builder

Creates, audits, and improves kernel skills against the quality standards of this system. Skills are general-purpose, standards-driven artifacts — not project customizations.

## Core Principle

**Standards over customization.** A skill encodes what is universally true about a domain. Project-specific details (package names, team conventions, proprietary tooling) do not belong in a skill. If a skill can only be used in one project, it is not a skill — it is a local rule.

## Quality Standards

### 1. Description (the routing signal)

The description is the ONLY content always in context. It must answer two questions in one sentence: what does it do, and when should it fire.

**Pattern:** `"{Does X in third-person}. Use when {trigger-1}, {trigger-2}, or when users ask about {X}."`

Rules:

- Third-person subject: "Enforces...", "Guides...", "Provides...", "Manages...", "Diagnoses..."
- Never starts with "Use when" or "I can" or imperative form ("Enforce...")
- Includes key user terms users would naturally say ("is this ready to ship?", "break this down", "clean up")
- Max 1024 characters
- Covers WHAT it does AND WHEN to invoke it

**Failure patterns:**

- `"Use when validating production readiness..."` → missing third-person subject
- `"Code review, formatting, refactoring..."` → noun phrase, no trigger language
- `"Advanced git workflows..."` → describes content, not behavior or trigger

### 2. Body Structure

Target: under 300 lines. Hard limit: 500 lines. Above 300 lines, extract code examples to reference files.

Canonical section order:

1. One-sentence role statement (no heading)
2. `## Rule` or `## Standards` — the authoritative constraints
3. `## Process` or `## Steps` — numbered workflow (if procedural)
4. `## Guardrails` — must/never list, always last

Rules:

- No project-specific package names (use `@your-org/auth`, not your actual org name)
- No project-specific commands (`pnpm lint` is fine; `pnpm validate-db-imports` is not)
- No team names, repo names, or proprietary tool names
- Code examples → `references/` files; keep body for rules and process
- Do not repeat frontmatter fields (`when:`, `applicability:`) in the body

### 3. Behavioral Fields

Set these in `template.ts` — they control how platforms invoke the skill:

| Field                          | When to set                                                                                        |
| ------------------------------ | -------------------------------------------------------------------------------------------------- |
| `disableModelInvocation: true` | Skill has side effects: deploys code, modifies issue state, archives work, creates PRs             |
| `userInvocable: false`         | Model-only auto-invoke; never a direct slash command (e.g. `kernel-conventions`)                   |
| `argumentHint: "..."`          | Skill benefits from a user-supplied argument (`kernel-triage`, `kernel-investigate`, `kernel-propose`) |
| `allowedTools: [...]`          | Skill needs specific tools without per-use approval                                                |

### 4. Merge Candidates

Two skills are merge candidates when:

- Their `when:` trigger conditions overlap significantly
- One is a subset of the other's domain
- Both fire in the same user context
- One encodes a single rule that belongs as a section in the other

Merge rule: keep the broader, more general name. Fold the narrower skill in as a named section with a `## Heading`. Move its code examples to the canonical skill's `references/`.

### 5. Reference Files

Use `references/` when a skill has substantial code examples, migration guides, or violation catalogs. Reference files are loaded on demand — keep them deep, keep the body shallow.

Structure: `references/<topic>` — descriptive, not namespaced. Any file type supported.

In `template.ts`:

```typescript
references: getSkillReferences(
  SKILL_NAMES.YOUR_SKILL,
  "references/patterns",
  "references/migration",
),
```

## Analysis Process

### Analyzing a single skill

1. **Read** `SKILL.md` and `template.ts`
2. **Check description**: third-person? includes trigger language? under 1024 chars?
3. **Count lines**: over 300? identify extractable sections (code examples, migration steps)
4. **Scan for specificity**: any `@org/`, project paths, proprietary commands, team names?
5. **Check behavioral fields**: does the skill have side effects? accepts arguments? model-only?
6. **Report**: list each failing standard with the exact fix

### Analyzing a directory of skills

1. **Glob** `src/templates/skills/*/template.ts` — collect all skill descriptions
2. **Cluster by trigger language**: group skills whose `when:` conditions overlap
3. **Flag merge candidates**: any cluster where 2+ skills fire in the same context
4. **Audit descriptions**: apply the description check to each
5. **Audit body lengths**: flag any over 300 lines
6. **Report**: merge candidates first (highest leverage), then individual fixes

### Output format

For each finding:

```
[SKILL] kernel-<name>
[ISSUE] Description missing trigger language
[CURRENT] "Code review, formatting, refactoring, and linting."
[FIX] "Reviews, refactors, and improves code quality across any stack. Use when reviewing code before a merge, fixing lint violations, or when users ask to clean up or refactor existing code."
```

For merge candidates:

```
[MERGE] kernel-<a> → kernel-<b>
[REASON] Both trigger when user adds code to a shared package; kernel-<a> encodes one rule that belongs as ## Monorepo Package Boundaries in kernel-<b>
[ACTION] Add section to kernel-<b>, move reference files, remove kernel-<a> from catalog and constants
```

## Guardrails

- Never add project-specific content to a skill — generalize or omit it
- Never create a skill for a single rule — merge it into the appropriate parent skill
- Never allow a skill description to start with "Use when" — it must have a third-person subject
- Never accept a skill body over 500 lines — extract references first
- A skill that cannot be used in a project other than the one it was written for is not a kernel skill
- When in doubt about merge vs. keep: if both skills would fire simultaneously in the same user context, merge
