---
name: kernel-typescript
kind: skill
tags:
  - typescript
  - types
  - patterns
profile: extended
description: "Enforces TypeScript correctness, type safety, and idiomatic
  patterns across all code. Use when writing or reviewing types, generics,
  utility types, narrowing logic, async patterns, error handling, Zod schemas,
  or when making structural decisions about where types should live."
license: MIT
compatibility: TypeScript 5+ / TypeScript 7 (tsgo).
metadata:
  author: project
  version: "1.0"
  category: Engineering
  tags:
    - typescript
    - types
    - generics
    - narrowing
    - utility-types
    - async
    - error-handling
    - zod
    - schemas
    - type-safety
    - monorepo
    - tsconfig
when:
  - user is writing or reviewing TypeScript types, interfaces, or generics
  - user is narrowing types or handling discriminated unions
  - user is writing utility types or mapped types
  - user is defining a schema with Zod and needs to derive types
  - user is handling async code or error types
  - user is deciding where a shared type should live in the package graph
  - user is configuring tsconfig.json or resolving a circular type dependency
  - user asks why a type is not what they expected, or why an assertion fails
applicability:
  - Use when adding any TypeScript type, generic, or schema to the codebase
  - Use when reviewing code for type safety regressions or `any` leakage
  - Use when a type needs to be shared across packages
  - Use when tsconfig or project references need to be set up or fixed
termination:
  - All types have a single source of truth with clear ownership
  - No `any` in exported or shared types — only `unknown` with explicit narrowing
  - Schemas are Zod-first with derived types — no parallel definitions
  - Async functions return typed results; errors are typed, not swallowed
outputs:
  - Correctly typed functions, generics, or utility types
  - Zod schema with inferred TypeScript type
  - tsconfig.json with correct project references (see references/architecture.md)
---

Enforces type safety, idiomatic patterns, and structural correctness across TypeScript code.

## Type Safety Rules

- Never use `any` in exported or shared types — use `unknown` and narrow explicitly
- Never use type assertions (`as Foo`) to paper over a type error — fix the root mismatch
- Never silence errors with `@ts-ignore` without a comment explaining why and a plan to remove it
- Prefer `interface` for object shapes that will be extended; prefer `type` for unions, intersections, and aliases
- Mark properties optional only when `undefined` is a meaningful value — absent vs. undefined are different things

## Narrowing

Use discriminated unions and exhaustive checks instead of boolean flags or `typeof` chains.

```typescript
type Result<T> =
  | { ok: true; value: T }
  | { ok: false; error: string };

function handle<T>(r: Result<T>): T {
  if (!r.ok) throw new Error(r.error);
  return r.value;
}
```

For exhaustive switch coverage:

```typescript
function assertNever(x: never): never {
  throw new Error(`Unhandled case: ${JSON.stringify(x)}`);
}
```

## Generics

Write constraints that communicate intent, not just `T`.

```typescript
// Too loose — T could be anything
function first<T>(arr: T[]): T | undefined { return arr[0]; }

// Constrained — caller knows what's expected
function getById<T extends { id: string }>(items: T[], id: string): T | undefined {
  return items.find(item => item.id === id);
}
```

Avoid generic overreach — if a function works on two or three known types, a union is cleaner than a generic.

## Utility Types

Prefer built-in utility types over hand-rolled equivalents:

| Need                              | Use                         |
| --------------------------------- | --------------------------- |
| Subset of an object's keys        | `Pick<T, K>`                |
| Object without certain keys       | `Omit<T, K>`                |
| All properties optional           | `Partial<T>`                |
| All properties required           | `Required<T>`               |
| Read-only properties              | `Readonly<T>`               |
| Return type of a function         | `ReturnType<typeof fn>`     |
| Unwrap a Promise                  | `Awaited<T>`                |
| Values of an object               | `T[keyof T]`                |

## Async and Error Handling

Type errors explicitly — do not catch and return `undefined`.

```typescript
// Prefer typed result over thrown errors at boundaries
async function fetchUser(id: string): Promise<Result<User>> {
  try {
    const user = await db.users.findById(id);
    return user ? { ok: true, value: user } : { ok: false, error: "Not found" };
  } catch (e) {
    return { ok: false, error: String(e) };
  }
}
```

- Always `await` Promises — never let them float without a `.catch()` or `void` annotation
- Use `Awaited<ReturnType<typeof fn>>` to derive async return types

## Zod Schemas

Define once, derive the type — never maintain a parallel `type` definition.

```typescript
import { z } from "zod";

export const UserSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  role: z.enum(["admin", "member"]).default("member"),
});

export type User = z.infer<typeof UserSchema>;
```

Parse at boundaries (API responses, form input, environment variables). Trust typed data downstream.

## Structural Decisions

See `references/architecture.md` for:
- Where types should live in a monorepo package graph
- tsconfig project references setup
- Package `exports` field configuration
- Anti-patterns for circular dependencies and codegen output

## Guardrails

- Never use `any` in exported types — it propagates unsafety to every consumer
- Never import from a package's `src/` directly — always from its published exports
- Never hand-edit generated type files (DB codegen, OpenAPI, GraphQL)
- A type belongs in the lowest-level package that needs it — do not hoist to shared until two packages need it
- `exactOptionalPropertyTypes` and `noUncheckedIndexedAccess` must be enabled — they catch real bugs
