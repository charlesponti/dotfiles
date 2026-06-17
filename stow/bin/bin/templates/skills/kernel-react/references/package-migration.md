# Migration Guide: Moving Business Logic Out of packages/ui

## Step-by-Step Migration

### 1. Identify what needs to move

Scan `packages/ui` for:

- [ ] Imports from auth packages (`@your-org/auth`, `useSession`, etc.)
- [ ] Imports from API/RPC packages (`@your-org/rpc`, `useMutation`, `useQuery`, etc.)
- [ ] Imports from database packages (`@your-org/db`)
- [ ] Routing hooks (`useNavigate`, `useSearchParams`, `useRouter`, etc.)
- [ ] Environment-specific code (`import.meta.env`, `process.env`)
- [ ] `console.log` / `console.error` statements

### 2. Find the right destination

| What                  | Where to move it                               |
| --------------------- | ---------------------------------------------- |
| Web routing hooks     | `apps/<web-app>/src/hooks/`                    |
| Auth hooks            | `packages/auth/src/hooks/`                     |
| API/data hooks        | `packages/rpc/src/` or `apps/<app>/src/hooks/` |
| Feature-specific data | `packages/<feature>/src/hooks/`                |

### 3. Refactor the component

Convert from internal hook usage to pure props:

```typescript
// Before: component owns its data
export function ItemCard() {
  const { data } = useItemData()        // ❌ data hook in UI
  const navigate = useNavigate()         // ❌ routing in UI
  return <div onClick={() => navigate(`/items/${data.id}`)}>{data.name}</div>
}

// After: component receives props
interface ItemCardProps {
  name: string
  onNavigate: () => void
}

export function ItemCard({ name, onNavigate }: ItemCardProps) {
  return <div onClick={onNavigate}>{name}</div>
}
```

### 4. Update the container

```typescript
// apps/<your-app>/src/components/item-card-container.tsx
import { useItemData } from '~/hooks/use-item-data'
import { useNavigate } from 'react-router'
import { ItemCard } from '@your-org/ui/item-card'

export function ItemCardContainer({ id }: { id: string }) {
  const { data } = useItemData(id)
  const navigate = useNavigate()

  return (
    <ItemCard
      name={data.name}
      onNavigate={() => navigate(`/items/${id}`)}
    />
  )
}
```

### 5. Update tests

```typescript
// Before: required mocking providers
render(
  <RouterProvider>
    <QueryProvider>
      <ItemCard />
    </QueryProvider>
  </RouterProvider>
)

// After: pure prop test
render(
  <ItemCard
    name="Test Item"
    onNavigate={vi.fn()}
  />
)
```

### 6. Validate

After refactoring:

- [ ] Run your project's import linter / import boundary checker
- [ ] Run `pnpm lint` (or your project's lint command)
- [ ] Update test mocks if component signature changed
- [ ] Verify no new console statements introduced
- [ ] Test in Storybook (should work without any provider wrappers)

## Environment Variable Access

`packages/ui` must never read environment variables directly. Accept config as props or a provider:

```typescript
// packages/ui — accept config as prop
interface ComponentProps {
  apiBaseUrl: string  // passed from container
}

// apps/<your-app> — resolve env in the container
const apiUrl =
  (typeof import.meta !== 'undefined' && import.meta.env?.VITE_API_URL) ||
  process.env.API_URL ||
  'http://localhost:3000'

<YourComponent apiBaseUrl={apiUrl} />
```

## Refactoring Checklist

**Before starting:**

- [ ] Identify all forbidden imports in the component
- [ ] Identify all routing hooks used
- [ ] Identify environment-specific code
- [ ] Find all container components that will need updates
- [ ] Check test files for mock cleanup

**After refactoring:**

- [ ] Run import linter
- [ ] Run lint
- [ ] Update tests (remove provider mocks, use props)
- [ ] Verify Storybook renders without providers
- [ ] Check no new console statements introduced
