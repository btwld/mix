# mix_annotations

[![Pub Version](https://img.shields.io/pub/v/mix_annotations?label=version&style=for-the-badge)](https://pub.dev/packages/mix_annotations/changelog)
[![MIT Licence](https://img.shields.io/github/license/leoafarias/mix?style=for-the-badge&longCache=true)](https://opensource.org/licenses/mit-license.php)

Annotations used by [mix_generator](https://pub.dev/packages/mix_generator) to generate boilerplate code for the [Mix](https://pub.dev/packages/mix) styling framework.

## Installation

```bash
flutter pub add mix_annotations
```

This package is typically used alongside `mix` and `mix_generator`:

```yaml
dependencies:
  mix: ^2.0.0
  mix_annotations: ^2.0.0

dev_dependencies:
  build_runner: ^2.4.0
  mix_generator: ^2.0.0
```

## Annotations

### `@MixableSpec`

Generates a self-contained `_$<Name>` mixin for Spec classes (immutable style data). The mixin declares `implements Spec<T>, Diagnosticable` and inlines `type`, `copyWith`, `lerp`, `props`, `==`, `hashCode`, `toString`, `toDiagnosticsNode`, and `debugFillProperties` — so the user class needs a single `with` to be a fully-formed Spec.

```dart
@MixableSpec()
final class BoxSpec with _$BoxSpec {
  @override
  final Color? color;
  @override
  final double? width;

  const BoxSpec({this.color, this.width});
}
```

The generated mixin `_$BoxSpec` is the only thing the user class mixes in — `Equatable`-style equality (via `propsEquals` / `propsHash` helpers) and `Diagnosticable`'s concrete surface are inlined by the generator, not pushed onto the user.

Control which methods are generated via `GeneratedSpecMethods` flags:

```dart
@MixableSpec(methods: GeneratedSpecMethods.skipLerp)
```

### `@MixableStyler`

Generates a mixin for Styler classes (mutable builders) with setter methods, `merge()`, `resolve()`, `debugFillProperties()`, `props`, and `call()`.

```dart
@MixableStyler()
class BoxStyler extends Style<BoxSpec>
    with Diagnosticable, ..., _$BoxStylerMixin {
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<Color>? $color;

  // ...
}
```

Control which methods are generated via `GeneratedStylerMethods` flags:

```dart
@MixableStyler(methods: GeneratedStylerMethods.skipCall)
```

### `@Mixable`

Generates a mixin for Mix classes (compound property types) with `merge()`, `resolve()`, `props`, and `debugFillProperties()`.

```dart
@Mixable()
final class BoxConstraintsMix extends ConstraintsMix<BoxConstraints>
    with DefaultValue<BoxConstraints>, Diagnosticable, _$BoxConstraintsMixMixin {
  final Prop<double>? $minWidth;
  final Prop<double>? $maxWidth;

  // ...
}
```

### `@MixWidget`

Generates a thin public `StatelessWidget` wrapper from a top-level Mix styler declaration.

```dart
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'card_styles.g.dart';

@MixWidget()
final cardStyle = BoxStyler()
    .paddingAll(16)
    .borderRounded(12);
```

This generates a `Card` widget that instantiates Mix's `Box` renderer:

```dart
class Card extends StatelessWidget {
  final Widget? child;

  const Card({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Box(key: key, style: cardStyle, child: child);
  }
}
```

Text stylers expose positional text because `StyledText` does:

```dart
@MixWidget()
final headingStyle = TextStyler()
    .fontSize(24)
    .fontWeight(FontWeight.w700);
```

```dart
class Heading extends StatelessWidget {
  final String text;

  const Heading(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return StyledText(text, key: key, style: headingStyle);
  }
}
```

The wrapper API comes from Mix renderer widget constructors matched by
canonical analyzer type identity. The generator does not inspect styler
`call()` methods for wrapper parameters.

Use a function-backed style when the generated component should accept style
inputs:

```dart
@MixWidget()
BoxStyler chipStyle({BoxStyler? style}) {
  return BoxStyler()
      .paddingAll(8)
      .borderRounded(999)
      .merge(style);
}
```

Factory parameters become generated widget constructor parameters and are
passed back to the factory.

```dart
class Chip extends StatelessWidget {
  final Widget? child;
  final BoxStyler? style;

  const Chip({super.key, this.child, this.style});

  @override
  Widget build(BuildContext context) {
    return Box(key: key, style: chipStyle(style: style), child: child);
  }
}
```

Mix-owned specs (`BoxSpec`, `TextSpec`, `FlexBoxSpec`, `IconSpec`,
`ImageSpec`, `StackBoxSpec`) ship with `@MixWidgetRenderer` annotations,
so applying `@MixWidget()` to a built-in styler renders through the right
widget automatically.

For custom design-system widgets, declare the renderer once on the spec
class:

```dart
@MixWidgetRenderer(Button)
class ButtonSpec extends Spec<ButtonSpec> {
  const ButtonSpec();
}

class ButtonStyler extends Style<ButtonSpec> {
  const ButtonStyler();
  ButtonStyler color(Color value) => this;
  ButtonStyler merge(ButtonStyler? other) => this;
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.style,
    required this.onPressed,
    required this.child,
  });

  final ButtonStyler style;
  final VoidCallback onPressed;
  final Widget child;
}

@MixWidget()
ButtonStyler primaryButtonStyle({Color color = Colors.blue}) {
  return ButtonStyler().color(color);
}
```

The generated `PrimaryButton` constructs `Button(...)` directly, mirroring
`Button`'s constructor (excluding `key`, `style`, `styleSpec`). Visual
variants belong in the styler or style factory.

The renderer widget needs only a `style:` named parameter assignable from
the styler's `Style<TSpec>`. It does not need to extend `StyleWidget` or
carry any annotation of its own. Specs without `@MixWidgetRenderer` produce
a clear codegen error.

`@MixWidget` currently supports top-level `final` variables and top-level
functions only. Function-backed declarations prepend their own public factory
parameters before renderer parameters so inputs can shape the generated base
style.

A top-level style function may take `BuildContext context` as its first required
positional parameter. The generated wrapper injects the build context from
`build()` and does not expose it as a constructor argument.

### `@MixableField`

Configures code generation for individual fields in Styler classes.

```dart
// Skip setter generation for this field
@MixableField(ignoreSetter: true)
final Prop<Matrix4>? $transform;

// Override the setter parameter type
@MixableField(setterType: List<Shadow>)
final Prop<List<Shadow>>? $shadows;
```

## Generator Flags

Each annotation accepts bitwise flags to control which methods or components are generated:

| Class | Available Flags |
|---|---|
| `GeneratedSpecMethods` | `copyWith`, `equals`, `lerp` |
| `GeneratedStylerMethods` | `setters`, `merge`, `resolve`, `debugFillProperties`, `props`, `call` |
| `GeneratedMixMethods` | `merge`, `resolve`, `props`, `debugFillProperties` |

Use `all` (default) to generate everything, or `skip*` helpers to exclude specific methods:

```dart
GeneratedSpecMethods.skipLerp      // all except lerp
GeneratedStylerMethods.skipCall    // all except call
GeneratedMixMethods.skipResolve    // all except resolve
```

## Code Generation

After annotating your classes, run `build_runner` to generate code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Or within the Mix monorepo:

```bash
melos run gen:build
```

## Learn More

- [Mix documentation](https://www.fluttermix.com)
- [mix](https://pub.dev/packages/mix) — Core framework
- [mix_generator](https://pub.dev/packages/mix_generator) — Code generator
- [GitHub repository](https://github.com/btwld/mix)
