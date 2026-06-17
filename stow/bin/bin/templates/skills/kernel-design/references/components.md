# Design System — Component Specifications

All components use tokens from `foundations.md`. Never hardcode values. All colors resolve via dark-mode CSS custom properties.

## Button

| Variant     | Background  | Text           | Border             | Radius   | Min height | Padding X    |
| ----------- | ----------- | -------------- | ------------------ | -------- | ---------- | ------------ |
| Primary     | accent      | white          | none               | md (8px) | 40px       | 16px         |
| Secondary   | bg-surface  | text-primary   | 1px border-default | md       | 40px       | 16px         |
| Destructive | destructive | white          | none               | md       | 40px       | 16px         |
| Ghost       | transparent | text-secondary | none               | md       | 36px       | 12px         |
| Icon        | transparent | text-secondary | none               | sm (4px) | 36px       | 8px (square) |

Touch target minimum: 44px × 44px. Use padding to expand hit area invisibly.

States:

- Hover: CSS `transition-colors duration-150` — no border-color change (border stays static). Primary darkens to accent-hover. Secondary shifts to emphasis.faint overlay.
- Focus-visible: `outline: 2px solid var(--color-ring); outline-offset: 2px; border-radius: inherit`
- Active/pressed: GSAP `scale(0.97)` on pointerdown, reversed on pointerup
- Disabled primary: `bg-bg-surface text-text-tertiary` (muted surface, not filled foreground)
- Disabled other: `opacity: 0.4; cursor: not-allowed; pointer-events: none` — never change color
- Loading: spinner replaces label, button remains at same dimensions, opacity 0.7

Copy rules:

- Verb-first, sentence case. "Save note" not "Save Note"
- Destructive buttons use the action name. "Delete note" not "Confirm"
- Never use OK, Yes, No as button labels
- Never ellipsis in label unless action opens a dialog for more info

---

## Composer

The composer is a fixed-bottom card (web) or floating input bar (mobile). Three button types, matched to mobile's `MobileComposerFooter`:

| Type         | Size  | Style                                                    | Use                                 |
| ------------ | ----- | -------------------------------------------------------- | ----------------------------------- |
| ToolBtn      | 38×38 | `bg-bg-surface border border-default rounded-full`       | Left tool strip (plus, camera, mic) |
| SecondaryBtn | 38×38 | Same as ToolBtn                                          | Right secondary action              |
| PrimaryBtn   | 42×42 | `bg-foreground text-background rounded-full` (no border) | Right primary action                |

Tool strip order: plus → camera → mic (not paperclip).
All buttons: `transition-colors duration-150`. Border stays static on hover — no border-color change.

### Primary action icon logic

| Posture           | Primary icon | Secondary icon |
| ----------------- | ------------ | -------------- |
| capture (home)    | circle-plus  | message-square |
| draft (note page) | circle-plus  | message-square |
| reply (chat page) | arrow-up     | circle-plus    |

Only the chat/reply context gets arrow-up. Both focus and note contexts use circle-plus.

### Card shell

```
position: fixed; bottom: 0; left: 0; right: 0;
padding-horizontal: 8px;
padding-bottom: max(env(safe-area-inset-bottom), 10px);

border-radius: 24px;
border: 1px solid var(--color-border-default);
background: var(--color-bg-elevated);
gap: 12px;
padding: 12px 12px 8px;
box-shadow: var(--shadow-low);
overflow: hidden;
```

Draft posture: min-height 160px container, min-height 104px textarea.
Capture/reply posture: min-height 38px textarea.

### Posture system

Route-derived — never imperative push from pages:

```
'generic'           → capture posture  (home route)
'note-aware'        → draft posture    (notes/:noteId)
'chat-continuation' → reply posture    (chat/:chatId)
```

`useComposerMode()` reads `useMatch()` — never `setChatContext`/`setNoteContext`.

---

## Input / Text field

| Property             | Value                                                                           |
| -------------------- | ------------------------------------------------------------------------------- |
| Background           | bg-inset                                                                        |
| Border (default)     | `1px solid border-default`                                                      |
| Border (focused)     | `border-color: var(--color-border-strong)`                                      |
| Background (focused) | `var(--color-bg-elevated)`                                                      |
| Box-shadow (focused) | `0 0 0 3px var(--color-accent-subtle)` — warm amber glow                        |
| Border (error)       | `2px solid var(--color-destructive)`                                            |
| Box-shadow (error)   | `0 0 0 2px var(--color-destructive), 0 0 0 4px var(--color-destructive-subtle)` |
| Radius               | md (8px)                                                                        |
| Padding vertical     | 12px                                                                            |
| Padding horizontal   | 16px                                                                            |
| Min height           | 44px                                                                            |
| Font size            | body-1 (16px) — minimum 16px on mobile                                          |
| Transition           | `border-color 150ms, box-shadow 150ms` (CSS only)                               |

States:

- Focused: warm accent-subtle glow — not blue, not near-black
- Error: destructive border + glow shadow, error message in body-4/destructive beneath field
- Disabled: `opacity: 0.5; cursor: not-allowed; pointer-events: none`
- Read-only: bg-surface border, no focus ring

Validation:

- Validate on blur, not on every keystroke
- Show error message only after the user has interacted with the field
- Error message: plain language, tells user what to do. "Name can't be empty" not "Required"
- Success state: do not add a green checkmark unless the field has async validation

---

## Textarea

Same rules as Input, plus:

- Min height: 88px (2 body-1 lines + padding)
- Resize: vertical only (`resize: vertical`) — never none, never horizontal
- Auto-grow: expand to content, with a max-height cap from tokens

---

## Card

| Property   | Value                     |
| ---------- | ------------------------- |
| Background | bg-surface                |
| Border     | `1px solid border-subtle` |
| Radius     | lg (12px)                 |
| Shadow     | shadows.low               |
| Padding    | 16px                      |

Hover: CSS `transition: background-color 120ms` to `emphasis.faint` overlay.
No shadow change on hover — shadow transitions are expensive and visually noisy.
Interactive cards get `cursor: pointer` and the pressed GSAP scale treatment.

In dark mode, the border carries more visual weight than the shadow — this is intentional. The card should feel like a contained region, not a floating sheet.

---

## Sheet / Drawer

| Property             | Value        |
| -------------------- | ------------ |
| Background           | bg-elevated  |
| Radius (top corners) | xl (16px)    |
| Radius (bottom)      | 0            |
| Shadow               | shadows.high |
| Backdrop             | bg-overlay   |
| Max height           | 90dvh        |
| Min height           | 30dvh        |

Animation: CSS `void-anim-*` via Radix `data-state` (slide from bottom on open, slide to bottom on close).
Focus trap: `aria-modal="true"`, focus moves to first focusable element on open.
Close: focus returns to trigger element.
Only one sheet open at a time.

---

## Modal / Dialog

| Property   | Value        |
| ---------- | ------------ |
| Background | bg-elevated  |
| Radius     | xl (16px)    |
| Shadow     | shadows.high |
| Backdrop   | bg-overlay   |
| Max width  | 480px        |
| Min width  | 320px        |
| Padding    | 24px         |

Animation: CSS `void-anim-*` via Radix `data-state` (fade + scale from 0.95).
Same focus rules as Sheet. Only one modal open at a time. Never nest modals.

In dark mode, add a `1px border-subtle` ring on the modal container for definition against the dark overlay.

---

## Badge / Pill

| Property   | Value                     |
| ---------- | ------------------------- |
| Background | bg-surface                |
| Border     | `1px solid border-subtle` |
| Radius     | sm (4px)                  |
| Padding    | 2px 8px                   |
| Font       | subheading-3 (12px / 500) |
| Min height | 20px                      |

Accent badge (counts, notifications): accent-subtle background, accent text, no border.
Destructive badge (errors, alerts): destructive-subtle background, destructive text.
Never use badges for long text — truncate at 24 characters maximum.

Note: badges no longer use solid filled backgrounds with white text. The subtle background + colored text pattern is more refined and keeps the UI consistent in dark mode.

---

## Avatar

| Size | Dimensions | Radius     |
| ---- | ---------- | ---------- |
| xs   | 20×20      | radii.icon |
| sm   | 24×24      | radii.icon |
| md   | 32×32      | radii.icon |
| lg   | 48×48      | radii.icon |
| xl   | 80×80      | radii.icon |

Fallback: initials (1–2 chars) in subheading-3, on bg-surface background.
Always provide alt text. Always provide explicit width and height to prevent CLS.

---

## Skeleton / Loading state

Structure: match the shape of the real content — same dimensions, same radius, same layout.
Use bg-surface as skeleton background, `playShimmer` for animation.
Never use spinners for full-page loading — use skeletons.
Kill the shimmer tween on data resolve before replacing skeleton with content.

Skeleton rules:

- Never show a skeleton for less than 300ms (perceived as a flash, not a loader)
- If data resolves in < 300ms, skip the skeleton entirely
- Stagger skeleton rows: `i * 0.04` delay, max 5 rows staggered

---

## Toast / Notification

| Property           | Value                                          |
| ------------------ | ---------------------------------------------- |
| Position           | bottom-right (desktop), bottom-center (mobile) |
| Z-index            | z-toast (400)                                  |
| Width              | 320px (desktop), calc(100vw - 32px) (mobile)   |
| Radius             | lg (12px)                                      |
| Shadow             | shadows.medium                                 |
| Background         | bg-elevated                                    |
| Border             | `1px solid border-subtle`                      |
| Duration (info)    | 4000ms auto-dismiss                            |
| Duration (error)   | 8000ms auto-dismiss                            |
| Duration (success) | 3000ms auto-dismiss                            |
| Max stacked        | 3 (oldest dismisses when 4th appears)          |

Variants: success, error, warning, info — indicated by a left-edge color bar (4px wide, semantic color), not a full background fill.
Always include a manual dismiss (×) button.
Never block the primary content with a toast.
Toasts portal to `document.body`.

---

## Empty state

Structure:

1. Illustration or icon (48px, text-tertiary)
2. Headline (heading-3, text-primary) — "No notes yet"
3. Description (body-2, text-secondary) — one sentence explaining what to do
4. Primary CTA button (optional)

Rules:

- Never use a sad face or error imagery — it's not an error
- Headline: active voice, present tense
- Never show an empty state while loading — show a skeleton instead
- CTA matches the primary action for the empty context

---

## Link

| State         | Treatment                                                    |
| ------------- | ------------------------------------------------------------ |
| Default       | accent color, no underline                                   |
| Hover         | underline, accent-hover color                                |
| Visited       | accent color (never change to grey — confuses with disabled) |
| Focus-visible | `outline: 2px solid var(--color-ring); outline-offset: 2px`  |
| Active        | `scale(0.98)`, accent color                                  |

External links: always open in new tab with `rel="noopener noreferrer"`. Add `aria-label` indicating external.
Never use "click here" as link text. Link text must describe the destination.

---

## Form layout

- Label above field always. Never placeholder-as-label.
- Label: subheading-2 (13px / 500), text-secondary
- Required indicator: asterisk (\*) in `var(--color-destructive)` after the label, with `aria-required="true"` on the input
- Help text: body-4, text-tertiary, between label and input
- Error message: body-4, `var(--color-destructive)`, below input
- Field gap: spacing[4] (16px)
- Submit button: right-aligned on desktop, full-width on mobile

---

## Table

| Property     | Value                                               |
| ------------ | --------------------------------------------------- |
| Header font  | subheading-2 (13px / 500)                           |
| Header color | text-secondary                                      |
| Row font     | body-2 (14px)                                       |
| Row color    | text-primary                                        |
| Row height   | 48px min                                            |
| Border       | `1px solid border-subtle` between rows              |
| Hover row    | emphasis.faint background (CSS `transition: 120ms`) |
| Radius       | lg (12px) on the table container                    |

Never use tables for layout. Tables are for tabular data only.
Always include `aria-label` or `<caption>`.

---

## Code block

| Property    | Value                                            |
| ----------- | ------------------------------------------------ |
| Background  | bg-inset                                         |
| Border      | `1px solid border-subtle`                        |
| Radius      | md (8px)                                         |
| Padding     | 16px                                             |
| Font        | fontFamily.mono (Geist Mono / system-mono), 13px |
| Line height | 1.6                                              |

Inline code: bg-inset, radii.sm, 2px 6px padding, same mono font.
Syntax highlighting: use the project's configured highlighter (react-syntax-highlighter or shiki).
Language label: subheading-4 (11px), text-tertiary, top-right corner of block.
Copy button: icon-only, 32px, always visible; may use subtle emphasis changes on hover/focus, but never hide behind hover.

---

## Markdown rendering

Rules for note content that renders markdown:

- h1 → heading-2 (20px / 600). Only one h1 per note, treated as the note title.
- h2 → heading-3 (18px / 600)
- h3 → heading-4 (16px / 600)
- p → body-1 (16px / 400), max-width 72ch
- ul/ol → body-1, 24px left indent, spacing[2] (8px) between items
- blockquote → left border 3px solid border-default, padding-left spacing[4], text-secondary
- hr → 1px solid border-subtle, spacing[5] vertical margin
- a → link rules above
- img → max-width 100%, radii.lg, shadows.low, explicit dimensions
- table → table rules above
- code (inline) → inline code rules above
- pre > code → code block rules above

Never render raw HTML from user markdown content — sanitise first.
