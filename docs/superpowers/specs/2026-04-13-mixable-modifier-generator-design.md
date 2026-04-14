# MixableModifier Generator Design

## Summary

Add a `@MixableModifier()` annotation and corresponding generator that reads fields from a `WidgetModifier` subclass and generates the full `ModifierMix` class in the `.g.dart` file. This eliminates the boilerplate of hand-writing ModifierMix classes for every modifier.

## Motivation

Every modifier currently requires a hand-written `ModifierMix` class with ~30-40 lines of repetitive code (fields wrapped in `Prop<T>`, `.create()` constructor, public constructor, `resolve()`, `merge()`, `debugFillProperties()`, `props`). The pattern is identical across all modifiers — only the field names and types change.

## Design

### Annotation (`mix_annotations`)

```dart
class MixableModifier {
  const MixableModifier();
}

const mixableModifier = MixableModifier();
```

No configuration flags needed. The generator always produces all methods (resolve, merge, debugFillProperties, props).

### Generator (`mix_generator`)

A new `ModifierGenerator extends GeneratorForAnnotation<MixableModifier>` that:

1. Validates the annotated class extends `WidgetModifier<T>`
2. Extracts all `final` instance fields (excluding inherited fields from `WidgetModifier` and `Spec`)
3. Uses `MixTypeRegistry` to determine `PropWrapperKind` for each field type
4. Generates a full standalone `ModifierMix` class

### Field Extraction

Fields are read directly from the annotated class — no `$` prefix convention needed. The generator reads all `final` non-static, non-synthetic fields declared on the class itself.

Example: `final double opacity;` becomes `final Prop<double>? opacity;` in the generated Mix class.

### Type Resolution

Uses the existing `MixTypeRegistry` and curated type maps to determine:

| Field type | Prop wrapper | Public constructor param type |
|---|---|---|
| `double`, `int`, `bool`, `String` | `Prop.maybe(value)` | Same as field type |
| `Clip`, other enums | `Prop.maybe(value)` | Same as field type |
| `EdgeInsetsGeometry` | `Prop.maybeMix(value)` | `EdgeInsetsGeometryMix?` |
| `BorderRadiusGeometry` | `Prop.maybeMix(value)` | `BorderRadiusGeometryMix?` |
| `CustomClipper<T>` | `Prop.maybe(value)` | Same as field type |

### Generated Class Structure

For a modifier `XModifier` with fields `f1: T1, f2: T2`:

```dart
class XModifierMix extends ModifierMix<XModifier> with Diagnosticable {
  final Prop<T1>? f1;
  final Prop<T2>? f2;

  const XModifierMix.create({this.f1, this.f2});

  XModifierMix({T1? f1, T2Mix? f2})
    : this.create(
        f1: Prop.maybe(f1),
        f2: Prop.maybeMix(f2),
      );

  @override
  XModifier resolve(BuildContext context) {
    return XModifier(
      f1: MixOps.resolve(context, f1),
      f2: MixOps.resolve(context, f2),
    );
  }

  @override
  XModifierMix merge(XModifierMix? other) {
    if (other == null) return this;
    return XModifierMix.create(
      f1: MixOps.merge(f1, other.f1),
      f2: MixOps.merge(f2, other.f2),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('f1', f1))
      ..add(DiagnosticsProperty('f2', f2));
  }

  @override
  List<Object?> get props => [f1, f2];
}
```

### resolve() Constructor Call

The resolve method calls the modifier constructor using **named parameters** matching the field names. This matches how most modifiers define their constructors (e.g., `ClipRRectModifier({BorderRadiusGeometry? borderRadius, ...})`).

### Diagnosticable Mixin

The generated class always includes `with Diagnosticable` since all existing ModifierMix classes use it.

## Files to Create/Modify

### New files

- `packages/mix_annotations/lib/src/mixable_modifier.dart` — annotation class
- `packages/mix_generator/lib/src/modifier_generator.dart` — generator
- `packages/mix_generator/lib/src/core/builders/modifier_mix_builder.dart` — class builder

### Modified files

- `packages/mix_annotations/lib/mix_annotations.dart` — export new annotation
- `packages/mix_generator/lib/builder.dart` — register new generator
- Modifier files (to add `@MixableModifier()` and `part` directive, remove hand-written Mix classes)

## Scope Boundaries

**In scope:** Modifiers where ModifierMix fields map 1:1 to WidgetModifier fields (opacity, padding, align, clip variants, aspect ratio, flexible, intrinsic height/width, sized box, visibility).

**Out of scope:** Complex modifiers where Mix fields differ from Modifier fields (ScaleModifierMix, RotateModifierMix, SkewModifierMix, TransformModifierMix) — these stay hand-written.

## Testing

- Unit tests for the generator verifying correct output for single-field, multi-field, and Mix-type-field modifiers
- Integration test: apply `@MixableModifier()` to a test modifier, run build_runner, verify generated code compiles and works correctly
