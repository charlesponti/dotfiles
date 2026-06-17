# Presentational Component Patterns

## Good: Presentational Component

```typescript
// packages/ui/src/components/composer/composer.tsx
interface ComposerProps {
  mode: 'insert' | 'update'
  itemId?: string
  onSubmit: (data: ComposerData) => void
  onCancel?: () => void
  initialValue?: string
}

export function Composer({ mode, itemId, onSubmit, onCancel, initialValue }: ComposerProps) {
  // Pure UI logic only
  const [content, setContent] = useState(initialValue ?? '')

  return (
    <form onSubmit={() => onSubmit({ content, itemId })}>
      {/* ... */}
    </form>
  )
}
```

## Bad: Component with Business Logic

```typescript
// ❌ Wrong — this belongs in apps/<your-app>/components/
const Composer = () => {
  const { mode, itemId } = useComposerMode(); // ❌ routing hook
  const navigate = useNavigate(); // ❌ routing
  const { mutate } = useCreateItem(); // ❌ API call

  const handleSubmit = async (data) => {
    await mutate(data); // ❌ business logic
    navigate("/items"); // ❌ navigation
  };
};
```

## Container → Presentational Split

### Container (in apps/)

```typescript
// apps/<your-app>/src/layout.tsx
import { useComposerMode } from '~/hooks/use-composer-mode'
import { Composer } from '@your-org/ui/composer'

export function Layout() {
  const composerMode = useComposerMode() // computes mode from URL or state

  return (
    <Composer
      {...composerMode}
      onSubmit={handleSubmit}
    />
  )
}
```

### Presentational (in packages/ui)

```typescript
// packages/ui/src/components/composer/composer.tsx
interface ComposerProps {
  mode: "insert" | "update";
  itemId?: string;
  // ... other props
}

export function Composer({ mode, itemId }: ComposerProps) {
  // Render based on props only — no routing or data logic
}
```

## Testing Presentational Components

UI components in `packages/ui` should be testable without mocking router, API, or auth providers:

```typescript
// ✅ Good — pure props
render(<Composer mode="insert" onSubmit={mockSubmit} />)

// ❌ Wrong — requires complex provider mocks
render(
  <RouterProvider>
    <QueryClientProvider>
      <Composer />
    </QueryClientProvider>
  </RouterProvider>
)
```

## Handling Optional Props with exactOptionalPropertyTypes

When using `exactOptionalPropertyTypes: true` in tsconfig:

```typescript
// ❌ Wrong — can't pass undefined explicitly
interface Props {
  data?: string
}

// ✅ Correct
interface Props {
  data?: string | undefined
}

// In containers: pass explicit undefined fallback from nullable query data
return <Component data={data ?? undefined} />
```

## Mobile/Web Component Separation

Mobile and web use incompatible rendering primitives — do not try to consolidate.
Instead, extract shared business logic:

```typescript
// Shared logic (packages/ui or feature package)
export function computeItemActions(item: Item) {
  return {
    canEdit: item.isOwner && !item.isDeleted,
    canDelete: item.isOwner,
    canCopy: item.content.length > 0,
  }
}

// Web component uses React DOM
export function ItemCard(props: ItemCardProps) { ... }

// Mobile component uses React Native
export function ItemCardMobile(props: ItemCardProps) { ... }
```
