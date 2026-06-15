# Widget Modifiers & Directives

## Widget Modifiers

Modifiers wrap a widget with another widget (`Transform`, `Padding`, `Opacity`, etc.) without changing the styled widget API. Apply them with `.wrap()` on a Styler, or use convenience methods such as `BoxStyler().rotate(...)` when the Styler exposes them.

### Usage

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .wrap(WidgetModifierConfig.opacity(0.5))
    .wrap(WidgetModifierConfig.rotate(radians: 0.1));
```

### Built-in Modifiers

**File:** `packages/mix/lib/src/modifiers/widget_modifier_config.dart`

| Factory Method | Modifier | Effect |
|---------------|----------|--------|
| `.opacity(value)` | `OpacityModifier` | Widget opacity |
| `.blur(sigma)` | `BlurModifier` | Gaussian blur |
| `.aspectRatio(ratio)` | `AspectRatioModifier` | Aspect ratio constraint |
| `.clipOval()` | `ClipOvalModifier` | Oval clip |
| `.clipRect()` | `ClipRectModifier` | Rectangular clip |
| `.clipRRect(borderRadius: value)` | `ClipRRectModifier` | Rounded rectangle clip |
| `.clipPath(clipper: value)` | `ClipPathModifier` | Custom path clip |
| `.clipTriangle()` | `ClipTriangleModifier` | Triangle clip |
| `.transform(transform: matrix)` | `TransformModifier` | Matrix4 transform |
| `.scale(x: value, y: value)` | `ScaleModifier` | Scale using transform |
| `.rotate(radians: angle)` | `RotateModifier` | Rotation |
| `.translate(x: x, y: y)` | `TranslateModifier` | Translation |
| `.skew(skewX: x, skewY: y)` | `SkewModifier` | Skew |
| `.shaderMask(...)` | `ShaderMaskModifier` | Shader mask |
| `.visibility(visible)` | `VisibilityModifier` | Show/hide |
| `.align(alignment: value)` | `AlignModifier` | Alignment |
| `.padding(insets)` | `PaddingModifier` | Extra padding |
| `.sizedBox(width: value, height: value)` | `SizedBoxModifier` | Fixed size box |
| `.flexible(flex: value, fit: value)` | `FlexibleModifier` | Flex layout |
| `.rotatedBox(quarterTurns)` | `RotatedBoxModifier` | 90-degree rotations |
| `.intrinsicHeight()` / `.intrinsicWidth()` | `IntrinsicModifier` | Intrinsic sizing |
| `.fractionallySizedBox(...)` | `FractionallySizedBoxModifier` | Fractional sizing |
| `.defaultTextStyle(...)` | `DefaultTextStyleModifier` | Default Flutter text style |
| `.defaultTextStyler(style)` | `DefaultTextStylerModifier` | Inherited Mix text style |
| `.iconTheme(...)` | `IconThemeModifier` | Icon theme |

### Authoring Modifiers

Use `@MixableModifier()` from `mix_annotations` for new generated modifier APIs. Annotate the modifier class, include the generated `part`, and mix in `_$NameModifier`; the generator emits the `WidgetModifier` contract methods plus the matching `NameModifierMix`.

```dart
part 'opacity_modifier.g.dart';

@MixableModifier()
final class OpacityModifier with _$OpacityModifier {
  @override
  final double opacity;

  const OpacityModifier([double? opacity]) : opacity = opacity ?? 1.0;

  @override
  Widget build(Widget child) => Opacity(opacity: opacity, child: child);
}
```

Set `@MixableModifier(lerp: false)` when the modifier needs a custom `lerp()` implementation.

### Modifier Ordering

`WidgetModifierConfig` resolves modifiers in an outermost-to-innermost order. `RenderModifiers` reverses that list while building wrappers so the first configured type becomes the outside wrapper.

1. Context and behavior: `Flexible`, `Visibility`, `IconTheme`, `DefaultTextStyle`, `DefaultTextStyler`
2. Size establishment: `SizedBox`, `FractionallySizedBox`, `Intrinsic`, `AspectRatio`
3. Layout: `RotatedBox`, `Align`
4. Spacing: `Padding`
5. Visual effects: `Transform`/`Scale`/`Rotate`/`Translate`/`Skew`, clip modifiers, `Blur`/`Opacity`, `ShaderMask`

Set custom style-local ordering with `WidgetModifierConfig.orderOfModifiers([...])`:

```dart
final style = BoxStyler().wrap(
  WidgetModifierConfig.orderOfModifiers([OpacityModifier, PaddingModifier])
      .opacity(0.8)
      .padding(EdgeInsetsGeometryMix.all(16)),
);
```

`MixScope(orderOfModifiers: ...)` stores an inherited default for callers that explicitly read it, but modifier rendering uses the order in the resolved `WidgetModifierConfig`.

### Fluent Chaining

`WidgetModifierConfig` also supports fluent chaining:

```dart
final modifier = WidgetModifierConfig.opacity(0.8)
    .padding(EdgeInsetsGeometryMix.all(16))
    .rotate(radians: 0.1);
```

## Directives

Directives transform resolved values. Text directives are stored on `TextSpec.textDirectives`; Prop-based number and color directives are stored in `Prop.$directives`.

### TextStyler Directives

Applied to the `String` rendered by `StyledText`:

| Method | Effect |
|--------|--------|
| `.uppercase()` | HELLO WORLD |
| `.lowercase()` | hello world |
| `.capitalize()` | Hello world |
| `.titlecase()` | Hello World |
| `.sentencecase()` | Hello world (first letter) |

```dart
final style = TextStyler().uppercase();

StyledText('hello world', style: style);
// or
TextStyler().uppercase()('hello world');
```

### Prop Number Directives

Applied to `Prop<T extends num>` and returned as `Prop<num>`:

| Method | Effect |
|--------|--------|
| `.multiply(factor)` | `value * factor` |
| `.add(amount)` | `value + amount` |
| `.subtract(amount)` | `value - amount` |
| `.divide(divisor)` | `value / divisor` |
| `.clamp(min, max)` | Clamp to range |
| `.abs()` | Absolute value |
| `.round()` | Round to nearest int |
| `.floor()` | Floor |
| `.ceil()` | Ceiling |
| `.scale(factor)` | Alias for multiply |

```dart
final value = Prop.value(10.0).multiply(2).add(4);
```

### Color Token Directives

`ColorRef` exposes channel methods that return a color token reference with directives attached:

| Method | Effect |
|--------|--------|
| `.withValues(alpha:, red:, green:, blue:, colorSpace:)` | Override multiple channels |
| `.withAlpha(value)` | Override alpha channel |
| `.withRed(value)` / `.withGreen(value)` / `.withBlue(value)` | Override one RGB channel |
| `.withOpacity(value)` | Set alpha from opacity |

```dart
final $primary = ColorToken('primary');
final style = BoxStyler().color($primary().withOpacity(0.7));
```

### How Directives Work

Prop directives are applied after value resolution:

```dart
// During resolution:
// value -> resolve sources -> apply Prop directives -> return
```

Text directives are applied by `StyledText` to the resolved string. Directives from merged Props or Stylers are combined and applied in order.
