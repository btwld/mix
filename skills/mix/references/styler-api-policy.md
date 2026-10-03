# Styler API Policy

Rules for static factory constructors on Styler classes and Dart 3.12+ dot-shorthand usage.

## Table of Contents

- [Top-level rule](#the-top-level-rule)
- [Nested shorthand](#nested-shorthand-rule)
- [Enum shorthand](#dot-shorthand-for-enumconstant-arguments)
- [Factory constructors](#factory-constructors-by-styler)
- [Chain-only methods](#methods-without-factories-chain-only)
- [Preferred spelling](#preferred-spelling)
- [Retired conveniences](#retired-conveniences)
- [Composition](#composition-decision-tree)

Requires Dart SDK >=3.12.0 and Flutter >=3.44.0.

## Terminal Pressable Builders

When a Mix styler owns the interactive surface, compose its appearance first,
then call `.pressable()` with no arguments. The returned immutable builder is
callable and accepts the content plus the full `Pressable` interaction surface:

```dart
final save = BoxStyler()
    .padding(.all(16))
    .onPressed(.scale(0.96))
    .pressable();

save(onPress: submit, child: const StyledText('Save'));
TextStyler().fontSize(18).pressable()('Settings', onPress: openSettings);
IconStyler().size(24).pressable()(
  icon: Icons.star,
  semanticLabel: 'Favorite',
  onPress: toggleFavorite,
);
ImageStyler().fit(.cover).pressable()(
  image: provider,
  semanticsLabel: 'Open photo',
  onPress: openPhoto,
);
```

This is a terminal boundary: builders expose no styling methods and do not
support a second `.pressable()`. Reuse a builder for independent calls, and
provide callbacks, focus nodes, and controllers per call. Use direct
`Pressable` when the surface contains arbitrary widget trees or nested controls.
The callable builder API is only available in the unreleased revision that
introduces it; published dependency examples should retain direct
`Pressable`/`PressableBox` forms until that release.

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
| Compound spacing | `padding(.all(8))`, `padding(.horizontal(8).left(4))`, `padding(.start(8).end(16))`, `margin(.start(8).end(16))`. `.only` / `.directional` receive concrete sides after the caller resolves fallbacks |
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

## Preferred spelling

Direct property chains come first. A structural wrapper is for geometry, scope, or an already-built Mix value.

```dart
// Uniform border — properties sit on the border
BoxStyler().border(.color(c).width(w).style(s).strokeAlign(a))

// Geometry
BoxStyler().padding(.all(16))
BoxStyler().borderRadius(.all(radius))

// Scope: top only. Do not lift color/width onto the border.
BoxStyler().border(.top(.color(c).width(2)))

// Reuse a side that already exists
BoxStyler().border(.all(sharedSide))
```

```dart
// Avoid as the canonical example — .all adds no geometry here
BoxStyler().border(.all(.color(c).width(w)))
```

Do not recommend `.new(...)` as Mix style. Ordinary code uses factories and chains. When a field may be null, use the explicit constructor, then apply it:

```dart
final side = BorderSideMix(
  color: color,
  width: width,
  style: style,
  strokeAlign: strokeAlign,
);
BoxStyler().border(.all(side));

BoxStyler().shadow(BoxShadowMix(
  color: color,
  offset: offset,
  blurRadius: blurRadius,
  spreadRadius: spreadRadius,
));
```

Known, non-null nested values chain inside the value. Grouped factories stay available when inputs are nullable; they are not deprecated.

```dart
// Known
padding(.start(8).end(16))
margin(.start(8).end(16))

// Nullable or grouped — resolve each side first. .only and .directional
// take concrete values and do not apply horizontal/vertical fallback.
padding(.only(
  left: left ?? horizontal,
  right: right ?? horizontal,
  top: top ?? vertical,
  bottom: bottom ?? vertical,
))
```

Where the Styler already exposes the property, set it there. Keep the nested setter for a prebuilt value.

```dart
BoxStyler().minWidth(100).maxWidth(300)
BoxStyler().constraints(existingConstraints)
```

Direct text and decoration setters follow the same split: inline authoring uses the Styler property; the lower-level value stays valid for reuse.

Factory and static constructors start a value. Instance methods extend one that already exists. Those pairs are not duplicates. Keep a subtype selector when the nested shorthand needs that type, as gradient subtype selectors do.

Preferring one spelling does not deprecate the other. Deprecation and removal are separate decisions.

## Retired Conveniences

These one-line shorthands are deprecated and will be removed in Mix 3.0. Write the dot-shorthand call instead; token arguments pass through unchanged (`.padding(.all($spaceLg()))`).

| Deprecated | Write instead |
|---|---|
| `paddingAll(v)`, `paddingX(v)`, `paddingY(v)` | `padding(.all(v))`, `padding(.horizontal(v))`, `padding(.vertical(v))` |
| `paddingTop(v)`, `paddingLeft(v)`, `paddingStart(v)`, … | `padding(.top(v))`, `padding(.left(v))`, `padding(.start(v))`, … |
| `paddingOnly(...)` | Physical, broad setter first: `padding(.horizontal(8).left(4))`. `start`/`end` are peers, either order: `padding(.start(4).end(16))`. Nullables: resolve each side, then `.only` or `.directional` |
| `marginAll(v)`, `marginTop(v)`, `marginOnly(...)`, … | Same split as padding. Broad setter first only for horizontal/vertical plus a physical side. `start`/`end` are peers |
| `borderRounded(x)`, `borderRoundedTop(x)`, … | `borderRadius(.circular(x))`, `borderRadius(.top(.circular(x)))`, … |
| `borderRadiusAll(r)`, `borderRadiusTopLeft(r)`, … | `borderRadius(.all(r))`, `borderRadius(.topLeft(r))`, … |
| `borderAll(...)`, `borderTop(...)`, … | Known: `border(.color(c).width(w).style(s).strokeAlign(a))`, `border(.top(.color(c).width(w).style(s).strokeAlign(a)))`. Nullables: `border(.all(BorderSideMix(color: color, width: width, style: style, strokeAlign: strokeAlign)))`, `border(.top(BorderSideMix(...)))` |
| `shapeCircle(...)`, `shapeStadium(...)`, … | `shape(.circle(...))`, `shape(.stadium(...))`, … |
| `constraintsOnly(...)` | Known, broad then specific: `width(200).minWidth(100)`. Nullables: `constraints(BoxConstraintsMix(minWidth: minWidth ?? width, maxWidth: maxWidth ?? width, minHeight: minHeight ?? height, maxHeight: maxHeight ?? height))`. Prebuilt: `constraints(existing)` |
| `shadowOnly(...)`, `boxShadows(v)`, `boxElevation(v)` | Known: `shadow(.color(c).offset(x: x, y: y).blurRadius(b).spreadRadius(s))`. Null offset: `shadow(BoxShadowMix(...))`. `shadows(v)`, `elevation(v)` |
| `transformReset()` | `transform(.identity())` (default alignment stays `Alignment.center`) |

`paddingOnly` / `marginOnly` resolve each side on its own:

- `left = left ?? horizontal`
- `right = right ?? horizontal`
- `top = top ?? vertical`
- `bottom = bottom ?? vertical`
- If `start` or `end` is set, the result is directional: `start = start ?? left ?? horizontal`, `end = end ?? right ?? horizontal`, with the top and bottom values above.
- Otherwise pass those four concretes to `.only(...)`. `.only` and `.directional` do not apply horizontal or vertical fallback themselves.
- A chain matches only with the broad setter first: `padding(.horizontal(8).left(4))` equals `paddingOnly(horizontal: 8, left: 4)`. `padding(.left(4).horizontal(8))` lets `horizontal` overwrite left. The same order applies to `.vertical(...).top(...)` and to margin.
- `start` / `end` stay directional in RTL. Physical `left` / `right` do not flip.

`constraintsOnly` resolves each bound on its own:

- `minWidth = minWidth ?? width`
- `maxWidth = maxWidth ?? width`
- `minHeight = minHeight ?? height`
- `maxHeight = maxHeight ?? height`
- Known values chain with the broad setter first: `width(200).maxWidth(320)` keeps min width at 200. `maxWidth(320).width(200)` lets `width` replace both bounds and does not match.

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
