# Data Fetching Patterns

## Query Hook

```typescript
import { useQuery } from "@tanstack/react-query";
import { apiClient } from "@/lib/api-client";

export function useUser(userId: string) {
  return useQuery({
    queryKey: ["users", userId],
    queryFn: () => apiClient.users[":id"].$get({ param: { id: userId } }).then((r) => r.json()),
    staleTime: 30_000,
    enabled: !!userId,
  });
}
```

## Mutation Hook

```typescript
import { useMutation, useQueryClient } from "@tanstack/react-query";

export function useUpdateUser() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: UpdateUserInput) =>
      apiClient.users[":id"].$patch({ param: { id: data.id }, json: data }).then((r) => r.json()),
    onSuccess: (updated) => {
      queryClient.invalidateQueries({ queryKey: ["users", updated.data.id] });
      queryClient.invalidateQueries({ queryKey: ["users"] });
    },
    onError: (error) => {
      // Propagate to UI — do not swallow errors
      console.error("Update failed:", error);
    },
  });
}
```

## Suspense Pattern

Use `useSuspenseQuery` for data a component absolutely requires. Wrap in `<Suspense>` and `<ErrorBoundary>`.

```tsx
import { useSuspenseQuery } from "@tanstack/react-query";

function UserProfile({ userId }: { userId: string }) {
  const { data } = useSuspenseQuery({
    queryKey: ["users", userId],
    queryFn: () => apiClient.users[":id"].$get({ param: { id: userId } }).then((r) => r.json()),
  });
  return <div>{data.data.name}</div>;
}

// Usage:
<ErrorBoundary fallback={<ErrorMessage />}>
  <Suspense fallback={<Skeleton />}>
    <UserProfile userId={id} />
  </Suspense>
</ErrorBoundary>;
```

## Pagination

| Pattern                        | Use for                                    |
| ------------------------------ | ------------------------------------------ |
| `useInfiniteQuery` with cursor | Feeds, timelines, infinite scroll          |
| `useQuery` with `page` param   | Tables, paginated lists with page controls |

```typescript
export function useUserFeed() {
  return useInfiniteQuery({
    queryKey: ["feed"],
    queryFn: ({ pageParam }) =>
      apiClient.feed.$get({ query: { cursor: pageParam } }).then((r) => r.json()),
    getNextPageParam: (lastPage) => lastPage.data.nextCursor,
    initialPageParam: undefined,
  });
}
```

## Optimistic Updates

Apply only when the rollback path is clear.

```typescript
onMutate: async (newData) => {
  await queryClient.cancelQueries({ queryKey: ["items"] });
  const previous = queryClient.getQueryData(["items"]);
  queryClient.setQueryData(["items"], (old) => optimisticallyUpdate(old, newData));
  return { previous };
},
onError: (_err, _vars, context) => {
  queryClient.setQueryData(["items"], context?.previous);
},
```

## API Contract Types

Import types from the API package. Never redeclare shapes that already exist in the contract.

```typescript
// ✅ correct — import from API contract
import type { User } from "@your-org/api/types";

// ❌ wrong — redeclaring a type that already exists
type User = { id: string; email: string; name: string };
```

Derive query result types from the RPC client type, not from hand-written interfaces.
