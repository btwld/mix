# Styler API Policy

Rules for static factory constructors on Styler classes and Dart 3.12+ dot-shorthand usage.

## Table of Contents

- [Top-level rule](#the-top-level-rule)
- [Nested shorthand](#nested-shorthand-rule)
- [Enum shorthand](#dot-shorthand-for-enumconstant-arguments)
- [Factory constructors](#factory-constructors-by-styler)
- [Chain-only methods](#methods-without-factories-chain-only)
- [Composition](#composition-decision-tree)

Requires Dart SDK >=3.12.0 and Flutter >=3.44.0.

## The Top-Level Rule

Start ordinary top-level style declarations with an instance constructor, then chain:

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

Use an explicitly typed factory initializer when the factory communicates
required topology better than an empty constructor. Grid is the deliberate
case in the current API:

```dart
// CORRECT — the declared type supplies shorthand context
final GridBoxStyler cards = .equalColumns(3)
    .gap(16)
    .autoRows(.auto());

// WRONG — no contextual type for the leading shorthand
final cards = .equalColumns(3);
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
- explicitly typed initializers such as `final GridBoxStyler grid = .columns(...)`
- `.container(.shadow(...))`
- `.onHovered(.color(...))`
- `.onDisabled(.color(...))`
- `.onConstraints(.maxWidth(600), .equalColumns(1))`

## Dot-Shorthand for Enum/Constant Arguments

Within chains, use Dart 3.12+ inferred shorthand for enum and constant values:

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
| `WrapStyler` | `direction`, `alignment`, `spacing`, `runAlignment`, `runSpacing`, `crossAxisAlignment`, `clipBehavior` |
| `WrapBoxStyler` | generated wrapbox fields plus Box factories; use collision-safe `wrapAlignment` and `wrapClipBehavior` for the inner Wrap |
| `GridBoxStyler` | handwritten `columns`, `equalColumns`, `rows`, `autoRows`, gaps, `clipBehavior`, `onConstraints`, `animate` |
| `StackStyler` | `alignment`, `fit`, `clipBehavior` |
| `StackBoxStyler` | generated stackbox fields plus Box factories; use `stackAlignment` and `stackClipBehavior` for the inner Stack |
| `TextStyler` | layout (`overflow`, `textAlign`, `maxLines`, `softWrap`, direction), typography (`style`, color/font/decoration/spacing), paint/shadow/font-feature fields, text directives (`uppercase`, `lowercase`, `capitalize`, `titlecase`, `sentencecase`) |
| `IconStyler` | `icon`, `color`, `size`, `weight`, `grade`, `opticalSize`, `fill`, `opacity`, `shadows`, `shadow`, `textDirection`, `applyTextScaling`, `blendMode` |
| `ImageStyler` | `image`, dimensions, `color`, `repeat`, `fit`, `alignment`, `centerSlice`, `filterQuality`, `colorBlendMode`, `gaplessPlayback`, `isAntiAlias`, `matchTextDirection` |

## Methods WITHOUT Factories (Chain-Only)

These are mid-chain or end-of-chain policy choices. Some may also have generated factories; still prefer chained usage in top-level declarations:

| Category | Methods |
|---|---|
| Compound spacing | `padding(.all(8))`, `padding(.horizontal(8))`, `padding(.vertical(8))`, `margin(.all(8))`, `margin(.horizontal(8))`, `margin(.vertical(8))`, `padding(.only(left: 8, right: 8))` |
| Compound border | `border(.color(...).width(...))`, `border(.all())`, `border(.top())`, `borderRadius(.circular())` |
| Compound box | `shadow(.color(...).blurRadius(...))`, `backgroundImageUrl` |
| Text directives | `uppercase`, `lowercase`, `capitalize`, `titlecase`, `sentencecase` |
| Variants and local constraints | `onHovered`, `onPressed`, `onDark`, `onLight`, `onDisabled`, `onFocused`, `variant`, `onBreakpoint`, Grid `onConstraints` |
| Advanced modifiers | `wrap`, `phaseAnimation`, `keyframeAnimation` |

**Rationale:** Factory constructors are reserved for primitives that map to stable style concepts. Compound convenience methods remain as instance methods to keep the static API focused.

### Uniform borders skip the side wrapper

`BoxBorderMix` exposes `color`, `width`, `style`, and `strokeAlign` statics that each build an all-sides border — `BoxBorderMix.color(v)` is defined as `BorderMix.all(BorderSideMix.color(v))`. So a border that is the same on every side needs no side wrapper:

```dart
// CORRECT — uniform border, side properties straight off border()
BoxStyler().border(.color(Colors.grey).width(1))

// Redundant — .all() wrapping a side that is then built anyway
BoxStyler().border(.all(.color(Colors.grey).width(1)))
```

Reach for `.all(...)`, `.top(...)`, and friends when the side wrapper earns its place:

```dart
// A specific side
BoxStyler().border(.top(.color(Colors.grey).width(1)))

// Forwarding optional values — the chained setters take non-nullable arguments,
// so a wrapper that passes nullables through needs the constructor
BoxStyler().border(.all(BorderSideMix(color: color, width: width)))

// A prebuilt side reused across several borders
BoxStyler().border(.all(sharedSide))
```

Constants that live on a Flutter class stay qualified, because dot shorthand resolves against the *parameter's* type. `strokeAlign` takes a `double`, so `.strokeAlignOutside` does not resolve:

```dart
// CORRECT
border(.color(c).strokeAlign(BorderSide.strokeAlignOutside))

// WRONG — the context type is double, not BorderSide
border(.color(c).strokeAlign(.strokeAlignOutside))
```

## Composition Decision Tree

- Fixed size? → `BoxStyler().size(w, h)`
- Square? → `BoxStyler().size(s, s)` or `BoxStyler(constraints: BoxConstraintsMix.square(s))`
- Min/max bounds? → `BoxStyler().minWidth(100).maxWidth(300)`
- Pre-built Size/constraints? → Pass via constructor
- Combining fragments? → `merge()`
- Choosing a multi-child layout? → Use the decision guide in [`layout.md`](layout.md)
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
