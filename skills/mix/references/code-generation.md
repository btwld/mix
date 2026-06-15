# Code Generation

Annotations, generators, and the codegen workflow in Mix.

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

### `@MixableStyler()` Legacy

`@MixableStyler()` still exists for handwritten Styler classes, but it is deprecated. Prefer `@MixableSpec(target: Widget.new)` for new widget-backed APIs.

Use legacy `@MixableStyler()` only when maintaining an existing handwritten Styler whose fields are already `$`-prefixed `Prop<V>?` values.

### `@MixWidget()`

Applied to a top-level variable or function returning a `Style<S>`. It generates a `StatelessWidget` wrapper whose `build()` delegates to the styler's `call()`.

```dart
@MixWidget()
final cardStyle = BoxStyler().paddingAll(16).borderRounded(12);
// Generates `class Card extends StatelessWidget { ... }`.
```

By default, the widget name is derived from a lowerCamelCase element name ending in `Style`: `cardStyle` becomes `Card`, and leading underscores are preserved. Override the name with `@MixWidget(name: 'X')`.

`@MixWidget` complements `@MixableSpec(target:)`; it wraps a style factory after a Styler exists, while `@MixableSpec(target:)` generates the Styler and its `call()` support. Mix's own specs use `@MixableSpec(target:)`; `@MixWidget` is mainly a downstream-author convenience.

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
```

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
