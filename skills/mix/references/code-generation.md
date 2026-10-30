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
`StyleWidget` or expose a Styler extension `call()` method. For example:

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

`@MixWidget` wraps an existing recipe; `@MixableSpec(target:)` generates the
styler itself. The proposal to remove `factoryParameters` and rename
`widgetParameters` to `targetParameters` is **unimplemented**. Current source
and the [constructor guide](https://github.com/btwld/mix/blob/main/guides/mix-widget-variant-constructors.md)
remain authoritative. Rationale lives in the
[decision log](https://github.com/btwld/mix/blob/main/ARCHITECTURE.md#mixwidget-variant-constructors).

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

Generates merge, resolution, equality props and diagnostics for Mix/DTO values.
Keep the `.create()` constructor compatible with generated merge calls and
wrap ergonomic nullable inputs using `Prop.maybe` / `Prop.maybeMix`. Inspect an
existing Mix counterpart before adding one.

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

## Generation workflow

In the monorepo, `packages/mix/lib/src/specs/box/` is canonical:
`box_spec.dart` owns the annotation and nullable final fields,
`box_spec.g.dart` contains `_$BoxSpec` and `BoxStyler`, and `box_widget.dart`
maps resolved values to Flutter. Do not add a parallel handwritten Box styler.

```bash
melos run gen:build
melos run exports
```

`gen:build` cleans, builds Flutter and Dart outputs, and regenerates the Winds
registry. It does **not** run exports. `gen:watch` supports iteration;
`gen:clean` removes generated outputs. Downstream, use the project's
`build_runner` command and dependencies instead of assuming Melos is present.

## Type metadata and flags

`packages/mix_generator/lib/src/core/curated/type_metadata.dart` maps analyzer
types to Mix counterparts, owning mixins, lerp categories and diagnostics.
Lerpable values use `MixOps.lerp`, snappable/enums use `lerpSnap`, and nested
`StyleSpec` uses its nested interpolation path. Update metadata when adding a
new supported Flutter value shape.

Method flags can skip generated operations, e.g.
`@MixableSpec(methods: GeneratedSpecMethods.skipLerp)` or
`@Mixable(methods: GeneratedMixMethods.skipResolve)`.
`GeneratedStylerMethods.call` / `skipCall` are deprecated compatibility flags;
widget-backed calls come from the spec's target.
