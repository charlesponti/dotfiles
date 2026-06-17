# Migration Patterns

## Expand → Backfill → Contract

For any change that would require backfilling existing rows or risks a table lock:

```
Migration 1 — Expand: add new column as nullable
  ALTER TABLE users ADD COLUMN display_name TEXT;

Migration 2 — Backfill: populate existing rows (run as a data migration or app-layer job)
  UPDATE users SET display_name = name WHERE display_name IS NULL;

Migration 3 — Contract: enforce the constraint, drop the old column
  ALTER TABLE users ALTER COLUMN display_name SET NOT NULL;
  ALTER TABLE users DROP COLUMN name;
```

Never combine steps. Each is a separate file. Deploy each step independently to avoid table locks on large datasets.

**When required:**

- Adding `NOT NULL` to an existing column without a default
- Renaming a column
- Splitting or merging columns
- Changing a column's type in a way that requires a cast

## Rollback

```bash
# Roll back latest migration on dev + test, then regenerate types
make db-rollback-sync

# Roll back on dev only
make db-rollback
# or: pnpm db:rollback

# Roll back on test only
make db-rollback-test

# Roll back both without type sync
make db-rollback-all

# Check status after rollback
make db-status
```

After rollback, always verify types are still consistent:

```bash
make db-verify-types
pnpm typecheck
```

## Production Deployments

### Migration-Before-Deploy Rule

Migrations always run **before** the application code that requires them. Never deploy application code and migrations simultaneously.

```
1. Run migration against production database
2. Wait for success
3. Deploy application code
4. Smoke test
5. Monitor error rates
```

### Online vs Offline DDL

| Operation                                | Risk                       | Mitigation                       |
| ---------------------------------------- | -------------------------- | -------------------------------- |
| `CREATE TABLE`                           | None                       | Safe online                      |
| `ADD COLUMN` with default (Postgres 11+) | None                       | Safe online                      |
| `ADD COLUMN NOT NULL` without default    | Table lock on old Postgres | Use expand pattern               |
| `CREATE INDEX`                           | Table lock                 | Use `CREATE INDEX CONCURRENTLY`  |
| `DROP INDEX`                             | Brief lock                 | Use `DROP INDEX CONCURRENTLY`    |
| `ALTER COLUMN TYPE`                      | Table rewrite              | Use expand → backfill → contract |
| `DROP TABLE` / `DROP COLUMN`             | Irreversible               | Requires explicit review         |

### Production Apply Commands

```bash
DATABASE_URL=$PROD_DATABASE_URL pnpm --filter @your-pkg/db goose:status
DATABASE_URL=$PROD_DATABASE_URL pnpm --filter @your-pkg/db goose:up
```

Always check status before applying. Confirm the pending migration count matches expectations.

## Destructive Changes

These require explicit review and sign-off before proceeding:

- `DROP TABLE`
- `DROP COLUMN`
- `TRUNCATE`
- Incompatible type rewrites (e.g., `TEXT` → `INTEGER`)
- Removing a constraint that is relied upon for data integrity

For each, document in the migration file:

```sql
-- DESTRUCTIVE: drops the legacy_tokens table.
-- Data cannot be recovered after this migration applies.
-- Verified safe: no application code reads legacy_tokens as of 2024-03-15.
-- Reviewed by: @author on 2024-03-14.
```

## Schema Drift Detection

If you suspect the live schema and the generated types are out of sync:

```bash
# Check migration status — are there unapplied migrations?
make db-status

# Regenerate and compare
make db-generate-types
make db-verify-types

# If diff found, apply missing migrations
make db-migrate-sync
```

Schema drift usually means either a migration was applied directly via psql, or a type regeneration step was skipped. Never fix drift by editing generated type files — always fix the underlying schema.
