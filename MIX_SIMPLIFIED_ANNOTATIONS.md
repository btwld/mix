# MIX SIMPLIFIED ANNOTATION DESIGN

**Principle:** Auto-detect everything possible. Zero configuration for common cases.

---

## Minimal Annotation API

### For Stylers (90% of cases)

```dart
@MixableStyler()
class BoxStyler extends Style<BoxSpec>
    with
        SpacingStyleMixin<BoxStyler>,
        DecorationStyleMixin<BoxStyler>,
        _$BoxStyler {

  // NO field annotations - everything auto-detected
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxConstraints? constraints;
  final Decoration? decoration;

  const BoxStyler({
    this.alignment,
    this.padding,
    this.margin,
    this.constraints,
    this.decoration,
  });
}
```

### For Modifiers

```dart
@MixableModifier()
final class AlignModifier extends WidgetModifier<AlignModifier>
    with _$AlignModifier {

  final AlignmentGeometry alignment;
  final double? widthFactor;
  final double? heightFactor;

  const AlignModifier({
    AlignmentGeometry? alignment,
    this.widthFactor,
    this.heightFactor,
  }) : alignment = alignment ?? Alignment.center;

  @override
  Widget build(Widget child) {
    return Align(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}
```

### Edge Cases Only

```dart
// When naming convention fails (IconStyler → Icon, but widget is StyledIcon)
@MixableStyler(widgetType: StyledIcon)
class IconStyler extends Style<IconSpec> with _$IconStyler { ... }

// Custom method name
@StylerField(methodName: 'shadow')
final List<Shadow>? shadows;
```

---

## Auto-Detection Rules

### 1. Spec Type
```dart
// Extracted from generic type
class BoxStyler extends Style<BoxSpec>  // → specType = BoxSpec
```

### 2. Widget Type
```dart
// Naming convention: strip "Styler" suffix
BoxStyler → Box
TextStyler → StyledText
FlexStyler → Flex
```

### 3. Mix Type (from TypeRegistry)
```dart
EdgeInsetsGeometry → EdgeInsetsGeometryMix
Decoration → DecorationMix
BoxConstraints → BoxConstraintsMix
Color → Color (no Mix version)
double → double (primitive)
```

### 4. Prop Strategy
```dart
// If Mix type exists → Prop.maybeMix
// Otherwise → Prop.maybe

padding: Prop.maybeMix(padding)     // EdgeInsetsGeometryMix exists
alignment: Prop.maybe(alignment)    // No AlignmentGeometryMix
```

### 5. Override Detection
```dart
// Check mixin signatures
SpacingStyleMixin has padding() → @override needed
DecorationStyleMixin has decoration() → @override needed
```

### 6. Utility Type
```dart
EdgeInsetsGeometry → EdgeInsetsGeometryUtility
Color → ColorUtility
Decoration → DecorationUtility
```

---

## Annotations to Add

### To `annotations.dart`

```dart
/// Generates complete Styler class from fields.
///
/// Auto-detects: specType, widgetType, mixTypes, propStrategies, overrides.
class MixableStyler {
  /// Override widget type if naming convention fails
  final Type? widgetType;

  /// Generate MutableStyler companion (default: true)
  final bool generateMutable;

  /// Control which methods to generate
  final int methods;

  const MixableStyler({
    this.widgetType,
    this.generateMutable = true,
    this.methods = GeneratedStylerMethods.all,
  });
}

/// Generates Modifier triplet (Modifier + Mix + Utility)
class MixableModifier {
  /// Control which methods to generate
  final int methods;

  /// Generate ModifierMix class
  final bool generateMix;

  /// Generate ModifierUtility class
  final bool generateUtility;

  const MixableModifier({
    this.methods = GeneratedModifierMethods.all,
    this.generateMix = true,
    this.generateUtility = true,
  });
}

/// Field-level override - USE ONLY FOR EDGE CASES
///
/// Everything is auto-detected. Use only when detection fails.
class StylerField {
  /// Custom builder method name
  final String? methodName;

  /// Skip builder method generation
  final bool generateMethod;

  const StylerField({
    this.methodName,
    this.generateMethod = true,
  });
}
```

### To `generator_flags.dart`

```dart
/// Flags for Styler method generation
class GeneratedStylerMethods {
  static const int none = 0x00;
  static const int resolve = 0x01;
  static const int merge = 0x02;
  static const int builders = 0x04;
  static const int props = 0x08;
  static const int debug = 0x10;
  static const int call = 0x20;

  static const int all = resolve | merge | builders | props | debug | call;

  static const skipResolve = all & ~resolve;
  static const skipMerge = all & ~merge;
  static const skipBuilders = all & ~builders;

  const GeneratedStylerMethods._();
}

/// Flags for Modifier method generation
class GeneratedModifierMethods {
  static const int none = 0x00;
  static const int copyWith = 0x01;
  static const int lerp = 0x02;
  static const int props = 0x04;
  static const int debug = 0x08;

  static const int all = copyWith | lerp | props | debug;

  const GeneratedModifierMethods._();
}
```

---

## What's NOT Added (Unnecessary)

| Option | Why Removed |
|--------|-------------|
| `specType` | Auto-detected from `Style<S>` generic |
| `mixins` | Already declared in `with` clause |
| `typedefAlias` | Auto-detected from naming convention |
| `@StylerField.mixType` | Auto-detected from TypeRegistry |
| `@StylerField.propStrategy` | Auto-detected from type analysis |
| `@StylerField.utilityType` | Auto-detected from TypeRegistry |
| `@StylerField.utilityPath` | Rarely needed, use config file |
| `@StylerField.isDirective` | Can detect from `List<Directive<T>>` |
| `PropStrategy` enum | Always auto-detect |

---

## Reusing Existing Annotations

### Keep As-Is
- `@MixableSpec` - Already works for Spec generation
- `@MixableType` - Already works for DTO generation
- `@MixableUtility` - Already works for utility generation
- `@MixableField` - Still useful for Spec/DTO field configuration
- `@MixableConstructor` - Still useful

### Extend TypeRegistry
The existing TypeRegistry in the generator needs these mappings:

```dart
// Mix type mappings
final mixTypes = {
  'EdgeInsetsGeometry': 'EdgeInsetsGeometryMix',
  'Decoration': 'DecorationMix',
  'BoxConstraints': 'BoxConstraintsMix',
  'BorderRadiusGeometry': 'BorderRadiusGeometryMix',
  'BoxBorder': 'BoxBorderMix',
  'TextStyle': 'TextStyleMix',
  'StrutStyle': 'StrutStyleMix',
  'Shadow': 'ShadowMix',
};

// Utility type mappings
final utilityTypes = {
  'EdgeInsetsGeometry': 'EdgeInsetsGeometryUtility',
  'Color': 'ColorUtility',
  'Decoration': 'DecorationUtility',
  'BoxConstraints': 'BoxConstraintsUtility',
};

// Mixin method signatures (for @override detection)
final mixinMethods = {
  'SpacingStyleMixin': ['padding', 'margin'],
  'DecorationStyleMixin': ['decoration', 'foregroundDecoration'],
  'BorderStyleMixin': ['border'],
  'BorderRadiusStyleMixin': ['borderRadius'],
  'ConstraintStyleMixin': ['constraints'],
  'TransformStyleMixin': ['transform'],
  'AnimationStyleMixin': ['animate'],
  'VariantStyleMixin': ['variants'],
  'WidgetModifierStyleMixin': ['wrap'],
  'ShadowStyleMixin': ['shadow', 'shadows'],
};
```

---

## Complexity Comparison

| Component | Plan (Complex) | Minimal Design | Reduction |
|-----------|---------------|----------------|-----------|
| BoxStyler | 10 annotations, 50+ params | 1 annotation, 0 params | **95%** |
| IconStyler | 14 annotations | 1-2 annotations | **90%** |
| TextStyler | 15 annotations | 1 annotation | **93%** |
| AlignModifier | 4 annotations | 1 annotation | **75%** |
| **Total verbosity** | ~200 lines | ~20 lines | **90%** |

---

## Implementation Priority

### Phase 1: Core Detection (Week 1)
1. Add `@MixableStyler` and `@MixableModifier` annotations
2. Add `GeneratedStylerMethods` and `GeneratedModifierMethods` flags
3. Implement spec type extraction from `Style<S>` generic
4. Implement widget type inference from naming convention

### Phase 2: Type Registry (Week 2)
1. Add Mix type mappings to TypeRegistry
2. Add utility type mappings
3. Add mixin method signatures for override detection
4. Implement Prop strategy auto-detection

### Phase 3: Builders (Weeks 3-4)
1. Implement StylerClassBuilder with auto-detection
2. Implement MutableStylerBuilder
3. Implement ModifierTripletBuilder
4. Add golden file tests

### Phase 4: Migration (Weeks 5+)
1. Migrate BoxStyler as pilot
2. Validate generated code matches hand-written
3. Migrate remaining components

---

## Example: Full BoxStyler Migration

### Before (Hand-written: 298 lines)

```dart
// box_style.dart - 298 lines of boilerplate
class BoxStyler extends Style<BoxSpec> with ... {
  final Prop<AlignmentGeometry>? $alignment;
  // ... 8 more Prop fields

  const BoxStyler.create({...}) : $alignment = alignment, ...;

  BoxStyler({...}) : this.create(
    alignment: Prop.maybe(alignment),
    padding: Prop.maybeMix(padding),
    // ...
  );

  @override
  StyleSpec<BoxSpec> resolve(BuildContext context) {
    // ... 20 lines
  }

  @override
  BoxStyler merge(BoxStyler? other) {
    // ... 20 lines
  }

  // ... 30+ builder methods
}
```

### After (With Code Generation: ~30 lines)

```dart
// box_style.dart - User writes ~30 lines
@MixableStyler()
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
        AnimationStyleMixin<BoxStyler, BoxSpec>,
        _$BoxStyler {
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxConstraints? constraints;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip? clipBehavior;

  const BoxStyler({
    this.alignment,
    this.padding,
    this.margin,
    this.constraints,
    this.decoration,
    this.foregroundDecoration,
    this.transform,
    this.transformAlignment,
    this.clipBehavior,
  });
}

// Generated: box_style.g.dart - ~270 lines of boilerplate
```

**Result: 90% reduction in hand-written code**

---

*Simplified design based on Code Simplifier Agent analysis*
*November 2025*
