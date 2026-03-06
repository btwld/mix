# mix_lint

Mix Lint helps you enforce coding standards and best practices in Flutter apps using [Mix](https://github.com/virtuallyio/mix).

## Getting Started

Add `mix_lint` as a dev dependency:

```bash
dart pub add -d mix_lint
```

Enable the plugin in `analysis_options.yaml` (requires Dart ≥ 3.10 / Flutter ≥ 3.38):

```yaml
plugins:
  mix_lint: any
```

Enable individual lint rules:

```yaml
plugins:
  mix_lint:
    diagnostics:
      mix_avoid_defining_tokens_within_style: true
      mix_avoid_defining_tokens_within_scope: true
      mix_avoid_empty_variants: true
      mix_max_number_of_attributes_per_style: true
      mix_variants_last: true
      mix_mixable_styler_has_create: true
      mix_prefer_dot_shorthands: true
```

Then restart the analysis server (or your IDE) to pick up the new plugin.

## Suppressing diagnostics

Use standard `// ignore:` comments with the format `mix_lint/<rule_name>`:

```dart
// ignore: mix_lint/mix_variants_last
final style = BoxStyler().onHovered(x).paddingAll(16);
```

## Rules

### mix_avoid_defining_tokens_within_style

Ensure that `MixToken` instances are not created directly inside Styler method calls. Define tokens outside the style (e.g. top-level or as local constants), then pass them in.

Tokens are meant to be shared across the app. Creating them inline inside a Styler makes them local to that call and harder to reuse or reference elsewhere.

#### Don't

```dart
// Inline token inside a Styler
final style = BoxStyler()
    .color.ref(ColorToken('primary'))
    .borderRadiusTopLeft(RadiusToken('rounded')());
```

#### Do

```dart
final primary = ColorToken('primary');
final rounded = RadiusToken('rounded');

final style = BoxStyler()
    .color.ref(primary)
    .borderRadiusTopLeft(rounded());
```

### mix_avoid_defining_tokens_within_scope

Ensure that `MixToken` instances are not created directly inside `MixScope` constructors. Define tokens outside (e.g. top-level or as local constants), then use them as keys in the scope's maps.

The scope maps tokens to resolved values; the tokens themselves should already exist. Creating them inline makes them unreferenceable elsewhere and can lead to duplication.

#### Don't

```dart
MixScope(
  colors: {
    ColorToken('primary'): Colors.blue,
  },
  child: child,
);
```

#### Do

```dart
final primary = ColorToken('primary');

MixScope(
  colors: {
    primary: Colors.blue,
  },
  child: child,
);
```

### mix_avoid_empty_variants

Don't create a Styler that only has `.on` variant methods (e.g. `.onHovered`, `.onDark`, `.onPressed`). Always include base styling so the style has a default appearance; then add variants for overrides.

#### Don't

```dart
// Styler with only variant methods, no base style
final style = BoxStyler()
    .onHovered(BoxStyler().color(Colors.blue))
    .onPressed(BoxStyler().color(Colors.green));
```

#### Do

```dart
final style = BoxStyler()
    .color(Colors.grey)
    .onHovered(BoxStyler().color(Colors.blue))
    .onPressed(BoxStyler().color(Colors.green));
```

### mix_max_number_of_attributes_per_style

Limit the number of attributes per style. The default value is 15. This rule encourages keeping styles concise and focused; split large styles into smaller, reusable Stylers and compose with `merge()`.

The rule reports when a `Styler` constructor or a variant-style invocation has more than `max_number` arguments.

#### Don't

```dart
// One large style with too many arguments (exceeds max_number)
final style = BoxStyler()
    .color(Colors.blue)
    .paddingAll(8)
    .margin(.all(4))
    .alignment(.center)
    .borderRounded(8)
    .width(200)
    .height(100)
    .opacity(0.9)
    .onHovered(BoxStyler()
        .color(Colors.red)
        .paddingAll(12)
        .margin(.all(6))
        .borderRounded(10)
        .width(220)
        .height(120)
        .opacity(1.0));
```

#### Do

```dart
final layout = BoxStyler()
    .paddingAll(8)
    .margin(.all(4))
    .alignment(.center);

final appearance = BoxStyler()
    .color(Colors.blue)
    .borderRounded(8)
    .width(200)
    .height(100)
    .opacity(0.9);

final hovered = BoxStyler()
    .color(Colors.red)
    .paddingAll(12)
    .margin(.all(6))
    .borderRounded(10)
    .width(220)
    .height(120)
    .opacity(1.0);

final style = layout
    .merge(appearance)
    .onHovered(hovered);
```

#### Parameters

##### max_number (int)

The maximum number of attributes allowed per style (or per variant invocation). The default value is 15.

### mix_variants_last

Ensures that variant methods (`onHovered`, `onPressed`, `onFocused`, `onDisabled`, `onDark`, etc.) are placed at the bottom of the Styler chain, after all base styling methods. Mixing variant calls between base properties makes the style harder to read and reason about.

#### Don't

```dart
final style = BoxStyler()
    .color(Colors.red)
    .onHovered(.color(Colors.blue))
    .paddingAll(16)
    .borderRounded(8)
    .onPressed(.color(Colors.green));
```

#### Do

```dart
final style = BoxStyler()
    .color(Colors.red)
    .paddingAll(16)
    .borderRounded(8)
    .onHovered(.color(Colors.blue))
    .onPressed(.color(Colors.green));
```

### mix_prefer_dot_shorthands

Prefer Dart's dot shorthand syntax when calling static methods or constructors on types that can be inferred from context. Instead of writing the full type name (e.g. `EdgeInsetsGeometryMix.all(10)` or `TextStyler.color(...)`), use the leading dot (e.g. `.all(10)` or `.color(...)`). This keeps code concise and readable while remaining type-safe. Requires Dart 3.11 or later.

#### Don't

```dart
final style = BoxStyler()
    .padding(EdgeInsetsGeometryMix.all(10))
```

#### Do

```dart
final style = BoxStyler()
    .padding(.all(10))
```

### mix_mixable_styler_has_create

Ensures that every class annotated with `@MixableStyler` defines a named constructor `.create`. The generated Styler mixin and the rest of the Mix API expect this constructor for const instantiation, merging, and default styles (e.g. `const BoxStyler.create()`).

#### Don't

```dart
@MixableStyler()
class MyStyler extends Style<MySpec> with _$MyStylerMixin {
  final Prop<Color>? $color;

  MyStyler({Prop<Color>? color}) : $color = color;
}
```

#### Do

```dart
@MixableStyler()
class MyStyler extends Style<MySpec> with _$MyStylerMixin {
  final Prop<Color>? $color;

  const MyStyler.create({
    Prop<Color>? color,
    super.variants,
    super.modifier,
    super.animation,
  }) : $color = color;

  MyStyler({Color? color, ...}) : this.create(color: Prop.maybe(color), ...);
}
```
