---
name: kernel-better-auth
kind: skill
tags:
  - backend
  - auth
  - security
profile: extended
description: Defines and enforces the authentication and authorization contract
  for apps and services using Better Auth as the sole auth authority. Use when
  implementing login, session management, token handling, protected routes,
  inter-service auth, configuring Better Auth plugins, implementing non-browser
  auth flows (mobile, CLI), or migrating from a custom auth stack.
license: MIT
compatibility: Any full-stack project with authentication requirements using Better Auth.
metadata:
  author: project
  version: "1.0"
  category: Security
  tags:
    - auth
    - authentication
    - authorization
    - better-auth
    - jwt
    - session
    - bearer
    - device-authorization
    - passkey
    - emailOTP
    - middleware
    - protected-routes
    - rbac
    - migration
    - multi-client
when:
  - user is implementing login, logout, or registration
  - user is managing sessions, JWTs, or refresh tokens
  - user is adding auth middleware to an API
  - user is implementing protected routes in the frontend
  - user is designing role-based access control
  - user is implementing inter-service authentication
  - user is configuring Better Auth plugins (JWT, bearer, deviceAuthorization, passkey, emailOTP)
  - user is implementing auth for a non-browser client (mobile app, CLI, desktop)
  - user is migrating from a custom JWT or session stack to Better Auth
  - user is removing custom token issuance, session stores, or refresh-token logic
  - user is deciding which auth surface to use for web vs mobile vs CLI
  - user is aligning API middleware or routes with Better Auth session/bearer state
applicability:
  - Use when implementing any authentication or authorization flow
  - Use when reviewing token storage, expiry, or rotation strategy
  - Use when adding an auth guard to a frontend route
  - Use when designing inter-service credential passing
  - Use when adding or configuring Better Auth plugins beyond the core setup
  - Use when ripping out a custom auth layer in favor of Better Auth
termination:
  - Session contract is defined and typed
  - Token lifecycle (access + refresh) is implemented per spec
  - API middleware verifies session before handler executes
  - Frontend auth guard handles loading, authenticated, and unauthenticated states
  - Better Auth is the sole auth authority; no custom JWT/session code remains
  - Each client type uses the correct Better Auth-native surface
  - DB schema exposes only Better Auth-native and plugin tables
  - Deprecated custom endpoints are removed; Better Auth-native routes serve all clients
outputs:
  - Session type definition
  - Token verification middleware
  - Frontend auth guard component
  - Logout implementation that revokes server-side
---

Authentication and authorization contract for apps and services. Better-Auth owns all authentication — never implement custom session handling, JWT issuance, or password hashing.

## Toolchain

| Concern              | Tool                                                               |
| -------------------- | ------------------------------------------------------------------ |
| Auth provider        | Better-Auth                                                        |
| Session hook (React) | `better-auth/react` → `useSession()`                               |
| Server middleware    | Better-Auth Hono plugin                                            |
| Inter-service auth   | Short-lived signed tokens (custom — Better-Auth doesn't cover s2s) |

Never use: custom JWT libraries, Passport.js, NextAuth, Lucia, or hand-rolled session logic.

## Client Auth Surface Map

| Client type        | Auth surface                            |
| ------------------ | --------------------------------------- |
| First-party web    | Better Auth session cookies             |
| Desktop (Electron) | Better Auth session cookies             |
| Mobile / Expo      | Better Auth JWT + bearer plugin         |
| CLI                | Better Auth device authorization        |
| Non-browser SDK    | Better Auth JWT + bearer plugin         |

Never mix surfaces: a CLI should not use session cookies; a web app should not issue bearer tokens.

## Server Setup

```typescript
// packages/auth/src/index.ts
import { betterAuth } from "better-auth";
import { db } from "@your-org/db";

export const auth = betterAuth({
  database: db,
  emailAndPassword: { enabled: true },
  session: {
    expiresIn: 60 * 60 * 24 * 7, // 7 days
    updateAge: 60 * 60 * 24, // refresh if older than 24h
    cookieCache: { enabled: true, maxAge: 5 * 60 },
  },
  trustedOrigins: [process.env.APP_URL!],
});

export type Session = typeof auth.$Infer.Session;
export type User = typeof auth.$Infer.Session.user;
```

## Plugin Configuration

Enable only the plugins the project actually uses. The auth config file contains nothing else.

```typescript
import { betterAuth } from "better-auth";
import { expo } from "@better-auth/expo";
import { jwt, bearer, deviceAuthorization } from "better-auth/plugins";
import { passkey, emailOTP, multiSession, oneTimeToken } from "better-auth/plugins";

export const auth = betterAuth({
  secret: process.env.BETTER_AUTH_SECRET!,
  baseURL: process.env.BETTER_AUTH_BASE_URL!,
  trustedOrigins: [process.env.APP_URL!],
  database: db,
  plugins: [
    expo(),
    jwt(),
    bearer(),
    deviceAuthorization(),
    passkey({ rpID: process.env.RP_ID!, rpName: "Your App" }),
    emailOTP({ sendVerificationOTP: async ({ email, otp }) => { /* send */ } }),
    multiSession(),
    oneTimeToken(),
  ],
});
```

Do not add to the auth config:
- `additionalFields` for role or session state — role modeling is an app-domain concern
- Custom schema/table/field remapping — keep the DB namespace via search path, not Better Auth model remapping
- Custom refresh or session hooks layered on top of Better Auth behavior

## Hono Integration

```typescript
// apps/api/src/middleware/auth.ts
import { auth } from "@your-org/auth";

// Mount Better-Auth handler — handles all /api/auth/* routes
app.on(["POST", "GET"], "/api/auth/**", (c) => auth.handler(c.req.raw));

// Session middleware — attaches session to context
export async function sessionMiddleware(c: Context, next: Next) {
  const session = await auth.api.getSession({ headers: c.req.raw.headers });
  c.set("session", session);
  await next();
}

// Auth guard — rejects unauthenticated requests
export async function requireAuth(c: Context, next: Next) {
  const session = c.get("session");
  if (!session) return c.json(ApiErrors.UNAUTHORIZED, 401);
  await next();
}
```

## Input Normalization

Normalize before validating. Never combine the two operations.

```ts
export function normalizeEmail(value: string): string  // trim + lowercase
export function normalizeOtp(value: string): string    // strip non-digits, cap at 6
export function isValidEmail(value: string): boolean   // expects normalized input
export function isValidOtp(value: string): boolean     // expects normalized input
```

- The canonical module is `packages/platform/auth/src/shared/validation.ts` (or equivalent shared auth package).
- `isValid*` functions always receive already-normalized values — never raw input.
- Never inline `trim().toLowerCase()` or `/\D/g` in auth handlers; always import from the shared module.
- Local UX normalization (e.g. per-character OTP input stripping) is separate from domain normalization — keep them distinct even when the regex is identical.

## Database Schema

Only Better Auth-native tables belong in the auth schema:

| Table          | Source                       |
| -------------- | ---------------------------- |
| `user`         | core                         |
| `session`      | core                         |
| `account`      | core                         |
| `verification` | core                         |
| `passkey`      | passkey plugin               |
| `jwks`         | jwt plugin                   |
| `device_code`  | deviceAuthorization plugin   |

Add plugin tables only when the corresponding plugin is enabled. Never add auth-owned role or permission tables — role state belongs in the app domain.

`packages/db` (or the equivalent DB package) is the sole source of truth for auth storage. Rebuild all published DB types from schema before touching any consumer.

## API Route Surface

Keep only routes that are thin wrappers around Better Auth-native endpoints:

| Route                      | Backed by                              |
| -------------------------- | -------------------------------------- |
| `/api/auth/session`        | Better Auth session                    |
| `/api/auth/jwks`           | Better Auth JWT plugin                 |
| `/api/auth/token`          | Better Auth JWT plugin                 |
| Email OTP send/verify      | Better Auth emailOTP plugin            |
| Passkey register/auth      | Better Auth passkey plugin             |
| Device authorization flows | Better Auth deviceAuthorization plugin |

Remove these routes entirely:
- `/api/auth/refresh` — replaced by Better Auth session renewal
- `/api/auth/token-from-session` — replaced by Better Auth JWT plugin
- Any custom refresh-grant endpoint
- Any revocation or session-cache logic that exists only for the old token model

## Authorization as a Separate Layer

Better-Auth handles authentication. Role checks are app-level middleware.

```typescript
export function requireRole(...roles: string[]) {
  return async (c: Context, next: Next) => {
    const session = c.get("session");
    if (!session) return c.json(ApiErrors.UNAUTHORIZED, 401);
    if (!roles.some((r) => session.user.role === r)) {
      return c.json(ApiErrors.FORBIDDEN, 403);
    }
    await next();
  };
}

// Usage — middleware chain
app.post("/api/admin/users", requireAuth, requireRole("admin"), handler);
```

Never conflate authentication and authorization in the same middleware.

## Client Setup

```typescript
// packages/auth/src/client.ts
import { createAuthClient } from "better-auth/react";

export const authClient = createAuthClient({
  baseURL: process.env.NEXT_PUBLIC_APP_URL,
});

export const { useSession, signIn, signOut, signUp } = authClient;
```

## Protected Routes (Frontend)

```tsx
import { useSession } from "@your-org/auth/client";

function RequireAuth({ children }: { children: React.ReactNode }) {
  const { data: session, isPending } = useSession();

  if (isPending) return <AuthSkeleton />;

  if (!session) {
    return <Navigate to={`/login?returnTo=${encodeURIComponent(location.pathname)}`} />;
  }

  return <>{children}</>;
}
```

Three states every auth guard must handle: loading, authenticated, unauthenticated.

## Login and Logout

```typescript
// Login
await signIn.email({ email, password, callbackURL: returnTo ?? "/dashboard" });

// Logout
await signOut();
queryClient.clear(); // purge all cached data after logout
```

Never POST to `/auth/login` manually — use Better-Auth's `signIn.*` methods. Never manage cookies manually.

## Inter-Service Authentication

Better-Auth does not cover service-to-service auth. Use short-lived signed tokens for this case only.

```typescript
// Service-to-service: short-lived signed token with service claim
const serviceToken = await signToken({
  sub: "service:worker",
  aud: "service:api",
  iat: Math.floor(Date.now() / 1000),
  exp: Math.floor(Date.now() / 1000) + 60, // 60-second lifetime
});

// Receiving service verifies aud claim
const payload = await verifyToken(token, { audience: "service:api" });
```

- Each service pair has unique credentials — never share credentials between services
- Rotate service credentials on a schedule, not only on breach

## Migrating from a Custom Auth Layer

Follow this order — each step must pass before the next begins.

### 1. Rebuild the DB Foundation

- Rewrite the schema to expose only Better Auth-native and plugin tables
- Run `db build` and `db typecheck`; verify generated types show no custom auth tables
- Fix any consumer that imported custom auth-layer types before continuing

### 2. Rewrite the Auth Config

- Remove all `additionalFields`, custom schema remapping, and custom hooks
- Enable only the plugins the project needs (see Plugin Configuration above)
- Verify the auth service starts and `/api/auth/session` responds correctly

### 3. Delete the Custom Token/Session Subsystem

Remove in this order to surface breakage early:
1. Custom access-token issuance and verification
2. Custom JWKS endpoint if it duplicates the Better Auth JWT plugin
3. Custom session store
4. Custom refresh-token rotation

At each step, run the auth typecheck and fix breakage before moving on.

### 4. Remove Deprecated Endpoints

- Drop `/api/auth/refresh` and `/api/auth/token-from-session`
- Update any client that called these to use Better Auth-native endpoints
- Remove custom revocation and session-cache logic

### 5. Realign Middleware and Routes

- Replace any middleware that reads custom token claims with Better Auth session/bearer resolution
- Remove `isAdmin` and any auth-owned role fields from session payloads and API responses
- Downstream breakage from missing role fields is resolved in app-domain role work — not by restoring auth-layer role state

### 6. Replace Test Helpers

- Remove helpers that mint custom tokens or depend on the old refresh/session model
- Use Better Auth-native session establishment in integration/E2E tests
- Rewrite auth contract tests to cover: session cookies (web), JWT/bearer (mobile), device authorization (CLI), passkey flows, email OTP flows

## Validation Checklist

- [ ] DB build and typecheck pass; generated types show only Better Auth-native tables
- [ ] Auth config contains only native configuration — no custom fields, hooks, or remapping
- [ ] No runtime references to custom refresh-token or session architecture
- [ ] No auth responses include `isAdmin` or other auth-owned role fields
- [ ] Web/desktop: session cookie auth works end-to-end
- [ ] Mobile/non-browser: JWT retrieval and bearer auth work end-to-end
- [ ] CLI: device authorization login flow works end-to-end
- [ ] Email OTP sign-in flow works
- [ ] Passkey register and authenticate flows work
- [ ] JWKS available only through Better Auth JWT plugin, not a custom endpoint
- [ ] Session contract is defined and typed
- [ ] Frontend auth guard handles loading, authenticated, and unauthenticated states

## Guardrails

- Never implement custom session handling, JWT issuance, or password hashing — Better-Auth owns all of this
- Never store tokens in `localStorage` or `sessionStorage` — Better-Auth uses httpOnly cookies
- Never log tokens, session cookies, or credentials — even in debug mode
- Never store user identity in `useState` — use `useSession()` from Better-Auth
- Never call auth endpoints manually — use Better-Auth's typed client methods
- Every API endpoint must have an explicit auth requirement (even if it's `public`)
- Authorization (role checks) is app-level — never inside Better-Auth config
- Never add role or permission fields to auth-owned DB types or API responses — role modeling belongs in the app domain
- Never configure custom auth behavior in the Better Auth config (no `additionalFields`, no custom session/refresh hooks, no schema remapping)
- Never issue JWTs, manage sessions, or rotate refresh tokens with custom code when Better Auth plugins cover the surface
- Never remove a custom auth endpoint without first wiring in the Better Auth-native replacement
- Never route auth through a custom session cache or token store — trust Better Auth's built-in state management
