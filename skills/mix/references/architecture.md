# Architecture

Core abstractions of the Mix styling system.

## Spec — Immutable Resolved Data

**File:** `packages/mix/lib/src/core/spec.dart`

```dart
@immutable
abstract class Spec<T extends Spec<T>> with Equatable {
  const Spec();
  T copyWith();
  T lerp(covariant T? other, double t);
}
```

All Specs are `@immutable final class` with nullable fields representing resolved values. Generated `_$FooSpec` mixin provides `copyWith()`, `lerp()`, equality/props, and diagnostics. `_$FooSpecMethods` is only a deprecated compatibility typedef.

**Example — BoxSpec:**

```dart
@MixableSpec(target: Box.new)
@immutable
final class BoxSpec with _$BoxSpec {
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxConstraints? constraints;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip? clipBehavior;

  const BoxSpec({this.alignment, this.padding, this.margin, ...});
}
```

Requires `part 'box_spec.g.dart'` for the generated Spec mixin and, when `target:` is provided, the generated Styler.

## Style / Styler — Immutable Fluent Builder

**Files:** `packages/mix/lib/src/core/style.dart`, `packages/mix/lib/src/style/abstracts/styler.dart`

```dart
abstract class Style<S extends Spec<S>> extends Mix<StyleSpec<S>> {
  final List<VariantStyle<S>>? $variants;
  final WidgetModifierConfig? $modifier;
  final AnimationConfig? $animation;

  Style<S> mergeActiveVariants(BuildContext context, {required Set<NamedVariant> namedVariants});
  StyleSpec<S> resolve(BuildContext context);
  Style<S> merge(covariant Style<S>? other);
  StyleSpec<S> build(BuildContext context, {Set<NamedVariant> namedVariants = const {}});
}
```

Generated Stylers extend `MixStyler<ST, SP>` and return new merged instances from fluent methods:
- `VariantStyleMixin` — `onDark()`, `onLight()`, breakpoint/platform variants
- `WidgetStateVariantMixin` — `onHovered()`, `onPressed()`, `onFocused()`, etc.
- `AnimationStyleMixin` — `animate()`, `phaseAnimation()`, `keyframeAnimation()`
- `WidgetModifierStyleMixin` — `wrap()`
- Plus domain mixins: `SpacingStyleMixin`, `DecorationStyleMixin`, `BorderStyleMixin`, etc.

**Example — BoxStyler:**

```dart
class BoxStyler extends MixStyler<BoxStyler, BoxSpec>
    with
        BorderStyleMixin<BoxStyler>,
        BorderRadiusStyleMixin<BoxStyler>,
        ShadowStyleMixin<BoxStyler>,
        DecorationStyleMixin<BoxStyler>,
        SpacingStyleMixin<BoxStyler>,
        TransformStyleMixin<BoxStyler>,
        ConstraintStyleMixin<BoxStyler>,
        TransformStyleMixin<BoxStyler> {

  final Prop<AlignmentGeometry>? $alignment;
  final Prop<EdgeInsetsGeometry>? $padding;
  final Prop<BoxConstraints>? $constraints;
  final Prop<Decoration>? $decoration;
  // ...

  // Internal constructor (const-capable, takes raw Prop<V>)
  const BoxStyler.create({
    Prop<AlignmentGeometry>? alignment,
    Prop<EdgeInsetsGeometry>? padding,
    // ...
    super.variants, super.modifier, super.animation,
  }) : $alignment = alignment, $padding = padding, ...;

  // Public constructor (takes Flutter/Mix types, wraps with Prop)
  BoxStyler({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometryMix? padding,
    // ...
  }) : this.create(
    alignment: Prop.maybe(alignment),
    padding: Prop.maybeMix(padding),
    // ...
  );
}
```

## Prop<V> — Unified Property System

**File:** `packages/mix/lib/src/core/prop.dart`

The central value wrapper enabling tokens, Mix types, merging, and directives.

### Sources

Each Prop holds `List<PropSource<V>>`:

| Source | Created By | Resolution |
|--------|-----------|------------|
| `ValueSource<V>` | `Prop.value(v)` | Returns value directly |
| `TokenSource<V>` | `Prop.token(t)` | Resolves from `MixScope` via `BuildContext` |
| `MixSource<V>` | `Prop.mix(m)` | Holds a `Mix<V>` DTO for accumulation |

### Factory Methods

```dart
Prop.value(v)       // Direct value (no auto-conversion to Mix)
Prop.mix(m)         // Explicit Mix value for accumulation merge
Prop.token(t)       // Token reference resolved from MixScope
Prop.maybe(v)       // Nullable — returns null if v is null
Prop.maybeMix(m)    // Nullable — returns null if m is null
Prop.directives(ds) // Directives only, no value source
```

### Merge Behavior

`mergeProp()` always accumulates all sources. During resolution:

- **Regular values (ValueSource)**: last value wins (replacement)
- **Mix values (MixSource)**: all Mix values merged via accumulation, then resolved
- **Directives**: merged from both Prop instances, applied after resolution

### Resolution Process

```
1. Resolve all sources (tokens → values, Mix types stay as Mix)
2. If Mix values present → try to convert regular values through `MixConverterRegistry`, merge convertible Mix values, resolve
3. If only regular values → use last value (replacement)
4. Apply directives to final value
```

## StyleWidget — Base Widget

**File:** `packages/mix/lib/src/core/style_widget.dart`

```dart
abstract class StyleWidget<S extends Spec<S>> extends StatefulWidget {
  final Style<S> style;
  final StyleSpec<S>? styleSpec;

  Widget build(BuildContext context, S spec);
}
```

Accepts either `style` (goes through full resolution) or `styleSpec` (pre-resolved, bypasses resolution). `StyleBuilder` merges variants and resolves the style; `StyleSpecBuilder` runs animation, provides the `StyleSpec`, and applies modifiers.

## Resolution Pipeline

```
StyleWidget.build(context)
  → StyleBuilder<S>
    → style.build(context, namedVariants)
      → mergeActiveVariants(context)     // evaluate variants, sort by priority
      → resolve(context)                 // Prop.resolveProp() for each field
      → StyleSpec<S>                     // wraps Spec + AnimationConfig + resolved WidgetModifier list
    → StyleAnimationBuilder              // implicit animation via SpecTween
    → widget.build(context, spec)        // map Spec fields to Flutter widgets
    → StyleSpecProvider                  // expose active StyleSpec
    → RenderModifiers                    // wrap with ordered widget modifiers
```

## WidgetModifier — Widget Wrapper

**File:** `packages/mix/lib/src/core/widget_modifier.dart`

```dart
abstract class WidgetModifier<Self extends WidgetModifier<Self>> extends Spec<Self> {
  Widget build(Widget child);
}
```

Modifiers wrap the rendered widget with additional Flutter widgets (Padding, Opacity, Transform, etc.). Defined at the style level via `ModifierMix<S>` and resolved during the pipeline.

## Mix<V> — Resolvable DTO

```dart
abstract class Mix<V> extends Mixable<V> with Resolvable<V>, Equatable {
  V resolve(BuildContext context);
}
```

Mix types are intermediate representations (DTOs) between user-facing API and resolved Flutter types. Examples: `EdgeInsetsGeometryMix`, `DecorationMix`, `BoxConstraintsMix`, `BorderRadiusMix`.

They support field-wise merging — setting `padding: EdgeInsetsGeometryMix.only(left: 8)` then merging with `padding: EdgeInsetsGeometryMix.only(right: 16)` produces `EdgeInsets.only(left: 8, right: 16)`.
