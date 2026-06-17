# Design System — Patterns

## Responsive behaviour

Mobile-first. All base styles are mobile. Never style down with max-width queries.

### Layout adaptations by breakpoint

| Component  | Mobile (base)                        | md (768px+)                   | lg (1024px+)                           |
| ---------- | ------------------------------------ | ----------------------------- | -------------------------------------- |
| Sidebar    | Hidden, accessible via drawer        | Hidden, accessible via drawer | Visible, 240px fixed                   |
| Feed       | Full width                           | Full width                    | Remaining width after sidebar          |
| Modal      | Full-width sheet from bottom         | Centred dialog, max 480px     | Same                                   |
| Form       | Full-width fields, full-width submit | Same                          | Max-width fields, right-aligned submit |
| Navigation | Bottom tab bar                       | Top nav or sidebar            | Sidebar                                |
| Toast      | Bottom-centre, calc(100vw - 32px)    | Bottom-right, 320px           | Same                                   |
| HyperForm  | Pinned to bottom, full width         | Max width 768px, centred      | Same                                   |

### Responsive rules

- Never hide content behind a breakpoint without an accessible alternative
- Touch targets remain 44px minimum at all breakpoints
- Sidebar drawer on mobile uses Sheet component with slide animation
- Font sizes do not change across breakpoints (use display-1 `clamp` for the one fluid size)

---

## Overlay stacking

### Rules

- Only one modal or sheet open at a time. Opening a second closes the first.
- Only one command palette open at a time.
- Toasts render above all modals — they portal to `document.body` at z-toast (400).
- Dropdowns and tooltips triggered from inside a modal must also portal to `document.body`.
- Backdrop (bg-overlay) renders at z-overlay (200), behind the modal at z-modal (300).

### Focus management

- On open: focus moves to the first focusable element, or the close button if no fields.
- On close: focus returns to the element that triggered the overlay.
- Tab key: cycles through focusable elements within the overlay only (focus trap).
- Escape key: closes the overlay.
- Never allow focus to escape an open modal to the page beneath.
- `aria-modal="true"` on all overlays.

### Z-index reference

| Layer     | Token      | Value |
| --------- | ---------- | ----- |
| Page      | z-base     | 0     |
| Sticky UI | z-raised   | 10    |
| Dropdowns | z-dropdown | 100   |
| Backdrop  | z-overlay  | 200   |
| Modals    | z-modal    | 300   |
| Toasts    | z-toast    | 400   |

---

## Copy and writing style

### Button labels

- Verb-first, sentence case: "Save note", "Start chat", "Delete account"
- Never: "Save Note", "SAVE", "Submit", "OK", "Yes", "No"
- Destructive actions: name the action. "Delete note" not "Confirm"
- Loading state: progressive verb. "Saving…" not "Loading…"
- Never ellipsis unless the action opens a dialog for more information

### Placeholder text

- Describe the action, not the field: "Write a note or start a chat…"
- Never use placeholder as label — always have an explicit label
- Never: "Enter your email address", "Type here"

### Error messages

- Plain language, tell the user what to do
- "Name can't be empty" not "Required field"
- "Email looks incorrect — check for typos" not "Invalid email format"
- Never expose technical error codes or stack traces to users
- Never blame the user: "Something went wrong" not "You entered an invalid value"

### Empty state copy

- Headline: active voice, present tense. "No notes yet"
- Body: one sentence, tells the user what to do. "Create your first note using the input below."
- Never: "There are no items to display", "Nothing found"

### Confirmation dialogs

- Title: "Delete this note?" not "Are you sure?"
- Destructive button: "Delete note" (matches the title action)
- Cancel button: "Cancel" (not "No" or "Go back")

### General rules

- Sentence case everywhere except proper nouns and product names
- Never use jargon or technical terms in user-facing copy
- Avoid abbreviations unless universally understood (e.g. "min" for minute is fine)
- Keep microcopy under 80 characters where possible

---

## Image handling

- Always provide explicit width and height attributes — prevents CLS
- Always provide alt text for non-decorative images (`aria-hidden="true"` for decorative)
- Lazy load images below the fold (`loading="lazy"`)
- Use `aspect-ratio` in CSS to reserve space before the image loads
- For user-uploaded images: enforce max dimensions on upload, not just on display
- Fallback: bg-surface background with an icon placeholder at the same dimensions
- Never use images for text content
- Optimise: WebP format preferred, AVIF where browser support allows

---

## Scrollbars

Web custom scrollbar (webkit only, graceful degradation):

- Width: 6px
- Track: transparent
- Thumb: `var(--color-border-default)`
- Thumb hover: `var(--color-border-strong)`
- Radius: 3px

Never hide scrollbars from elements that can overflow — users need to know content is scrollable.
Use `overflow: auto` not `overflow: scroll` (avoids showing scrollbar when content fits).
Scroll containers: always set a `max-height` or `height`, never let the browser guess.

### Scrollbar-induced layout shift

- Use `scrollbar-gutter: stable` on the root element to prevent layout shift when scrollbars appear
- On web, account for 6px scrollbar width in page max-width calculations

---

## Cursor rules

| Element                        | Cursor                   |
| ------------------------------ | ------------------------ |
| Clickable (button, link, card) | pointer                  |
| Disabled (any element)         | not-allowed              |
| Text input, textarea           | text                     |
| Draggable element              | grab                     |
| Dragging (active drag)         | grabbing                 |
| Resize handle                  | col-resize or row-resize |
| Default (non-interactive)      | default                  |

Never set `cursor: pointer` on non-interactive elements.
Never remove cursor feedback from disabled elements — users need to know why they can't interact.

---

## Selection styles

```css
::selection {
  background: var(--color-accent-subtle); /* accent at 12% opacity */
  color: inherit;
}
```

Uses the accent-subtle token so selection color matches the warm amber palette.

---

## Gesture patterns (mobile)

| Gesture         | Component  | Behaviour                                              |
| --------------- | ---------- | ------------------------------------------------------ |
| Swipe down      | Sheet      | Dismiss if velocity > 500px/s or distance > 30% height |
| Swipe left      | List row   | Reveal destructive action                              |
| Swipe right     | Navigation | Back (iOS native, do not intercept)                    |
| Long press      | List row   | Context menu                                           |
| Pull to refresh | Feed       | Trigger refetch, show activity indicator               |
| Pinch           | Image      | Zoom (only on image views, not general content)        |

Never intercept the iOS back swipe gesture.
Swipe-to-delete: always require a tap to confirm — never delete on swipe release alone.
Haptic feedback on destructive confirmations (react-native's HapticFeedback or Expo Haptics).

---

## Focus management — detailed rules

- Focus ring: `outline: 2px solid var(--color-ring); outline-offset: 2px; border-radius: inherit`. `--color-ring` is warm gray (stone-500 light / stone-400 dark), never accent. Never suppress without replacement.
- Only `:focus-visible` shows the ring (hides it for mouse users, shows for keyboard).
- Tab order: logical DOM order. Never use `tabIndex > 0` to create artificial tab order.
- Skip link: "Skip to main content" as the first focusable element on every page.
- After route change: focus moves to the page `h1` or the main content landmark.
- After async content loads: do not move focus unless the user triggered the load.
- Combobox/autocomplete: use `aria-activedescendant` pattern, not `tabIndex` on options.
- List rows: use `transition-colors duration-150` on the `<li>`, not on child links individually. Use `focus-within` on the `<li>` to cover keyboard navigation into any child.

---

## Sidebar navigation pattern

- All notes + chats in a single unified `InboxStreamItem[]` feed, sorted `updatedAt` DESC.
- Filter pills (All / Notes / Chats): client-side only — no re-fetch.
- Search: client-side title filter — no re-fetch.
- GSAP stagger on new items: `x: -6 → 0, opacity: 0 → 1, duration: 0.15, stagger: 0.03` on first 5.
- Row icons: `FileText` for notes, `MessageSquare` for chats — both `size-3.5 opacity-50`.
- Overflow (···) menu: visible by default at `text-sidebar-foreground/40`, strengthens to full opacity on row hover/focus and button hover — never hide the action entirely.

### Hover/focus states on list rows

```tsx
// Active row
"bg-sidebar-accent/60";

// Hover / focus-within row (on the <li>)
"hover:bg-sidebar-accent/40 focus-within:bg-sidebar-accent/40 transition-colors duration-150";
```

Active state (/60) is stronger than hover (/40) to clearly indicate selection.
Icon/button children add `transition-colors duration-150` to stay in sync with the row.
Hover may refine emphasis, but must never be the only way to discover or access a control.

---

## Route simplification pattern

When a route's content is fully covered by the sidebar, the route becomes a redirect or empty canvas:

```tsx
// /notes → redirect since sidebar handles all navigation
export default function NotesPage() {
  return <Navigate to="/home" replace />;
}

// /home → empty canvas; sidebar + composer (in layout) are sufficient
export default function FocusView() {
  return <div className="h-dvh bg-background" />;
}
```

---

## Dark mode patterns

### Implementation

- Color mode is fixed to `data-theme="dark"` on `<html>`.
- All color tokens resolve via CSS custom properties for the dark theme.
- Never use Tailwind `dark:` variants for colors — use the dark tokens directly.
- Avoid theme variants for non-color properties unless they are required for a specific implementation detail.

### Visual adjustments in dark mode

- Borders carry more structural weight than shadows. Add `border-subtle` to elevated surfaces that rely only on shadow.
- Accent color (`#D4A574`) remains the same — it naturally reads warmer against dark backgrounds.
- Never invert colors (e.g., white → black) — use the defined dark mode token.
- Images: consider `brightness(0.9)` filter on user-uploaded images to reduce glare in dark mode.
- Elevated surfaces in dark mode get progressively lighter (`#0a0a0a` → `#141414` → `#1c1c1c`), not darker.

---

## Performance patterns

### List rendering

- Virtualise any list > 50 items: `react-window` (`FixedSizeList` or `VariableSizeList`) on web, `FlashList` on mobile
- Always provide a `getItemKey` function — never rely on array index as key
- `React.memo` on row components with a custom `areEqual` comparator

### Code splitting

- Route-level: `React.lazy` + `Suspense` on every route
- Feature-level: dynamic import for heavy features (chart libraries, markdown editors, rich text)
- Never load a feature's code until the user navigates to it

### Image loading

- Intersection Observer for lazy loading (or `loading="lazy"` on img)
- Show skeleton at the image's final dimensions while loading
- `playShimmer` on the skeleton, kill on load event

### Query patterns

- `useInfiniteQuery` for paginated feeds with IntersectionObserver sentinel
- Optimistic updates for note create/edit — update cache before the API call resolves
- Stale time: 30 seconds for feed queries, 5 minutes for detail queries

### Bundle rules

- Named imports only from all libraries — no namespace imports (`import * as`)
- Never import lodash — use native array/object/string methods
- Audit imports: if a library adds > 20kb gzipped, evaluate a lighter alternative
