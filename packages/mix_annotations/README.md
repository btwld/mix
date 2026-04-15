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

Generates `copyWith`, `==`/`hashCode`, and `lerp` methods for Spec classes (immutable style data).

```dart
@MixableSpec()
final class BoxSpec extends Spec<BoxSpec> with _$BoxSpec {
  final Color? color;
  final double? width;

  const BoxSpec({this.color, this.width});
}
```

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
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'card_styles.g.dart';

@MixWidget(styleable: true)
BoxStyler cardStyle({required Color color}) => BoxStyler.color(color);
```

This generates a widget wrapper whose public constructor mirrors the styler's `call()` signature while still constructing the target Mix widget directly. A generated `style:` parameter can be added on top of the mirrored `call()` inputs when `styleable: true`.

Use `widgetBuilder` when a style family supports multiple widget targets:

```dart
@MixWidget(widgetBuilder: MixWidgetBuilder.rowBox())
final toolbarStyle = FlexBoxStyler();
```

`@MixWidget` currently supports top-level `final` variables and top-level functions only. Function-backed declarations prepend their own factory parameters before the mirrored `call()` inputs.

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
