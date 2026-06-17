---
name: kernel-react-native
kind: skill
tags:
  - mobile
  - react
profile: extended
description: Guides React Native and Expo development across UI patterns, Expo
  Router conventions, styling, navigation, performance, animations, and state
  management. Use when building React Native screens, implementing mobile
  navigation, optimizing list performance, or when users ask about mobile UI,
  animations, or Expo configuration.
license: MIT
compatibility: React Native with Expo Router and Expo SDK.
metadata:
  author: project
  version: "2.0"
  category: Mobile
  tags:
    - react-native
    - expo
    - expo-router
    - mobile
    - performance
    - animations
    - reanimated
    - lists
    - navigation
    - ios
    - apple-hig
when:
  - user is building any React Native or Expo component, screen, or feature
  - user is implementing Expo Router navigation, routes, tabs, or stacks
  - user is styling a mobile UI following Apple HIG
  - user is optimizing list, scroll, or rendering performance
  - user is implementing animations with Reanimated or gestures
  - user is working with native controls, media, storage, or device APIs
  - user is configuring native modules, fonts, or Expo plugins
  - user is structuring native dependencies in a monorepo
applicability:
  - Use for all React Native and Expo app development
  - Use when implementing any mobile UI, navigation pattern, or screen layout
  - Use when reviewing mobile code for performance, correctness, or platform
    conventions
termination:
  - Component or screen implemented following Expo Router and Apple HIG
    conventions
  - "Performance rules applied: FlashList, memoized items, stable callbacks"
  - Animations run on UI thread using transform/opacity only
  - Native navigation stack used instead of JS navigators
outputs:
  - React Native component or screen following Expo Router conventions
  - Navigation layout with correct Stack, NativeTabs, and route structure
  - Performance-optimized list implementation
  - Animation using Reanimated on GPU-friendly properties
---

React Native and Expo standards: UI patterns, Expo Router conventions, performance rules, animation, state management, and monorepo configuration.

## Toolchain

| Concern    | Tool                                                   |
| ---------- | ------------------------------------------------------ |
| Framework  | React Native + Expo                                    |
| Navigation | Expo Router                                            |
| Builds     | EAS (`eas build`, `eas submit`)                        |
| Animations | `react-native-reanimated` — never `Animated` from core |
| Gestures   | `react-native-gesture-handler`                         |
| Lists      | `FlashList` — never `FlatList` for long lists          |
| Images     | `expo-image`                                           |

Never use: React Native CLI (use Expo), `Animated` from React Native core, `FlatList` for long lists, `TouchableOpacity` (use `Pressable`).

## Running the App

**Always try Expo Go first before creating custom builds.**

Most Expo apps work in Expo Go without any custom native code. Before running `pnpm exec expo run:ios` or `pnpm exec expo run:android`:

1. Start with `pnpm exec expo start` — scan the QR code with Expo Go
2. Test thoroughly in Expo Go
3. Only create custom builds when required (see below)

### When Custom Builds Are Required

You need `pnpm exec expo run:ios/android` or `eas build` only when using:

- **Local Expo modules** (custom native code in `modules/`)
- **Apple targets** (widgets, app clips, extensions via `@bacons/apple-targets`)
- **Third-party native modules** not included in Expo Go
- **Custom native configuration** that can't be expressed in `app.json`

Expo Go supports all `expo-*` packages, Expo Router navigation, Reanimated, gesture handler, push notifications, deep links, and more. If unsure, try Expo Go first.

---

## Code Style

- Use import statements at the top of the file — no inline requires
- Use kebab-case for file names: `comment-card.tsx`
- Never use special characters in file names
- Always remove old route files when moving or restructuring navigation
- Configure `tsconfig.json` with path aliases; prefer aliases over relative imports
- Escape nested backticks and quotes carefully — unterminated strings are a common error

---

## Library Preferences

| Use                                  | Instead of                             |
| ------------------------------------ | -------------------------------------- |
| `expo-audio`                         | `expo-av` for audio                    |
| `expo-video`                         | `expo-av` for video                    |
| `expo-image` with `source="sf:name"` | `expo-symbols` or `@expo/vector-icons` |
| `react-native-safe-area-context`     | React Native's built-in `SafeAreaView` |
| `process.env.EXPO_OS`                | `Platform.OS`                          |
| `React.use`                          | `React.useContext`                     |
| `expo-image` `<Image>`               | intrinsic `<img>` element              |
| `expo-glass-effect`                  | custom blur implementations            |
| `Pressable`                          | `TouchableOpacity`                     |
| `FlashList`                          | `FlatList` for long lists              |

**Never use:** Picker, WebView, SafeAreaView, or AsyncStorage from core React Native — they have been removed. Never use `legacy expo-permissions`.

---

## Performance Rules

### Priority Order

| Priority | Category         | Impact   |
| -------- | ---------------- | -------- |
| 1        | List Performance | CRITICAL |
| 2        | Animation        | HIGH     |
| 3        | Navigation       | HIGH     |
| 4        | UI Patterns      | HIGH     |
| 5        | State Management | MEDIUM   |
| 6        | Rendering        | MEDIUM   |
| 7        | Monorepo         | MEDIUM   |
| 8        | Configuration    | LOW      |

### List Performance (CRITICAL)

- Use `FlashList` for any list that may exceed ~20 items — see `list-performance-virtualize.md`
- Memoize list item components with `React.memo` — see `list-performance-item-memo.md`
- Stabilize all callbacks with `useCallback` before passing to list items — see `list-performance-callbacks.md`
- Never create inline style objects in render — see `list-performance-inline-objects.md`
- Extract functions outside the component that don't need closures — see `list-performance-function-references.md`
- Use `expo-image` with correct size hints in list items — see `list-performance-images.md`
- Move all expensive computation outside list item render — see `list-performance-item-expensive.md`
- Use `getItemType` for lists with multiple item layouts — see `list-performance-item-types.md`

### Animation (HIGH)

- Animate only `transform` and `opacity` on the UI thread — see `animation-gpu-properties.md`
- Use `useDerivedValue` for values computed from other animated values — see `animation-derived-value.md`
- Use `Gesture.Tap()` from `react-native-gesture-handler` instead of `Pressable` for gesture-driven animations — see `animation-gesture-detector-press.md`

### Navigation (HIGH)

- Always use native stack (`createNativeStackNavigator`) and native tabs over JS navigators — see `navigation-native-navigators.md`

---

## Responsiveness

- Always wrap the root component in a `ScrollView` for responsiveness
- Use `<ScrollView contentInsetAdjustmentBehavior="automatic" />` instead of `<SafeAreaView>` for smarter safe area insets
- Apply `contentInsetAdjustmentBehavior="automatic"` to `FlatList` and `SectionList` as well
- Use flexbox instead of the `Dimensions` API
- Always prefer `useWindowDimensions` over `Dimensions.get()` to measure screen size

---

## Styling

Follow Apple Human Interface Guidelines.

- Prefer flex gap over margin and padding
- Prefer padding over margin where possible
- Always account for safe area — with stack headers, tabs, or `contentInsetAdjustmentBehavior="automatic"`
- Ensure both top and bottom safe area insets are accounted for
- Use inline styles or `StyleSheet.create` — CSS and Tailwind are not supported
- Add entering and exiting animations for state changes
- Use `{ borderCurve: 'continuous' }` for rounded corners unless creating a capsule shape
- Always use a navigation stack title instead of a custom text element on the page
- Use `contentContainerStyle` padding on `ScrollView` — not padding on the `ScrollView` itself

### Shadows

Use CSS `boxShadow` style prop. Never use legacy React Native `shadow*` props or `elevation`.

```tsx
<View style={{ boxShadow: "0 1px 2px rgba(0, 0, 0, 0.05)" }} />
```

### Text

- Add `selectable` prop to every `<Text>` displaying important data or error messages
- Use `{ fontVariant: 'tabular-nums' }` for counters and numeric values

---

## Behavior

- Use `expo-haptics` conditionally on iOS for delightful feedback
- Use built-in haptic views like `<Switch />` and `@react-native-community/datetimepicker`
- When a route belongs to a Stack, its first child should almost always be a `ScrollView` with `contentInsetAdjustmentBehavior="automatic"`
- Prefer `headerSearchBarOptions` in `Stack.Screen` options over a custom search bar
- Use `<Text selectable />` for data that users may want to copy
- Format large numbers as `1.4M` or `38k`
- Never use intrinsic elements like `<img>` or `<div>` unless inside a WebView or Expo DOM component

---

## Routes

See `references/expo-route-structure.md` for detailed conventions.

- Routes belong in the `app/` directory
- Never co-locate components, types, or utilities in `app/` — this is an anti-pattern
- Always ensure there is a route matching `"/"`, even if inside a group

---

## Navigation

See `references/navigation.md` for link, stack, modal, sheet, and route-structure conventions.

---

## State Management

- Minimize the number of state subscriptions per component — see `react-state-minimize.md`
- Use dispatcher pattern for callbacks passed to child components — see `react-state-dispatcher.md`
- Always show a fallback state on first render before data loads — see `react-state-fallback.md`
- Do not store scroll position in component state — see `scroll-position-no-state.md`
- Maintain a single source of truth for derived state — see `state-ground-truth.md`

---

## Monorepo Configuration

- Keep all native dependencies (`react-native-*`, Expo modules) in the app package, not shared packages — see `monorepo-native-deps-in-app.md`
- Enforce single versions of all React Native dependencies across the monorepo — see `monorepo-single-dependency-versions.md`
- Use config plugins for custom fonts rather than manual native linking — see `fonts-config-plugin.md`

---

## Performance Optimization

See `references/performance.md` for optimization guidance, common fixes, and problem-to-reference mappings.

---

_Performance optimization content based on "The Ultimate Guide to React Native Optimization" by Callstack._
