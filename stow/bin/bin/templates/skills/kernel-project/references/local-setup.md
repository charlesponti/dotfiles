# Local Project Setup

Use this workflow when cloning an existing repository, onboarding a developer, or diagnosing setup drift on a machine that should already be able to run the project.

## Prerequisites

- Node.js LTS installed
- pnpm installed via Corepack
- Docker Desktop running when local infrastructure is required
- Git with SSH configured
- Access to any private registries or secret managers used by the project

## First-Time Setup

```bash
git clone git@github.com:<org>/<repo>.git && cd <repo>

pnpm install

cp .env.example .env.local

docker compose up -d
pnpm db:migrate
pnpm db:seed

pnpm typecheck && pnpm build && pnpm test

pnpm dev
```

Install dependencies from the monorepo root, never from a package subdirectory.

## Environment Variables

- `.env.example` is committed and contains every required key.
- `.env.local` is gitignored and holds real local values.
- Secrets belong in the team secrets manager, not in source control.

## Daily Workflow

```bash
git pull origin main
pnpm install
pnpm db:migrate
pnpm dev
```

Before pushing:

```bash
pnpm typecheck && pnpm lint && pnpm test
```

## Health Diagnostics

Run these in order and stop at the first failure.

| Area         | Command                                                                      | Healthy signal                                  |
| ------------ | ---------------------------------------------------------------------------- | ----------------------------------------------- |
| Runtime      | `node --version`                                                             | Returns an active LTS version                   |
| Docker       | `docker compose ps`                                                          | Required services show `Up (healthy)`           |
| Dependencies | `pnpm install --frozen-lockfile`                                             | Exits 0 with no warnings                        |
| Environment  | `diff <(grep -oP '^[A-Z_]+' .env.example) <(grep -oP '^[A-Z_]+' .env.local)` | No missing keys                                 |
| Type check   | `pnpm typecheck`                                                             | Exits 0                                         |
| Build        | `pnpm build`                                                                 | Exits 0 and writes build output                 |
| Tests        | `pnpm test`                                                                  | All pass                                        |
| Lint         | `pnpm lint`                                                                  | Exits 0                                         |

Report status as `healthy`, `degraded (specific issues)`, or `broken (remediation steps)`.

## Cleanup

Targets: `dist/`, `.vite/`, `.turbo/`, `node_modules/.cache/`, `*.tmp`, `*.log`

```bash
rm -rf dist .vite .turbo node_modules/.cache
pnpm build
```

## Reset

```bash
docker compose down -v
rm -rf node_modules
pnpm install
docker compose up -d
pnpm db:migrate && pnpm db:seed
pnpm dev
```

If setup takes more than 15 minutes, the docs are incomplete. Fix the docs rather than institutionalizing tribal knowledge.