# Project Scaffold

Use this workflow when starting a new repository or bootstrapping a new application surface in a monorepo.

## Project Shapes

- **Full-stack web app** — TanStack Router frontend + Hono backend + Kysely + Goose
- **Backend service only** — Hono + Kysely + Goose
- **Frontend only** — TanStack Router + Vite
- **Mobile app** — React Native + Expo + EAS
- **Monorepo** — Vite+ workspaces containing any combination of the above

## Scaffold

```bash
# Monorepo root
pnpm init
```

Suggested workspace layout:

```text
apps/
  web/          # TanStack Router app
  api/          # Hono service
  mobile/       # React Native + Expo app
packages/
  db/           # Kysely client + Goose migrations
  ui/           # Shared components (Tailwind + CSS Modules)
  auth/         # Better-Auth config
```

Single-app projects follow the same internal structure without the workspace layer.

## Tooling

### TypeScript

Use TypeScript 7 with tsgo.

```json
{
  "compilerOptions": {
    "strict": true,
    "exactOptionalPropertyTypes": true,
    "noUncheckedIndexedAccess": true,
    "module": "ESNext",
    "moduleResolution": "bundler",
    "target": "ESNext",
    "jsx": "react-jsx"
  }
}
```

### Vite and Tailwind

```bash
pnpm add -D tailwindcss @tailwindcss/vite
```

```ts
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [react(), tailwindcss()],
});
```

Use CSS Modules for component-scoped styles alongside Tailwind utility classes. Never use inline styles.

### Linting and Testing

```bash
pnpm add -D eslint @typescript-eslint/eslint-plugin prettier
pnpm add -D vitest @testing-library/react
```

Enforce format and lint in CI.

### TanStack Router

```bash
pnpm add @tanstack/react-router
pnpm add -D @tanstack/router-vite-plugin
```

Use file-based routing. Never use React Router.

### Hono

```bash
pnpm add hono
```

```ts
import { Hono } from "hono";

const app = new Hono();

export default app;
```

### Kysely and Goose

```bash
pnpm add kysely
pnpm add -D goose
```

- Migration files live in `packages/db/migrations/`.
- Generated Kysely types live in `packages/db/src/schema.ts`.
- Never change the schema outside a Goose migration.

### Better-Auth

```bash
pnpm add better-auth
```

All auth logic lives in `packages/auth/`.

## Environment

```bash
cp .env.example .env.local
```

`.env.example` must include every required key with a placeholder value and a comment describing it.

## Git

```bash
git init
git add .
git commit -m "chore: initial project setup"
```

`.gitignore` must exclude `node_modules/`, `dist/`, `.env.local`, `*.local`, `.turbo/`, and `build/`.

## Verification Gates

```bash
pnpm typecheck
pnpm build
pnpm test
pnpm lint
```

Do not write application code until all four pass with zero errors.