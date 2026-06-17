# Design System Standards

This document defines the non-negotiable product standards for the project’s UI work. It is **not** a general style guide and it is **not** framework-agnostic. It exists to remove ambiguity, reduce implementation drift, and keep decisions consistent across the supported stack.

## Scope

This skill applies to the project’s supported frontend surfaces only.

- **React web is supported**
- **React Native is supported where the product surface requires it**
- **Next.js is not supported**
- Do not assume rules from one platform automatically transfer to another
- When a rule is platform-specific, say so explicitly

## How to use these standards

Treat these standards as the default answer. Do not present multiple equally valid options unless the project truly supports them.

When a decision is made, include the reason for it:

- what the rule is
- why it exists
- what tradeoff it avoids
- what happens if you ignore it

If a rule is wrong or outdated, update the standard itself. Do not bypass it ad hoc in product code.

## Standards-first posture

This project is standards-heavy by design.

- Prefer explicit rules over vague advice
- Prefer consistent constraints over developer preference
- Prefer hard requirements over “best effort”
- Prefer concrete examples over general principles
- Prefer a single approved pattern over many acceptable ones

If something can be specified, it should be specified.

## Prescriptive writing rules

Every guideline in this skill should be written as an instruction, not a suggestion.

Good:

- Use semantic HTML for interactive elements
- Trap focus in overlays
- Keep interactive targets at least 44px square
- Use tokens for all spacing, color, radius, and elevation values

Bad:

- Consider using semantic HTML
- Try to trap focus
- Smaller touch targets may be okay in some cases
- Tokens are preferred when convenient

## Required reasoning standard

Every rule must be justified well enough that another engineer can defend it in review.

A valid justification includes at least one of:

- accessibility
- consistency
- performance
- maintainability
- cross-platform correctness
- reduced user confusion
- reduced implementation risk

If a rule has no rationale, it should not be in the standard.

## Decision-making hierarchy

When standards conflict, resolve them in this order:

1. Accessibility and user safety
2. Platform correctness
3. Product consistency
4. Performance
5. Visual preference

Do not optimize visual polish at the expense of access, correctness, or maintainability.

## Framework policy

- Do not introduce Next.js patterns into this skill
- Do not describe the system as framework-agnostic
- Do not generalize implementation details beyond the supported stack
- Use platform-specific guidance when it matters
- Use shared language only when the rule truly applies to both web and native

## Review expectation

If you are reviewing UI work, look for:

- whether the correct standard was applied
- whether the implementation followed the prescribed pattern
- whether the reasoning for any deviation was documented
- whether the code remains consistent with the rest of the system

If the work deviates from the standard without a strong reason, treat that as a defect.

## Escalation rule

If a requested design decision cannot be supported by the current standards:

1. identify the missing or conflicting rule
2. explain why the current standard is insufficient
3. propose the new standard
4. update the reference before treating the implementation as correct

## Bottom line

This design system is meant to be precise, enforceable, and opinionated. The goal is not to allow every reasonable approach. The goal is to make the right approach obvious and repeatable.

## Review checklist

Fail the review if any of the following are violated:

### Tokens & values

- [ ] No hardcoded colors, sizes, radii, durations, z-indices, or font values
- [ ] Platform-correct token keys used (web vs. native)
- [ ] New token added to token files if a value was missing
- [ ] Dark-mode token defined for any new color

### Animation

- [ ] All interactive animations use GSAP canonical sequences
- [ ] Radix/headless UI states use CSS `void-anim-*` classes only
- [ ] `reducedMotion()` guard respected
- [ ] No animation of layout-triggering CSS properties
- [ ] 60fps achievable on mid-range device

### Typography & copy

- [ ] Composed utility classes used — no raw size/weight combinations
- [ ] Font weight ≤ 700
- [ ] Mobile inputs ≥ 16px
- [ ] Button labels are verb-first, sentence case
- [ ] Error messages tell the user what to do

### Color & contrast

- [ ] All colors from CSS custom properties — no raw Tailwind palette
- [ ] Text dimmed via tier token, not opacity
- [ ] Accent and destructive never swapped
- [ ] WCAG AA contrast met (4.5:1 body, 3:1 UI components)
- [ ] Dark mode tested end to end, with no ad hoc color inversion

### Accessibility

- [ ] Touch targets ≥ 44px × 44px
- [ ] Focus ring uses `--color-ring`, not accent, with `border-radius: inherit`
- [ ] `:focus` shows nothing; `:focus-visible` shows the ring
- [ ] Modals/sheets trap focus with `aria-modal`
- [ ] Focus returns to trigger on close
- [ ] No `tabIndex > 0`
- [ ] Alt text on non-decorative images
- [ ] `aria-label` on icon-only buttons
- [ ] Controls are not hidden behind hover; keyboard, focus, and touch users see the same action affordance.
- [ ] Live region or native accessibility announcement exists for meaningful async state changes (saving, uploading, errors, completion)
- [ ] Form fields expose labels, help text, and error text via programmatic associations
- [ ] Color is never the only state signal for selection, error, or disabled state

### Components & states

- [ ] All required interaction states implemented
- [ ] Loading and error states implemented where applicable
- [ ] Component spec consulted before implementing (components.md)

### Layout & responsive

- [ ] Mobile-first — base styles are mobile, breakpoints layer up
- [ ] No max-width media queries
- [ ] Z-index from token scale only
- [ ] Only one modal/sheet open at a time
- [ ] Toasts portal to document body

### Performance

- [ ] Lists > 50 items virtualised
- [ ] React.memo on feed row components
- [ ] Routes lazy-loaded
- [ ] Named icon imports only
- [ ] Explicit width/height on images

### Chat UI

- [ ] `chatTokens` used for all chat-specific values
- [ ] User messages in bubble, assistant messages plain
- [ ] No hardcoded Tailwind color classes in chat
- [ ] No `animate-pulse` — custom CSS class or GSAP for streaming cursor
- [ ] Mobile: react-native-reanimated used, not `Animated` from React Native core
- [ ] Message enter animation on mount
- [ ] Shimmer tweens killed on data resolve
- [ ] Composer shadow upgrade on focus
- [ ] Actions row has 44px minimum touch targets
- [ ] No stub components returning `null`
