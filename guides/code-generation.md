# Mix Code Generation Guide

This guide documents the complete Mix code generation surface in this
repository: public annotations, generated APIs, builder wiring, generator
internals, validation rules, and the normal workflows for extending codegen.

The existing `guides/mix-widget-codegen-output.md` stays focused on
`@MixWidget` output examples. This guide is broader and should be the first
place to look when changing or reviewing Mix code generation.

## Package Map

Code generation is split into two packages:

- `packages/mix_annotations` defines the public annotation API. This package
  is safe for runtime dependencies and must not depend on analyzer,
  source_gen, or build_runner.
- `packages/mix_generator` implements the source_gen builders. This package is
  a dev dependency for users and owns analyzer/source_gen/build_runner logic.

The generated code is consumed by `packages/mix`, mostly under:

- `packages/mix/lib/src/specs/**`
- `packages/mix/lib/src/properties/**`
- any user library that opts into `@MixWidget`

Every annotated input library needs a `part '<file>.g.dart';` directive. The
individual builders write cache parts, and `source_gen:combining_builder`
combines them into the checked-in `.g.dart` file.

## Installation

Typical package setup:

```yaml
dependencies:
  mix: ^2.0.0
  mix_annotations: ^2.0.0

dev_dependencies:
  build_runner: ^2.4.0
  mix_generator: ^2.0.0
```

`mix_annotations` belongs in `dependencies` because annotated source imports
it at runtime. `mix_generator` and `build_runner` belong in
`dev_dependencies` because they are only needed while generating code.

## Builder Entry Points

`packages/mix_generator/lib/mix_generator.dart` exposes four builder factory
functions:

| Builder factory | Annotation | Generator | Cache part extension | Main output |
|---|---|---|---|---|
| `mixGenerator` | `@MixableSpec` | `SpecGenerator` | `.mix_generator.g.part` | `_$Name` spec mixin |
| `stylerGenerator` | `@MixableStyler` | `StylerGenerator` | `.styler_generator.g.part` | `_$NameMixin` styler mixin |
| `mixableGenerator` | `@Mixable` | `MixableGenerator` | `.mixable_generator.g.part` | `_$NameMixin` mix mixin |
| `mixWidgetGenerator` | `@MixWidget` | `MixWidgetGenerator` | `.mix_widget_generator.g.part` | public widget class |

All four builders are `SharedPartBuilder`s and use the same formatter:

```dart
DartFormatter(languageVersion: version).format(code)
```

The generator package's `build.yaml` registers all builders with:

- `auto_apply: dependents`
- `build_to: cache`
- `applies_builders: ['source_gen:combining_builder']`

The Mix package narrows where builders run:

- `mix_generator` and `styler_generator` run on `lib/src/specs/**/*.dart`
- `mixable_generator` runs on `lib/src/properties/**/*.dart`
- `mix_widget_generator` runs on `lib/**/*.dart`

## Public Annotation API

The annotation API lives in
`packages/mix_annotations/lib/src/annotations.dart`.

Const aliases are exported for the annotations that do not require
configuration:

- `mixableSpec`
- `mixableStyler`
- `mixWidget`
- `mixable`

### `@MixableSpec`

Use `@MixableSpec()` on immutable spec classes.

```dart
@MixableSpec()
final class BoxSpec with _$BoxSpec {
  @override
  final Color? color;

  const BoxSpec({this.color});
}
```

Input contract:

- The annotated element must be a class.
- The class must have a name.
- The class must have an unnamed constructor.
- Named parameters on the unnamed constructor define the generated field list.
- Each named constructor parameter must map to a field with the same name.

Generated API:

- `mixin _$Name implements Spec<Name>, Diagnosticable`
- abstract getters for every constructor-backed field
- `Type get type`
- `copyWith(...)`
- `lerp(Name? other, double t)`
- `List<Object?> get props`
- `operator ==`
- `hashCode`
- `bool get stringify`
- `Map<String, String> getDiff(Equatable other)`
- `toStringShort()`
- `toString({DiagnosticLevel minLevel})`
- `toDiagnosticsNode(...)`
- `debugFillProperties(...)`

Spec mixins always implement `Diagnosticable`. The user spec class only needs
`with _$Name`; it does not need to mix in `Diagnosticable` itself.

Flags:

```dart
@MixableSpec(methods: GeneratedSpecMethods.skipLerp)
```

| Flag | Effect |
|---|---|
| `GeneratedSpecMethods.copyWith` | emit `copyWith` |
| `GeneratedSpecMethods.equals` | emit `props`, `==`, `hashCode`, `stringify`, `getDiff` |
| `GeneratedSpecMethods.lerp` | emit `lerp` |
| `GeneratedSpecMethods.all` | emit all spec methods |
| `GeneratedSpecMethods.none` | emit no optional spec methods |
| `skipCopyWith`, `skipEquals`, `skipLerp` | emit all except the named method group |

`GeneratedSpecComponents` currently has `none` and `all`, but `all == none`.
There are no external spec components generated today.

### `@MixableStyler`

Use `@MixableStyler()` on styler classes that extend `Style<TSpec>` or a
subclass such as `MixStyler<Self, Spec>`.

```dart
@MixableStyler()
class BoxStyler extends MixStyler<BoxStyler, BoxSpec>
    with Diagnosticable, _$BoxStylerMixin {
  @override
  final Prop<Color>? $color;

  const BoxStyler.create({Prop<Color>? color}) : $color = color;

  BoxStyler({Color? color}) : this.create(color: Prop.maybe(color));
}
```

Input contract:

- The annotated element must be a class.
- The class must extend `Style<T>`, directly or through a subclass.
- The `Style<T>` spec type must be visible from the annotated library.
- Generated fields are class fields whose names start with `$`.
- Base fields `$variants`, `$modifier`, and `$animation` are excluded from the
  normal field loop and handled separately.
- Fields are sorted by name for stable output.

Generated API:

- `mixin _$NameMixin on Style<Spec>, Diagnosticable`
- abstract getters for every generated `$` field
- chainable setter methods for generated fields
- base setters `animate(AnimationConfig)`, `variants(List<VariantStyle<Spec>>)`,
  and `wrap(WidgetModifierConfig)`
- `merge(Name? other)`
- `resolve(BuildContext context)`
- `debugFillProperties(...)`
- `List<Object?> get props`

Setter generation rules:

- Field names drop the `$` prefix. `$alignment` becomes `alignment(...)`.
- `Prop<T>` fields usually expose `T` as the public parameter type.
- If `T` has a curated Mix counterpart, the setter uses the Mix type instead.
  For example `Prop<EdgeInsetsGeometry>?` exposes
  `EdgeInsetsGeometryMix`.
- Raw-list fields keep a list type rather than going through `Prop<T>`.
- `@MixableField(ignoreSetter: true)` suppresses a generated setter.
- `@MixableField(setterType: SomeType)` overrides the generated setter
  parameter type.
- Curated field aliases can suppress or rename setters. Today
  `TextStyler.textDirectives` is labeled as `directives` for diagnostics and
  does not get a generated setter.

Flags:

```dart
@MixableStyler(methods: GeneratedStylerMethods.skipSetters)
```

| Flag | Effect |
|---|---|
| `GeneratedStylerMethods.setters` | emit field setters plus base `animate`, `variants`, `wrap` |
| `GeneratedStylerMethods.merge` | emit `merge` |
| `GeneratedStylerMethods.resolve` | emit `resolve` |
| `GeneratedStylerMethods.debugFillProperties` | emit diagnostics |
| `GeneratedStylerMethods.props` | emit `props` |
| `GeneratedStylerMethods.all` | emit all styler method groups |
| `GeneratedStylerMethods.none` | emit no optional styler method groups |
| `skipSetters`, `skipMerge`, `skipResolve`, `skipDebugFillProperties`, `skipProps` | emit all except the named group |

### `@Mixable`

Use `@Mixable()` on Mix property classes that extend `Mix<T>` or a subclass
that eventually binds to `Mix<T>`.

```dart
@Mixable()
final class BoxConstraintsMix extends ConstraintsMix<BoxConstraints>
    with DefaultValue<BoxConstraints>, Diagnosticable, _$BoxConstraintsMixMixin {
  @override
  final Prop<double>? $minWidth;

  const BoxConstraintsMix.create({Prop<double>? minWidth})
      : $minWidth = minWidth,
        super.create();
}
```

Input contract:

- The annotated element must be a class.
- The class must extend `Mix<T>`, `Mixable<T>`, or a subclass that binds to one
  of those types.
- The resolve target is inferred from the `Mix<T>` binding unless
  `resolveToType` is supplied.
- The resolve target type must be visible from the annotated library.
- Generated fields are `$` fields collected from the class hierarchy.
- Subclass fields override inherited fields with the same name.
- Fields are sorted by name for stable output.

Generated API:

- `mixin _$NameMixin on Mix<ResolveType>[, DefaultValue<ResolveType>][, Diagnosticable]`
- abstract getters for every generated `$` field
- `merge(Name? other)`
- `resolve(BuildContext context)`
- `debugFillProperties(...)`
- `List<Object?> get props`

The `Diagnosticable` constraint is included only when
`GeneratedMixMethods.debugFillProperties` is enabled. Disabling that flag also
removes the generated diagnostics method.

`DefaultValue<T>` changes generated `resolve` behavior. When the class mixes in
`DefaultValue<T>`, each resolved property falls back to `defaultValue.<field>`
when the resolved value is null.

Flags:

```dart
@Mixable(methods: GeneratedMixMethods.skipResolve)
@Mixable(resolveToType: 'BoxConstraints')
```

| Flag | Effect |
|---|---|
| `GeneratedMixMethods.merge` | emit `merge` |
| `GeneratedMixMethods.resolve` | emit `resolve` |
| `GeneratedMixMethods.props` | emit `props` |
| `GeneratedMixMethods.debugFillProperties` | emit diagnostics |
| `GeneratedMixMethods.all` | emit all mix method groups |
| `GeneratedMixMethods.none` | emit no optional mix method groups |
| `skipMerge`, `skipResolve`, `skipProps`, `skipDebugFillProperties` | emit all except the named group |

### `@MixWidget`

Use `@MixWidget()` on a public top-level final styler variable or a public
top-level styler factory function.

```dart
@MixWidget()
final cardStyle = BoxStyler().paddingAll(16);

@MixWidget(name: 'PrimaryButton')
ButtonStyler primaryButtonStyle({Color color = Colors.blue}) {
  return ButtonStyler().color(color);
}
```

Input contract:

- The annotated target must be a top-level final variable or top-level
  function.
- The target must be public.
- Function targets must not be generic.
- The target type must be a concrete non-null `Style<T>` subtype.
- The target cannot be typed as the abstract `Style<T>` itself.
- The concrete styler type must expose a non-generic `call()` method.
- The `call()` return type must be assignable to Flutter `Widget`.
- `Widget`, `StatelessWidget`, and `BuildContext` must be available
  unprefixed in the annotated library.

Generated class naming:

- By default the target name is converted to UpperCamelCase.
- A trailing `Styler` or `Style` suffix is removed before conversion.
- `cardStyle` becomes `Card`.
- `primary_button_style` becomes `PrimaryButton`.
- `@MixWidget(name: 'CustomName')` overrides the derived name.
- The final generated name must be public and match
  `^[A-Z][A-Za-z0-9_]*$`.
- The generated name must not conflict with an existing declaration or another
  generated widget in the same library.

Generated API:

- `class GeneratedName extends StatelessWidget`
- const constructor with `super.key`
- final fields for every generated wrapper parameter
- `Widget build(BuildContext context)` delegating to the styler:

```dart
return styleFactory(...factoryParams).call(
  key: key,
  ...callParams,
);
```

Wrapper parameter sources:

- Factory parameters are exposed first and passed back to the factory.
- Styler `call()` parameters are exposed after factory parameters.
- A named `Key? key` parameter on `call()` is not exposed as a field. The
  generated widget forwards its own key to it.
- Required positional parameters stay positional in the generated constructor.
- Named parameters stay named.
- Required named parameters stay `required`.
- Defaults are preserved when their default-value expressions are visible from
  the annotated library.

`BuildContext` factory injection:

- A style factory may take `BuildContext context` as its first required
  positional parameter.
- That parameter is injected from `build()` and is not exposed on the widget
  constructor.
- Any other `BuildContext` factory parameter is rejected.
- A same-named non-Flutter `BuildContext` is rejected.

Parameter validation:

- Optional positional factory parameters are rejected, except for the special
  first `BuildContext context` case.
- Optional positional `call()` parameters are rejected.
- `key` and `build` are reserved generated wrapper parameter names.
- Private parameters are rejected.
- Duplicate names between factory parameters and `call()` parameters are
  rejected.
- A `call()` key parameter must be named and exactly `Key?`.
- Parameter types must be visible from the annotated library.
- Default value identifiers must be visible from the annotated library and must
  not be shadowed by a different declaration there.

For output examples, see `guides/mix-widget-codegen-output.md`.

### `@MixableField`

Use `@MixableField` on individual styler fields.

```dart
@MixableField(ignoreSetter: true)
final Prop<Matrix4>? $transform;

@MixableField(setterType: List<ShadowMix>)
final Prop<List<Shadow>>? $shadows;
```

Options:

- `ignoreSetter: true` prevents `@MixableStyler` from generating the fluent
  setter for that field.
- `setterType: SomeType` overrides the generated setter parameter type.

### Other Exported Flags

`packages/mix_annotations/lib/src/generator_flags.dart` also exports two flag
groups that are not currently consumed by the active annotations or generator
classes in this branch:

| Class | Values |
|---|---|
| `GeneratedUtilityMethods` | `none`, `callMethod`, `all`, `skipCallMethod` |
| `GeneratedPropertyComponents` | `none`, `utility`, `resolvableExtension`, `all`, `skipUtility`, `skipResolvableExtension` |

Keep these documented because they are part of the public annotations package
surface, even though no current generator reads them.

## Generated Field Semantics

The generators intentionally derive fields from the shape of the authored API:

- Spec fields come from named parameters in the spec's unnamed constructor.
- Styler fields come from `$`-prefixed fields declared on the styler class.
- Mix fields come from `$`-prefixed fields in the class hierarchy.
- Widget fields come from factory parameters plus the styler `call()` method.

This keeps handwritten constructors and call signatures as the source of truth
for generated APIs.

## Type Metadata

`packages/mix_generator/lib/src/core/curated/type_metadata.dart` contains the
curated type registry used for setter types, lerp behavior, diagnostics, and
raw-list handling.

Mix counterpart mappings:

| Flutter/value type | Generated public Mix type |
|---|---|
| `EdgeInsetsGeometry` | `EdgeInsetsGeometryMix` |
| `BoxConstraints` | `BoxConstraintsMix` |
| `Decoration` | `DecorationMix` |
| `TextStyle` | `TextStyleMix` |
| `StrutStyle` | `StrutStyleMix` |
| `TextHeightBehavior` | `TextHeightBehaviorMix` |
| `BorderRadiusGeometry` | `BorderRadiusGeometryMix` |
| `BoxBorder` | `BoxBorderMix` |
| `Shadow` | `ShadowMix` |
| `BoxShadow` | `BoxShadowMix` |

List Mix mappings:

| Flutter element | Element Mix | List Mix |
|---|---|---|
| `Shadow` | `ShadowMix` | `ShadowListMix` |
| `BoxShadow` | `BoxShadowMix` | `BoxShadowListMix` |

Raw-list fields:

| Field | Public type |
|---|---|
| `textDirectives` | `List<Directive<String>>` |

Lerpable types use `MixOps.lerp`. Snappable and enum types use
`MixOps.lerpSnap`. `StyleSpec<T>` fields delegate to `field.lerp(...)`.

Lerpable geometry and layout types:

```text
EdgeInsetsGeometry, BoxConstraints, AlignmentGeometry, Matrix4, Rect,
Constraints
```

Lerpable painting, text, and shadow types:

```text
Decoration, TextStyle, StrutStyle, BorderRadiusGeometry, BoxBorder,
Shadow, BoxShadow, Color, BorderSide, Border, ShapeBorder, BoxDecoration,
ShapeDecoration, LinearGradient, RadialGradient, SweepGradient, Gradient,
IconThemeData
```

Lerpable numeric and Flutter value types:

```text
double, int, num, HSVColor, HSLColor, Offset, Size, RRect, Alignment,
FractionalOffset, EdgeInsets, EdgeInsetsDirectional, BorderRadius,
BorderRadiusDirectional, RelativeRect
```

Snappable direct value types:

```text
bool, String, TextHeightBehavior, ImageProvider<Object>, ImageProvider,
TextScaler, Locale, IconData
```

Enum types are also snappable and are listed below.

Diagnostic property mapping:

| Field type | Diagnostic property |
|---|---|
| `Color` | `ColorProperty` |
| `double` | `DoubleProperty` |
| `int` | `IntProperty` |
| `String` | `StringProperty` |
| `bool` with curated description | `FlagProperty` |
| curated enum types | `EnumProperty<T>` |
| `List<T>` | `IterableProperty<T>` |
| everything else | `DiagnosticsProperty` |

Curated enum types:

```text
Clip, Axis, TextAlign, TextDirection, TextBaseline, MainAxisAlignment,
CrossAxisAlignment, MainAxisSize, VerticalDirection, TextOverflow,
TextWidthBasis, BoxFit, ImageRepeat, FilterQuality, BlendMode, StackFit
```

Curated bool flag descriptions:

| Field | `FlagProperty.ifTrue` |
|---|---|
| `softWrap` | `wrapping at word boundaries` |
| `excludeFromSemantics` | `excluded from semantics` |
| `gaplessPlayback` | `gapless playback` |
| `isAntiAlias` | `anti-aliased` |
| `matchTextDirection` | `matches text direction` |
| `applyTextScaling` | `scales with text` |

## Internal Architecture

The generator implementation is organized into small phases:

- `src/*_generator.dart` validates the annotated element and extracts typed
  models from analyzer elements.
- `src/core/models/*` carries generator data without leaking analyzer types
  into emitters where possible.
- `src/core/builders/*` emits Dart source for generated mixins/classes.
- `src/core/resolvers/*` owns specialized decisions such as lerp strategy,
  diagnostics, and `@MixWidget` call resolution.
- `src/core/helpers/field_emitter.dart` provides shared field-loop emitters
  used by the spec, styler, and mix builders.
- `src/core/helpers/type_hierarchy.dart` walks supertype chains for
  `Style<T>`, `Mix<T>`, and `Mixable<T>` bindings.
- `src/core/helpers/library_scope.dart` writes type references as they are
  visible from the annotated library.
- `src/core/errors.dart` centralizes `InvalidGenerationSource` failures.
- `src/core/checkers.dart` centralizes `TypeChecker.fromUrl(...)` constants.

The generator prefers source_gen and analyzer for semantic inspection, then
emits straightforward Dart strings for mixin bodies. `@MixWidget` uses
`code_builder` for class, field, constructor, and method shape, with raw
`Code` blocks for invocation bodies.

## For Generator Contributors

`peekMethodsBitmask` in `src/core/errors.dart` is the shared reader for
annotation method flags. The spec, styler, and mix generators all use it to
fall back to their `Generated*Methods.all` defaults.

`MixWidgetGenerator` overrides `typeChecker` with the URL-based
`mixWidgetAnnotationChecker`. This keeps `@MixWidget` discovery working in
`build_test` fixtures where annotation stubs do not have the same runtime type
as the package annotation class.

`packages/mix_generator/lib/mix_generator.dart` re-exports builders, curated
metadata, field models, resolvers, and generator classes for tests and
extension points. Treat those exports as generator-facing surface, not as
runtime Mix API.

## Visibility Rules

Generated code is written as a `part of` contribution. That means generated
references must be valid from the annotated library's import scope.

The generator checks visibility for:

- spec field types
- styler field types and setter override types
- mix resolve target types
- `@MixWidget` factory and `call()` parameter types
- `@MixWidget` default value identifiers
- unprefixed Flutter `Widget`, `StatelessWidget`, and `BuildContext`

If a type is not visible, import or re-export that type from the annotated
library where the annotation appears.

## Error Shape

All validation failures should go through:

```dart
fail(element, 'Message', todo: 'Concrete fix')
```

`fail` throws `InvalidGenerationSource` with the failing analyzer element
attached. Prefer adding a `todo` when there is an obvious fix the user can
apply.

## Common Workflows

### Add a New Spec

1. Create the spec class with `@MixableSpec()`.
2. Add an unnamed constructor whose named parameters match the spec fields.
3. Add `part '<file>.g.dart';`.
4. Mix in `_$SpecName`.
5. Run `melos run gen:build`.
6. Review the generated `copyWith`, `lerp`, equality, and diagnostics.

### Add a New Styler

1. Create the styler class with `@MixableStyler()`.
2. Extend `Style<Spec>` or `MixStyler<Self, Spec>`.
3. Add `$` fields using `Prop<T>?` unless the field is an intentional raw
   field.
4. Add a `.create(...)` constructor that accepts `Prop<T>?` fields.
5. Add a public constructor that wraps values with `Prop.maybe` or
   `Prop.maybeMix`.
6. Use `@MixableField` for setter suppression or setter type overrides.
7. Run `melos run gen:build`.
8. Review setters, `merge`, `resolve`, diagnostics, and `props`.

### Add a New Mix Property Class

1. Create the class with `@Mixable()`.
2. Extend `Mix<T>` or a subclass binding to `Mix<T>`.
3. Add `$` fields using `Prop<T>?`.
4. Add `DefaultValue<T>` if generated resolve should fall back to
   `defaultValue`.
5. Add `Diagnosticable` if diagnostics are generated.
6. Use `resolveToType` only when inference from `Mix<T>` is not enough.
7. Run `melos run gen:build`.
8. Review `merge`, `resolve`, diagnostics, and `props`.

### Add a Generated Widget Wrapper

1. Make sure the library imports Flutter widgets unprefixed.
2. Add `part '<file>.g.dart';`.
3. Annotate a public top-level final styler variable or public top-level
   styler factory with `@MixWidget()`.
4. Put style-shaping inputs on the factory signature.
5. Put widget-structure inputs on the styler `call()` method.
6. Add `BuildContext context` as the first required positional factory
   parameter only when the style factory needs context.
7. Run `melos run gen:build`.
8. Review the generated constructor and `build` delegation.

### Change Generator Behavior

1. Update `mix_annotations` first when changing public annotation API.
2. Update the matching generator or model in `mix_generator`.
3. Add or update focused tests under `packages/mix_generator/test`.
4. Refresh relevant golden output when generated text changes.
5. Update this guide and any package README sections affected by the API
   change.
6. Run the full verification command for codegen changes.

## Tests And Goldens

Important test areas:

- `packages/mix_generator/test/integration/generator_smoke_test.dart`
- `packages/mix_generator/test/integration/generator_validation_test.dart`
- `packages/mix_generator/test/integration/widget_generator_test.dart`
- `packages/mix_generator/test/integration/widget_generator_golden_test.dart`
- `packages/mix_generator/test/core/**`
- `packages/mix_generator/test/goldens/mix_widget/**`

Current `MixWidget` golden fixtures:

```text
box_basic
box_factory_style_param
cross_file_imported_style
defaults_preserved
explicit_name_override
flex_box_basic
function_context_injected
function_factory_style_param
icon_basic
image_basic
stack_box_basic
text_basic
```

Useful commands:

```bash
melos run gen:build
melos run ci
melos run analyze
melos run goldens:mix_widget:update
```

For a full pre-commit check:

```bash
melos run gen:build && melos run ci && melos run analyze
```

## Troubleshooting

Missing `part` directive:

- Add `part '<file>.g.dart';` to the annotated library.

Generated type is not visible:

- Import or re-export the type from the annotated library. Remember generated
  code is a part file and uses that library's imports.

`@MixableSpec` cannot find a field:

- Make sure every named constructor parameter has a same-named field.

`@MixableStyler` does not generate a setter:

- Check for `@MixableField(ignoreSetter: true)`.
- Check curated field aliases.
- Check whether the `setters` method flag was disabled.

`@MixWidget` cannot find `call()`:

- The annotated target must return a concrete styler type with a concrete
  non-generic `call()` method.

`@MixWidget` generated name conflicts:

- Rename the style declaration or pass `@MixWidget(name: 'PublicName')`.

`@MixWidget` rejects a parameter:

- Avoid private names.
- Avoid `key` and `build`.
- Avoid optional positional parameters.
- Avoid duplicate names between factory and `call()` parameters.

Stale generated output:

- Run `melos run gen:build`.
- If build_runner reports conflicting output, use the repository's normal
  generation command rather than editing `.g.dart` files by hand.
