# Common Violations

## 1. Importing Auth Hooks in UI Components

```typescript
// ❌ Wrong — auth logic in packages/ui
import { useSession } from "@your-org/auth";
import { useUser } from "@your-org/auth";

// ✅ Correct — pass auth data as props
interface UserAvatarProps {
  userId: string;
  displayName: string;
  avatarUrl?: string;
}
```

**Fix**: Move auth hook to the container component in `apps/` and pass the data as props.

## 2. Using Navigation Hooks

```typescript
// ❌ Wrong — routing in packages/ui
import { useNavigate } from "react-router";
import { useRouter } from "next/router";

// ✅ Correct — accept a callback prop
interface ListItemProps {
  label: string;
  onPress: () => void; // navigation is the container's responsibility
}
```

**Fix**: Replace navigation logic with an `onPress` / `onClick` callback prop.

## 3. Direct API Calls or Query Hooks

```typescript
// ❌ Wrong — data fetching in packages/ui
import { useQuery } from "@tanstack/react-query";
import { useMutation } from "@your-org/rpc";

const { data } = useQuery({ queryKey: ["items"], queryFn: fetchItems });

// ✅ Correct — accept typed data as props
interface ItemListProps {
  items: Item[];
  isLoading: boolean;
  onRefresh: () => void;
}
```

**Fix**: Move query/mutation hooks to the container and pass data and callbacks as props.

## 4. Environment-Specific Code

```typescript
// ❌ Wrong — env access in packages/ui
const apiUrl = import.meta.env.VITE_API_URL;
const isDev = process.env.NODE_ENV === "development";

// ✅ Correct — accept config as prop or via provider
interface ClientProps {
  apiBaseUrl: string;
}
```

**Fix**: Resolve environment variables in the container (`apps/`) and pass the resolved values as props.

## 5. Console Statements

```typescript
// ❌ Wrong — logging in UI components
} catch (error) {
  console.error('Failed:', error)  // leaks implementation detail
}

// ✅ Correct — let the caller handle errors
} catch {
  // Error state is surfaced via the error prop or callback
}

// In containers/routes where logging is appropriate:
import { logger } from '@your-org/utils/logger'
} catch (error) {
  logger.error('Upload failed', error instanceof Error ? error : undefined)
}
```

## When to Break These Rules

Rare exceptions that require explicit team approval:

- **Browser API wrappers** — hooks like `useMediaQuery`, `useLocalStorage`, `useIntersectionObserver` are UI-layer utilities, acceptable in `packages/ui`
- **Design system tokens that need runtime values** — e.g., reading `prefers-color-scheme` via `window.matchMedia`
- **Truly cross-cutting feature flags** — only when the flag controls visual rendering, not behavior or data fetching

Document any exception with a comment explaining why it was approved.
