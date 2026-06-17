# Navigation

## Link

```tsx
import { Link } from 'expo-router';

<Link href="/path" />

// With custom component
<Link href="/path" asChild>
  <Pressable>...</Pressable>
</Link>
```

Always consider adding `<Link.Preview>` to follow iOS conventions. Add context menus and previews frequently.

## Stack

- Always use `_layout.tsx` files to define stacks
- Use `Stack` from `'expo-router/stack'` for native navigation stacks
- Set the page title in `Stack.Screen` options, not with a custom `<Text>` element

## Context Menus

```tsx
<Link href="/settings" asChild>
  <Link.Trigger>
    <Pressable>
      <Card />
    </Pressable>
  </Link.Trigger>
  <Link.Menu>
    <Link.MenuAction title="Share" icon="square.and.arrow.up" onPress={handleShare} />
    <Link.MenuAction title="Delete" icon="trash" destructive onPress={handleDelete} />
  </Link.Menu>
</Link>
```

## Modal and Sheet

```tsx
// Modal
<Stack.Screen name="modal" options={{ presentation: "modal" }} />

// Form sheet with detents
<Stack.Screen
  name="sheet"
  options={{
    presentation: "formSheet",
    sheetGrabberVisible: true,
    sheetAllowedDetents: [0.5, 1.0],
    contentStyle: { backgroundColor: "transparent" }, // liquid glass on iOS 26+
  }}
/>
```

## Common Route Structure

```
app/
  _layout.tsx               — <NativeTabs />
  (index,search)/
    _layout.tsx             — <Stack />
    index.tsx               — Main list
    search.tsx              — Search view
```

```tsx
// app/_layout.tsx
import { NativeTabs, Icon, Label } from "expo-router/unstable-native-tabs";

export default function Layout() {
  return (
    <NativeTabs>
      <NativeTabs.Trigger name="(index)">
        <Icon sf="list.dash" />
        <Label>Items</Label>
      </NativeTabs.Trigger>
      <NativeTabs.Trigger name="(search)" role="search" />
    </NativeTabs>
  );
}
```
