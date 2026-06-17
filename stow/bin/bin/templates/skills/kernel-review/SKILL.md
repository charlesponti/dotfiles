---
name: kernel-review
kind: skill
tags:
  - review
profile: core
description: Assesses completed deliverables for correctness, completeness,
  quality, security, performance, and standards compliance. Also covers
  refactoring, formatting, linting, and performance optimization. Use after
  implementation to evaluate whether work meets acceptance criteria, before
  handoff, merge, or deployment, or when asked to refactor, clean up, or improve
  code quality.
license: MIT
compatibility: Use after implementation is complete, before handoff, merge, or deployment.
metadata:
  author: project
  version: "2.0"
  category: Workflow
  tags:
    - workflow
    - review
    - quality
    - post-completion
    - refactor
    - lint
    - format
    - optimize
when:
  - a deliverable is complete and ready for sign-off
  - a goal or task checkpoint has been reached and work should be reviewed before continuing
  - before handing off, deploying, or merging
  - user asks to review, refactor, format, or optimize code
  - there are lint violations, style inconsistencies, or performance issues
applicability:
  - Use to formally assess whether completed work meets its acceptance criteria
  - Use to surface must-fix issues before the work moves downstream
  - "Use for any code quality task: review, refactor, lint, format, or
    performance work"
termination:
  - All evaluation dimensions covered
  - Findings prioritised as must-fix, should-fix, or consider
  - "Clear recommendation delivered: approve | approve with changes | needs
    rework"
  - Refactoring complete with tests still passing
  - Lint and format checks pass
outputs:
  - Review report with recommendation
  - Prioritised findings list
  - Updated local `.kernel` status or follow-up notes
  - Refactored code with unchanged behaviour
  - Lint-clean, formatted code
disableModelInvocation: true
userInvocable: false
argumentHint: task, PR link, or file/directory to review (optional)
allowedTools:
  - Read
  - Grep
  - Glob
  - Bash
---

Answer: _is this done well enough to move forward?_

## Steps

### 1. Read the local plan

- Read the relevant `.kernel` task or goal markdown to retrieve the goal and acceptance criteria.
- Identify the goal and what "done" means for this work.

### 2. Examine the output

- Read the relevant files, diffs, or artifacts produced.
- Check whether the output matches what was promised.

### 3. Evaluate across dimensions

Weight each dimension by what matters most for this work:

| Dimension        | Question                                           |
| ---------------- | -------------------------------------------------- |
| **Correctness**  | Does it do what it is supposed to do?              |
| **Completeness** | Are all acceptance criteria satisfied?             |
| **Quality**      | Is it well-made, readable, and maintainable?       |
| **Security**     | Are there vulnerabilities or unsafe patterns?      |
| **Performance**  | Are there obvious bottlenecks or wasted resources? |
| **Standards**    | Does it conform to project conventions?            |

### 4. Prioritise findings

- **Must fix** — blocks approval; cannot move forward without this
- **Should fix** — significant issue; address before closing but not a blocker today
- **Consider** — improvement that would add value but is not required

### 5. Deliver the review report

```
## Review: [approve | approve with changes | needs rework]

**Summary**
[2–3 sentences: what was reviewed and the overall finding]

**Findings**

### Must Fix
- [specific issue]: [why it matters] — [what to do]

### Should Fix
- [specific issue]: [why it matters] — [what to do]

### Consider
- [suggestion]: [rationale]

**Recommendation**
[Clear direction: what happens next and who owns it]
```

### 6. Update the local work state

- If approved: mark the task ready to move forward.
- If needs rework: keep the task open and attach the must-fix list to the local work notes.
- If approve with changes: record the should-fix list and decide whether the work can still advance.

## Review Principles

- **Review against the goal, not your preferences.** The question is whether the work achieves its stated intent.
- **Be specific.** Name the exact location, the exact problem, and the exact fix.
- **Prioritise ruthlessly.** A review with ten must-fixes is broken. If everything is urgent, nothing is.
- **Recommend, don't just report.** A review that surfaces problems without a path forward leaves the recipient stuck.
- **Acknowledge what works.** A review that only criticises misses context and demotivates iterative improvement.

## Quality Checks

Before delivering the review:

- [ ] Findings are specific and actionable, not vague
- [ ] Must-fix items are genuinely blocking
- [ ] The recommendation is clear and unambiguous
- [ ] The report distinguishes between fact and opinion
- [ ] Nothing important was omitted to avoid an uncomfortable conversation

## Refactoring

Follow this process for any refactoring task:

### 1. Intent Gate

- Classify the request: rename, extract, inline, move, simplify, or restructure
- Identify the target clearly and scope the impact

### 2. Codebase Analysis

- Map all call sites and usages of affected code
- Identify type boundaries, test coverage, and established patterns
- Check for side effects and hidden dependencies

### 3. Plan

- Write the exact sequence of atomic, independently verifiable steps
- Each step must leave the codebase in a passing state

### 4. Execute

- Apply changes one step at a time
- Run type-check and tests after each step
- Never proceed with a failing build

### 5. Final Verification

- Full test suite passes
- Type-check clean
- Lint clean
- Behaviour is unchanged (tests are the proof)

### Refactoring Rules

- NEVER skip diagnostics or proceed with failing tests
- NEVER use `as any` or `@ts-ignore` as workarounds
- NEVER delete tests to make the build pass
- NEVER change behaviour inside a refactoring commit — separate it

## Code Formatting

1. Confirm the formatter the project uses (prettier, eslint, rustfmt, biome, etc.)
2. Run the formatter on changed files
3. Review the diff — formatting changes should be pure whitespace/style
4. Commit formatting separately from logic changes

## Linting

Supported linters by language:

- JavaScript/TypeScript: eslint, oxlint
- Ruby: RuboCop, StandardRB, Fasterer
- Rust: clippy

Process:

1. Run linter on the target scope
2. Auto-fix safe fixable violations
3. Review remaining violations — distinguish errors from warnings
4. Manual-fix remaining issues, document exceptions with rationale

## Performance Optimization

Profile before optimizing:

- **Algorithm** — choose better data structures, reduce time complexity
- **Memory** — reduce allocations, fix leaks, improve GC pressure
- **CPU** — cache-friendly access patterns, avoid repeated computation
- **Network** — batch requests, reduce payload, use compression
- **Build** — lazy loading, code splitting, tree-shaking

Measure before and after with realistic data. Never sacrifice correctness for micro-optimizations.
