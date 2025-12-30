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
| ImageSpec | Yes | `StyledImage call({ImageProvider? image, ...})` | `animate(...)` without AnimationStyleMixin |
| FlexSpec | Yes | **No call method** | Deprecated `gap` param in `.create()` |
| StackSpec | Yes | **No call method** | Layout spec only |
| FlexBoxSpec | **Spec mixin only** | N/A | Composite styler deferred |
| StackBoxSpec | **Spec mixin only** | N/A | Composite styler deferred |

---

## Special Cases (v1)

### TextStyler directives
`textDirectives` is a **raw List**, not a Prop.

Expected behavior:
```dart
final List<Directive<String>>? $textDirectives; // NOT Prop<List<...>>
textDirectives: $textDirectives, // direct assignment in resolve
MixOps.mergeList($textDirectives, other?.$textDirectives) // in merge
..add(DiagnosticsProperty('directives', $textDirectives)); // diagnostic label
```

Custom methods expected:
- `textDirective`, `directive`, `uppercase`, `lowercase`, `capitalize`, `titlecase`, `sentencecase`

### FlexStyler deprecated gap (constructor override)
`FlexStyler.create` must accept deprecated `gap` param and map to `$spacing`.

### Animate without mixin
`ImageStyler` exposes `animate(...)` even though it doesn't include `AnimationStyleMixin`.

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
