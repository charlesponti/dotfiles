# Design System — Motion

## Mandate

All interactive animations on web MUST use GSAP via the project's canonical sequences file
(typically `packages/ui/src/lib/gsap/sequences.ts`).

CSS keyframe animations (`animations.css`) are reserved EXCLUSIVELY for Radix UI (or equivalent
headless UI library) component enter/exit transitions via data-attribute selectors.

Do not add new `@keyframes` for product surfaces under any circumstances.

On mobile: react-native-reanimated worklets. Never the Animated API from React Native core.

---

## Why GSAP

- Frame-perfect multi-element sequencing via timelines — CSS cannot coordinate sequences reliably
- Imperative control (kill, reverse, pause) required for gesture-driven interfaces
- `power*` easing family is physically correct in ways CSS cubic-bezier approximations are not
- `reducedMotion()` guard enforced centrally — CSS `prefers-reduced-motion` requires per-rule media queries that are easy to miss
- Single animation authority means consistent timing, no competing CSS + JS animations

---

## Canonical sequences

Never reimplement these locally. Import from the project's sequences file.

| Sequence             | Function signature                             | When                                       |
| -------------------- | ---------------------------------------------- | ------------------------------------------ |
| Component arrives    | `playFocusExpand(el, onComplete?)`             | Sheet open, panel reveal, form mount       |
| Component leaves     | `playFocusCollapse(el, onComplete?)`           | Sheet dismiss, form close                  |
| In-place mode switch | `playContextSwitch(el or el[])`                | Label/content swap on context change       |
| Submit confirmation  | `playSubmitPulse(btnEl, inputEl, onComplete?)` | Form submit before clear                   |
| List row arrives     | `playEnterRow(el, delay?)`                     | New item in feed, sidebar, or list         |
| List row leaves      | `playExitRow(el, onComplete?)`                 | Item removal                               |
| Loading skeleton     | `playShimmer(el)` → returns tween              | Skeleton states; `.kill()` on data resolve |

---

## Timing constants

Never hardcode duration values. Use the tokens from `motion.ts`.

| Constant           | GSAP value | CSS equivalent                |
| ------------------ | ---------- | ----------------------------- |
| durations.enter    | 0.15       | 150ms                         |
| durations.exit     | 0.12       | 120ms                         |
| durations.standard | 0.12       | 120ms                         |
| durations.breezy   | 1.8        | 1800ms (loop/wave animations) |

---

## Easing

| Role                  | GSAP                | CSS cubic-bezier               |
| --------------------- | ------------------- | ------------------------------ |
| Arriving elements     | power2.out          | cubic-bezier(0.0, 0.0, 0.2, 1) |
| Departing elements    | power2.in           | cubic-bezier(0.4, 0.0, 1, 1)   |
| In-place transitions  | power2.inOut        | cubic-bezier(0.4, 0, 0.2, 1)   |
| Gesture snap (spring) | elastic.out(1, 0.5) | — (not achievable in CSS)      |

Spring/elastic easing only for physical gesture completion (swipe snap, drag release).
Use sparingly — maximum one elastic animation per user interaction.

---

## Translate distances

| Direction      | Enter             | Exit              |
| -------------- | ----------------- | ----------------- |
| Y (vertical)   | 6px from below    | 4px upward        |
| X (horizontal) | 6px from the side | 4px toward origin |

Always use transform — never animate top/left/right/bottom.

---

## Reduced motion

Every GSAP sequence must check `reducedMotion()` before animating.
If true: `gsap.set()` to final state immediately, call `onComplete()` if provided.

The canonical sequences handle this automatically when used correctly.
Never write a custom GSAP call without implementing this guard.
Never use CSS animations for product surfaces where the reduced motion handling would be bypassed.

---

## Stagger pattern

```ts
elements.forEach((el, i) => playEnterRow(el, i * 0.04));
```

Maximum cascade: 5 items × 40ms = 200ms total.
Elements beyond the visible fold enter without delay (do not stagger off-screen elements).

Sidebar stagger for new items: GSAP fromTo `x: -6 → 0, opacity: 0 → 1, duration: 0.15, stagger: 0.03`, on first 5 new items only.

---

## Animation decision table

| Case                                            | Tool                                 |
| ----------------------------------------------- | ------------------------------------ |
| Enter/exit, context switches, submit pulse      | GSAP (project sequences file)        |
| Hover background, focus ring, color transitions | CSS `transition-colors duration-150` |
| List row stagger on data load                   | GSAP fromTo                          |
| Mobile swipe snap                               | GSAP (local, not shared sequences)   |

`prefers-reduced-motion`: always guard GSAP animations. CSS transitions are suppressed by the global `transition-duration: 0.01ms !important` rule in the reduced-motion media query.

---

## Forbidden animation targets

Never animate these CSS properties — they trigger layout recalculation:

- width, height
- top, left, right, bottom
- margin, padding
- box-shadow (animate a pseudo-element's opacity instead)

Always animate: transform (translate, scale, rotate), opacity.

---

## What CSS animation IS permitted for

Only Radix UI (or equivalent headless component library) component state transitions
via `data-[state=open/closed]` attribute selectors. Examples:

- Dialog open/close
- Popover open/close
- DropdownMenu open/close
- Tooltip enter/exit
- Sheet slide in/out
- Accordion expand/collapse

---

## Mobile animation (React Native)

Use react-native-reanimated exclusively:

- `useSharedValue` + `useAnimatedStyle` for value-driven animations
- `withTiming` (equivalent to GSAP tween) with `Easing.out(Easing.quad)`
- `withSpring` for gesture snap/release
- `useReducedMotion()` hook — mirror the web `reducedMotion()` guard
- `runOnJS()` when callbacks must execute on the JS thread

Never use:

- `Animated` from react-native
- `LayoutAnimation`
- CSS transitions or keyframes in React Native

### Mobile gesture thresholds

| Gesture                  | Threshold                                       |
| ------------------------ | ----------------------------------------------- |
| Swipe to dismiss (sheet) | velocity > 500 px/s OR distance > 30% of height |
| Swipe to navigate        | velocity > 300 px/s AND distance > 60px         |
| Long press               | 500ms                                           |
| Double tap window        | 300ms between taps                              |

---

## Route transitions

Web: No full-page route transitions by default. Content fades via `playFocusExpand` on mount.
Do not animate the URL bar, scroll position, or layout shell on route change.
Only the content region animates — sidebar and header are static.

Mobile: Use react-navigation's built-in slide transition (iOS-native push).
Do not override the platform transition with a custom one unless explicitly required.

---

## Performance targets

- 60fps minimum on all animations
- No animation may block the main thread for more than 8ms
- GSAP runs on RAF — do not wrap GSAP calls in `setTimeout` or `setInterval`
- Kill all active tweens on component unmount (return cleanup from `useEffect`)
- `playShimmer` returns a tween — always `.kill()` it when loading resolves
