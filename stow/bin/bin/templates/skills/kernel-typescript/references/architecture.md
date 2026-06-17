# Type Architecture

Types are the contract between modules. Where a type lives determines who can use it, who can change it, and what breaks when it changes.

## Type Ownership

Every type has exactly one source of truth. Duplication creates divergence.

| Type category              | Lives in                                                    |
| -------------------------- | ----------------------------------------------------------- |
| Database row types         | `packages/db` — codegen output, never hand-edited           |
| API request/response types | `packages/api` or `services/api` — derived from Zod schemas |
| Shared domain types        | A dedicated `packages/types` or `packages/core`             |
| App-local UI state types   | The app package that owns them                              |
| Utility types              | The package that uses them — do not hoist unless shared     |

**Import direction:** apps import from packages; packages do not import from apps.

## Zod-First Schemas

Define schemas with Zod. Derive types from schemas — never maintain parallel type definitions.

```typescript
import { z } from "zod";

export const CreateUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
  role: z.enum(["admin", "standard"]).default("standard"),
});

// Derive — do not redeclare
export type CreateUserInput = z.infer<typeof CreateUserSchema>;
```

Never write:

```typescript
// ❌ schema and type maintained separately — they will diverge
const CreateUserSchema = z.object({ email: z.string() });
type CreateUserInput = { email: string };
```

## tsconfig Layout

Use TypeScript project references for monorepos.

```
tsconfig.json             ← root: solution config (references only)
tsconfig.base.json        ← shared compiler options
packages/
  db/
    tsconfig.json         ← composite: true, declarationMap: true
  api/
    tsconfig.json         ← composite: true, references db
  types/
    tsconfig.json         ← composite: true
apps/
  web/
    tsconfig.json         ← references api, types
```

```json
// Root tsconfig.json — solution file
{
  "files": [],
  "references": [
    { "path": "./packages/db" },
    { "path": "./packages/types" },
    { "path": "./packages/api" },
    { "path": "./apps/web" }
  ]
}
```

```json
// packages/api/tsconfig.json
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": {
    "composite": true,
    "declarationMap": true,
    "outDir": "./dist"
  },
  "references": [{ "path": "../db" }, { "path": "../types" }]
}
```

## Base tsconfig Options

```json
{
  "compilerOptions": {
    "target": "ESNext",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "exactOptionalPropertyTypes": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "skipLibCheck": false,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  }
}
```

Always enable `strict`, `exactOptionalPropertyTypes`, and `noUncheckedIndexedAccess`. Never use `module: NodeNext` or `moduleResolution: NodeNext` when the stack uses a bundler.

## Package Exports

Use the `exports` field — not `main` — for all packages.

```json
{
  "exports": {
    ".": { "import": "./dist/index.js", "types": "./dist/index.d.ts" },
    "./types": { "import": "./dist/types.js", "types": "./dist/types.d.ts" }
  }
}
```

Import paths in consuming packages must use the published export path, not relative paths across package boundaries.

## Anti-Patterns

| Anti-pattern                                           | Fix                                                                       |
| ------------------------------------------------------ | ------------------------------------------------------------------------- |
| `any` in a shared type                                 | Use `unknown` and narrow explicitly                                       |
| Types redeclared in multiple packages                  | Move to `packages/types`, export from there                               |
| Circular package references                            | Introduce a shared types package that neither imports from the other      |
| Hand-edited codegen output                             | Regenerate from source; add to `.gitignore`                               |
| `@ts-ignore` without explanation                       | Explain why; add a ticket to remove it                                    |
