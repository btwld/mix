# Flutter-Specific Adaptations for Tailwind Parity

This document explains the differences between Tailwind CSS behavior and Flutter's layout system, and how mix_tailwinds bridges the gap.

## Key Behavioral Differences

### 1. `flex-1` Behavior

**Tailwind CSS:**
```html
<div className="flex-1">...</div>
```
- `flex-1` applies `flex: 1 1 0%` - items expand and can shrink below content size

**mix_tailwinds:**
- `flex-1` automatically applies min-width/height constraints for CSS parity
- Use `min-w-auto` escape hatch if you need intrinsic minimum sizing

---

### 2. `min-w-0` for Flex Shrinking

**Tailwind CSS:**
```html
<div className="flex flex-1 flex-col gap-1">...</div>
```
- Flex items can shrink below content size by default

**Flutter Adaptation:**
```dart
Div(classNames: 'flex flex-1 flex-col gap-1 min-w-0', ...)
```
- For `flex-auto` or other flex utilities, explicitly add `min-w-0` to allow shrinking
- `flex-1` handles this automatically

**Root Cause:** Flutter widgets have intrinsic minimum sizes based on content.

---

### 3. Text Truncation in Flex Containers

**Tailwind CSS:**
```html
<p className="truncate text-sm text-gray-500">{text}</p>
```
- `truncate` works directly on text elements in flex containers

**Flutter Adaptation:**
```dart
// Option 1: Use TruncatedP helper
TruncatedP(text: update, classNames: 'text-sm text-gray-500')

// Option 2: Manual wrapper
Div(
  classNames: 'flex-1 min-w-0',
  child: P(
    text: update,
    classNames: 'truncate text-sm text-gray-500',
  ),
)
```

**Root Cause:** Flutter's Text widget calculates intrinsic size from content. CSS elements naturally fill container width.

---

### 4. `overflow-hidden` for Clipping

**Tailwind CSS:**
```html
<button className="flex items-center justify-center rounded-full ...">
  View live dashboard
</button>
```
- Content naturally clips to element bounds

**Flutter Adaptation:**
```dart
Div(
  classNames: '... flex items-center justify-center overflow-hidden',
  child: P(text: label, classNames: '... truncate'),
)
```
- Need explicit `overflow-hidden` on container

**Root Cause:** Flutter doesn't implicitly clip overflow like HTML elements do.

---

## Summary Table

| CSS Behavior | Flutter Adaptation | Notes |
|--------------|-------------------|-------|
| `flex-1` shrinks | Automatic | mix_tailwinds handles this |
| `flex-auto` shrinks | Add `min-w-0` | Explicit for non-flex-1 |
| Text truncates in flex | Use `TruncatedP` | Or manual wrapper pattern |
| Content clips to bounds | Add `overflow-hidden` | Explicit clipping required |

---

## Technical Background

### CSS vs Flutter Layout Philosophy

| Aspect | CSS | Flutter |
|--------|-----|---------|
| Constraints | Implicit (viewport, document flow) | Explicit (parent passes down) |
| Minimum size | `min-width: auto` protects content | Intrinsic size always enforced |
| Text sizing | Block elements fill container width | Text calculates intrinsic width |
| Overflow | `overflow: hidden` enables shrinking | Must explicitly clip |

### The `min-width: auto` Problem

CSS flexbox uses `min-width: auto` as the default for flex items. When `overflow: hidden` is set, this computes to 0, allowing shrinking.

Flutter has no such exception - widgets always have intrinsic minimum sizes unless explicitly overridden.

### Why `flex-1` Needed Special Handling

**CSS `flex: 1`** = `flex: 1 1 0%`:
- `flex-grow: 1` - grow to fill space
- `flex-shrink: 1` - can shrink
- `flex-basis: 0%` - start from zero

**Flutter `flex: 1` + `FlexFit.tight`**:
- Allocates space proportionally
- Forces child to use allocated space
- Child's minimum size was still enforced (before fix)

mix_tailwinds now automatically applies `min-w-0` semantics for `flex-1` to match CSS behavior.
