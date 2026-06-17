---
name: kernel-ship
kind: skill
tags:
  - infrastructure
  - deployment
profile: extended
description: Validate production readiness, confirm with the user, then deploy
  with the correct strategy for the change. Use when deploying services,
  releasing a feature, coordinating database migrations, managing mobile builds,
  or diagnosing a deployment failure.
license: MIT
metadata:
  author: project
  version: "2.0"
  category: Workflow
  tags:
    - workflow
    - ship
    - deploy
    - release
    - local
when:
  - User wants to deploy a service, release a feature, or ship a build
  - A PR or branch is ready for production
  - A deployment needs readiness validation before proceeding
  - User says 'ship', 'deploy', 'release', or 'push to production'
termination:
  - Readiness verdict delivered (optionally written to the linked `.kernel` task)
  - Deployment executed with chosen strategy
  - Post-deploy verification complete
outputs:
  - Readiness verdict (PASS / FAIL) report
  - Deployed release in target environment
  - Post-deploy verification summary
dependencies:
  - kernel-review
disableModelInvocation: true
argumentHint: branch, PR, feature, or task to ship
allowedTools:
  - bash
---

# kernel-ship

Ship to any environment safely. Validates production readiness first, then executes the deployment with the right strategy for the change.

---

## Phase 1 — Gate

### 1. Identify scope

- Determine what is being deployed: a PR, branch, feature, or full release.
- Ask for the associated Linear issue or project if not provided — the verdict will be written back to it.

### 2. Run the readiness checklist

**Code Quality**

- [ ] No `console.log` or debug statements left in production paths
- [ ] No hardcoded secrets, tokens, or environment-specific values in source
- [ ] Error handling is present at all external boundaries (API calls, user input, file I/O)
- [ ] TypeScript types are correct and there are no `any` casts masking real errors

**Testing**

- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed for the changed user flows
- [ ] Edge cases and error paths are covered

**Security**

- [ ] All user input is validated and sanitized
- [ ] Authentication and authorization enforced on all protected routes
- [ ] No OWASP Top 10 issues introduced
- [ ] Secrets are not in source code or committed files

**Performance**

- [ ] No memory leaks or unbounded resource allocations
- [ ] No N+1 queries or unindexed lookups on hot paths

**Deployment**

- [ ] All required environment variables are configured in the target environment
- [ ] Database migrations are backward-compatible and ready to run
- [ ] Dependent services are compatible with this release
- [ ] CI is green on the branch being deployed

**Scope completeness**

- [ ] Feature is complete per the issue description and acceptance criteria
- [ ] No known regressions introduced

### 3. Deliver verdict and prompt

Write the verdict to a deployment record or associated `.kernel` task (optional):

```bash
# Optional: Capture deployment procedure as a knowledge note
kernel knowledge new "Deployment validation for <feature>"
```

Or, if associated with a task, record deployment validation in `.kernel/work/tasks/active/<taskId>/task.md` under `## Journal`.

- **FAIL** — list each blocking item with a description. Stop — do not proceed to deployment.
- **PASS** — all items satisfied. Then ask:

> Everything looks good. **Ship now?** (yes / no)

If the user says **no**: stop. The work is validated and ready whenever they choose to deploy.
If the user says **yes**: proceed to Phase 2.

---

## Phase 2 — Strategy

Choose the deployment strategy automatically based on the nature of the change. State the strategy with a one-line rationale before proceeding.

| Signal                                             | Strategy                                                           |
| -------------------------------------------------- | ------------------------------------------------------------------ |
| Change touches auth, payments, or a data migration | **Canary** — route 5–10% first, monitor 10 min before full rollout |
| New feature with a feature flag                    | **Feature flag** — deploy dark, enable incrementally               |
| Routine release, no schema changes, low risk       | **Blue-Green** — zero-downtime swap                                |
| Capacity constraints prevent blue-green            | **Rolling** — last resort only                                     |

---

## Phase 3 — Execute

### Deployment order (when migrations are included)

```
1. Apply database migrations
2. Wait for migration to complete successfully
3. Deploy application code
4. Smoke-test in the target environment
5. Monitor error rates and latency for 5–10 minutes
```

Never deploy application code before its migrations have applied.

### Service deployment (Fly.io)

```bash
fly deploy --app <app-name>
fly status --app <app-name>
fly logs --app <app-name>
```

### Database migration coordination

```bash
# Run migrations before deploying application code
fly ssh console --app <app-name> -C "pnpm db:migrate"
fly ssh console --app <app-name> -C "pnpm db:status"
# If migration fails: do NOT deploy application code
```

### Mobile builds (EAS / TestFlight)

```bash
eas build --platform ios --profile preview
eas submit --platform ios --latest
```

| Profile      | Purpose                                 |
| ------------ | --------------------------------------- |
| `preview`    | Internal QA — TestFlight internal group |
| `production` | App Store / external TestFlight group   |

---

## Phase 4 — Verify

Immediately after deploying:

1. **Health checks** — confirm all services respond to their health endpoints
2. **Error rates** — compare against pre-deploy baseline; target < 0.1%
3. **Latency** — p95 should be within 20% of baseline
4. **Key user flows** — manually verify: login, core action, critical path
5. **Logs** — scan for unexpected errors not present before

---

## Phase 5 — Rollback

If error rates spike, health checks fail, or user reports arrive — roll back immediately. Do not attempt a hot-fix on a broken production deployment.

```bash
fly deploy --image <previous-image> --app <app-name>
# For database rollback:
fly ssh console --app <app-name> -C "pnpm db:rollback"
# Order: application first, then migration (reverse of deploy order)
```

1. Roll back immediately.
2. Preserve evidence — capture logs and metrics before anything changes.
3. Diagnose offline — understand the root cause before re-deploying.
4. Re-deploy with the fix verified — run Phase 1 again.

Decide within 10 minutes whether to roll forward or roll back.

---

## Guardrails

- Every checklist item must be explicitly confirmed or noted as not-applicable — no silent skips.
- A PASS verdict with unresolved security or testing items is never acceptable.
- Never deploy without a PASS verdict from Phase 1.
- Never deploy directly from a local machine to production — use the CI/CD pipeline.
- Never deploy application code before its migrations have applied.
- Roll back first, fix second — always.
- Monitor error rates after every production deployment — do not walk away immediately.
