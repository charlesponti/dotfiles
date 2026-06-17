---
name: security-review
kind: command
tags:
  - security
  - review
description: Analyze pending branch changes for security vulnerabilities — injection, auth gaps, secret exposure, and dependency risks — with severity-ranked findings.
group: specialist
argumentHint: optional scope or focus area (e.g., 'focus on the auth module', 'check the new API endpoints')
---

Analyze the pending changes on the current branch for security vulnerabilities.

1. Run `git diff main...HEAD` (or the base branch) to get the full diff.
2. Review each changed file for:
   - Injection vulnerabilities (SQL, command, template, path traversal)
   - Authentication and authorization gaps
   - Sensitive data exposure (secrets in code, overly broad API responses, insecure logging)
   - Dependency additions: check for known-vulnerable versions or suspicious packages
   - Insecure defaults (missing TLS verification, permissive CORS, weak crypto)
3. Report findings by severity: **Critical**, **High**, **Medium**, **Low**, **Informational**.
4. For each finding, include: the file and line, what the risk is, and a concrete remediation.

Focus on the diff only — do not audit unchanged code unless a changed line interacts with it.
