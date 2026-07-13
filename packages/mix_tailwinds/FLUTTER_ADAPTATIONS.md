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

## Default Typography Parity (Tailwind vs Mix)

### Why text can still look different even when tokens match

`mix_tailwinds` maps utility tokens correctly (`text-lg` -> `18`, `font-semibold` -> `w600`, etc.), but text can still render differently because:

1. Tailwind relies on browser defaults and Preflight (`ui-sans-serif`, `letter-spacing: normal`).
2. Flutter text can inherit app theme defaults that don't match Tailwind base typography.
3. `H1`-`H6` in `mix_tailwinds` intentionally have no default heading styles (Tailwind-like behavior).

If you want visual parity, align **global defaults** first, then compare utility mapping.

### Which system controls what

| Concern | Tailwind side | Flutter side |
|---|---|---|
| Utility scale (`text-*`, spacing, colors, breakpoints) | `tailwind.config.js` theme scale | `TwConfig.standard().copyWith(...)` |
| Global defaults (`font-family`, base font-size, base tracking, base line-height) | `@layer base` / body defaults | `TwConfig.textDefaults` applied by `TwScope` (`MixScope` + `TextScope`) |
| Semantic app design tokens | Tailwind CSS variables or design token layer | `MixScope` (`ColorToken`, `TextStyleToken`, `SpaceToken`, etc.) |

### Tailwind change -> Mix equivalent

| Tailwind change | Mix equivalent |
|---|---|
| `theme.extend.colors` | `TwConfig.copyWith(colors: {...})` |
| `theme.extend.spacing` | `TwConfig.copyWith(space: {...})` |
| `theme.extend.borderRadius` | `TwConfig.copyWith(radii: {...})` |
| `theme.extend.screens` | `TwConfig.copyWith(breakpoints: {...})` |
| `theme.extend.fontSize` | `TwConfig.copyWith(fontSizes: {...})` |
| `theme.extend.fontWeight` | Update translator typography mapping or use `MixScope(fontWeights: ...)` for non-tailwind Mix styles |
| `theme.extend.fontFamily` / base `font-sans` stack | `TwConfig.copyWith(textDefaults: config.textDefaults.copyWith(...))` |
| Use native platform font defaults | `TwConfig.copyWith(textDefaults: const TwTextDefaults.platformDefault())` |
| `@layer base { body { font-size / letter-spacing / line-height } }` | `TwConfig.textDefaults.copyWith(fontSize: ..., letterSpacing: ..., lineHeight: ...)` |

### Recommended parity setup

Use a single source of truth for both utility parsing and semantic Mix styling:

```dart
final twConfig = TwConfig.standard().copyWith(
  colors: {
    ...TwConfig.standard().colors,
    'brand-500': const Color(0xFF4F46E5),
  },
  fontSizes: {
    ...TwConfig.standard().fontSizes,
    'lg': 18, // keep in sync with Tailwind
  },
  textDefaults: TwConfig.standard().textDefaults.copyWith(
    // Match your Tailwind base stack.
    fontFamily: 'Inter',
    fontSize: 16, // Tailwind preflight default
    letterSpacing: 0,
    lineHeight: 1.5,
  ),
);

runApp(
  TwScope(
    config: twConfig,
    // Optional semantic tokens for your design system
    tokens: const {
      TextStyleToken('typography.body'): TextStyle(fontSize: 16, height: 1.5),
    },
    child: const MaterialApp(home: MyPage()),
  ),
);
```

`TwScope` internally wires:
- `TwConfigProvider` for utility parsing scales
- `MixScope` for tokenized default text style
- `TextScope` for tree-level default typography

### Decision rule

- If you are matching Tailwind utility behavior and defaults: use `TwConfig` + `TwScope`.
- If you are defining app-level design semantics: use `MixScope` tokens.
- For pixel parity screenshots, normalize global typography via `TwConfig.textDefaults` before debugging individual utilities.

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

### Parser and Variant Adaptations

`mix_tailwinds` parses Tailwind candidates with a registry generated from the Tailwind spec lab, then translates supported values directly into Mix stylers and runtime variants. Protocol representability is enforced in tests by encoding, strictly decoding, and canonically re-encoding a broad translator-output corpus through the development-only `mix_protocol` dependency.

Current adaptation policy:

| Tailwind feature | mix_tailwinds behavior | Reason |
|---|---|---|
| `group-*`, `peer-*` variants | Parsed, ignored | Flutter has no selector-relative group/peer state equivalent in this widget API. |
| Arbitrary selector variants like `[&_p]:mt-4` | Parsed, ignored | Flutter widgets cannot target descendants by CSS selector. |
| Container query variants like `@...` | Parsed, ignored | Container-query semantics remain in the widget/layout layer, not styler payloads. |
| `!important` prefix/suffix | Parsed, ignored and reported through `onUnsupported` | Flutter/Mix has no CSS cascade priority model. |
| Arbitrary properties like `[color:red]` | Parsed, ignored | They do not map safely to typed Mix styler fields. |
| `from`/`via`/`to` gradients | Accumulated into `LinearGradientMix` | Gradient outputs encode through `mix_protocol`, including CSS keyword directions. |
| `bg-*/50` alpha modifiers | Approximated with Flutter alpha | Flutter has no `color-mix()`/OKLAB equivalent for Tailwind's CSS output. |

Responsive layout utilities such as `w-full`, `w-screen`, fractions, external margin, negative margin handling, flex item parent data, axis, and gap remain in `tw_widget.dart` because they depend on live Flutter constraints.

### Percent-Based Sizing

**Tailwind CSS:**
```html
<div className="w-[50%] h-[25%]">...</div>
```
- Percent sizing is relative to parent container

**Current Limitation:**
- Arbitrary percent values like `w-[50%]` are syntactically parsed but **not applied** by translator or widget sizing
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
- `translate-x-[50%]` is **unsupported** and reported through `onUnsupported`

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
- `basis-1/2`, `basis-1/3`, `basis-full` are **not supported** and are
  reported through `onUnsupported`
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
- **3/4/6/8-digit CSS hex colors** are supported in arbitrary syntax
- `bg-[#ff0000]` ✓ works
- `bg-[#f00]` ✓ works
- `bg-[#ffff]` ✓ works
- `bg-[#ffffff80]` ✓ works
- `bg-[rgb(255,0,0)]` ✗ not supported
- `rgb()` and `hsl()` arbitrary color functions remain unsupported

**Workaround:**
```dart
// Use CSS hex arbitrary values
Div(classNames: 'bg-[#ff0000]', ...)  // ✓ Works
Div(classNames: 'bg-[#f00]', ...)     // ✓ Works

// Or add custom colors to TwConfig
final config = TwConfig.standard().copyWith(
  colors: {
    ...TwConfig.standard().colors,
    'brand': Color(0xFFFF0000),
  },
);
```

---

### Text Block Margin Variants

**Tailwind CSS:**
```html
<p className="m-2 hover:m-4">...</p>
```
- Margin changes on hover

**Current Limitation:**
- `P` and heading margin extraction is base-only
- Only unprefixed positive margins like `mb-4` are applied externally
- `hover:m-4`, `dark:m-2`, `group-hover:m-4`, `@md:m-4`, and selector variants like `[&_p]:mt-4` are skipped instead of becoming unconditional margins

**Workaround:**
```dart
// Use padding instead (which does respond to variants)
P(text: '...', classNames: 'p-2 hover:p-4')  // ✓ Works

// Or handle margin changes manually with StatefulWidget
```

**Why:** Text block CSS semantic margin is applied outside the `StyleBuilder` so margin stays outside the text hit-test/styling area. Until responsive/interactive margin semantics exist there, variant margins are ignored.

---

## Limitations Summary Table

| Tailwind Feature | Status | Workaround |
|-----------------|--------|------------|
| `w-[50%]`, `h-[25%]` | ✗ Parsed but not applied | Use `w-1/2`, `h-1/4` fractions |
| `translate-x-1/2` | ✗ Not supported | Use pixel values |
| `translate-x-[50%]` | ✗ Unsupported | Use Flutter Transform |
| `basis-1/2`, `basis-full` | ✗ Unsupported; reported through `onUnsupported` | Use `w-1/2 flex-none` |
| `bg-[rgb(...)]`, `bg-[hsl(...)]` | ✗ Not supported | Use CSS hex: `bg-[#rgb]`, `bg-[#rrggbb]`, or `bg-[#rrggbbaa]` |
| `hover:m-4` on `P`/headings | ✗ Ignored | Use padding instead |
