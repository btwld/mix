# Styler API policy

Preferred authoring spellings for current Dart 3.12+ Mix APIs. Confirm the
consuming project's SDK and resolved Mix version. A preference does not deprecate
another valid constructor or factory.

## The top-level rule

Start ordinary declarations with a concrete instance, then chain:

```dart
final card = BoxStyler().color(Colors.blue).padding(.all(16));
final title = TextStyler().fontSize(18).fontWeight(.bold);
```

Generated factories remain valid API. Consult `*_spec.g.dart` for exact coverage;
there is no maintained factory inventory here. For Grid, use an explicitly
typed initializer so required topology is visible:

```dart
final GridBoxStyler grid = .equalColumns(3).gap(16);
```

`final grid = .equalColumns(3)` lacks a contextual type.

## Nested shorthand

Use bare shorthand where the expected type is known:

```dart
card.onHovered(.color(Colors.blue.shade700));
BoxStyler().border(.top(.color(Colors.grey).width(2)));
```

Dart shorthand resolves against the **argument's type**. Flutter class constants
whose target is a primitive stay qualified:
`strokeAlign(BorderSide.strokeAlignOutside)` takes a `double`, so
`strokeAlign(.strokeAlignOutside)` is invalid.

## Compound and nullable values

For uniform known borders, prefer `.border(.color(c).width(w).style(s))`.
Use a side wrapper for a specific side, a reusable side, or nullable forwarding:

```dart
BoxStyler().border(.top(.color(Colors.grey).width(2)));
BoxStyler().border(.all(sharedSide));
BoxStyler().border(.all(BorderSideMix(color: color, width: width)));
```

Known nested values chain; nullable inputs use explicit constructors. Do not
rewrite nullables into non-null setters or recommend `.new(...)` as the normal
style. Grouped factories remain available for nullable fields.

Where the styler exposes a property, set it there:
`.minWidth(100).maxWidth(300)`. Use `.constraints(existing)` for a prebuilt value.
Factory/static methods start a value; instance methods extend it. These are
complementary surfaces. Keep a subtype selector where nested shorthand needs it.
Text directives, for example `TextStyler.uppercase`, can have factories too;
there is no general rule that compound methods are chain-only.

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


## Composition decision tree

- One style: chain on a concrete styler.
- Reusable independent fragments: `base.merge(patch)`.
- Prebuilt constraints/Mix values: pass the value rather than reconstructing it.
- Nullable grouped inputs: preserve fallback semantics with explicit constructors.
- A layout choice: see [Layout](layout.md).

Plain values replace; partial Mix values accumulate fields. See the
[fluent reference](fluent-api.md) for a merge example and interactions.
