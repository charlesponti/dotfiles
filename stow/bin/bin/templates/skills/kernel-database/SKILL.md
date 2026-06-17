---
name: kernel-database
kind: skill
tags:
  - backend
  - database
profile: extended
description: "Manages the full database migration lifecycle: schema design,
  authoring, validation, multi-environment apply, type generation, rollback, and
  production deployment coordination. Use whenever a schema change is required,
  migrations need to be applied or rolled back, or generated types are out of
  sync."
license: MIT
compatibility: Any PostgreSQL project using Goose for migrations and
  kysely-codegen for type generation.
metadata:
  author: project
  version: "2.0"
  category: Database
  tags:
    - database
    - migrations
    - sql
    - goose
    - postgres
    - schema
    - kysely
    - drizzle
    - codegen
    - types
    - ddl
when:
  - user needs to add, modify, or remove a table, column, index, or constraint
  - user needs to create, inspect, apply, or roll back a migration
  - a feature requires a schema change before the application code can be written
  - user asks about migration status, pending migrations, or schema drift
  - a destructive or hard-to-reverse DDL change is being considered
  - a schema change needs to be coordinated with a production deployment
  - generated database types are stale or out of sync with the schema
  - user needs to design a table schema or choose column types
applicability:
  - Use for every schema change — no exceptions
  - Use when reviewing a migration for correctness, safety, or reversibility
  - Use when planning a multi-step expand → backfill → contract migration
  - Use when coordinating a migration with a production deploy
  - Use when diagnosing schema drift between the live database and generated
    types
termination:
  - Migration file authored with correct Up and Down blocks
  - Migration applied to dev and test databases without errors
  - Generated type file regenerated and verified against live schema
  - Lint and typecheck pass with no errors introduced by the migration
  - Production rollout risks documented and communicated
outputs:
  - Timestamped SQL migration file following schema design standards
  - Applied migration confirmed on dev and test environments
  - Regenerated and verified generated type file
  - Rollout risk assessment for production deployment
disableModelInvocation: true
---

Safe, repeatable database schema changes with automated type generation. Every schema change flows through this process — no exceptions.

The workflow has two modes:

- **Applied-schema mode** for migrations that have already run anywhere
- **Greenfield baseline mode** for a clean baseline track that has not shipped or been applied outside disposable databases

Treat those modes differently.

## Core Principles

- **Migrations are immutable once applied** — never edit a file that has been run against any environment
- **A greenfield baseline may be edited until it ships** — if a clean baseline track has only been used on disposable databases, improving those files directly is allowed
- **One concern per migration** — a single table, a single column set, a single index group
- **Always write Down** — every migration must be reversible unless you explicitly document why it cannot be
- **Additive by default** — add before removing (expand → backfill → contract)
- **Types must stay in sync** — no migration is complete until generated types are regenerated and verified
- **Report everything** — always tell the user what ran, what changed, and what the rollout risks are

## Modeling Principles

Design the schema from user capabilities, not from a menu of app screens.

Before writing DDL, identify whether the concept is primarily:

- **entity** — a durable object with identity over time
- **event** — an immutable fact that happened at a point or over a period
- **link** — an explicit semantic relation between entities
- **space** — a collaborative context boundary
- **tag** — flexible cross-domain organization
- **source** — provenance and sync state from an external system

Additional rules:

- prefer one strong primitive over multiple overlapping abstractions
- use strong relational constraints where they help, but do not fake integrity through brittle app-only rules
- separate authored content from derived analysis and provenance
- use `jsonb` only for bounded provider payloads or intentionally schemaless metadata
- keep access control, organization, provenance, and behavior as distinct concerns
- preserve user customization when it is part of product meaning, such as `color` and `icon` on user-facing objects

## PostgreSQL Features

Prefer modern PostgreSQL features when they materially improve correctness or performance.

Good candidates:

- `uuidv7()` for write-friendly ordered UUIDs
- range and multirange types for temporal modeling
- `WITHOUT OVERLAPS` constraints for active windows and assignments
- expression indexes for search and derived lookup paths
- `DEFERRABLE` constraints when cross-row correctness needs transaction-time validation

Do not adopt advanced features just for novelty. Use them when they simplify the model or enforce an invariant the application would otherwise have to fake.

## File Format

### Naming

```
YYYYMMDDHHMMSS_description_of_change.sql
```

Use the scaffold command — never create files by hand:

```bash
make db-new-migration NAME=add_users_table
# or: pnpm db:migration:new add_users_table
```

### File Structure (Goose)

```sql
-- +goose Up
-- +goose StatementBegin
CREATE TABLE users (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  email       TEXT        NOT NULL,
  name        TEXT        NOT NULL,
  role        TEXT        NOT NULL DEFAULT 'standard',
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX idx_users_email ON users (email);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS users;
-- +goose StatementEnd
```

**Required wrapping:** Use `-- +goose StatementBegin` / `-- +goose StatementEnd` around every block. Apply consistently — even single statements — to prevent parse errors when `DO $$` or semicolons appear.

## Full Migration Lifecycle

### Step 1 — Confirm Scope

Before writing anything, confirm:

- Does this require a migration, or is it an app-layer change?
- Is there a prior migration that should be amended instead? (Only if it has never been applied outside disposable environments)
- Does this change conflict with any pending migration in the set?
- Is this an applied-schema change or a greenfield baseline refinement?
- What user capability does this unlock or protect?
- Is the concept best modeled as an entity, event, link, space, tag, or source object?

```bash
make db-status
```

### Step 2 — Design Before DDL

Write down the intended invariant before touching SQL.

At minimum, answer:

1. What should the user be able to do after this change?
2. What must be queryable?
3. What must stay durable over time?
4. What access-control boundary applies?
5. What provenance or history must be preserved?
6. What should be enforced by the database instead of application code?

If the change affects a core model, prefer updating a product/schema design doc first.

### Step 3 — Scaffold

```bash
make db-new-migration NAME=add_posts_table
```

Edit only the generated file. Never create migration SQL by hand.

If you are working on a greenfield baseline track that has not shipped yet, you may instead refine the baseline files directly. Report clearly that you edited the baseline in place.

### Step 4 — Write Up and Down

Write the `Up` block first. Then write the `Down` block that exactly reverses it.

**Down block rules:**

- `CREATE TABLE` → `DROP TABLE IF EXISTS`
- `ADD COLUMN` → `DROP COLUMN`
- `CREATE INDEX` → `DROP INDEX IF EXISTS`
- `ADD CONSTRAINT` → `ALTER TABLE ... DROP CONSTRAINT`
- `CREATE TYPE` → `DROP TYPE IF EXISTS`

If the Down cannot be made safe (e.g., data was deleted), document it explicitly:

```sql
-- +goose Down
-- +goose StatementBegin
-- IRREVERSIBLE: data deleted in Up cannot be restored.
-- This migration was intentionally made one-way.
-- +goose StatementEnd
```

### Step 5 — Validate Before Applying

1. Inspect the migration set for conflicts — is any table, index, or constraint name duplicated?
2. Verify the Down exactly reverses the Up
3. Check that all referenced tables/columns already exist
4. Confirm `NOT NULL` columns without defaults won't fail on existing rows
5. Confirm every foreign key and uniqueness rule matches the actual business invariant
6. Look for accidental overlap between tables that should really be one primitive
7. Confirm search, sharing, provenance, and history behavior are all represented somewhere explicit

### Step 6 — Apply

```bash
# Apply to dev + test, then regenerate types (canonical workflow)
make db-migrate-sync
```

If you are working on a greenfield baseline track, use the project’s fresh-database verification path in addition to normal migration commands.

### Step 7 — Regenerate and Verify Types

**Mandatory after any schema-changing migration.**

```bash
make db-generate-types
make db-verify-types
pnpm lint
pnpm typecheck
```

Never leave a migration merged with stale generated types.

### Step 8 — Verify Behavior

Schema verification is not complete until behavior is tested.

At minimum, validate:

- fresh bootstrap on an empty database
- key integrity rules
- RLS behavior where applicable
- any registry, graph, or provenance side effects

Prefer database-native or SQL-driven assertions for schema behavior, not only app-layer tests.

### Step 9 — Report

Always tell the user:

- Which migration file was created or modified
- Whether the work was a new migration or an in-place greenfield baseline refinement
- Whether `db-migrate-sync` passed on dev and test
- Whether `db-verify-types` passed
- Whether lint and typecheck are clean
- Any destructive, irreversible, or rollout-sensitive aspects
- Any important modeling choices, especially around entities, events, links, spaces, tags, or sources

## References

- **schema-design.md** — table conventions, column rules, index rules, constraints
- **migration-patterns.md** — expand/backfill/contract, rollback, production deployments, destructive changes, schema drift
- **goose-workflow.md** — make targets and direct Goose commands quick reference

## Guardrails

- Never edit a migration file that has been applied to any environment — create a new migration instead
- Never confuse a collaborative **space** with a tag or taxonomy bucket
- Never collapse durable content and transient interaction history into the same model without an explicit reason
- Never store a derived relationship as the only copy of important authored truth
- Never apply migrations via raw `psql` or direct DB client in any environment
- Never hand-edit generated type files
- Never skip type verification after a schema change — stale types cause runtime type errors
- Never apply a destructive migration without a documented data impact assessment
- Never deploy application code before its required migrations have applied
- Never use `SERIAL` or `INTEGER` primary keys — use `UUID`
- Never use `TIMESTAMP` without time zone — use `TIMESTAMPTZ`
- If `db-migrate-sync` fails, stop — do not proceed to type verification or code deployment
