---
name: kernel-react
kind: skill
tags:
  - frontend
  - react
profile: extended
description: Provides React patterns and component architecture guidance for app
  and monorepo work. Use when building React components, writing query or
  mutation hooks, managing state, composing hooks, handling async data,
  reviewing React code for correctness, or when adding code to a shared UI
  package that must stay presentational.
license: MIT
compatibility: Any React application (web or React Native).
metadata:
  author: project
  version: "1.0"
  category: Frontend
  tags:
    - react
    - components
    - hooks
    - state
    - performance
    - patterns
    - suspense
    - typescript
    - monorepo
    - package-boundaries
    - tanstack-query
    - data-fetching
    - mutations
when:
  - user is building a React component or custom hook
  - user is deciding where to put state or how to share it between components
  - user is implementing async data loading or error handling in React
  - user is reviewing React code for correctness or performance issues
  - user is working with lists, keys, or memoization
  - user is writing a query hook, mutation hook, or wiring up Suspense for data
    loading
  - user is implementing pagination, infinite scroll, or optimistic updates
  - user is adding code to a shared UI package (packages/ui or equivalent)
  - a component is importing from auth, API, or routing packages and should not
    be
applicability:
  - Use when building any React component that handles state, data, or side
    effects
  - Use when reviewing React code for anti-patterns or performance issues
  - Use when deciding on component composition or hook design
termination:
  - Component has single responsibility and correct key usage
  - State lives at the appropriate level — no derived state stored in useState
  - Async data handled via query hooks with Suspense or explicit loading states
outputs:
  - React component following single-responsibility principle
  - Custom hook with isolated, testable logic
  - Correct async data pattern (Suspense or inline loading state)
---

# React Patterns

Canonical patterns for building correct, performant React components.

## Component Design

Keep components small and single-responsibility. If a component needs more than ~150 lines, it is doing too much.

```
<Page>               ← layout and data orchestration only
  <Header />
  <UserList>         ← renders a list; handles empty/loading states
    <UserCard />     ← renders a single item; no data fetching
  </UserList>
</Page>
```

**Rules:**

- Presentational components receive data via props — no data fetching inside them
- Data-fetching components (containers) focus on fetching and pass data down
- Never define a component inside another component's render — it remounts on every render

## State Management

| State type             | Tool                                   |
| ---------------------- | -------------------------------------- |
| Server data (remote)   | TanStack Query                         |
| Shared client UI state | Zustand or Context                     |
| Local component state  | `useState`                             |
| Derived values         | Compute inline — do not store in state |

```typescript
// ✅ derive — do not store derived values in state
const fullName = `${user.firstName} ${user.lastName}`;

// ❌ storing derived state — will go stale
const [fullName, setFullName] = useState(`${user.firstName} ${user.lastName}`);
```

## useEffect Rules

`useEffect` is for synchronizing with external systems — not for reacting to state changes.

```typescript
// ✅ sync with an external system
useEffect(() => {
  const subscription = store.subscribe(callback);
  return () => subscription.unsubscribe(); // always clean up
}, [store]);

// ❌ deriving state in an effect — compute inline instead
useEffect(() => {
  setFullName(`${firstName} ${lastName}`);
}, [firstName, lastName]);
```

If you find yourself writing `useEffect` to update state when other state changes, compute the derived value directly instead.

## Custom Hooks

Extract reusable logic into custom hooks. A hook should have a single responsibility.

```typescript
// useDisclosure.ts — manages open/close state
export function useDisclosure(initial = false) {
  const [isOpen, setIsOpen] = useState(initial);
  const open = useCallback(() => setIsOpen(true), []);
  const close = useCallback(() => setIsOpen(false), []);
  const toggle = useCallback(() => setIsOpen((v) => !v), []);
  return { isOpen, open, close, toggle };
}
```

Rules:

- Hooks start with `use` — always
- A hook that fetches data should not also manage UI state
- A hook that manages form state should not also submit the form

## Async Patterns

For required data, use Suspense + ErrorBoundary:

```tsx
<ErrorBoundary fallback={<ErrorState />}>
  <Suspense fallback={<Skeleton />}>
    <UserProfile userId={id} />
  </Suspense>
</ErrorBoundary>
```

For optional or secondary data, handle loading/error inline:

```tsx
function UserAvatar({ userId }: { userId: string }) {
  const { data, isLoading, error } = useUser(userId);
  if (isLoading) return <AvatarSkeleton />;
  if (error || !data) return <DefaultAvatar />;
  return <img src={data.avatarUrl} alt={data.name} />;
}
```

## Performance

```typescript
// Memoize expensive computations
const sorted = useMemo(
  () => items.sort((a, b) => a.name.localeCompare(b.name)),
  [items]
);

// Stabilize callbacks passed to memoized children
const handleClick = useCallback((id: string) => {
  onSelect(id);
}, [onSelect]);

// Memoize components that receive stable props
const ExpensiveList = memo(function ExpensiveList({ items }: Props) {
  return <ul>{items.map(item => <li key={item.id}>{item.name}</li>)}</ul>;
});
```

Only memoize when you have measured a performance problem. Premature memoization adds complexity without benefit.

## Keys

Use stable, unique IDs as list keys — never array indices.

```tsx
// ✅ stable identity
items.map((item) => <Card key={item.id} {...item} />);

// ❌ index as key — causes incorrect reconciliation on reorder/delete
items.map((item, i) => <Card key={i} {...item} />);
```

## Error Boundaries

Every route and every async data boundary needs an `<ErrorBoundary>`. Uncaught errors crash the entire React tree.

```tsx
// Wrap at the route level
<ErrorBoundary
  fallback={({ error, resetErrorBoundary }) => (
    <ErrorPage error={error} onRetry={resetErrorBoundary} />
  )}
>
  <Route />
</ErrorBoundary>
```

## Server State

All remote data flows through the API layer — apps never import from the database package directly.

```
app component
  → query/mutation hook
    → typed API client (RPC)
      → API service
        → database
```

Use TanStack Query (or equivalent server-state library) for all remote data:

| Need                    | Hook                            |
| ----------------------- | ------------------------------- |
| Read data               | `useQuery` / `useSuspenseQuery` |
| Write data              | `useMutation`                   |
| Infinite scroll / feeds | `useInfiniteQuery`              |

**Query key rules:**

- Must be an array — never a plain string
- Must include every variable that affects the result (e.g. `["users", userId]`)
- `staleTime` must be set explicitly; the default `0` causes excessive refetches

**Mutation rule:** always invalidate or update affected query keys on `onSuccess`.

See `references/data-fetching.md` for query hook, mutation hook, suspense, pagination, optimistic update, and API contract type examples.

## Monorepo Package Boundaries

In a monorepo, `packages/ui` (or equivalent) must stay presentational and environment-agnostic. It is a shared component library that should work in any context — web, mobile, Storybook — without knowing about data sources or routing.

| Layer                     | Location             | Responsibilities                       |
| ------------------------- | -------------------- | -------------------------------------- |
| Presentational components | `packages/ui`        | Rendering, interactions, styling       |
| Container components      | `apps/`              | Data fetching, routing, business logic |
| Feature hooks             | `packages/<feature>` | Reusable domain logic                  |

**Hook location rules:**

| Hook type                             | Location                       |
| ------------------------------------- | ------------------------------ |
| Pure UI (`useHover`, `useMediaQuery`) | `packages/ui/src/hooks`        |
| Web routing (`useComposerMode`)       | `apps/<web-app>/src/hooks`     |
| Auth (`useSession`)                   | `packages/auth/src/hooks`      |
| API/RPC                               | `packages/rpc/src`             |
| Feature-specific                      | `packages/<feature>/src/hooks` |

**Checklist for shared UI package changes:**

- [ ] No imports from auth, API/RPC, or database packages
- [ ] No routing hooks (`useNavigate`, `useSearchParams`, `useRouter`)
- [ ] No direct API calls or mutation hooks
- [ ] Props accept data — components don't fetch it
- [ ] Works in Storybook without mock providers for data
- [ ] No `import.meta.env` or `process.env` access
- [ ] No `console.log` statements

See reference files for code examples, migration steps, and common violations.

## Guardrails

- Never mutate props or state directly — always produce a new value
- Never call hooks conditionally — hooks must run in the same order every render
- Never use array index as a key for lists that can be reordered or filtered
- Never define a component inside another component
- Never fetch data directly in `useEffect` — use a query hook
- Never store server state in `useState` — that is what TanStack Query is for
- Never call `fetch` directly from a component — always through the typed API client
- Never import the database package in app packages
- Never construct query keys as plain strings — use arrays
- Never use `dangerouslySetInnerHTML` with user-supplied content
- Never import from auth, API, or database packages inside `packages/ui`
- Never use routing hooks inside a shared UI package component
