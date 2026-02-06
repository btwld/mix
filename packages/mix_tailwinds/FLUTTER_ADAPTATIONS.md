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

---

## Known Limitations

The following Tailwind utilities have limited or no support in mix_tailwinds due to fundamental differences between CSS and Flutter's layout system.

### Percent-Based Sizing

**Tailwind CSS:**
```html
<div className="w-[50%] h-[25%]">...</div>
```
- Percent sizing is relative to parent container

**Current Limitation:**
- Arbitrary percent values like `w-[50%]` are parsed (as `TwUnit.percent`) but **not applied** by style appliers
- Only pixel values (`w-[100px]`) work in arbitrary syntax

**Workaround:**
```dart
// Use fractional sizing instead
Div(classNames: 'w-1/2 h-1/4', ...)  // ✓ Works

// Or use Flutter's FractionallySizedBox directly
FractionallySizedBox(
  widthFactor: 0.5,
  child: Div(classNames: '...', ...),
)
```

---

### Translate with Fractions/Percent

**Tailwind CSS:**
```html
<div className="translate-x-1/2 translate-y-[50%]">...</div>
```
- Translates by 50% of the element's own size

**Current Limitation:**
- `translate-x-1/2` and similar fractions are **not supported**
- `translate-x-[50%]` is **treated as 50 pixels**, not 50%

**Workaround:**
```dart
// Use explicit pixel values
Div(classNames: 'translate-x-4', ...)  // ✓ Works (16px)

// Or use Flutter's Transform directly for percent-based translation
Transform.translate(
  offset: Offset(size.width * 0.5, 0),
  child: Div(classNames: '...', ...),
)
```

**Why:** Flutter's `Matrix4` transform uses absolute pixels. Percent-based translation would require a `LayoutBuilder` to measure the element first.

---

### Flex Basis Fractions

**Tailwind CSS:**
```html
<div className="basis-1/2 basis-full">...</div>
```
- Sets flex basis to 50% or 100% of container

**Current Limitation:**
- `basis-1/2`, `basis-1/3`, `basis-full` are **not supported**
- Only space scale values (`basis-4`, `basis-8`) and `basis-auto` work

**Workaround:**
```dart
// Use width/height constraints instead
Div(classNames: 'w-1/2 flex-none', ...)  // Approximate basis-1/2

// Or set explicit pixel basis
Div(classNames: 'basis-48', ...)  // 192px basis
```

---

### Arbitrary Color Formats

**Tailwind CSS:**
```html
<div className="bg-[rgb(255,0,0)] bg-[hsl(0,100%,50%)]">...</div>
```
- Supports hex, rgb(), rgba(), hsl(), hsla()

**Current Limitation:**
- Only **6-digit hex colors** are supported in arbitrary syntax
- `bg-[#ff0000]` ✓ works
- `bg-[rgb(255,0,0)]` ✗ not supported
- Short hex like `bg-[#f00]` ✗ **silently produces a wrong color** (parsed as a raw int, not expanded to 6 digits)

**Workaround:**
```dart
// Always use full 6-digit hex (short hex silently produces wrong colors)
Div(classNames: 'bg-[#ff0000]', ...)  // ✓ Works
Div(classNames: 'bg-[#f00]', ...)     // ✗ Wrong color!

// Or add custom colors to TwConfig
final config = TwConfig.standard().copyWith(
  colors: {
    ...TwConfig.standard().colors,
    'brand': Color(0xFFFF0000),
  },
);
```

---

### Variant Margin Behavior

**Tailwind CSS:**
```html
<div className="m-2 hover:m-4">...</div>
```
- Margin changes on hover

**Current Limitation:**
- Margin is resolved once at build time
- `hover:m-4`, `dark:m-2` and similar variant margins **do not update** on state change

**Workaround:**
```dart
// Use padding instead (which does respond to variants)
Div(classNames: 'p-2 hover:p-4', ...)  // ✓ Works

// Or handle margin changes manually with StatefulWidget
```

**Why:** CSS semantic margin is applied outside the `StyleBuilder` to ensure correct hit-testing behavior (margin should not be part of the interactive area). This means it doesn't receive variant state updates.

---

## Limitations Summary Table

| Tailwind Feature | Status | Workaround |
|-----------------|--------|------------|
| `w-[50%]`, `h-[25%]` | ✗ Parsed but not applied | Use `w-1/2`, `h-1/4` fractions |
| `translate-x-1/2` | ✗ Not supported | Use pixel values |
| `translate-x-[50%]` | ⚠️ Treated as pixels | Use Flutter Transform |
| `basis-1/2`, `basis-full` | ✗ Not supported | Use `w-1/2 flex-none` |
| `bg-[rgb(...)]` | ✗ Not supported | Use hex: `bg-[#rrggbb]` |
| `bg-[#f00]` (short hex) | ⚠️ Silently wrong color | Use full hex: `bg-[#ff0000]` |
| `hover:m-4` | ✗ Not reactive | Use padding instead |
