---
name: kernel-testing
kind: skill
tags:
  - testing
  - quality
profile: extended
description: Provides testing guidance for test files and test strategy
  decisions across unit, integration, and end-to-end layers. Use when writing
  new tests, reviewing test coverage, deciding where a test should live, or when
  users ask about testing patterns, test structure, or what to test.
license: MIT
compatibility: Any TypeScript project using Vitest, Jest, or a compatible test runner.
metadata:
  author: project
  version: "1.0"
  category: Engineering
  tags:
    - testing
    - unit-tests
    - integration-tests
    - e2e
    - vitest
    - jest
    - tdd
    - coverage
    - factories
when:
  - user is writing tests for a new feature or bug fix
  - user is deciding what type of test to write (unit vs integration vs E2E)
  - user is reviewing tests for correctness, coverage, or naming
  - user is structuring test files or choosing test tooling
  - user is investigating a flaky or ineffective test
applicability:
  - Use when writing any automated test
  - Use when reviewing tests for behavior coverage vs implementation coverage
  - Use when establishing the test strategy for a new module or feature
termination:
  - Tests describe behavior, not implementation
  - Each test cleans up after itself
  - Integration tests use a real database, not mocks
outputs:
  - Unit tests for pure business logic
  - Integration tests for API routes or service boundaries
  - Test factory functions for repeatable test data
---

Tests verify behavior, not implementation. A test that passes when behavior is broken is worse than no test.

## Toolchain

| Concern                 | Tool                               |
| ----------------------- | ---------------------------------- |
| Test runner             | Vitest (`pnpm test`)               |
| Component testing       | `@testing-library/react` + Vitest  |
| API/integration testing | Hono's `app.request()` test client |
| E2E                     | Playwright (`pnpm test:e2e`)       |

Never use Jest, Mocha, Jasmine, or any other test runner. Vitest is the only prescribed runner.

## Test Pyramid

| Layer       | What it tests                                    | Speed            | Count    |
| ----------- | ------------------------------------------------ | ---------------- | -------- |
| Unit        | Pure functions, business logic, isolated modules | Fast (< 5ms)     | Many     |
| Integration | Module boundaries, DB queries, API routes        | Medium (< 500ms) | Moderate |
| E2E         | Critical user flows end-to-end                   | Slow (seconds)   | Few      |

Write tests at the lowest level that gives meaningful confidence.

## File Organization

Co-locate test files with the source file they test:

```
src/
  users/
    service.ts
    service.test.ts     ← unit tests for the service
    handlers.ts
    handlers.test.ts    ← integration tests for route handlers
```

E2E tests live in a top-level directory:

```
e2e/
  auth.spec.ts
  checkout.spec.ts
```

## Test Naming

Describe behavior, not implementation:

```typescript
// ✅ describes behavior
it("returns 401 when the session token is expired", async () => { ... });
it("sends a welcome email after user registration", async () => { ... });
it("does not allow deleting another user's resource", async () => { ... });

// ❌ describes implementation
it("calls verifyToken", async () => { ... });
it("sets isEmailSent to true", async () => { ... });
```

Use `describe` blocks to group related tests:

```typescript
describe("POST /api/users", () => {
  describe("when request is valid", () => {
    it("creates the user and returns 201", async () => { ... });
    it("sends the welcome email", async () => { ... });
  });
  describe("when email is already taken", () => {
    it("returns 409 with CONFLICT code", async () => { ... });
  });
});
```

## Unit Tests

Test pure functions with direct assertions. Avoid mocking internal modules.

```typescript
import { calculateDiscount } from "./pricing";

describe("calculateDiscount", () => {
  it("applies 10% for premium members", () => {
    expect(calculateDiscount(100, "premium")).toBe(90);
  });
  it("applies no discount for standard members", () => {
    expect(calculateDiscount(100, "standard")).toBe(100);
  });
  it("never returns a negative price", () => {
    expect(calculateDiscount(5, "premium")).toBeGreaterThanOrEqual(0);
  });
});
```

## Integration Tests

Test at the HTTP boundary. Use a real database — not a mock.

```typescript
import { createTestApp } from "@/test/helpers";
import { db } from "@/database";

describe("GET /api/users/:id", () => {
  let app: Awaited<ReturnType<typeof createTestApp>>;

  beforeAll(async () => {
    app = await createTestApp();
  });
  afterEach(async () => {
    await db.deleteFrom("users").execute();
  });

  it("returns the user when found", async () => {
    const user = await db
      .insertInto("users")
      .values({ email: "a@example.com", name: "Alice" })
      .returningAll()
      .executeTakeFirstOrThrow();

    const res = await app.request(`/api/users/${user.id}`, {
      headers: { Authorization: `Bearer ${testToken(user.id)}` },
    });

    expect(res.status).toBe(200);
    const body = await res.json();
    expect(body.data.id).toBe(user.id);
  });

  it("returns 404 when user does not exist", async () => {
    const res = await app.request("/api/users/nonexistent", {
      headers: { Authorization: `Bearer ${testToken("any-id")}` },
    });
    expect(res.status).toBe(404);
  });
});
```

## Test Data

Use factory functions — not hard-coded magic values.

```typescript
// test/factories.ts
export function makeUser(overrides: Partial<User> = {}): User {
  return {
    id: crypto.randomUUID(),
    email: `user-${Date.now()}@example.com`,
    name: "Test User",
    role: "standard",
    createdAt: new Date(),
    ...overrides,
  };
}
```

## Mocking

Mock only at system boundaries:

- External HTTP APIs — use `msw` or `nock`
- Email/SMS providers — mock the provider client
- Payment processors — use sandbox environments, not mocks

Never mock internal modules, the database, or business logic.

## Coverage

- Track coverage as a signal — do not treat it as a goal
- Enforce a minimum floor in CI (recommended: 80% line coverage on core business logic)
- 100% coverage does not mean the tests are good; 60% with correct assertions is better than 100% with trivial ones
- Identify uncovered paths and ask: does this path need a test, or does the code need to be deleted?

## Guardrails

- Every test must fail for the right reason — remove `it.only` before committing
- Tests that always pass regardless of behavior are worse than no tests — validate the failure path
- Do not use `setTimeout` or `sleep` in tests — use proper async patterns or fake timers
- Each test must clean up after itself — no test should depend on another test's side effects
- Flaky tests are bugs — fix or delete them; do not skip them with `it.skip`
