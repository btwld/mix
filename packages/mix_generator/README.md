# mix_generator

[![Pub Version](https://img.shields.io/pub/v/mix_generator?label=version&style=for-the-badge)](https://pub.dev/packages/mix_generator/changelog)
[![MIT Licence](https://img.shields.io/github/license/leoafarias/mix?style=for-the-badge&longCache=true)](https://opensource.org/licenses/mit-license.php)

Code generator for the [Mix](https://pub.dev/packages/mix) styling framework. Processes [mix_annotations](https://pub.dev/packages/mix_annotations) to generate boilerplate code for Spec, Styler, and Mix classes.

## Installation

```bash
flutter pub add mix
flutter pub add mix_annotations
flutter pub add --dev mix_generator
flutter pub add --dev build_runner
```

Or in `pubspec.yaml`:

```yaml
dependencies:
  mix: ^2.0.0
  mix_annotations: ^2.0.0

dev_dependencies:
  build_runner: ^2.4.0
  mix_generator: ^2.0.0
```

## What It Generates

### From `@MixableSpec` — Spec mixin

Generates a `_$<Name>` mixin for immutable Spec classes with:

- `copyWith()` — create modified copies
- `==` / `hashCode` — value equality
- `lerp()` — smooth interpolation between specs

```dart
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'box_spec.g.dart';

@MixableSpec()
final class BoxSpec extends Spec<BoxSpec> with _$BoxSpec {
  final Color? color;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  const BoxSpec({this.color, this.width, this.height, this.alignment});
}
```

### From `@MixableStyler` — Styler mixin

Generates a `_$<Name>Mixin` for mutable Styler classes with:

- Setter methods for each `$`-prefixed field
- `merge()` — combine styles
- `resolve()` — resolve to the corresponding Spec
- `debugFillProperties()` — diagnostics support
- `props` — equality comparison
- `call()` — widget creation

```dart
part 'box_styler.g.dart';

@MixableStyler()
class BoxStyler extends Style<BoxSpec>
    with Diagnosticable, _$BoxStylerMixin {
  final Prop<Color>? $color;
  final Prop<double>? $width;
  final Prop<double>? $height;
  final Prop<AlignmentGeometry>? $alignment;

  // ...
}
```

### From `@Mixable` — Mix mixin

Generates a `_$<Name>Mixin` for compound property types with:

- `merge()` — combine mix instances
- `resolve()` — resolve to the target type
- `props` — equality comparison
- `debugFillProperties()` — diagnostics support

```dart
part 'box_constraints_mix.g.dart';

@Mixable()
final class BoxConstraintsMix extends ConstraintsMix<BoxConstraints>
    with DefaultValue<BoxConstraints>, Diagnosticable, _$BoxConstraintsMixMixin {
  final Prop<double>? $minWidth;
  final Prop<double>? $maxWidth;
  final Prop<double>? $minHeight;
  final Prop<double>? $maxHeight;

  // ...
}
```

### Field-level control with `@MixableField`

```dart
// Skip setter generation
@MixableField(ignoreSetter: true)
final Prop<Matrix4>? $transform;

// Override the setter parameter type
@MixableField(setterType: List<Shadow>)
final Prop<List<Shadow>>? $shadows;
```

## Running the Generator

```bash
dart run build_runner build
```

Or within the Mix monorepo:

```bash
melos run gen:build
```

Generated files use the `.g.dart` extension and should be committed to version control.

## Debugging

### VS Code

1. Set breakpoints in the generator source files under `lib/src/`.
2. Select the "Debug build_runner" launch configuration.
3. Press F5.

### Manual

```bash
dart --enable-vm-service=8888 --pause-isolates-on-start run build_runner build --verbose
```

Then connect your debugger to `localhost:8888`.

## Learn More

- [Mix documentation](https://www.fluttermix.com)
- [mix](https://pub.dev/packages/mix) — Core framework
- [mix_annotations](https://pub.dev/packages/mix_annotations) — Annotation definitions
- [GitHub repository](https://github.com/btwld/mix)
