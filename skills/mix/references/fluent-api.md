# Fluent API

Chaining patterns, style mixins, and composition in Mix.

## Core Principle

Prefer fluent chaining on Styler types. Each setter returns a new merged instance:

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .paddingAll(16)
    .borderRounded(8)
    .width(200);
```

Generated primitive setters merge a new Styler with the changed field. Convenience methods may delegate to lower-level setters or add widget modifiers.

## Style Mixins

Stylers mix in convenience methods. All methods are available on the corresponding Styler.

### SpacingStyleMixin

Padding and margin shortcuts:

| Method | Description |
|--------|-------------|
| `paddingAll(v)` | All sides |
| `paddingX(v)` / `paddingY(v)` | Horizontal / vertical |
| `paddingTop(v)`, `paddingBottom(v)`, `paddingLeft(v)`, `paddingRight(v)` | Individual sides |
| `paddingStart(v)` / `paddingEnd(v)` | RTL-aware |
| `paddingOnly(...)` | Named parameters for any combination |
| `marginAll(v)` | All margin sides |
| `marginTop(v)`, etc. | Individual margin sides |
| `marginOnly(...)` | Named margin parameters |

### DecorationStyleMixin

Decoration, color, gradient, border, shadow, shape, background image:

| Method | Description |
|--------|-------------|
| `color(v)` | Background color |
| `gradient(v)` | Gradient fill |
| `border(v)` | Border (BoxBorderMix) |
| `borderRadius(v)` | Border radius (BorderRadiusGeometryMix) |
| `shadow(v)` / `shadows(v)` | Box shadow(s) |
| `elevation(v)` | Elevation shadow preset |
| `image(v)` | Decoration image |
| `shape(v)` | Shape border |
| `shapeCircle()`, `shapeStadium()`, `shapeRoundedRectangle()`, etc. | Shape shortcuts |
| `backgroundImage(image)`, `backgroundImageUrl(url)`, `backgroundImageAsset(path)` | Background image utilities |
| `linearGradient(...)`, `radialGradient(...)`, `sweepGradient(...)` | Gradient shortcuts |
| `foregroundLinearGradient(...)`, etc. | Foreground gradient shortcuts |

### BorderStyleMixin

| Method | Description |
|--------|-------------|
| `borderAll(...)` | All sides: `color`, `width`, `style`, `strokeAlign` |
| `borderTop(...)`, `borderBottom(...)`, `borderLeft(...)`, `borderRight(...)` | Individual sides |
| `borderStart(...)` / `borderEnd(...)` | RTL-aware |
| `borderVertical(...)` / `borderHorizontal(...)` | Grouped sides |

### BorderRadiusStyleMixin

| Method | Description |
|--------|-------------|
| `borderRounded(radius)` | Uniform circular radius (most common) |
| `borderRadiusAll(radius)` | All corners with `Radius` |
| `borderRadiusTop(r)`, `borderRadiusBottom(r)` | Top/bottom grouped |
| `borderRadiusLeft(r)`, `borderRadiusRight(r)` | Left/right grouped |
| `borderRadiusTopLeft(r)`, `borderRadiusTopRight(r)`, etc. | Individual corners |
| `borderRadiusTopStart(r)`, `borderRadiusTopEnd(r)`, etc. | RTL-aware corners |
| `borderRoundedTop(r)`, `borderRoundedBottom(r)`, etc. | Circular grouped |

### ConstraintStyleMixin

| Method | Description |
|--------|-------------|
| `width(v)` / `height(v)` | Fixed dimension |
| `size(w, h)` | Both dimensions |
| `minWidth(v)` / `maxWidth(v)` | Width constraints |
| `minHeight(v)` / `maxHeight(v)` | Height constraints |
| `constraintsOnly(...)` | Named parameters for any combination |

### ShadowStyleMixin

| Method | Description |
|--------|-------------|
| `shadowOnly(...)` | Single shadow with `color`, `offset`, `blurRadius`, `spreadRadius` |
| `boxShadows(v)` | List of BoxShadowMix |
| `boxElevation(v)` | ElevationShadow preset |

### TransformStyleMixin

| Method | Description |
|--------|-------------|
| `transform(matrix, {alignment})` | Raw Matrix4 |
| `rotate(angle, {alignment})` | Rotation in radians |
| `scale(factor, {alignment})` | Uniform scale |
| `translate(x, y, [z])` | Translation |
| `skew(skewX, skewY)` | Skew |
| `transformReset()` | Reset to identity |

### FlexStyleMixin (on FlexStyler/FlexBoxStyler)

`RowBox` and `ColumnBox` are widgets backed by `FlexBoxStyler`; there are no separate `RowBoxStyler` or `ColumnBoxStyler` classes.

| Method | Description |
|--------|-------------|
| `direction(axis)` | Flex direction |
| `mainAxisAlignment(v)` | Main axis alignment |
| `crossAxisAlignment(v)` | Cross axis alignment |
| `mainAxisSize(v)` | Main axis sizing |
| `spacing(v)` | Gap between children |
| `row()` / `column()` | Direction shortcuts |

### TextStyleMixin (on TextStyler)

| Method | Description |
|--------|-------------|
| `color(v)`, `fontSize(v)`, `fontWeight(v)`, `fontStyle(v)` | Basic text styling |
| `letterSpacing(v)`, `wordSpacing(v)`, `height(v)` | Spacing |
| `decoration(v)`, `decorationColor(v)`, `decorationStyle(v)` | Text decoration |
| `fontFamily(v)`, `fontFamilyFallback(v)` | Font selection |
| `shadows(v)`, `fontFeatures(v)`, `fontVariations(v)` | Advanced |

`IconStyler` and `ImageStyler` expose their common generated field setters too; see the `IconStyler` and `ImageStyler` rows in [`styler-api-policy.md`](styler-api-policy.md).

## Sizing Decision Tree

See [`styler-api-policy.md`](styler-api-policy.md) for the canonical sizing and composition decision tree.

## Composition via Merge

Use `merge()` for combining reusable style fragments; see [`styler-api-policy.md`](styler-api-policy.md) for the reference example. Later replacement values override earlier ones, while Mix values merge field-by-field before resolving.

## Callable Stylers

Widget-backed Stylers support `call()` for inline widget creation. This includes `BoxStyler`, `TextStyler`, `IconStyler`, `ImageStyler`, `FlexBoxStyler`, and `StackBoxStyler`; layout-only stylers such as `FlexStyler` and `StackStyler` do not create widgets directly.

```dart
BoxStyler().color(Colors.blue).paddingAll(16)(child: Text('Hello'))
// Equivalent to: Box(style: BoxStyler()..., child: Text('Hello'))
```
