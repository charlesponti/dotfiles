---
name: kernel-docker
kind: skill
tags:
  - infrastructure
  - devops
profile: extended
description: Manages Docker workflows for local development infrastructure and
  production container packaging. Use when writing Dockerfiles, configuring
  compose services, debugging container issues, optimizing image size, or when
  users ask about containerization.
license: MIT
compatibility: Any project using Docker for local infrastructure or production deployments.
metadata:
  author: project
  version: "1.0"
  category: Engineering
  tags:
    - docker
    - compose
    - containers
    - dockerfile
    - multi-stage
    - infrastructure
    - devops
when:
  - user is writing or reviewing a Dockerfile
  - user is configuring Docker Compose for local development
  - user is debugging a container that fails to start or behaves unexpectedly
  - user is optimizing image size or reducing build time
  - user is setting up local databases, caches, or queues via containers
applicability:
  - Use when authoring or reviewing any Dockerfile or compose.yml
  - Use when setting up local development infrastructure
  - Use when preparing container images for production deployment
termination:
  - Dockerfile uses multi-stage build with minimal runtime image
  - Containers run as non-root user
  - Local compose services start healthy and are accessible
outputs:
  - Production-ready multi-stage Dockerfile
  - Docker Compose configuration for local infrastructure
  - Image size analysis and optimization recommendations
---

# Docker Workflow

Consistent patterns for local development containers and production image builds.

## Local Development with Docker Compose

Use Compose for all local infrastructure (databases, caches, message queues). Keep application code running on the host for fast feedback loops.

```yaml
# compose.yml
services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: dev
      POSTGRES_DB: app_dev
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U dev"]
      interval: 5s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

```bash
# Start infrastructure
docker compose up -d

# Stop and remove containers (keep volumes)
docker compose down

# Stop and remove containers + volumes (reset data)
docker compose down -v

# View logs
docker compose logs -f postgres
```

## Dockerfile — Production

Use multi-stage builds to minimize image size and attack surface.

```dockerfile
# syntax=docker/dockerfile:1

# ── Stage 1: Dependencies ──────────────────────────────────────────
FROM node:22-alpine AS deps
WORKDIR /app
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile --prod

# ── Stage 2: Build ────────────────────────────────────────────────
FROM node:22-alpine AS builder
WORKDIR /app
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm build

# ── Stage 3: Runtime ──────────────────────────────────────────────
FROM node:22-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder --chown=node:node /app/dist ./dist
COPY --from=deps    --chown=node:node /app/node_modules ./node_modules
COPY --from=builder --chown=node:node /app/package.json ./package.json
USER node
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1
ENTRYPOINT ["node", "dist/index.js"]
```

## Multi-Container Networking

When your app depends on multiple services (database, cache, queue), Compose creates a default network for inter-container communication.

```yaml
# compose.yml — services can reach each other by service name
services:
  postgres:
    image: postgres:16-alpine
    # ...
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U dev"]
      interval: 5s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    # ...
    healthcheck:
      test: ["CMD-SHELL", "redis-cli ping"]
      interval: 5s
      timeout: 5s
      retries: 5

  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgres://dev:dev@postgres:5432/app_dev
      REDIS_URL: redis://redis:6379
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
```

**Rules:**

- Always use `depends_on` with `condition: service_healthy` — never bare `depends_on` (it only waits for container start, not readiness).
- Reference other services by their Compose service name (e.g., `postgres`, not `localhost`).
- The host app (running outside Docker) connects via `localhost:<published-port>`. Containers inside the network connect via `<service-name>:<container-port>`.
- Define `healthcheck` on every infrastructure service.

## Image Build and Push

```bash
# Build image
docker build -t myapp:latest .

# Tag for registry
docker tag myapp:latest registry.example.com/myapp:1.2.3

# Push to registry
docker push registry.example.com/myapp:1.2.3

# Build and push in one step (buildx)
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --tag registry.example.com/myapp:1.2.3 \
  --push .
```

## Image Size Optimization

| Technique              | Impact                                    |
| ---------------------- | ----------------------------------------- |
| Alpine base images     | -100MB+ vs Debian                         |
| Multi-stage builds     | Excludes build tools from runtime         |
| `--production` install | Excludes devDependencies                  |
| `.dockerignore`        | Excludes source, tests, docs from context |
| Combine RUN commands   | Fewer layers                              |

```dockerignore
# .dockerignore
node_modules
.git
*.md
__tests__
*.test.ts
*.spec.ts
.env*
dist
.vite
.turbo
```

## Security

- Run containers as a non-root user — always add `USER app` in the runtime stage
- Never embed secrets in the image — pass via environment variables at runtime
- Scan images for vulnerabilities: `docker scout cves myapp:latest`
- Pin base image digests in production: `FROM node:20-alpine@sha256:<digest>`
- Never run `docker run --privileged` in production

## Debugging

```bash
# Shell into a running container
docker exec -it <container_name> sh

# Shell into a new container from an image
docker run --rm -it myapp:latest sh

# Inspect container environment
docker inspect <container_name> | jq '.[0].Config.Env'

# Check resource usage
docker stats

# View recent logs
docker logs --tail 100 -f <container_name>
```

## Guardrails

- Never use `latest` tag in production deployments — always pin to a specific version or digest
- Never store state in a container's writable layer — use named volumes or external storage
- Never commit `.env` files or secrets to the Docker context
- Always define a HEALTHCHECK in production images
- Compose files for local dev should not be used as production configs — maintain separate production deployment manifests
