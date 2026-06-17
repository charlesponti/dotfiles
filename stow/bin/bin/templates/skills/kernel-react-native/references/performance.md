# Performance Optimization

This guidance covers performance optimization for React Native applications.

## When to Apply

Reference these guidelines when:

- Debugging slow or janky UI or animations
- Investigating memory leaks in JS or native code
- Optimizing app startup time (TTI)
- Reducing bundle or app size
- Writing native modules (Turbo Modules)
- Profiling React Native performance
- Reviewing React Native code for performance

## Priority Order

| Priority | Category           | Impact      |
| -------- | ------------------ | ----------- |
| 1        | List Performance   | CRITICAL    |
| 2        | Bundle Size        | CRITICAL    |
| 3        | FPS & Re-renders   | CRITICAL    |
| 4        | TTI Optimization   | HIGH        |
| 5        | Native Performance | HIGH        |
| 6        | Memory Management  | MEDIUM-HIGH |
| 7        | Animations         | MEDIUM      |

## Quick Reference

**Profile first:**

```bash
# Open React Native DevTools
# Press 'j' in Metro, or shake device -> "Open DevTools"
```

**Common fixes for slow or janky UI:**

- Replace ScrollView with FlatList or FlashList for lists
- Use React Compiler for automatic memoization
- Use atomic state (Jotai or Zustand) to reduce re-renders
- Use `useDeferredValue` for expensive computations

**Common fixes for bundle size:**

- Avoid barrel imports; import directly from source
- Remove unnecessary Intl polyfills; Hermes has native support
- Enable tree shaking in Expo SDK 52+ or Re.Pack
- Enable R8 for Android native code shrinking

**Common fixes for TTI:**

- Disable JS bundle compression on Android to enable Hermes mmap
- Use native navigation (`react-native-screens`)
- Preload commonly used expensive screens before navigating to them

**Common fixes for native performance:**

- Use background threads for heavy native work
- Prefer async over sync Turbo Module methods
- Use C++ for cross-platform performance-critical code

## Performance References

| Category         | Files |
| ---------------- | ----- |
| JavaScript/React | `js-lists-flatlist-flashlist.md`, `js-profile-react.md`, `js-measure-fps.md`, `js-memory-leaks.md`, `js-atomic-state.md`, `js-concurrent-react.md`, `js-react-compiler.md`, `js-animations-reanimated.md`, `js-uncontrolled-components.md` |
| Native           | `native-turbo-modules.md`, `native-sdks-over-polyfills.md`, `native-measure-tti.md`, `native-threading-model.md`, `native-profiling.md`, `native-platform-setup.md`, `native-view-flattening.md`, `native-memory-patterns.md`, `native-memory-leaks.md`, `native-android-16kb-alignment.md` |
| Bundling         | `bundle-barrel-exports.md`, `bundle-analyze-js.md`, `bundle-tree-shaking.md`, `bundle-analyze-app.md`, `bundle-r8-android.md`, `bundle-hermes-mmap.md`, `bundle-native-assets.md`, `bundle-library-size.md`, `bundle-code-splitting.md` |

## Problem -> Start Here

| Problem | Start With |
| ------- | ---------- |
| App feels slow or janky | `js-measure-fps.md` -> `js-profile-react.md` |
| Too many re-renders | `js-profile-react.md` -> `js-react-compiler.md` |
| Slow startup (TTI) | `native-measure-tti.md` -> `bundle-analyze-js.md` |
| Large app size | `bundle-analyze-app.md` -> `bundle-r8-android.md` |
| Memory growing | `js-memory-leaks.md` or `native-memory-leaks.md` |
| Animation drops frames | `js-animations-reanimated.md` |
| List scroll jank | `js-lists-flatlist-flashlist.md` |
| TextInput lag | `js-uncontrolled-components.md` |
| Native module slow | `native-turbo-modules.md` -> `native-threading-model.md` |
| Native library alignment issue | `native-android-16kb-alignment.md` |
