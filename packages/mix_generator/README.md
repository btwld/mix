# mix_generator

[![Pub Version](https://img.shields.io/pub/v/mix_generator?label=version&style=for-the-badge)](https://pub.dev/packages/mix_generator/changelog)
[![MIT Licence](https://img.shields.io/github/license/leoafarias/mix?style=for-the-badge&longCache=true)](https://opensource.org/licenses/mit-license.php)

Code generator for the [Mix](https://pub.dev/packages/mix) styling framework. Processes [mix_annotations](https://pub.dev/packages/mix_annotations) to generate boilerplate code for Spec, Styler, Mix, and widget-wrapper classes.

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

The generator emits several surfaces with deliberately different shapes, chosen to match the type they're paired with:

- **`@MixableSpec`** emits a *rich* mixin (`mixin _$<Name> implements Spec<T>, Diagnosticable`) that fully completes the Spec contract on its own. Specs are immutable value types with no shared concrete behavior to inherit, so the generated mixin can be self-contained — user code only writes `with _$<Name>`.
- **`@MixableSpec(target: Widget.new)`** also emits a full generated Styler class into the same `.g.dart` part file as the spec mixin. The generated class owns fields, constructors, factories, fluent methods, `call()`, merge, resolve, diagnostics, and props.
- **`@MixableStyler`** emits a legacy *slim* mixin (`mixin _$<Name>Mixin on Style<S>, Diagnosticable`) that fills in per-field plumbing for handwritten styler classes.
- **`@Mixable`** emits a *slim* mixin (`mixin _$<Name>Mixin on Mix<T>[, DefaultValue<T>][, Diagnosticable]`) for the same reason — Mix subclasses commonly compose intermediate base classes (e.g., `class BoxConstraintsMix extends ConstraintsMix<BoxConstraints>`) and the user keeps that inheritance chain.

If the asymmetry feels surprising, the rule is: rich/full shape for pure-data specs and their generated stylers; slim shape for types whose `extends` chain carries shared state or behavior.

A fourth annotation, **`@MixWidget`**, generates a full `StatelessWidget` class (not a mixin) that wraps a top-level `Style<S>` factory — see the [`@MixWidget`](#from-mixwidget--widget-wrapper) section below.

### From `@MixableSpec` — Spec mixin

Generates a self-contained `_$<Name>` mixin (`implements Spec<Name>, Diagnosticable`) for immutable Spec classes. User code declares the spec with a single `with _$<Name>` — Equatable-style equality and Diagnosticable's concrete surface are inlined by the generator:

- `Type get type` — the concrete spec `Type`
- `copyWith()` — create modified copies
- `lerp()` — smooth interpolation between specs
- `props` by default, `==`, `hashCode` — deep equality via `propsEquals` / `propsHash` helpers
- `toString({DiagnosticLevel minLevel})`, `toStringShort()`, `toDiagnosticsNode()` — Flutter inspector integration
- `debugFillProperties()` — diagnostic output

No `with Equatable` and no `with Diagnosticable` on the user class — the mixin carries both.

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'box_spec.g.dart';

@MixableSpec()
@immutable
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

When `@MixableSpec` generates a Styler, the host library must import the Mix
runtime and any Flutter or local types referenced by the generated styler code,
because the generated output is a Dart part and cannot declare its own imports.

**Legacy declaration shape.** Pre-2.0 generators emitted a slim `_$<Name>SpecMethods` mixin and required `class <Name> extends Spec<<Name>> with Diagnosticable, _$<Name>SpecMethods`. The generator now emits a `@Deprecated typedef _$<Name>SpecMethods = _$<Name>;` alongside every spec mixin so those legacy declarations keep compiling — you'll just see a deprecation warning. Migrate to `class <Name> with _$<Name>` to silence it; the alias is scheduled for removal in `mix_generator` 3.0. One observable change for legacy callers: `toString()` now routes through `Diagnosticable.toDiagnosticsNode`, replacing Equatable's `Name(field: …)` output with Flutter's diagnostic-node format.

### From `@MixableStyler` — legacy Styler mixin

Generates a `_$<Name>Mixin` for handwritten Styler classes with:

- Setter methods for each `$`-prefixed field
- `merge()` — combine styles
- `resolve()` — resolve to the corresponding Spec
- `debugFillProperties()` — diagnostics support
- `props` — equality comparison

```dart
part 'box_style.g.dart';

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

### From `@MixWidget` — widget wrapper

Generates a `StatelessWidget` wrapper around a top-level `Style<S>` variable or function. The wrapper's constructor mirrors the factory's parameters (for function-backed styles) plus the styler's `call()` parameters; `build()` invokes the factory and forwards the parameters through to the resulting widget.

```dart
part 'card.g.dart';

@mixWidget
final cardStyle = BoxStyler()
    .color(Colors.white)
    .borderRounded(8)
    .paddingAll(16);

// Generates:
//   class Card extends StatelessWidget {
//     const Card({super.key, this.child});
//     final Widget? child;
//     @override Widget build(BuildContext context) =>
//         cardStyle.call(key: this.key, child: this.child);
//   }
```

The widget name is derived from a lower-camel-case `*Style` identifier (`cardStyle` → `Card`); pass `@MixWidget(name: 'X')` to override. Function-backed factories thread their args before the styler `call()`: `@MixWidget Style<S> badge({Color? color}) => ...` generates a `Badge({this.color, this.child})` constructor.

See [`mix_annotations`](https://pub.dev/packages/mix_annotations) for the full annotation contract (parameter rules, `Key? key` forwarding, naming/visibility constraints).

### Field-level control with `@MixableField`

```dart
// Skip setter generation.
@MixableField(ignoreSetter: true)
final Prop<Matrix4>? $transform;

// Override the setter parameter type.
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
