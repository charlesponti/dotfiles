# Design System — Chat UI

Canonical specification for all chat/conversation UI components across web and mobile. This document is the authoritative reference for chat components; always use it alongside `components.md`.

---

## Anatomy

A chat screen consists of four regions, top to bottom:

```
┌──────────────────────────────────────┐
│  ChatHeader                           │  ← Fixed, non-scrolling
├──────────────────────────────────────┤
│                                      │
│  ChatMessages (scrollable)            │  ← Virtualised if > 50 items
│    └── ChatMessage (per turn)         │
│                                      │
│                                      │
├──────────────────────────────────────┤
│  Composer (pinned)                   │  ← Always visible
└──────────────────────────────────────┘
```

---

## ChatHeader

### Web

| Property      | Value                                    |
| ------------- | ---------------------------------------- |
| Background    | `bg-elevated` with `bg-overlay` backdrop |
| Height        | 56px mobile, 60px desktop                |
| Border bottom | `1px solid border-subtle`                |
| Back button   | Left-aligned, 44×44px touch target       |
| Title area    | Centre-aligned, max-width 50% of header  |
| Status copy   | `body-4`, `text-tertiary`                |
| Actions       | Right-aligned, icon buttons 44×44px      |

**Status copy states:**

- New conversation: "New conversation"
- With messages: "{n} messages"
- Classifying: "Preparing note review"
- Reviewing: "Review ready"
- Persisting: "Saving note"

### Mobile

- Safe area insets applied to top padding
- Context anchor shows above status copy
- Icon buttons 36×36px minimum

---

## ChatMessages — Scroll Container

| Property                 | Web                                     | Mobile                          |
| ------------------------ | --------------------------------------- | ------------------------------- |
| Max width                | `chatTokens.transcriptMaxWidth` (768px) | Full width                      |
| Horizontal padding       | 24px desktop, 16px mobile               | 16px                            |
| Vertical padding         | 24px top, clearance for composer bottom | 4px top                         |
| Scroll                   | Native overflow-y                       | `FlatList`                      |
| Composer clearance       | 32px bottom padding                     | `CHAT_COMPOSER_CLEARANCE` token |
| Auto-scroll              | On new message if user is near bottom   | Same                            |
| Virtualisation threshold | 50 messages                             | Same                            |

---

## ChatMessage — Per-turn rendering

Each turn consists of layers in this order:

1. **Message row** — handles padding and alignment
2. **MessageContent** — column container, handles max-width
3. **Reasoning** (assistant only) — above main content, 3px left border
4. **Tool calls** — below reasoning, above main content
5. **Main content** — bubble (user) or plain (assistant)
6. **Focus items** — referenced notes, collapsed by default
7. **Metadata** — sender label · timestamp, `body-4`, `text-tertiary`
8. **Actions** — always visible; hover may refine emphasis, but never gate visibility

**Gap between layers:** 8px (`chatTokens.contentGap`)
**Turn gap (between messages):** 20px (`chatTokens.turnGap`)

---

## User message bubble

| Property      | Value                                                      |
| ------------- | ---------------------------------------------------------- |
| Max width     | `chatTokens.userBubbleMaxWidth` (544px)                    |
| Background    | `var(--color-accent)` — warm amber                         |
| Border        | none                                                       |
| Border radius | `chatTokens.radii.bubble` = `radii.md` (8px web, 8 native) |
| Padding       | 16px horizontal, 12px vertical                             |
| Text color    | `#1c1917` (stone-900) — dark text on warm amber            |
| Font          | `body-1` (16px web, 17px mobile)                           |
| Line height   | 1.6 web, 1.5 mobile                                        |
| Alignment     | Right                                                      |
| Shadow        | none                                                       |

The user bubble uses the warm amber accent as its background. Text is dark (stone-900) for maximum contrast against the amber surface. No shadow — the color itself provides visual separation.

**Forbidden:**

- Never put assistant messages in a bubble
- Never show a user avatar
- Never put "You" inside the user bubble
- Never use `rounded-full` for message bubbles
- Never use white text on the amber bubble — use dark text for contrast

---

## Assistant message surface

| Property    | Value                               |
| ----------- | ----------------------------------- |
| Width       | Full transcript width (up to 768px) |
| Background  | `transparent`                       |
| Border      | None                                |
| Text color  | `text-primary`                      |
| Font        | `body-1` (16px web, 18px mobile)    |
| Line height | 1.6 web, 1.5 mobile                 |
| Alignment   | Left                                |

**Never wrap assistant messages in a bubble.** The transcript is prose.

---

## Metadata row

| Property  | Value                             |
| --------- | --------------------------------- |
| Font      | `body-4` (12px)                   |
| Color     | `text-tertiary`                   |
| Content   | Sender label · Relative timestamp |
| Alignment | Matches message alignment         |

- "You" for user, "AI Assistant" for assistant — never initials
- Relative timestamp: "just now", "2m ago", "Yesterday"
- Never show absolute timestamps in the transcript
- No opacity dimming on metadata — use text-tertiary token directly

---

## Actions row

| Property     | Value                                                               |
| ------------ | ------------------------------------------------------------------- |
| Visibility   | Always visible                                      |
| Transition   | CSS `transition-colors duration-150`; use emphasis changes, not hide/show |
| Touch target | 44×44px minimum                                                     |
| aria-label   | Required on every icon-only button                                  |

**Actions per message type:**

| Action      | User | Assistant |
| ----------- | ---- | --------- |
| Copy        | yes  | yes       |
| Edit        | yes  | no        |
| Regenerate  | no   | yes       |
| Delete      | yes  | yes       |
| Speak (TTS) | no   | yes       |
| Share       | no   | yes       |

---

## Reasoning block (assistant)

| Property    | Value                      |
| ----------- | -------------------------- |
| Background  | `bg-surface`               |
| Border left | `3px solid border-default` |
| Padding     | 16px left, 8px vertical    |
| Font        | `body-4`, monospace        |
| Color       | `text-tertiary`            |

---

## Tool calls

| Property          | Value                                                                           |
| ----------------- | ------------------------------------------------------------------------------- |
| Surface           | `bg-surface` with `1px border border-subtle`                                    |
| Radius            | `radii.md`                                                                      |
| Padding           | 12px                                                                            |
| Tool name         | `body-4`, `fontWeight: 600`                                                     |
| Args              | monospace, 12px, `text-secondary`                                               |
| Status            | Dot indicator: `accent` = running, `success` = completed, `destructive` = error |
| Gap between tools | 8px                                                                             |

---

## Focus items (referenced notes)

| Property | Value                                      |
| -------- | ------------------------------------------ |
| Surface  | `bg-base` with `1px border border-default` |
| Radius   | `radii.md`                                 |
| Padding  | 8px horizontal, 4px vertical               |
| Font     | `body-4`                                   |
| State    | Collapsed by default (show count only)     |

---

## Composer

### Web

| Property      | Value                                                            |
| ------------- | ---------------------------------------------------------------- |
| Container     | Full width up to 768px                                           |
| Background    | `var(--color-bg-elevated)`                                       |
| Border        | `1px solid var(--color-border-default)`                          |
| Border radius | `24px`                                                           |
| Shadow        | `var(--shadow-low)`, upgrades to `var(--shadow-medium)` on focus |
| Padding       | 16px                                                             |
| Submit button | 36×36px, circular, foreground background, background-color icon  |

### Mobile

| Property   | Value                                            |
| ---------- | ------------------------------------------------ |
| Background | `bg-elevated`                                    |
| Border top | `1px solid border-default`                       |
| Shadow     | shadows.low (iOS only)                           |
| Textarea   | 17px font, `text-primary`                        |
| Submit     | 44×44px, accent background                       |
| Clearance  | 220px minimum from bottom (keyboard + safe area) |

### Suggestions strip (shown when input is empty)

| Property | Value                                  |
| -------- | -------------------------------------- |
| Surface  | `bg-surface`                           |
| Border   | `1px solid border-subtle`              |
| Radius   | `radii.md`                             |
| Font     | `body-2`                               |
| On tap   | Insert suggestion text, focus textarea |

---

## Thinking indicator (streaming)

| Property  | Web                                             | Mobile                              |
| --------- | ----------------------------------------------- | ----------------------------------- |
| Label     | "AI Assistant" in `body-4`                      | Same                                |
| Indicator | 3 dots, 8px each                                | Same                                |
| Animation | CSS custom class (not Tailwind `animate-pulse`) | react-native-reanimated bounce dots |
| Text      | "Thinking…" in `body-4`, `text-tertiary`        | Same                                |

**Mobile:** Use react-native-reanimated `withSequence` + `withTiming`. Do not use `Animated` from React Native core.

---

## Skeleton / shimmer

| Property        | Web                                | Mobile               |
| --------------- | ---------------------------------- | -------------------- |
| Structure       | Match the shape of real messages   | Same                 |
| Background      | `bg-surface`                       | `bg-surface`         |
| Animation       | GSAP `playShimmer`                 | reanimated pulse     |
| Kill on resolve | Yes — always `.kill()` the shimmer | Cancel the animation |

**Rules:**

- Never show skeleton for < 300ms
- If load resolves in < 300ms, skip skeleton entirely
- Match the radius of real content bubbles

---

## Error display

| Property        | Value                                                          |
| --------------- | -------------------------------------------------------------- |
| Surface         | `bg-surface` with `1px border var(--color-destructive-subtle)` |
| Background tint | `var(--color-destructive-subtle)`                              |
| Radius          | `radii.md`                                                     |
| Padding         | 16px                                                           |
| Headline        | `body-2`, `fontWeight: 600`, `var(--color-destructive)`        |
| Body            | `body-4`, `text-secondary`                                     |

---

## Token summary

Chat-specific tokens must be defined in the project's token files (e.g. `@your-org/ui/tokens/chat.ts`). Key tokens:

| Token                | Value                         | Purpose                             |
| -------------------- | ----------------------------- | ----------------------------------- |
| `transcriptMaxWidth` | 768px                         | Transcript max width                |
| `userBubbleMaxWidth` | 544px                         | User bubble max width               |
| `searchMaxWidth`     | 640px                         | Search overlay max width            |
| `turnGap`            | 20px                          | Gap between message turns           |
| `contentGap`         | 8px                           | Gap between content blocks          |
| `metadataGap`        | 4px                           | Gap in metadata row                 |
| `surfaces.user`      | `var(--color-accent)`         | User bubble background (warm amber) |
| `surfaces.assistant` | `transparent`                 | Assistant surface                   |
| `surfaces.composer`  | `var(--color-bg-elevated)`    | Composer background                 |
| `borders.composer`   | `var(--color-border-default)` | Composer border                     |
| `radii.bubble`       | `radii.md` (8px)              | Message bubble radius               |
| `foregrounds.user`   | `#1c1917`                     | User bubble text (dark on amber)    |

---

## Common violations

| Violation                               | Fix                                             |
| --------------------------------------- | ----------------------------------------------- |
| `bg-white` or `bg-bg-surface` in chat   | Use `chatTokens.surfaces.*`                     |
| `border-subtle` Tailwind class          | Use `colors['border-subtle']` token             |
| `rounded-[1.75rem]`                     | Use `24px` or `radii.xl`                        |
| `rounded-full` on message bubble        | Use `radii.md` (8px)                            |
| Hardcoded font size (17, 18, 24)        | Use `body-1` class or `fontSizes` token         |
| `rgba(0,0,0,0.35)` for muted text       | Use `text-tertiary`                             |
| White text on amber user bubble         | Use dark text (`#1c1917`) for contrast          |
| `space-y-4` between messages            | Use `chatTokens.turnGap`                        |
| `animate-pulse` for streaming cursor    | Custom CSS class or GSAP                        |
| `Animated` from react-native            | Use react-native-reanimated worklet             |
| Stub component returning `null`         | Implement it                                    |
| No message enter animation              | `playEnterRow` on mount (web)                   |
| No shimmer `.kill()` on data resolve    | Call `.kill()` in data callback                 |
| Composer shadow not upgraded on focus   | `shadows.low` → `shadows.medium`                |
| Actions row touch targets < 44px        | Add invisible padding or `hitSlop`              |
| aria-label missing on icon-only buttons | Add descriptive `aria-label`                    |
| Using `dark:` for chat colors           | Use CSS custom properties that resolve per mode |
