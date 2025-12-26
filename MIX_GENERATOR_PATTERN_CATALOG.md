# Mix 2.0 Generator Pattern Catalog

## Overview

This document catalogs all repetitive patterns identified in the Mix 2.0 codebase for Spec, Styler, and MutableStyler classes. These patterns form the foundation for the new generator architecture.

---

## 1. Spec Patterns

### 1.1 Class Structure Pattern

**Location**: `packages/mix/lib/src/specs/*/`

```dart
/// {Documentation}
final class {Name}Spec extends Spec<{Name}Spec> with Diagnosticable {
  // Fields...

  const {Name}Spec({...});

  @override
  {Name}Spec copyWith({...});

  @override
  {Name}Spec lerp({Name}Spec? other, double t);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties);

  @override
  List<Object?> get props => [...];
}
```

**Examples**:
- `BoxSpec` (box_spec.dart:13)
- `TextSpec` (text_spec.dart:12) - uses `final class`
- `IconSpec` (icon_spec.dart:11) - uses `final class`
- `FlexSpec` (flex_spec.dart:12) - uses `@immutable` + `final class`

### 1.2 Field Declaration Pattern

**Rule**: All Spec fields are **nullable** with `?` suffix.

| Category | Type Examples | Pattern |
|----------|--------------|---------|
| Flutter primitives | `double?`, `int?`, `bool?`, `String?` | Direct declaration |
| Flutter geometry | `EdgeInsetsGeometry?`, `AlignmentGeometry?`, `BoxConstraints?` | Direct declaration |
| Flutter painting | `Color?`, `Decoration?`, `TextStyle?`, `Gradient?` | Direct declaration |
| Flutter enums | `Clip?`, `Axis?`, `TextAlign?`, `BoxFit?` | Direct declaration |
| Collections | `List<Shadow>?`, `List<Directive<String>>?` | Nullable list |
| Special | `Matrix4?`, `ImageProvider<Object>?` | Direct declaration |

**Examples from codebase**:
```dart
// BoxSpec
final AlignmentGeometry? alignment;
final EdgeInsetsGeometry? padding;
final Decoration? decoration;
final Clip? clipBehavior;

// TextSpec
final TextOverflow? overflow;
final TextStyle? style;
final List<Directive<String>>? textDirectives;

// IconSpec
final Color? color;
final double? size;
final List<Shadow>? shadows;
```

### 1.3 Constructor Pattern

**Pattern**: All-optional named parameters with `this.` syntax.

```dart
const {Name}Spec({
  this.field1,
  this.field2,
  // ... all fields
});
```

**Key observations**:
- Constructor is always `const`
- All parameters are optional (no `required`)
- Uses `this.` shorthand for all fields

### 1.4 copyWith Pattern

```dart
@override
{Name}Spec copyWith({
  Type1? field1,
  Type2? field2,
  // ... all fields with nullable parameter types
}) {
  return {Name}Spec(
    field1: field1 ?? this.field1,
    field2: field2 ?? this.field2,
    // ... null-coalescing for all fields
  );
}
```

**Key**: Each field uses `paramName ?? this.fieldName` pattern.

### 1.5 lerp Pattern

**Critical**: Type determines lerp strategy.

```dart
@override
{Name}Spec lerp({Name}Spec? other, double t) {
  return {Name}Spec(
    lerpableField: MixOps.lerp(lerpableField, other?.lerpableField, t),
    snappableField: MixOps.lerpSnap(snappableField, other?.snappableField, t),
  );
}
```

**Type → Lerp Strategy Mapping**:

| Type | Strategy | Code |
|------|----------|------|
| `double` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `int` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `Color` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `EdgeInsetsGeometry` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `AlignmentGeometry` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `BoxConstraints` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `Decoration` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `TextStyle` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `StrutStyle` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `Matrix4` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `Rect` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `List<Shadow>` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `List<BoxShadow>` | interpolate | `MixOps.lerp(a, other?.a, t)` |
| `bool` | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `String` | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `Clip` (enum) | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `Axis` (enum) | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `TextAlign` (enum) | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `TextDirection` (enum) | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `BoxFit` (enum) | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `BlendMode` (enum) | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `ImageProvider<Object>` | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `IconData` | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `TextScaler` | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `List<Directive<String>>` | snap | `MixOps.lerpSnap(a, other?.a, t)` |
| `Locale` | snap | `MixOps.lerpSnap(a, other?.a, t)` |

**Decision Rule**:
- If type has a static `lerp` method → use `MixOps.lerp` (interpolate)
- If type is enum → use `MixOps.lerpSnap` (snap)
- If type is discrete/non-interpolatable → use `MixOps.lerpSnap` (snap)

### 1.6 debugFillProperties Pattern

```dart
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  super.debugFillProperties(properties);
  properties
    ..add({DiagnosticType}('{fieldName}', fieldName))
    ..add({DiagnosticType}('{fieldName}', fieldName));
}
```

**Type → DiagnosticProperty Mapping**:

| Type | Diagnostic Property |
|------|---------------------|
| `Color` | `ColorProperty('name', value)` |
| `double` | `DoubleProperty('name', value)` |
| `int` | `IntProperty('name', value)` |
| `String` | `StringProperty('name', value)` |
| `bool` | `FlagProperty('name', value: value, ifTrue: 'description')` |
| enum types | `EnumProperty<EnumType>('name', value)` |
| `List<T>` | `IterableProperty<T>('name', value)` |
| other | `DiagnosticsProperty('name', value)` |

**Examples**:
```dart
// BoxSpec
..add(DiagnosticsProperty('alignment', alignment))
..add(EnumProperty<Clip>('clipBehavior', clipBehavior))

// TextSpec
..add(EnumProperty<TextOverflow>('overflow', overflow))
..add(IntProperty('maxLines', maxLines))
..add(FlagProperty('softWrap', value: softWrap, ifTrue: 'wrapping at word boundaries'))

// IconSpec
..add(ColorProperty('color', color))
..add(DoubleProperty('size', size))
..add(IterableProperty<Shadow>('shadows', shadows))
```

### 1.7 props Pattern

```dart
@override
List<Object?> get props => [
  field1,
  field2,
  // ... all fields in declaration order
];
```

---

## 2. Styler Patterns

### 2.1 Class Structure Pattern

**Location**: `packages/mix/lib/src/specs/*/`

```dart
typedef {Name}Mix = {Name}Styler;

class {Name}Styler extends Style<{Name}Spec>
    with
        Diagnosticable,
        WidgetModifierStyleMixin<{Name}Styler, {Name}Spec>,
        VariantStyleMixin<{Name}Styler, {Name}Spec>,
        WidgetStateVariantMixin<{Name}Styler, {Name}Spec>,
        // ... domain-specific mixins
        AnimationStyleMixin<{Name}Styler, {Name}Spec> {

  // $-prefixed Prop fields
  final Prop<Type>? $fieldName;

  // .create() constructor (internal)
  const {Name}Styler.create({...});

  // Public constructor
  {Name}Styler({...}) : this.create(...);

  // Static chain accessor
  static {Name}MutableStyler get chain => {Name}MutableStyler({Name}Styler());

  // Setter methods
  {Name}Styler fieldName(Type value);

  // resolve()
  @override
  StyleSpec<{Name}Spec> resolve(BuildContext context);

  // merge()
  @override
  {Name}Styler merge({Name}Styler? other);

  // debugFillProperties()
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties);

  // props getter
  @override
  List<Object?> get props => [...];
}
```

### 2.2 Field Declaration Pattern

**Rule**: All Styler fields are `Prop<T>?` wrapped with `$` prefix.

```dart
final Prop<AlignmentGeometry>? $alignment;
final Prop<EdgeInsetsGeometry>? $padding;
final Prop<Decoration>? $decoration;
final Prop<Clip>? $clipBehavior;
```

**Exceptions**:
- `List<Directive<String>>? $textDirectives` - NOT wrapped in Prop (TextStyler:50)

### 2.3 Dual Constructor Pattern

**.create() Constructor** (internal, takes Props):
```dart
const {Name}Styler.create({
  Prop<Type1>? field1,
  Prop<Type2>? field2,
  super.animation,
  super.modifier,
  super.variants,
}) : $field1 = field1,
     $field2 = field2;
```

**Public Constructor** (takes raw values, converts to Props):
```dart
{Name}Styler({
  Type1? field1,
  MixType2? field2,  // Mix types for mergeable fields
  AnimationConfig? animation,
  WidgetModifierConfig? modifier,
  List<VariantStyle<{Name}Spec>>? variants,
}) : this.create(
       field1: Prop.maybe(field1),           // For non-Mix types
       field2: Prop.maybeMix(field2),        // For Mix types
       animation: animation,
       modifier: modifier,
       variants: variants,
     );
```

**Prop Wrapper Decision**:

| Public Parameter Type | Prop Wrapper |
|-----------------------|--------------|
| `Type?` (Flutter type) | `Prop.maybe(value)` |
| `TypeMix?` (Mix type) | `Prop.maybeMix(value)` |
| `List<ShadowMix>?` | `Prop.mix(ShadowListMix(value))` |
| `List<Directive<String>>?` | Pass through (no wrapper) |

### 2.4 Setter Method Pattern

```dart
/// Sets the {description}.
{Name}Styler fieldName(Type value) {
  return merge({Name}Styler(fieldName: value));
}
```

**All setter methods**:
1. Take a single value parameter
2. Call `merge()` with a new Styler instance
3. Return `{Name}Styler`

### 2.5 resolve() Pattern

```dart
@override
StyleSpec<{Name}Spec> resolve(BuildContext context) {
  final spec = {Name}Spec(
    field1: MixOps.resolve(context, $field1),
    field2: MixOps.resolve(context, $field2),
    // Special: pass through non-Prop fields directly
    textDirectives: $textDirectives,
  );

  return StyleSpec(
    spec: spec,
    animation: $animation,
    widgetModifiers: $modifier?.resolve(context),
  );
}
```

### 2.6 merge() Pattern

```dart
@override
{Name}Styler merge({Name}Styler? other) {
  return {Name}Styler.create(
    field1: MixOps.merge($field1, other?.$field1),
    field2: MixOps.merge($field2, other?.$field2),
    // Special: mergeList for List types
    textDirectives: MixOps.mergeList($textDirectives, other?.$textDirectives),
    // Base fields always included
    animation: MixOps.mergeAnimation($animation, other?.$animation),
    modifier: MixOps.mergeModifier($modifier, other?.$modifier),
    variants: MixOps.mergeVariants($variants, other?.$variants),
  );
}
```

**Merge Decision**:

| Field Type | Merge Pattern |
|------------|---------------|
| `Prop<T>?` | `MixOps.merge($field, other?.$field)` |
| `List<T>?` | `MixOps.mergeList($field, other?.$field)` |
| `AnimationConfig?` | `MixOps.mergeAnimation($animation, other?.$animation)` |
| `WidgetModifierConfig?` | `MixOps.mergeModifier($modifier, other?.$modifier)` |
| `List<VariantStyle<S>>?` | `MixOps.mergeVariants($variants, other?.$variants)` |

### 2.7 Common Mixins Pattern

**Required mixins** (all Stylers):
- `Diagnosticable`
- `WidgetModifierStyleMixin<{Name}Styler, {Name}Spec>`
- `VariantStyleMixin<{Name}Styler, {Name}Spec>`
- `WidgetStateVariantMixin<{Name}Styler, {Name}Spec>`
- `AnimationStyleMixin<{Name}Styler, {Name}Spec>`

**Domain mixins** (based on fields):

| Spec Features | Mixin |
|---------------|-------|
| Has padding/margin | `SpacingStyleMixin<{Name}Styler>` |
| Has decoration | `DecorationStyleMixin<{Name}Styler>` |
| Has border | `BorderStyleMixin<{Name}Styler>` |
| Has borderRadius | `BorderRadiusStyleMixin<{Name}Styler>` |
| Has shadow | `ShadowStyleMixin<{Name}Styler>` |
| Has transform | `TransformStyleMixin<{Name}Styler>` |
| Has constraints | `ConstraintStyleMixin<{Name}Styler>` |
| Has TextStyle | `TextStyleMixin<{Name}Styler>` |
| Has flex properties | `FlexStyleMixin<{Name}Styler>` |

---

## 3. MutableStyler Patterns

### 3.1 Class Structure Pattern

```dart
class {Name}MutableStyler extends StyleMutableBuilder<{Name}Spec>
    with
        UtilityVariantMixin<{Name}Styler, {Name}Spec>,
        UtilityWidgetStateVariantMixin<{Name}Styler, {Name}Spec> {

  // Utility declarations
  late final fieldName = {Utility}Type<{Name}Styler>(...);

  // Convenience accessors
  late final shortcut = utility.nested.property;

  // Mutable state
  @override
  @protected
  late final {Name}MutableState mutable;

  // Constructor
  {Name}MutableStyler([{Name}Styler? attribute]) {
    mutable = {Name}MutableState(attribute ?? {Name}Styler());
  }

  // Direct methods
  {Name}Styler methodName(Type v) => mutable.methodName(v);

  // Animation
  {Name}Styler animate(AnimationConfig animation) => mutable.animate(animation);

  // Variant methods
  @override
  {Name}Styler withVariant(Variant variant, {Name}Styler style);

  @override
  {Name}Styler withVariants(List<VariantStyle<{Name}Spec>> variants);

  // merge() and resolve()
  @override
  {Name}MutableStyler merge(Style<{Name}Spec>? other);

  @override
  StyleSpec<{Name}Spec> resolve(BuildContext context);

  // Value accessors
  @override
  {Name}Styler get currentValue => mutable.value;

  @override
  {Name}Styler get value => mutable.value;
}

class {Name}MutableState extends {Name}Styler with Mutable<{Name}Styler, {Name}Spec> {
  {Name}MutableState({Name}Styler style) {
    value = style;
  }
}
```

### 3.2 Utility Initialization Pattern

```dart
late final fieldName = {Utility}Type<{Name}Styler>(
  (prop) => mutable.merge({Name}Styler.create(fieldName: Prop.mix(prop))),
);
```

**Type → Utility Mapping**:

| Field Type | Utility | Callback |
|------------|---------|----------|
| `EdgeInsetsGeometry` | `EdgeInsetsGeometryUtility` | `(prop) => mutable.merge({Name}Styler.create(fieldName: Prop.mix(prop)))` |
| `BoxConstraints` | `BoxConstraintsUtility` | Same pattern |
| `Decoration` | `DecorationUtility` | Same pattern |
| `TextStyle` | `TextStyleUtility` | Same pattern |
| `StrutStyle` | `StrutStyleUtility` | Same pattern |
| `TextHeightBehavior` | `TextHeightBehaviorUtility` | Same pattern |
| `Color` | `ColorUtility` | Same pattern |
| Simple types | `MixUtility` | `MixUtility(mutable.methodName)` |

### 3.3 Convenience Accessor Pattern

```dart
// Nested property delegation
late final border = decoration.box.border;
late final borderRadius = decoration.box.borderRadius;
late final color = decoration.box.color;
late final shadow = decoration.box.boxShadow;

// Constraint shortcuts
late final width = constraints.width;
late final height = constraints.height;
late final minWidth = constraints.minWidth;
late final maxWidth = constraints.maxWidth;

// Text style shortcuts
late final fontSize = style.fontSize;
late final fontWeight = style.fontWeight;
late final fontFamily = style.fontFamily;
```

### 3.4 Deprecated Utility Pattern

```dart
@Deprecated(
  'Use direct methods like \$box.onHovered() instead. '
  'Note: Returns {Name}Style for consistency with other utility methods like animate().',
)
late final on = OnContextVariantUtility<{Name}Spec, {Name}Styler>(
  (v) => mutable.variants([v]),
);
```

---

## 4. Mix Type Patterns

### 4.1 Class Structure Pattern

```dart
@immutable
sealed class {Name}Mix<T extends {FlutterType}> extends Mix<T> {
  final Prop<FieldType1>? $field1;
  final Prop<FieldType2>? $field2;

  const {Name}Mix({...}) : ...;

  // Factory constructors
  factory {Name}Mix.value(T value);
  static {Name}Mix? maybeValue(T? value);

  // Convenience constructors
  static {Subtype}Mix fieldName(FieldType value);

  // Methods
  @override
  {Name}Mix<T> merge(covariant {Name}Mix<T>? other);
}
```

### 4.2 Subclass Pattern

```dart
final class {Subtype}Mix extends {Name}Mix<{FlutterType}> with Diagnosticable {
  // Additional fields specific to this subtype
  final Prop<Type>? $specificField;

  // Public constructor
  {Subtype}Mix({
    Type? field1,
    MixType? mixField,
  }) : this.create(
         field1: Prop.maybe(field1),
         mixField: Prop.maybeMix(mixField),
       );

  // Internal constructor
  const {Subtype}Mix.create({...}) : ...;

  // Value constructor
  {Subtype}Mix.value({FlutterType} value) : this(...);

  // Fluent methods
  {Subtype}Mix fieldName(Type value) => merge({Subtype}Mix.fieldName(value));

  @override
  {FlutterType} resolve(BuildContext context) {
    return {FlutterType}(
      field1: MixOps.resolve(context, $field1),
      field2: MixOps.resolve(context, $field2) ?? defaultValue,
    );
  }

  @override
  {Subtype}Mix merge({Subtype}Mix? other) {
    return {Subtype}Mix.create(
      field1: MixOps.merge($field1, other?.$field1),
      field2: MixOps.merge($field2, other?.$field2),
    );
  }
}
```

---

## 5. Mapping Tables

### 5.1 Type → Lerp Strategy

```
LERPABLE (use MixOps.lerp):
  - double, int
  - Color, HSVColor, HSLColor
  - Offset, Size, Rect, RRect
  - Alignment, FractionalOffset, AlignmentGeometry
  - EdgeInsets, EdgeInsetsGeometry
  - BorderRadius, BorderRadiusGeometry
  - RelativeRect
  - TextStyle, StrutStyle
  - BoxShadow, Shadow
  - List<BoxShadow>, List<Shadow>
  - Border, ShapeBorder
  - LinearGradient, RadialGradient, SweepGradient
  - BoxConstraints
  - IconThemeData
  - Matrix4
  - Decoration (BoxDecoration, ShapeDecoration)
  - Nested Spec types (delegates to inner lerp)

SNAPPABLE (use MixOps.lerpSnap):
  - bool, String
  - All enums (Clip, Axis, TextAlign, TextDirection, etc.)
  - ImageProvider<Object>
  - IconData
  - TextScaler
  - Locale
  - TextHeightBehavior
  - FilterQuality
  - List<Directive<T>>
  - Callbacks/Functions
```

### 5.2 Type → Prop Wrapper

| Public Type | Prop Method |
|-------------|-------------|
| `T` (non-Mix Flutter type) | `Prop.maybe(value)` |
| `TMix` (Mix type) | `Prop.maybeMix(value)` |
| `List<TMix>` (List of Mix) | `Prop.mix(TListMix(value))` |
| `List<T>` (direct pass) | No wrapper (direct assignment) |

### 5.3 Type → Utility Class

| Type | Utility |
|------|---------|
| `EdgeInsetsGeometry` | `EdgeInsetsGeometryUtility` |
| `BoxConstraints` | `BoxConstraintsUtility` |
| `Decoration` | `DecorationUtility` |
| `TextStyle` | `TextStyleUtility` |
| `StrutStyle` | `StrutStyleUtility` |
| `TextHeightBehavior` | `TextHeightBehaviorUtility` |
| `Color` | `ColorUtility` |
| `Gradient` | `GradientUtility` |
| `BoxBorder` | `BoxBorderUtility` |
| `BorderRadiusGeometry` | `BorderRadiusGeometryUtility` |
| `DecorationImage` | `DecorationImageUtility` |
| `ShapeBorder` | `ShapeBorderUtility` |
| `List<BoxShadow>` | `BoxShadowListUtility` |
| `List<Shadow>` | `ShadowListUtility` |
| Simple scalars | `MixUtility(callback)` |

### 5.4 Type → Diagnostic Property

| Type | DiagnosticsProperty |
|------|---------------------|
| `Color` | `ColorProperty` |
| `double` | `DoubleProperty` |
| `int` | `IntProperty` |
| `String` | `StringProperty` |
| `bool` | `FlagProperty` (with ifTrue) |
| `enum` | `EnumProperty<T>` |
| `List<T>` | `IterableProperty<T>` |
| other | `DiagnosticsProperty` |

---

## 6. Generator Architecture

### 6.1 Proposed Directory Structure

```
packages/mix_generator/lib/src/
  mix_generator.dart              # Entry point
  core/
    metadata/
      spec_metadata.dart          # Spec class analysis
      styler_metadata.dart        # NEW: Styler class analysis
      mutable_metadata.dart       # NEW: MutableStyler analysis
      field_metadata.dart         # Field-level metadata
      type_metadata.dart          # Type introspection
    builders/
      spec_builder.dart           # Generate Spec methods
      styler_builder.dart         # NEW: Generate Styler class
      mutable_builder.dart        # NEW: Generate MutableStyler
    resolvers/
      lerp_resolver.dart          # NEW: Type → lerp strategy
      prop_resolver.dart          # NEW: Type → Prop wrapper
      utility_resolver.dart       # NEW: Type → Utility class
      diagnostic_resolver.dart    # NEW: Type → DiagnosticsProperty
    utils/
      code_builder.dart           # code_builder utilities
      type_utils.dart             # Type analysis helpers
```

### 6.2 Metadata Classes

```dart
/// Extracts Spec field information
class SpecFieldMetadata {
  final String name;
  final DartType type;
  final bool isNullable;
  final LerpStrategy lerpStrategy;
  final DiagnosticType diagnosticType;
}

/// Extracts Styler field information
class StylerFieldMetadata {
  final String name;
  final DartType specType;      // Type in Spec
  final DartType? mixType;      // Type in public constructor (if different)
  final PropWrapper propWrapper;
  final String? utilityClass;
}

/// Extracts MutableStyler information
class MutableFieldMetadata {
  final String name;
  final String utilityClass;
  final List<String> convenienceAccessors;
}
```

### 6.3 Resolver Classes

```dart
abstract class LerpResolver {
  LerpStrategy resolveStrategy(DartType type);
  String generateLerpCode(String fieldName, DartType type);
}

abstract class PropResolver {
  PropWrapper resolveWrapper(DartType type, bool hasMixType);
  String generatePropCode(String value, DartType type);
}

abstract class UtilityResolver {
  String? resolveUtility(DartType type);
  String generateUtilityInit(String fieldName, DartType type, String stylerName);
}
```

### 6.4 Builder Classes

```dart
class SpecBodyBuilder {
  String buildCopyWith(SpecMetadata metadata);
  String buildLerp(SpecMetadata metadata);
  String buildDebugFillProperties(SpecMetadata metadata);
  String buildProps(SpecMetadata metadata);
}

class StylerBuilder {
  String buildFields(StylerMetadata metadata);
  String buildCreateConstructor(StylerMetadata metadata);
  String buildPublicConstructor(StylerMetadata metadata);
  String buildSetterMethods(StylerMetadata metadata);
  String buildResolve(StylerMetadata metadata);
  String buildMerge(StylerMetadata metadata);
}

class MutableStylerBuilder {
  String buildUtilities(MutableMetadata metadata);
  String buildConvenienceAccessors(MutableMetadata metadata);
  String buildMutableState(MutableMetadata metadata);
}
```

---

## 7. Implementation Plan

### Phase 1: Metadata Extraction Layer
1. Create `StylerMetadata` class (mirrors SpecMetadata for Stylers)
2. Create `MutableMetadata` class
3. Enhance `FieldMetadata` with Mix-specific properties

### Phase 2: Type Resolution Utilities
1. Implement `LerpResolver` with type lookup table
2. Implement `PropResolver` with Mix type detection
3. Implement `UtilityResolver` with utility mapping
4. Implement `DiagnosticResolver` with property type mapping

### Phase 3: Spec Builder
1. Port existing Spec generation to new architecture
2. Add code_builder integration
3. Generate copyWith, lerp, debugFillProperties, props

### Phase 4: Styler Builder
1. Generate field declarations ($-prefixed Props)
2. Generate dual constructors (.create and public)
3. Generate setter methods
4. Generate resolve() method
5. Generate merge() method
6. Generate mixin applications

### Phase 5: MutableStyler Builder
1. Generate utility initializations
2. Generate convenience accessors
3. Generate MutableState class
4. Generate variant methods

### Phase 6: Testing Infrastructure
1. Golden file tests for each generated artifact
2. Unit tests for resolvers
3. Integration tests with build_runner

---

## 8. File References

### Spec Files Analyzed
- `packages/mix/lib/src/specs/box/box_spec.dart`
- `packages/mix/lib/src/specs/text/text_spec.dart`
- `packages/mix/lib/src/specs/icon/icon_spec.dart`
- `packages/mix/lib/src/specs/flex/flex_spec.dart`
- `packages/mix/lib/src/specs/stack/stack_spec.dart`
- `packages/mix/lib/src/specs/image/image_spec.dart`

### Styler Files Analyzed
- `packages/mix/lib/src/specs/box/box_style.dart`
- `packages/mix/lib/src/specs/text/text_style.dart`
- `packages/mix/lib/src/specs/icon/icon_style.dart`
- `packages/mix/lib/src/specs/flex/flex_style.dart`

### MutableStyler Files Analyzed
- `packages/mix/lib/src/specs/box/box_mutable_style.dart`
- `packages/mix/lib/src/specs/text/text_mutable_style.dart`

### Core Files Analyzed
- `packages/mix/lib/src/core/spec.dart`
- `packages/mix/lib/src/core/style.dart`
- `packages/mix/lib/src/core/prop.dart`
- `packages/mix/lib/src/core/helpers.dart` (MixOps)
- `packages/mix/lib/src/core/spec_utility.dart`
- `packages/mix/lib/src/core/utility.dart`
- `packages/mix/lib/src/core/mix_element.dart`
- `packages/mix/lib/src/core/style_spec.dart`

### Mix Type Files Analyzed
- `packages/mix/lib/src/properties/painting/decoration_mix.dart`
- `packages/mix/lib/src/properties/layout/edge_insets_geometry_mix.dart`
- `packages/mix/lib/src/properties/layout/edge_insets_geometry_util.dart`

### Annotation Files Analyzed
- `packages/mix_annotations/lib/src/annotations.dart`
- `packages/mix_annotations/lib/src/generator_flags.dart`

### Legacy Generator Files Analyzed
- `packages/mix_generator/lib/src/mix_generator.dart`
- `packages/mix_generator/lib/src/core/metadata/spec_metadata.dart`
- `packages/mix_generator/lib/src/core/type_registry.dart`
