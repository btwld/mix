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

### Available wrappers

`WidgetModifierConfig` includes opacity/blur/shader masks, clips, transforms,
alignment/padding, size/aspect/intrinsic/fractional sizing, Flexible, visibility,
and inherited text/icon defaults. Read its declaration for exact signatures;
the complete generated surface is not duplicated here. Blur defaults to
`TileMode.clamp`; use `TileMode.decal` for soft glows when appropriate.

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

Resolution concatenates style-local ordering, the nearest
`MixScope(orderOfModifiers: ...)` list, and package defaults, keeping the first
occurrence of each type. Local ordering takes priority; scoped types absent
from the local list retain their order after it. Remaining configured types
append stably.

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

Arithmetic methods include multiply/add/subtract/divide, clamp, abs,
round/floor/ceil and scale (multiply alias). Check the result type when an API
requires a specific numeric Prop.

```dart
final value = Prop.value(10.0).multiply(2).add(4);
```

### Color Token Directives

`ColorRef` exposes channel methods that return a color token reference with directives attached:

Channel methods include `withValues`, `withAlpha`, RGB setters and
`withOpacity`; they attach directives to the token reference.

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
