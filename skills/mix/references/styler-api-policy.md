# Styler API Policy

Rules for static factory constructors on Styler classes and Dart 3.11+ dot-shorthand usage.

Requires Dart SDK >=3.11.0 and Flutter >=3.41.0.

## The Top-Level Rule

Start every top-level style declaration with an instance constructor, then chain:

```dart
// CORRECT — instance constructor at top-level
BoxStyler().color(Colors.blue).padding(.all(16))
TextStyler().fontSize(18).color(Colors.white)
IconStyler().size(24).color(Colors.red)
FlexBoxStyler().direction(.horizontal).spacing(8).padding(.all(16))
```

```dart
// Discouraged by policy at top-level, though valid API
BoxStyler.color(Colors.blue)

// WRONG — bare dot-shorthand at top-level
.color(Colors.blue)
```

## Nested Shorthand Rule

In typed contexts (variants, state callbacks, typed params), use bare shorthand without the type prefix:

```dart
// CORRECT — bare shorthand in nested contexts
style.onHovered(.color(Colors.blue))
style.onDark(.color(Colors.white))
style.onDisabled(.color(Colors.grey))
BoxStyler().color(Colors.blue)
  .onHovered(.shadow(.color(Colors.black12).blurRadius(10)))
```

```dart
// WRONG — explicit constructor in nested context
style.onHovered(BoxStyler().color(Colors.blue))
```

Common typed contexts:
- `.container(.shadow(...))`
- `.onHovered(.color(...))`
- `.onDisabled(.color(...))`

## Dot-Shorthand for Enum/Constant Arguments

Within chains, use Dart 3.11+ inferred shorthand for enum and constant values:

```dart
BoxStyler().alignment(.center)
FlexBoxStyler().mainAxisAlignment(.center)
StackBoxStyler().fit(.expand)
```

## Factory Constructors by Styler

Generated Styler factories are valid API, but this skill intentionally discourages top-level factory entry points in favor of `Styler().chain()` declarations. The factory surface is generated and can drift, so confirm against the local `*_spec.g.dart` file when exact coverage matters.

Common generated factories include:

| Styler | Common factory groups |
|---|---|
| `BoxStyler` | layout (`alignment`, `padding`, `margin`, constraints), decoration (`color`, `gradient`, `border`, `borderRadius`, `shadow`, `image`, `shape`), transforms (`transform`, `scale`, `rotate`, `translate`, `skew`), gradients/background images, `textStyle`, `animate` |
| `FlexStyler` | `direction`, `mainAxisAlignment`, `crossAxisAlignment`, `mainAxisSize`, `spacing`, row/column presets |
| `FlexBoxStyler` | generated flexbox spec fields plus many box-style factories; verify clip/flex naming in `flexbox_spec.g.dart` |
| `StackStyler` | `alignment`, `fit`, `clipBehavior` |
| `StackBoxStyler` | generated stackbox spec fields plus box-style factories; verify stack-specific names in `stackbox_spec.g.dart` |
| `TextStyler` | layout (`overflow`, `textAlign`, `maxLines`, `softWrap`, direction), typography (`style`, color/font/decoration/spacing), paint/shadow/font-feature fields, text directives (`uppercase`, `lowercase`, `capitalize`, `titlecase`, `sentencecase`) |
| `IconStyler` | `icon`, `color`, `size`, `weight`, `grade`, `opticalSize`, `fill`, `opacity`, `shadows`, `shadow`, `textDirection`, `applyTextScaling`, `blendMode` |
| `ImageStyler` | `image`, dimensions, `color`, `repeat`, `fit`, `alignment`, `centerSlice`, `filterQuality`, `colorBlendMode`, `gaplessPlayback`, `isAntiAlias`, `matchTextDirection` |

## Methods WITHOUT Factories (Chain-Only)

These are mid-chain or end-of-chain policy choices. Some may also have generated factories; still prefer chained usage in top-level declarations:

| Category | Methods |
|---|---|
| Compound spacing | `padding(.all(8))`, `padding(.horizontal(8))`, `padding(.vertical(8))`, `margin(.all(8))`, `margin(.horizontal(8))`, `margin(.vertical(8))`, `padding(.only(left: 8, right: 8))` |
| Compound border | `border(.all())`, `border(.top())`, `borderRadius(.circular())` |
| Compound box | `shadow(.color(...).blurRadius(...))`, `backgroundImageUrl` |
| Text directives | `uppercase`, `lowercase`, `capitalize`, `titlecase`, `sentencecase` |
| Variants | `onHovered`, `onPressed`, `onDark`, `onLight`, `onDisabled`, `onFocused`, `variant`, `onBreakpoint` |
| Advanced modifiers | `wrap`, `phaseAnimation`, `keyframeAnimation` |

**Rationale:** Factory constructors are reserved for primitives that map to stable style concepts. Compound convenience methods remain as instance methods to keep the static API focused.

## Composition Decision Tree

- Fixed size? → `BoxStyler().size(w, h)`
- Square? → `BoxStyler().size(s, s)` or `BoxStyler(constraints: BoxConstraintsMix.square(s))`
- Min/max bounds? → `BoxStyler().minWidth(100).maxWidth(300)`
- Pre-built Size/constraints? → Pass via constructor
- Combining fragments? → `merge()`
- Otherwise → Chain on the Styler instance

## Composition Examples

```dart
// Chaining (preferred for everyday use)
final style = BoxStyler().color(Colors.blue).padding(.all(16)).borderRadius(.circular(8));

// merge() for combining reusable fragments
final base = BoxStyler().padding(.all(16));
final elevated = BoxStyler().borderRadius(.circular(12));
final card = base.merge(elevated);

// Constructor for passing pre-built objects
final box = BoxStyler(constraints: BoxConstraintsMix.square(200));
```
