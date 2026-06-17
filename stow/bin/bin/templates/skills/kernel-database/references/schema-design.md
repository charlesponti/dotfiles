# Schema Design Standards

## Table Conventions

| Column       | Type                                    | Requirement                                 |
| ------------ | --------------------------------------- | ------------------------------------------- |
| Primary key  | `UUID DEFAULT gen_random_uuid()`        | Always UUID — never serial/integer          |
| `created_at` | `TIMESTAMPTZ NOT NULL DEFAULT now()`    | Required on every table                     |
| `updated_at` | `TIMESTAMPTZ NOT NULL DEFAULT now()`    | Required; maintain via trigger or app layer |
| Foreign keys | `UUID NOT NULL REFERENCES table(id)`    | Always NOT NULL unless explicitly optional  |
| Soft deletes | `deleted_at TIMESTAMPTZ`                | Use over hard deletes when history matters  |
| Status/state | `TEXT NOT NULL` with a check constraint | Over enums — TEXT is easier to extend       |

## Column Rules

- `NOT NULL` by default — only add nullable columns when the domain requires it
- Prefer `TEXT` over `VARCHAR(n)` — PostgreSQL stores them identically; TEXT avoids arbitrary limits
- Use `TIMESTAMPTZ` everywhere — never `TIMESTAMP WITHOUT TIME ZONE`
- Avoid `BOOLEAN` columns that encode state; use a status column with check constraint instead
- Use `NUMERIC` for money/currency — never `FLOAT` or `DOUBLE PRECISION`

## Index Rules

- Always index foreign keys that will be used in joins
- Add partial indexes for common filtered queries: `WHERE deleted_at IS NULL`
- Use `CONCURRENTLY` for indexes on tables with existing data in production
- Name indexes explicitly: `idx_{table}_{columns}[_{qualifier}]`

```sql
-- Standard index
CREATE INDEX idx_posts_user_id ON posts (user_id);

-- Partial index
CREATE INDEX idx_posts_active ON posts (created_at DESC) WHERE deleted_at IS NULL;

-- Unique constraint via index
CREATE UNIQUE INDEX idx_users_email ON users (email);

-- Composite index for a common query pattern
CREATE INDEX idx_posts_user_status ON posts (user_id, status) WHERE deleted_at IS NULL;
```

## Constraints

```sql
-- Check constraint for status fields
ALTER TABLE orders ADD CONSTRAINT orders_status_check
  CHECK (status IN ('pending', 'processing', 'completed', 'cancelled'));

-- Foreign key with explicit ON DELETE behavior
ALTER TABLE posts ADD CONSTRAINT posts_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
```
