# Code Generation

Annotations, generators, and the codegen workflow in Mix.

## Table of Contents

- [Spec-driven generation](#current-default-spec-driven-styler-generation)
- [Annotations](#annotations)
- [File structure](#file-structure-per-widget-spec)
- [Type metadata](#type-metadata-registry)
- [Run code generation](#running-code-generation)
- [Box reference implementation](#reference-implementation-box)
- [Generator flags](#generator-flags)

## Current Default: Spec-Driven Styler Generation

For widget-backed specs, prefer `@MixableSpec(target: Widget.new)`. The generator emits both:

- `_$FooSpec` — Spec contract mixin for `FooSpec`
- `FooStyler` — generated fluent Styler in the same `<name>_spec.g.dart` part

```dart
part 'box_spec.g.dart';

@MixableSpec(target: Box.new)
@immutable
final class BoxSpec with _$BoxSpec {
  @override
  final AlignmentGeometry? alignment;
  @override
  final EdgeInsetsGeometry? padding;

  const BoxSpec({this.alignment, this.padding});
}
```

Generated stylers include value fields (`Prop<V>?`), `.create()` and default constructors, field factories, fluent setters, `merge()`, `resolve()`, diagnostics, props, and `call()` when a widget target supports it.

`_$FooSpecMethods` is only a deprecated compatibility typedef for older `extends Spec<FooSpec> with _$FooSpecMethods` declarations. Do not use it for new specs.

## Annotations

### `@MixableSpec()`

Applied to Spec classes. Generates `_$FooSpec` with:

- `copyWith()` — replaces fields when non-null replacement arguments are provided
- `lerp()` — interpolation for supported fields
- `props`, `==`, `hashCode` — value equality support
- `debugFillProperties()` — Flutter diagnostics

Optional method flags:

- `GeneratedSpecMethods.all` — copyWith | equals | lerp
- `GeneratedSpecMethods.skipCopyWith`
- `GeneratedSpecMethods.skipEquals` — suppresses generated `props`; the user must supply props for equality
- `GeneratedSpecMethods.skipLerp`

With `target: Widget.new`, it also drives generated Styler and `call()` support from the target widget constructor.
The target can be any `Widget` constructor with a named `style` parameter that
accepts the generated Styler; extending `StyleWidget` is not required. A
`styleSpec` parameter must be optional because generated calls omit it.
Direct, uninstantiated generic targets are supported; generated `call()` methods preserve and forward their type parameters and bounds. Instantiated targets such as `Widget<int>.new` and generic constructor tear-offs through typedefs are rejected because their substitutions are not yet supported. A target type parameter named `Key` is also rejected when the constructor forwards Flutter's `key`, because it would shadow the generated `Key? key` parameter.

### `@MixableStyler()` Legacy

`@MixableStyler()` still exists for handwritten Styler classes, but it is deprecated. Prefer `@MixableSpec(target: Widget.new)` for new widget-backed APIs.

Use legacy `@MixableStyler()` only when maintaining an existing handwritten Styler whose fields are already `$`-prefixed `Prop<V>?` values.

### `@MixWidget()`

Apply to a top-level variable or function returning a `Style<S>`. It generates a
`StatelessWidget` wrapper whose `build()` delegates to the styler's `call()` or
to an explicitly configured plain Widget target.

```dart
@MixWidget()
final cardStyle = BoxStyler().padding(.all(16)).borderRadius(.circular(12));
// Generates `class Card extends StatelessWidget { ... }`.
```

By default, the widget name is derived from a lowerCamelCase element name ending in `Style`: `cardStyle` becomes `Card`, and leading underscores are preserved. Override the name with `@MixWidget(name: 'X')`.

For a plain Widget with a compatible named `style` parameter, pass its
constructor tear-off through `target`. The Widget does not need to extend
`StyleWidget` or expose a Styler extension `call()` method. This direct-target
path ships in `mix_generator 2.2.0-beta.2` with
`mix_annotations 2.2.0-beta.1`:

```dart
@MixWidget(
  name: 'AppButton',
  target: PlainButton.new,
  widgetParameters: .only({'label', 'onPressed'}),
  factoryParameters: .only({'variant', 'size'}),
)
ButtonStyler appButtonStyle({
  ButtonVariant variant = .solid,
  ButtonSize size = .medium,
  bool highContrast = false,
}) => switch (variant) {
  .solid => solidButtonStyle(size, highContrast: highContrast),
  .soft => softButtonStyle(size, highContrast: highContrast),
};
```

Use `widgetParameters` to curate parameters read from the Styler `call()` or
plain target constructor. Use `factoryParameters` to curate the recipe
function's own parameters. Required parameters must remain selected; omitted
optional parameters use their original defaults. The target's `style` and
`styleSpec` parameters never become generated wrapper fields.

When a recipe function has a named, non-nullable enum parameter named exactly
`variant` and that parameter remains selected by `factoryParameters`, generate
one named constructor per accessible enum value while retaining the unnamed
constructor:

```dart
AppButton.solid(label: 'Save')
AppButton.soft(label: 'Save')
AppButton(variant: selectedVariant, label: 'Save')
```

Do not add an `EnumVariant` mixin solely for this feature. The enum is a recipe
switch key and does not enter Mix's runtime variant system. Nullable,
positional, non-enum, or differently named parameters retain the unnamed-only
constructor shape. Preserve the unnamed constructor because runtime-selected
variants cannot choose a named constructor at compile time.

`@MixWidget` complements `@MixableSpec(target:)`; it wraps a style recipe after
a Styler exists, while `@MixableSpec(target:)` generates the Styler and its
`call()` support. Mix's own specs use `@MixableSpec(target:)`; `@MixWidget` is
mainly a downstream-author convenience. When changing this contract inside the
Mix repository, also consult its `guides/mix-widget-variant-constructors.md`
decision record if present; do not treat a proposed curation rename as shipped
API unless the current source exposes it.

### `@MixableModifier()`

Applied to `WidgetModifier` classes. The modifier class mixes in the generated `_$FooModifier` mixin, and the generator emits both the modifier contract implementation and the matching `FooModifierMix` class.

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

Use `@MixableModifier(lerp: false)` when interpolation needs custom behavior and the modifier class implements `lerp()` manually. Current built-in generated modifiers live under `packages/mix/lib/src/modifiers/`.

### `@Mixable()`

Applied to Mix/DTO classes. Generates `_$FooMixin` with:

- `merge()`
- `resolve()`
- `props`
- `debugFillProperties()`

```dart
@Mixable()
final class BoxConstraintsMix extends ConstraintsMix<BoxConstraints>
    with DefaultValue<BoxConstraints>, Diagnosticable, _$BoxConstraintsMixMixin {
  final Prop<double>? $minWidth;
  final Prop<double>? $maxWidth;
}
```

### `@MixableField()`

Applied to fields for per-field generation control.

For spec-driven stylers:

```dart
@MixableField(skipFactory: true)
final Color? internalColor;

@MixableField(factoryName: 'visibility')
final bool? visible;

@MixableField(mixin: SpacingStyleMixin)
final EdgeInsetsGeometry? padding;

@MixableField(skipMixin: true)
final Matrix4? transform;

@MixableField(forwardStyler: true)
final StyleSpec<LabelSpec>? label;
```

Nested `StyleSpec<XSpec>` fields derive `XStyler` by convention for generated
constructors and setters. Use `setterType` only to override that convention.
Use `forwardStyler: true` to project a nested Styler's canonical factories and
fluent anchors onto the parent Styler; add `stylerSurface` only when generation
needs an explicit compatible surface during a same-package clean build.

For legacy handwritten stylers:

```dart
@MixableField(ignoreSetter: true)
final Prop<Matrix4>? $transform;

@MixableField(setterType: List<Shadow>)
final Prop<List<Shadow>>? $shadows;
```

## File Structure Per Widget Spec

Current spec-driven shape:

```text
specs/box/
├── box_spec.dart     # Hand-written: @MixableSpec(target: Box.new), fields
├── box_spec.g.dart   # Generated: _$BoxSpec + BoxStyler
└── box_widget.dart   # Hand-written: Box extends StyleWidget<BoxSpec>
```

There is no handwritten `box_style.dart` for the current `Box` implementation; `BoxStyler` is generated from `box_spec.dart`.

Current generated modifier shape:

```text
modifiers/
├── opacity_modifier.dart     # Hand-written: @MixableModifier(), fields, build()
└── opacity_modifier.g.dart   # Generated: _$OpacityModifier + OpacityModifierMix
```

## Type Metadata Registry

**File:** `packages/mix_generator/lib/src/core/curated/type_metadata.dart`

The generator uses `typeMetadata` and helpers from the curated registry to determine:

- Mix counterpart type (`TypeMetadata.mixType`, exposed through helpers such as `mixTypeFor`)
- Owner mixins for generated Styler methods
- Lerp behavior (`TypeCategory.lerpable`, `.snappable`, `.enumType`)
- Diagnostic property behavior

When generating `lerp()`, the generator selects:

- Lerpable → `MixOps.lerp(field, other?.field, t)`
- Snappable/enum → `MixOps.lerpSnap(field, other?.field, t)`
- Nested `StyleSpec<T>` → delegate to the nested spec lerp path

## Running Code Generation

```bash
# Full clean + rebuild
melos run gen:build

# Watch mode during development
melos run gen:watch

# Clean generated files
melos run gen:clean
```

`gen:build` runs:

1. `gen:clean`
2. `gen:build:flutter`
3. `gen:build:dart`

The build commands pass `--delete-conflicting-outputs`; the clean scripts remove generated outputs separately.

## Reference Implementation: Box

Use `packages/mix/lib/src/specs/box/` as the canonical current pattern:

1. `box_spec.dart` — `BoxSpec` with `@MixableSpec(target: Box.new)` and nullable final fields
2. `box_spec.g.dart` — generated `_$BoxSpec` and `BoxStyler`
3. `box_widget.dart` — `Box extends StyleWidget<BoxSpec>`, defaults to `IdentityStyle(BoxSpec())`, maps `BoxSpec` fields to `Container`

## Generator Flags

Fine-grained control uses bitflags in annotation parameters:

```dart
@MixableSpec(methods: GeneratedSpecMethods.skipLerp)
@Mixable(methods: GeneratedMixMethods.skipResolve)
```

`GeneratedStylerMethods.call` / `skipCall` are deprecated compatibility flags. `call()` for widget-backed generated stylers comes from `@MixableSpec(target: Widget.new)`, not from the legacy styler flag.
