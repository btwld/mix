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

Generates a self-contained `_$<Name>` mixin (`implements Spec<Name>, Diagnosticable`) for immutable Spec classes. User code declares the spec with a single `with _$<Name>` — Equatable-style equality and Diagnosticable's concrete surface are inlined by the generator:

- `Type get type` — the concrete spec `Type`
- `copyWith()` — create modified copies
- `lerp()` — smooth interpolation between specs
- `props`, `==`, `hashCode` — deep equality via `propsEquals` / `propsHash` helpers
- `toString({DiagnosticLevel minLevel})`, `toStringShort()`, `toDiagnosticsNode()` — Flutter inspector integration
- `debugFillProperties()` — diagnostic output

No `with Equatable` and no `with Diagnosticable` on the user class — the mixin carries both.

```dart
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'box_spec.g.dart';

@MixableSpec()
final class BoxSpec with _$BoxSpec {
  @override
  final Color? color;
  @override
  final double? width;
  @override
  final double? height;
  @override
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

### From `@MixWidget` — Generated widget wrapper

Generates a thin public `StatelessWidget` wrapper from a top-level Mix styler declaration.

```dart
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

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

Different specs expose different widget inputs. A text styler produces a
positional `text` parameter because `StyledText` does:

```dart
@MixWidget()
final headingStyle = TextStyler()
    .fontSize(24)
    .fontWeight(FontWeight.w700);
```

Roughly equivalent generated wrapper:

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
passed back to the factory:

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
so `@MixWidget()` on built-in stylers picks the right renderer
automatically.

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

The generated `PrimaryButton` constructs `Button(...)` directly. Wrapper
parameters come from `Button`'s constructor, excluding the reserved names
`key`, `style`, and `styleSpec`. The renderer needs only a `style:` named
parameter assignable from the styler's `Style<TSpec>`; it does not have to
extend `StyleWidget` or carry any annotation of its own.

`@MixWidget` supports top-level `final` variables and top-level functions.
Function-backed declarations prepend their own public factory parameters
before renderer parameters, so inputs can shape the generated base style.

Custom specs without `@MixWidgetRenderer` produce a clear codegen error.

A top-level style function may take `BuildContext context` as its first required
positional parameter. The generated wrapper injects the build context from
`build()` and does not expose it as a constructor argument.

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
dart run build_runner build --delete-conflicting-outputs
```

Or within the Mix monorepo:

```bash
melos run gen:build
```

Generated files use the `.g.dart` extension and should be committed to version control.

To refresh the checked-in `MixWidget` generator goldens in this repository:

```bash
melos run goldens:mix_widget:update
```

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
