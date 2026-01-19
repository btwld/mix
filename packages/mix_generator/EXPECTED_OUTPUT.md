# Mix Generator v1 - Expected Output & Use Cases

This document defines the **exact outputs** expected from the v1 generator, along with API examples and usage scenarios. It is intended to be used as a verification target alongside golden tests.

---

## Scope (v1)

**Generated**
- Spec mixins (`_$XSpecMethods`) for **all specs**.
- Stylers for **non-composite specs**:
  - Box, Text, Icon, Image, Flex, Stack.

**Deferred (hand-written in v1)**
- Composite Stylers: `FlexBoxStyler`, `StackBoxStyler`.
- Composite Styler call signatures and flattened constructors.

**Not generated**
- Mutable Stylers (remain hand-written).
- Utility classes (legacy utility generation replaced by Styler APIs).
 - Pressable (widget only; no spec).

---

## Trigger & File Layout

**Input**
```dart
@MixableSpec()
final class BoxSpec extends Spec<BoxSpec>
    with Diagnosticable, _$BoxSpecMethods {
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;

  const BoxSpec({this.alignment, this.padding});
}
```

**Output** (part file)
- `box_spec.g.dart` contains:
  1. `mixin _$BoxSpecMethods`
  2. `class BoxStyler extends Style<BoxSpec> { ... }`

**Notes**
- PartBuilder injects `part of` automatically.
- No imports are emitted; stubs must import all symbols used by the generated code.

---

## Generated Spec Mixin (Example)

> **Note**: For complete lerp strategy (lerp vs lerpSnap) and diagnostic type mappings, see `mix_generator_plan.md` sections 1.5 and 1.6.

```dart
mixin _$BoxSpecMethods on Spec<BoxSpec>, Diagnosticable {
  AlignmentGeometry? get alignment;
  EdgeInsetsGeometry? get padding;

  @override
  BoxSpec copyWith({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
  }) {
    return BoxSpec(
      alignment: alignment ?? this.alignment,
      padding: padding ?? this.padding,
    );
  }

  @override
  BoxSpec lerp(BoxSpec? other, double t) {
    return BoxSpec(
      alignment: MixOps.lerp(alignment, other?.alignment, t),
      padding: MixOps.lerp(padding, other?.padding, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(DiagnosticsProperty('padding', padding));
  }

  @override
  List<Object?> get props => [alignment, padding];
}
```

---

## Generated Styler Mixin Lists

Each styler extends `Style<XSpec>` and uses the following mixins (in declaration order):

| Styler | Mixins |
|--------|--------|
| BoxStyler | `Diagnosticable`, `WidgetModifierStyleMixin<BoxStyler, BoxSpec>`, `VariantStyleMixin<BoxStyler, BoxSpec>`, `WidgetStateVariantMixin<BoxStyler, BoxSpec>`, `BorderStyleMixin<BoxStyler>`, `BorderRadiusStyleMixin<BoxStyler>`, `ShadowStyleMixin<BoxStyler>`, `DecorationStyleMixin<BoxStyler>`, `SpacingStyleMixin<BoxStyler>`, `TransformStyleMixin<BoxStyler>`, `ConstraintStyleMixin<BoxStyler>`, `AnimationStyleMixin<BoxStyler, BoxSpec>` |
| TextStyler | `Diagnosticable`, `WidgetModifierStyleMixin<TextStyler, TextSpec>`, `VariantStyleMixin<TextStyler, TextSpec>`, `WidgetStateVariantMixin<TextStyler, TextSpec>`, `TextStyleMixin<TextStyler>`, `AnimationStyleMixin<TextStyler, TextSpec>` |
| IconStyler | `Diagnosticable`, `WidgetModifierStyleMixin<IconStyler, IconSpec>`, `VariantStyleMixin<IconStyler, IconSpec>`, `WidgetStateVariantMixin<IconStyler, IconSpec>`, `AnimationStyleMixin<IconStyler, IconSpec>` |
| ImageStyler | `Diagnosticable`, `WidgetModifierStyleMixin<ImageStyler, ImageSpec>`, `VariantStyleMixin<ImageStyler, ImageSpec>`, `WidgetStateVariantMixin<ImageStyler, ImageSpec>`, `AnimationStyleMixin<ImageStyler, ImageSpec>` |
| FlexStyler | `Diagnosticable`, `WidgetModifierStyleMixin<FlexStyler, FlexSpec>`, `VariantStyleMixin<FlexStyler, FlexSpec>`, `WidgetStateVariantMixin<FlexStyler, FlexSpec>`, `FlexStyleMixin<FlexStyler>`, `AnimationStyleMixin<FlexStyler, FlexSpec>` |
| StackStyler | `Diagnosticable`, `WidgetModifierStyleMixin<StackStyler, StackSpec>`, `VariantStyleMixin<StackStyler, StackSpec>`, `WidgetStateVariantMixin<StackStyler, StackSpec>`, `AnimationStyleMixin<StackStyler, StackSpec>` |

**Common mixins (all stylers)**:
- `Diagnosticable` - Flutter diagnostics integration
- `WidgetModifierStyleMixin<S, T>` - `wrap()`, `modifier()` methods
- `VariantStyleMixin<S, T>` - `variant()`, `onVariant()` methods
- `WidgetStateVariantMixin<S, T>` - `onHovered()`, `onPressed()`, etc.
- `AnimationStyleMixin<S, T>` - `animate()` method

**Spec-specific mixins**:
- `BorderStyleMixin`, `BorderRadiusStyleMixin`, `ShadowStyleMixin`, `DecorationStyleMixin`, `SpacingStyleMixin`, `TransformStyleMixin`, `ConstraintStyleMixin` - BoxStyler only
- `TextStyleMixin` - TextStyler only
- `FlexStyleMixin` - FlexStyler only

---

## Generated Styler (Example: Box)

```dart
class BoxStyler extends Style<BoxSpec>
    with
        Diagnosticable,
        WidgetModifierStyleMixin<BoxStyler, BoxSpec>,
        VariantStyleMixin<BoxStyler, BoxSpec>,
        WidgetStateVariantMixin<BoxStyler, BoxSpec>,
        BorderStyleMixin<BoxStyler>,
        BorderRadiusStyleMixin<BoxStyler>,
        ShadowStyleMixin<BoxStyler>,
        DecorationStyleMixin<BoxStyler>,
        SpacingStyleMixin<BoxStyler>,
        TransformStyleMixin<BoxStyler>,
        ConstraintStyleMixin<BoxStyler>,
        AnimationStyleMixin<BoxStyler, BoxSpec> {
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<EdgeInsetsGeometry>? $padding;
  // ...

  const BoxStyler.create({
    Prop<AlignmentGeometry>? alignment,
    Prop<EdgeInsetsGeometry>? padding,
    // ...
    super.variants,
    super.modifier,
    super.animation,
  }) : $alignment = alignment,
       $padding = padding;

  BoxStyler({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometryMix? padding,
    // ...
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<BoxSpec>>? variants,
  }) : this.create(
         alignment: Prop.maybe(alignment),
         padding: Prop.maybeMix(padding),
         // ...
         animation: animation,
         modifier: modifier,
         variants: variants,
       );

  static BoxMutableStyler get chain => BoxMutableStyler(BoxStyler());

  /// Call signature (curated)
  Box call({Key? key, Widget? child}) {
    return Box(key: key, style: this, child: child);
  }

  // Standard methods (mixins + setters)
  BoxStyler alignment(AlignmentGeometry value) => merge(BoxStyler(alignment: value));
  BoxStyler padding(EdgeInsetsGeometryMix value) => merge(BoxStyler(padding: value));
  BoxStyler wrap(WidgetModifierConfig value) => modifier(value);
  BoxStyler animate(AnimationConfig animation) => merge(BoxStyler(animation: animation));
  // ...

  @override
  StyleSpec<BoxSpec> resolve(BuildContext context) { ... }

  @override
  BoxStyler merge(BoxStyler? other) { ... }
}
```

---

## v1 Spec Coverage (Exact Targets)

| Spec | Styler Generated | Call Method | Special Handling |
|------|------------------|-------------|------------------|
| BoxSpec | Yes | `Box call({Key? key, Widget? child})` | Mixins: Decoration/Spacing/Transform/Constraint/Border/BorderRadius/Shadow + Animation |
| TextSpec | Yes | `StyledText call(String text)` | `textDirectives` raw list; `textDirective` + `directive` + case helpers |
| IconSpec | Yes | `StyledIcon call({Key? key, IconData? icon, String? semanticLabel})` | `List<ShadowMix>` -> `Prop.mix(ShadowListMix(...))` |
| ImageSpec | Yes | `StyledImage call({ImageProvider? image, ImageFrameBuilder? frameBuilder, ImageLoadingBuilder? loadingBuilder, ImageErrorWidgetBuilder? errorBuilder, Animation<double>? opacity})` | Standard mixins; note: no `Key? key` parameter |
| FlexSpec | Yes | **No call method** | Deprecated `gap` param in `.create()` |
| StackSpec | Yes | **No call method** | Layout spec only |
| FlexBoxSpec | **Spec mixin only** | N/A | Composite styler deferred |
| StackBoxSpec | **Spec mixin only** | N/A | Composite styler deferred |

---

## Special Cases (v1)

### TextStyler directives
`textDirectives` is a **raw List**, NOT wrapped in `Prop<>`.

**CRITICAL: No setter method is generated for textDirectives!**

Unlike other fields, `textDirectives` does NOT get a setter method like `textDirectives(List<Directive<String>> value)`. Instead, it's handled by custom directive methods.

**Field declaration**:
```dart
final List<Directive<String>>? $textDirectives; // NOT Prop<List<...>>?
```

**Constructor handling**:
```dart
// .create() constructor - accepts raw list
TextStyler.create({
  List<Directive<String>>? textDirectives,  // NOT Prop<...>
  // ...
}) : $textDirectives = textDirectives;

// Public constructor - passes through directly
TextStyler({
  List<Directive<String>>? textDirectives,  // No wrapping, no Mix type
  // ...
}) : this.create(
       textDirectives: textDirectives,  // Direct assignment, NOT Prop.maybe
       // ...
     );
```

**Merge handling**:
```dart
textDirectives: MixOps.mergeList($textDirectives, other?.$textDirectives),  // NOT MixOps.merge
```

**Resolve handling**:
```dart
textDirectives: $textDirectives,  // Direct pass-through, NOT MixOps.resolve
```

**Diagnostic label**:
```dart
..add(DiagnosticsProperty('directives', $textDirectives));  // Label is 'directives', NOT 'textDirectives'
```

**Custom methods (instead of setter)**:
- `textDirective(Directive<String> value)` - adds single directive
- `directive(Directive<String> value)` - alias for textDirective
- `uppercase()` - adds UppercaseStringDirective
- `lowercase()` - adds LowercaseStringDirective
- `capitalize()` - adds CapitalizeStringDirective
- `titlecase()` - adds TitleCaseStringDirective
- `sentencecase()` - adds SentenceCaseStringDirective

### TextStyler setter methods
`TextStyler` generates setter methods for its properties, similar to other stylers.

**Setter methods generated**:
- `overflow(TextOverflow value)` - Sets text overflow behavior
- `strutStyle(StrutStyleMix value)` - Sets strut style
- `textAlign(TextAlign value)` - Sets text alignment
- `textScaler(TextScaler value)` - Sets text scaler
- `maxLines(int value)` - Sets maximum number of lines
- `textWidthBasis(TextWidthBasis value)` - Sets text width basis
- `textHeightBehavior(TextHeightBehaviorMix value)` - Sets text height behavior
- `textDirection(TextDirection value)` - Sets text direction
- `softWrap(bool value)` - Sets soft wrap behavior
- `selectionColor(Color value)` - Sets selection color
- `semanticsLabel(String value)` - Sets semantics label
- `locale(Locale value)` - Sets locale

**Note**: `TextStyleMixin<TextStyler>` provides additional text-styling convenience methods (font, color, decoration, etc.).

### Base-field handling in Stylers

Stylers inherit **base fields** (`$variants`, `$modifier`, `$animation`) from `Style<T>`. These are passed via `super` in constructors but must be handled correctly in generated code.

**CRITICAL: props vs debugFillProperties handling differs!**

#### props getter - INCLUDES base fields

The `props` getter must include ALL fields (domain + base) for proper equality comparison:

```dart
@override
List<Object?> get props => [
  // Domain-specific fields
  $alignment,
  $padding,
  $margin,
  $constraints,
  $decoration,
  $foregroundDecoration,
  $transform,
  $transformAlignment,
  $clipBehavior,
  // Base fields (ALWAYS INCLUDED in props)
  $animation,
  $modifier,
  $variants,
];
```

#### debugFillProperties - EXCLUDES base fields

The `debugFillProperties` method only includes domain-specific fields:

```dart
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  super.debugFillProperties(properties);
  properties
    ..add(DiagnosticsProperty('alignment', $alignment))
    ..add(DiagnosticsProperty('padding', $padding))
    ..add(DiagnosticsProperty('margin', $margin))
    ..add(DiagnosticsProperty('constraints', $constraints))
    ..add(DiagnosticsProperty('decoration', $decoration))
    ..add(DiagnosticsProperty('foregroundDecoration', $foregroundDecoration))
    ..add(DiagnosticsProperty('transform', $transform))
    ..add(DiagnosticsProperty('transformAlignment', $transformAlignment))
    ..add(DiagnosticsProperty('clipBehavior', $clipBehavior));
  // NO base fields ($animation, $modifier, $variants)
}
```

#### Field counts by Styler

| Styler | Domain Fields | Base Fields | Total in props |
|--------|---------------|-------------|----------------|
| BoxStyler | 9 | 3 | 12 |
| TextStyler | 14 | 3 | 17 |
| IconStyler | 13 | 3 | 16 |
| ImageStyler | 15 | 3 | 18 |
| FlexStyler | 9 | 3 | 12 |
| StackStyler | 4 | 3 | 7 |

#### Constructor handling

Base fields are passed via `super` parameters, not assigned to local fields:

```dart
const BoxStyler.create({
  Prop<AlignmentGeometry>? alignment,
  Prop<EdgeInsetsGeometry>? padding,
  // ... domain fields ...
  super.variants,   // Base field via super
  super.modifier,   // Base field via super
  super.animation,  // Base field via super
}) : $alignment = alignment,
     $padding = padding;
     // NO assignment for base fields - they go to super
```

#### merge() handling

Base fields use specialized merge functions:

```dart
@override
BoxStyler merge(BoxStyler? other) {
  return BoxStyler.create(
    // Domain fields use MixOps.merge
    alignment: MixOps.merge($alignment, other?.$alignment),
    padding: MixOps.merge($padding, other?.$padding),
    // ...
    // Base fields use specialized merge functions
    variants: MixOps.mergeVariants($variants, other?.$variants),
    modifier: MixOps.mergeModifier($modifier, other?.$modifier),
    animation: MixOps.mergeAnimation($animation, other?.$animation),
  );
}
```

### FlexStyler deprecated gap (constructor override)
`FlexStyler.create` must accept deprecated `gap` param and map to `$spacing`.

### Composite stylers (FlexBox/StackBox)
Composite stylers are hand-written in v1 and out of scope for generation.

### FlexStyler / StackStyler (no widget call)
These stylers are generated but **do not** expose a `call()` method because there is no corresponding widget:
- `FlexStyler` (layout spec only)
- `StackStyler` (layout spec only)

---

## Variants & Usage Examples

**Basic style**
```dart
final style = BoxStyler()
    .color(Colors.blue)
    .paddingAll(16)
    .borderRounded(8);
```

**Variants**
```dart
final style = BoxStyler()
    .color(Colors.white)
    .onDark(BoxStyler().color(Colors.black))
    .onHovered(BoxStyler().color(Colors.blue));
```

**Text directives**
```dart
final style = TextStyler()
    .uppercase()
    .textAlign(TextAlign.center);
```

**Image**
```dart
final style = ImageStyler()
    .width(200)
    .height(200)
    .fit(BoxFit.cover);
```

---

## Non-Goals (v1)

- Composite stylers (FlexBox/StackBox) generation
- Mutable styler generation
- Utility class generation
- Typedef aliases (e.g., `BoxMix`, `TextMix`) are intentionally removed

---

## Summary of v1 Outputs

- `Spec` mixin (`_$XSpecMethods`) for every `@MixableSpec`
- `Styler` class for non-composite specs
- Curated methods, call signatures, and constructor overrides where required
```
