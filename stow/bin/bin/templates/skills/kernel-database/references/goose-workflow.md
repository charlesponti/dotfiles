# Goose Quick Reference

## Make Targets

| Command                             | Effect                                                           |
| ----------------------------------- | ---------------------------------------------------------------- |
| `make db-new-migration NAME=<desc>` | Scaffold timestamped migration file                              |
| `make db-migrate`                   | Apply pending migrations → dev database                          |
| `make db-migrate-test`              | Apply pending migrations → test database                         |
| `make db-migrate-all`               | Apply pending migrations → dev + test                            |
| `make db-migrate-sync`              | Apply dev + test, then regenerate types (**canonical workflow**) |
| `make db-rollback`                  | Roll back latest migration → dev                                 |
| `make db-rollback-test`             | Roll back latest migration → test                                |
| `make db-rollback-all`              | Roll back latest → dev + test                                    |
| `make db-rollback-sync`             | Roll back dev + test, then regenerate types                      |
| `make db-generate-types`            | Regenerate `packages/db/src/types/database.ts` from live schema  |
| `make db-verify-types`              | Assert generated types match live schema                         |
| `make db-status`                    | Show applied/pending migration state                             |

## Direct Goose Commands (when Make unavailable)

```bash
# Status
DATABASE_URL=<url> pnpm --filter @your-pkg/db goose:status

# Apply pending
DATABASE_URL=<url> pnpm --filter @your-pkg/db goose:up

# Roll back latest
DATABASE_URL=<url> pnpm --filter @your-pkg/db goose:down
```

Run all commands from the **monorepo root**.

## Migration File Template

```sql
-- +goose Up
-- +goose StatementBegin
CREATE TABLE example_items (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS example_items;
-- +goose StatementEnd
```

## Canonical Local Workflow

```bash
make db-new-migration NAME=<description>
# edit the generated file
make db-migrate-sync   # apply dev + test + regenerate types
make db-verify-types   # assert types match schema
pnpm lint              # catch any downstream type errors
```

## Generated Types

- File: generated type file in your db package (e.g., `packages/db/src/types/database.ts`)
- Generator: `kysely-codegen` or equivalent
- Never hand-edit this file
- Must be regenerated after every schema-changing migration
