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

Generates a self-contained `_$<Name>` mixin for Spec classes (immutable style data). The mixin declares `implements Spec<T>, Diagnosticable` and inlines `type`, `copyWith`, `lerp`, generated `props` by default, `==`, `hashCode`, `toString`, `toDiagnosticsNode`, and `debugFillProperties` — so the user class needs a single `with` to be a fully-formed Spec.

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

  const BoxSpec({this.color, this.width});
}
```

The generated mixin `_$BoxSpec` is the only thing the user class mixes in — `Equatable`-style equality (via `propsEquals` / `propsHash` helpers) and `Diagnosticable`'s concrete surface are inlined by the generator, not pushed onto the user.

Control which methods are generated via `GeneratedSpecMethods` flags:

```dart
@MixableSpec(methods: GeneratedSpecMethods.skipLerp)
```

`GeneratedSpecMethods.skipEquals` suppresses generated `props` so the class can
author custom equality inputs while still using the generated equality surface.

### `@MixableStyler` legacy marker

Retained for compatibility with older code and shared generated styler method flags. New Mix stylers are generated from `@MixableSpec(target: Widget.new)`.

```dart
@MixableStyler()
class BoxStyler extends Style<BoxSpec>
    with Diagnosticable, ..., _$BoxStylerMixin {
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<Color>? $color;

  // ...
}
```

`GeneratedStylerMethods` flags remain available for generator internals and compatibility.

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

### `@MixableField`

Configures code generation for individual fields in Styler classes.

```dart
// Skip setter generation for this field
@MixableField(ignoreSetter: true)
final Prop<Matrix4>? $transform;

// Override the setter parameter type
@MixableField(setterType: List<Shadow>)
final Prop<List<Shadow>>? $shadows;

// Forward canonical factories from a nested generated Styler.
@MixableField(forwardStyler: true)
final StyleSpec<BoxSpec>? container;

// Restrict a FlexBox-backed field to the Box-generated Styler surface.
@MixableField(forwardStyler: true, stylerSurface: BoxSpec)
final StyleSpec<FlexBoxSpec>? restrictedContainer;
```

`stylerSurface` references the source `@MixableSpec` type, not its generated
Styler, so same-package clean builds do not depend on resolving generated code.
Forwarding preserves the canonical named-factory allowlist and does not promote
fluent-only helpers such as `paddingAll`.

When `setterType` and `forwardStyler` are combined, the custom setter type must
be a concrete class with an accessible unnamed constructor callable without
arguments. It must implement every forwarded fluent method with the canonical
generated signature and return a type assignable to itself.

### `@MixWidget`

Generates a `StatelessWidget` wrapper around a top-level styler variable or
styler-returning function. By default, the wrapper exposes every non-`key`
value parameter from the styler's `call()` method:

```dart
@MixWidget() // Equivalent to widgetParameters: .all()
final cardStyle = BoxStyler();
```

Use `widgetParameters: .only(...)` to keep the generated widget's value-
parameter API limited to a deliberate subset. This prevents newly added styler
value parameters from becoming public widget parameters automatically:

```dart
@MixWidget(
  widgetParameters: .only({'controller', 'focusNode'}),
)
final editorStyle = EditorStyler();
```

An empty `.only({})` exposes no selectable styler value parameters. Factory
parameters, a valid `Key? key`, and method-level `call<T>()` type parameters
remain automatic in every mode; required styler value parameters must be
selected. Excluded optional parameters are not forwarded, so the styler
method's defaults apply.

Generators that also support older `mix_annotations` releases interpret an
annotation without `widgetParameters` as `.all()`. Using `.only(...)` requires
an annotations release that defines `MixWidgetParameterSelection`.

## Generator Flags

Each annotation accepts bitwise flags to control which methods or components are generated:

| Class | Available Flags |
|---|---|
| `GeneratedSpecMethods` | `copyWith`, `equals`, `lerp` |
| `GeneratedStylerMethods` | `setters`, `merge`, `resolve`, `debugFillProperties`, `props` |
| `GeneratedMixMethods` | `merge`, `resolve`, `props`, `debugFillProperties` |

Use `all` (default) to generate everything, or `skip*` helpers to exclude specific methods:

```dart
GeneratedSpecMethods.skipLerp      // all except lerp
GeneratedSpecMethods.skipEquals    // user authors props; equality surface still emits
GeneratedMixMethods.skipResolve    // all except resolve
```

`GeneratedStylerMethods.call` / `skipCall` are retained for source
compatibility, but call generation is no longer supported.

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
