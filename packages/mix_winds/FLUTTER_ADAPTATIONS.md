# Flutter-Specific Adaptations for Tailwind Parity

This document explains the differences between Tailwind CSS behavior and Flutter's layout system, and how mix_winds bridges the gap.

## Key Behavioral Differences

### 1. `flex-1` Behavior

**Tailwind CSS:**
```html
<div className="flex-1">...</div>
```
- `flex-1` applies `flex: 1 1 0%`.
- The default automatic minimum size can still protect content; add `min-w-0`
  when the item must shrink below its content-based minimum.
- Padding, border, and margin remain outside a zero flex basis. They are
  reserved before the remaining content space is distributed.

**mix_winds:**
- When positive content space remains, a Tailwind `Div(classNames: 'flex')`
  reserves each zero-basis grower's main-axis margin, padding, and border
  before distributing that space. For example, two `flex-1` items in 900px,
  where only the first has `border px-5` (42px total), size to 471px and 429px
  like the browser.
- The adapter delegates both layout passes to Flutter's `RenderFlex`, so gap,
  direction, alignment, baseline, overflow, and clipping stay on Flutter's
  maintained implementation.
- A Tailwind child placed directly in a native `Row` or `Column` keeps the
  compatibility mapping to Flutter `Flexible`; native parents therefore use
  Flutter's outer-box distribution.

---

### 2. `min-w-0` for Flex Shrinking

**Tailwind CSS:**
```html
<div className="flex flex-1 flex-col gap-1">...</div>
```
- Flex items default to `min-width: auto`, which can preserve a content-based
  minimum. `min-w-0` explicitly opts out.

**Flutter Adaptation:**
```dart
Div(classNames: 'flex flex-1 flex-col gap-1 min-w-0', ...)
```
- Keep `min-w-0` in shared Tailwind markup when browser content must shrink.
- Flutter's tight flex allocation can already assign less than the child's
  intrinsic width. It does not reproduce CSS's automatic minimum-size rule,
  and `min-w-auto` cannot restore that rule in a Flutter flex parent.

**Root Cause:** CSS flex layout has a content-aware automatic minimum. Flutter
passes explicit constraints to a child and has no equivalent flex-item
minimum-size phase.

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

### 5. `self-*` Is Applied by the Flex, Not the Child

**Tailwind CSS:**
```html
<div class="flex flex-row items-center">
  <div class="self-start">Badge</div>
</div>
```
- `align-self` overrides the container's `align-items` for that one child.

**Flutter Adaptation:**

`self-start`, `self-end`, and `self-center` are honored, including inside a row
nested in a column where the flex sizes its own cross axis.

**Root Cause:** Flutter's `RenderFlex` exposes a single `crossAxisAlignment` for
every child, and a child cannot place itself: wrapping in an `Align` only
shrink-wraps, so the flex goes on positioning it by the container's rule. A flex
container holding a self-aligned child therefore renders through a `RenderFlex`
subclass that offsets those children along the cross axis after layout, once the
flex has measured its own cross extent. Self alignment changes offsets only;
it does not add another layout pass by itself.

**Note:** `self-auto` is a no-op by definition — it means "use the container's
`align-items`" — so it is correct that it changes nothing.

---

## Summary Table

| CSS Behavior | Flutter Adaptation | Notes |
|--------------|-------------------|-------|
| Zero-basis grow with unequal margin/padding/border | Automatic in Tailwind `Div` flex containers | Native `Row`/`Column` keeps Flutter distribution |
| CSS automatic flex-item minimum | Not modeled | Keep `min-w-0` in shared browser markup; `min-w-auto` cannot restore it in Flutter |
| Text truncates in flex | Use `TruncatedP` | Or manual wrapper pattern |
| Content clips to bounds | Add `overflow-hidden` | Explicit clipping required |

---

## Default Typography Parity (Tailwind vs Mix)

### Why text can still look different even when tokens match

`mix_winds` maps utility tokens correctly (`text-lg` -> `18`, `font-semibold` -> `w600`, etc.), but text can still render differently because:

1. Tailwind relies on browser defaults and Preflight (`ui-sans-serif`, `letter-spacing: normal`).
2. Flutter text can inherit app theme defaults that don't match Tailwind base typography.
3. `H1`-`H6` in `mix_winds` intentionally have no default heading styles (Tailwind-like behavior).

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
| Minimum size | `min-width: auto` can protect content | No flex-item automatic-minimum phase |
| Text sizing | Block elements fill container width | Text calculates intrinsic width |
| Overflow | `overflow: hidden` enables shrinking | Must explicitly clip |

### The `min-width: auto` Difference

CSS flexbox uses `min-width: auto` as the default for flex items. For a
non-scrollable item this can resolve to a content-based minimum; for a scroll
container the automatic minimum is zero.

Flutter has no matching flex-item phase. A tight `Flexible` allocation controls
the outer size directly, while overflowing descendants still need explicit
clipping or truncation.

### Why `flex-1` Needed Special Handling

**CSS `flex: 1`** = `flex: 1 1 0%`:
- `flex-grow: 1` - grow to fill space
- `flex-shrink: 1` - can shrink
- `flex-basis: 0%` - start from zero

**Flutter `flex: 1` + `FlexFit.tight`**:
- Allocates each child's complete outer extent proportionally
- Includes that child's padding and border inside its share

For an owned Tailwind flex container, mix_winds first lets `RenderFlex`
measure the line, then adjusts only the affected flex-factor ratios so the
second `RenderFlex` pass reserves each zero-basis item's non-content extent.
The stock path remains in use when the adjustment would not change the result.

---

## Known Limitations

The following Tailwind utilities have limited or no support in mix_winds due to fundamental differences between CSS and Flutter's layout system.

### Zero-basis Flex Overflow Boundary

The content-box adjustment delegates final sizing to `RenderFlex`, so it only
engages when the growing children's combined margin, padding, and border leave
positive content space. If those extents alone consume the line, mix_winds
falls back to Flutter's outer-box allocation instead of reproducing CSS's
overflowing minimum. Move padding and border to an inner `Div` when that narrow
boundary must match the browser exactly.

Interaction variants that change a flex item's margin, padding, or border width
after the container builds are not fed back into the container's distribution.
Keep those extents stable across hover/press/focus states, or put the changing
decoration on an inner `Div`.

This adapter corrects positive-space distribution for zero-basis growers; it
does not replace Flutter's flex algorithm wholesale. CSS min/max freezing and
scaled shrink-factor resolution remain subject to the existing Flutter
adaptations.

### Parser and Variant Adaptations

`mix_winds` parses Tailwind candidates with a registry generated from the Tailwind spec lab, then translates supported values directly into Mix stylers and runtime variants. Protocol representability is enforced in tests by encoding, strictly decoding, and canonically re-encoding a broad translator-output corpus through the development-only `mix_protocol` dependency.

Current adaptation policy:

| Tailwind feature | mix_winds behavior | Reason |
|---|---|---|
| `group-*`, `peer-*` variants | Parsed, ignored, reported through `onDiagnostic` | Flutter has no selector-relative group/peer state equivalent in this widget API. |
| Arbitrary selector variants like `[&_p]:mt-4` | Parsed, ignored, reported through `onDiagnostic` | Flutter widgets cannot target descendants by CSS selector. |
| Container query variants like `@...` | Parsed, ignored, reported through `onDiagnostic` | Container-query semantics remain in the widget/layout layer, not styler payloads. |
| `!important` prefix/suffix | Parsed, ignored, reported through `onDiagnostic` | Flutter/Mix has no CSS cascade priority model. |
| Arbitrary properties like `[color:red]` | Parsed, ignored, reported through `onDiagnostic` | They do not map safely to typed Mix styler fields. |
| `from`/`via`/`to` gradients | Accumulated into `LinearGradientMix` | Gradient outputs encode through `mix_protocol`, including CSS keyword directions. |
| `bg-*/50` alpha modifiers | Approximated with Flutter alpha | Flutter has no `color-mix()`/OKLAB equivalent for Tailwind's CSS output. |

### Compatibility Ledger Status Notes

The generated compatibility ledger records current behavior, including differences
that still require a 1.0 decision. A ledger entry is an accounting statement, not a
promise that the adaptation is final.

| Tailwind feature | Current mix_winds behavior |
|---|---|
| `active:` | Uses Mix's pressed widget state. |
| `focus-visible:` | Uses Mix's focus-visible state, driven by Flutter's app-wide focus-highlight modality rather than CSS's per-element focus heuristics. Any focus matches while highlight mode is traditional (keyboard and desktop-pointer input); nothing matches in touch modality. Desktop mouse-click focus can therefore match where CSS would not. |
| `dark:` | Uses Flutter platform brightness rather than a CSS selector strategy. |
| `light:` | A mix_winds parser-registry extension that uses Flutter platform brightness as the inverse of `dark:`. |
| `not-hover:` | Uses Mix's inverse-hover runtime state. This is partial support for Tailwind's compound `not` variant; other `not-*` forms remain unsupported and are reported through `onDiagnostic`. |
| `theme-midnight:` | Unsupported and reported through `onDiagnostic`; custom named theme variants require an explicit application-level design. |
| `2xl:` / `3xl:` | `2xl:` uses the standard Flutter breakpoint configuration. `3xl:` is not present in `TwConfig.standard().breakpoints`, so it is unsupported unless the runtime configuration and compatibility policy are extended together. |
| `w-auto` / `h-auto` | Clear the corresponding Flutter minimum and maximum constraints. This is the Flutter representation of automatic sizing, rather than CSS intrinsic layout. |
| `block` | Has no observable style or widget-layout implementation and is classified as unsupported. |

Responsive layout utilities such as `w-full`, `w-screen`, fractions, external
margin, negative margin handling, flex item parent data, axis, and gap remain
in `tw_widget.dart` because they depend on live Flutter constraints. Fixed,
fractional, full, and automatic widths are resolved from the element's active
responsive classes; `w-auto` and `h-auto` explicitly clear earlier fixed
constraints.

When the viewport width is positive, responsive decisions use it. If it is
unavailable or zero, widget-owned layout decisions inherit the enclosing Tw
flex's resolved responsive width, then fall back to local constraints when no
Tw flex scope exists. Nested Tw flex containers inherit that same width even
when their own allocated width is smaller. This keeps the margin a parent
reserves equal to the margin its child applies. Native `Row` and `Column`
parents retain local constraint fallback. Padding and border variants always
use the viewport width, matching Mix's breakpoint activation.
Intrinsic wrapping (`IntrinsicWidth` or `IntrinsicHeight`) of responsive margins
requires a positive viewport width or an enclosing Tw flex scope; without either,
margin selection needs layout constraints and cannot support intrinsic measurement.

### Actionable Elements

Use `Button` for HTML button counterparts instead of wrapping `Div` in another
gesture or interaction widget. It keeps hover, pressed, focus, focus-visible,
keyboard activation, disabled state, and fixed button semantics under one Mix
`Pressable`. A null `onPressed` disables it unless `onLongPress` supplies an
action. Its Tailwind margin is applied outside the border box, so margin is not
tappable and does not become part of the accessibility bounds. Keep structural
elements and non-button tags, including links, as `Div`.

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
- `translate-x-[50%]` is **unsupported** and reported through `onDiagnostic`

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
  reported through `onDiagnostic`
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
- `P` and heading margins support unprefixed positive utilities such as `mb-4`
  and configured viewport breakpoints such as `md:mb-4`
- `hover:m-4`, `dark:m-2`, `group-hover:m-4`, `@md:m-4`, and selector variants like `[&_p]:mt-4` are skipped instead of becoming unconditional margins
- CSS-semantic box wrappers such as `Div` have the same limitation for
  interactive and contextual margin variants
- Semantic widget compilation reports supported margin utilities with interactive
  variants as `widgetLayerVariantUnsupported`. `Div` and `Button` deliver this
  diagnostic through `onDiagnostic`.
- `TwParser.compileText` and `compileIcon` report this limitation for their
  supported external margins. Direct Box and Flex styler compilation retains
  supported margin variants because Mix can apply those variants.
- Ignored context, container, and selector variants retain their existing
  diagnostic categories.

**Workaround:**
```dart
// Apply interactive padding to a wrapping Div.
Div(
  classNames: 'p-2 hover:p-4',
  child: P(text: '...'),
)

// Or handle margin changes manually with StatefulWidget
```

**Why:** The widget applies external margin outside `StyleBuilder` to preserve the hit-test area.
The compiled layout plan selects viewport breakpoints. The layout plan does not
evaluate interactive or contextual margin variants, so the compiler reports their limitations.

---

## Limitations Summary Table

| Tailwind Feature | Status | Workaround |
|-----------------|--------|------------|
| `w-[50%]`, `h-[25%]` | ✗ Parsed but not applied | Use `w-1/2`, `h-1/4` fractions |
| `translate-x-1/2` | ✗ Not supported | Use pixel values |
| `translate-x-[50%]` | ✗ Unsupported | Use Flutter Transform |
| `basis-1/2`, `basis-full` | ✗ Unsupported; reported through `onDiagnostic` | Use `w-1/2 flex-none` |
| `bg-[rgb(...)]`, `bg-[hsl(...)]` | ✗ Not supported | Use CSS hex: `bg-[#rgb]`, `bg-[#rrggbb]`, or `bg-[#rrggbbaa]` |
| `hover:m-4` on semantic widgets | ✗ Unsupported; compiler reports the limitation | Apply padding to a wrapping `Div` |
