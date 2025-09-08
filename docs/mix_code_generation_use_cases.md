# Mix Framework Code Generation Use Cases

This document provides a comprehensive mapping of all code generation use cases in the Mix framework. Each pattern is documented with its purpose, structure, and concrete examples from the codebase.

## Table of Contents

1. [Spec Generation](#1-spec-generation)
2. [DTO/Mixable Generation](#2-dtomixable-generation)
3. [Attribute Generation](#3-attribute-generation)
4. [Utility Generation](#4-utility-generation)
5. [Modifier Generation](#5-modifier-generation)
6. [Extension Method Generation](#6-extension-method-generation)
7. [Type Registry Integration](#7-type-registry-integration)

---

## 1. Spec Generation

### Purpose
Specs define the styling contract for Mix widgets. Generated code provides consistent APIs for creating, modifying, and animating specs.

### Generated Components

#### A. Spec Mixin (`_$SpecName`)
**Pattern:** `mixin _$SpecName on Spec<SpecName>`

**Generated Methods:**
- `static SpecName from(MixContext mix)` - Creates spec from context
- `static SpecName of(BuildContext context)` - Retrieves spec from widget tree
- `SpecName copyWith({...})` - Creates modified copy
- `SpecName lerp(SpecName? other, double t)` - Interpolates between specs
- `List<Object?> get props` - Properties for equality comparison
- `void _debugFillProperties(DiagnosticPropertiesBuilder properties)` - Debug support

**Example from `box_spec.g.dart`:**
```dart
mixin _$BoxSpec on Spec<BoxSpec> {
  static BoxSpec from(MixContext mix) {
    return mix.attributeOf<BoxSpecAttribute>()?.resolve(mix) ?? const BoxSpec();
  }

  static BoxSpec of(BuildContext context) {
    return ComputedStyle.specOf<BoxSpec>(context) ?? const BoxSpec();
  }
  
  @override
  BoxSpec copyWith({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    // ... other properties
  }) {
    return BoxSpec(
      alignment: alignment ?? _$this.alignment,
      padding: padding ?? _$this.padding,
      // ... other properties
    );
  }
}
```

#### B. Spec Attribute Class
**Pattern:** `class SpecNameAttribute extends SpecAttribute<SpecName>`

**Generated Components:**
- Constructor with nullable fields
- `resolve(MixContext mix)` - Converts DTOs to Flutter types
- `merge(SpecNameAttribute? other)` - Merges attributes
- `List<Object?> get props` - Equality comparison
- `debugFillProperties` - Debug support

#### C. Spec Utility Class
**Pattern:** `class SpecNameUtility<T> extends SpecUtility<T, SpecNameAttribute>`

**Generated Components:**
- Nested utility fields for complex properties
- Convenience accessors mapping to nested properties
- `only({...})` method for creating attributes
- `call()` method with primitive parameters

**Example:**
```dart
class BoxSpecUtility<T extends StyleElement> 
    extends SpecUtility<T, BoxSpecAttribute> {
  // Nested utilities
  late final alignment = AlignmentGeometryUtility((v) => only(alignment: v));
  late final padding = EdgeInsetsGeometryUtility((v) => only(padding: v));
  
  // Convenience accessors
  late final color = decoration.color;
  late final borderRadius = decoration.borderRadius;
}
```

#### D. Spec Tween Class
**Pattern:** `class SpecNameTween extends Tween<SpecName?>`

**Generated Components:**
- Null-safe interpolation handling
- Fallback to default spec when both values are null

---

## 2. DTO/Mixable Generation

### Purpose
DTOs (Data Transfer Objects) provide type-safe wrappers around Flutter types with Mix-specific functionality like merging and resolution.

### Generated Components

#### A. DTO Mixin (`_$DtoName`)
**Pattern:** `mixin _$DtoName on Mixable<FlutterType>` or `mixin _$DtoName on Mixable<FlutterType>, HasDefaultValue<FlutterType>`

**Generated Methods:**
- `FlutterType resolve(MixContext mix)` - Resolves to Flutter type with fallbacks
- `DtoName merge(DtoName? other)` - Merges with another DTO using various strategies
- `List<Object?> get props` - Equality comparison
- `DtoName get _$this` - Type-safe self reference

**Merge Strategies:**
- Simple null coalescing: `other.property ?? _$this.property`
- Nested merging: `_$this.property?.merge(other.property) ?? other.property`
- Special merge utilities: `DtoType.tryToMerge(_$this.property, other.property)`
- List merging: `MixHelpers.mergeList(_$this.list, other.list)`

**Example from `border_dto.g.dart`:**
```dart
mixin _$BorderDto on Mixable<Border> {
  @override
  Border resolve(MixContext mix) {
    return Border(
      top: _$this.top?.resolve(mix) ?? BorderSide.none,
      bottom: _$this.bottom?.resolve(mix) ?? BorderSide.none,
      left: _$this.left?.resolve(mix) ?? BorderSide.none,
      right: _$this.right?.resolve(mix) ?? BorderSide.none,
    );
  }
  
  @override
  BorderDto merge(BorderDto? other) {
    if (other == null) return _$this;
    return BorderDto(
      top: _$this.top?.merge(other.top) ?? other.top,
      // ... other properties with nested merge
    );
  }
}
```

**Resolution Patterns:**
- **Simple fallback**: `property ?? defaultValue`
- **With default value**: `_$this.property ?? defaultValue.property` (for HasDefaultValue DTOs)
- **Nested resolution**: `property?.resolve(mix) ?? defaultValue`
- **List resolution**: `list?.map((e) => e.resolve(mix)).toList() ?? defaultValue`

#### B. Extension Methods
**Pattern:** 
- `extension FlutterTypeMixExt on FlutterType`
- `extension ListFlutterTypeMixExt on List<FlutterType>`

**Generated Methods:**
- `DtoName toDto()` - Converts Flutter type to DTO
- `List<DtoName> toDto()` - Batch conversion for lists

#### C. DTO Utility Class
**Pattern:** `class DtoNameUtility<T> extends DtoUtility<T, DtoName, FlutterType>`

**Generated Components:**
- Constructor with `valueToDto: (v) => v.toDto()` parameter
- Nested utilities for complex properties
- `only({...})` method with DTO parameters
- `call({...})` method with primitive parameters that auto-converts to DTOs

**Example from `gradient_dto.g.dart`:**
```dart
class LinearGradientUtility<T extends StyleElement>
    extends DtoUtility<T, LinearGradientDto, LinearGradient> {
  // Nested utilities
  late final begin = AlignmentGeometryUtility((v) => only(begin: v));
  late final colors = ListUtility<T, Mixable<Color>>((v) => only(colors: v));
  
  LinearGradientUtility(super.builder) : super(valueToDto: (v) => v.toDto());
  
  T call({
    AlignmentGeometry? begin,
    List<Mixable<Color>>? colors,
    List<double>? stops, // Primitive type
  }) {
    return only(
      begin: begin,
      colors: colors,
      stops: stops?.toDto(), // Auto-conversion
    );
  }
}
```

---

## 3. Attribute Generation

### Purpose
Attributes are the building blocks of specs, representing individual styling properties.

### Generated Components

Similar to Spec generation but simpler:
- Extends `SpecAttribute<T>` instead of `Spec<T>`
- No `from()` or `of()` methods
- Simpler structure focused on data storage and resolution

---

## 4. Utility Generation

### Purpose
Utilities provide the builder pattern API for creating style attributes and DTOs.

### Types of Utilities

#### A. Enum Utilities
**Pattern:** `mixin _$EnumNameUtility<T> on MixUtility<T, EnumType>`

**Generated Methods:**
- `T call(EnumType value)` - Direct value setter
- Named method for each enum value

**Example from `enum_util.g.dart`:**
```dart
mixin _$AxisUtility<T extends StyleElement> on MixUtility<T, Axis> {
  T call(Axis value) => builder(value);
  T horizontal() => builder(Axis.horizontal);
  T vertical() => builder(Axis.vertical);
}
```

#### B. Scalar Utilities
**Pattern:** Various patterns for Flutter value types

**Common Patterns:**
1. **Static constants** - `T zero()`, `T identity()`
2. **Constructor methods** - Match Flutter constructors with parameters
3. **Named presets** - Common values as methods
4. **Complex constructors** - Methods with multiple parameters and defaults

**Example from `scalar_util.g.dart`:**
```dart
mixin _$AlignmentUtility<T extends StyleElement>
    on MixUtility<T, AlignmentGeometry> {
  T topLeft() => builder(Alignment.topLeft);
  T topCenter() => builder(Alignment.topCenter);
  T center() => builder(Alignment.center);
  T call(AlignmentGeometry value) => builder(value);
}

mixin _$FontFeatureUtility<T extends StyleElement> 
    on MixUtility<T, FontFeature> {
  T enable(String feature) => builder(FontFeature.enable(feature));
  T disable(String feature) => builder(FontFeature.disable(feature));
  T alternative(int value) => builder(FontFeature.alternative(value));
  T alternativeFractions() => builder(const FontFeature.alternativeFractions());
  T localeAware({bool enable = true}) => builder(FontFeature.localeAware(enable: enable));
  T notationalForms([int value = 1]) => builder(FontFeature.notationalForms(value));
  T call(FontFeature value) => builder(value);
}
```

#### C. List Utilities
**Pattern:** Handle list types with proper generic constraints

**Generated Features:**
- Maintains list type safety
- Handles nested generics correctly

---

## 5. Modifier Generation

### Purpose
Widget modifiers provide composable widget transformations.

### Generated Components

Similar to Spec pattern but for widget modifiers:
- `ModifierSpec` with standard spec methods
- `ModifierSpecAttribute` for data storage
- `ModifierSpecUtility` for builder API

**Example Pattern:**
```dart
mixin _$PaddingModifierSpec on WidgetModifierSpec<PaddingModifierSpec> {
  @override
  PaddingModifierSpec copyWith({EdgeInsetsGeometry? padding}) {
    return PaddingModifierSpec(padding: padding ?? _$this.padding);
  }
  
  @override
  PaddingModifierSpec lerp(PaddingModifierSpec? other, double t) {
    return PaddingModifierSpec(
      padding: EdgeInsetsGeometry.lerp(_$this.padding, other?.padding, t),
    );
  }
}
```

---

## 6. Extension Method Generation

### Purpose
Provide convenient conversions between Flutter types and Mix types.

### Patterns

#### A. Single Type Extensions
```dart
extension ColorExt on Color {
  ColorDto toDto() => Mixable.value(this);
}
```

#### B. List Extensions
```dart
extension ListBorderMixExt on List<Border> {
  List<BorderDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}
```

#### C. Primitive Type Extensions
```dart
extension DoubleExt on double {
  SpaceDto toDto() => SpaceDto(this);
}

extension ListDoubleExt on List<double> {
  List<SpaceDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}
```

---

## 7. Type Registry Integration

### Purpose
The type registry maps types for code generation, determining which utilities and DTOs to generate.

### Key Mappings

#### A. Resolvables Map
Maps DTO/Attribute names to their resolved Flutter types:
```dart
final resolvables = {
  'BoxSpecAttribute': 'BoxSpec',
  'ColorDto': 'Color',
  'BorderDto': 'Border',
  // ... 30+ entries
};
```

#### B. Utilities Map
Maps utility class names to their value types:
```dart
final utilities = {
  'AlignmentUtility': 'Alignment',
  'ColorUtility': 'Color',
  'ListUtility': 'List',
  // ... 70+ entries
};
```

#### C. TryToMerge Set
Identifies DTOs with special merge handling:
```dart
final tryToMerge = {
  'BoxBorderDto',
  'DecorationDto',
  'EdgeInsetsGeometryDto',
  // ... 5 entries
};
```

**Special Merge Handling:**
DTOs in the `tryToMerge` set use `DtoType.tryToMerge()` static method instead of instance `merge()`. This handles complex merging scenarios where the properties have special merge logic or where null handling needs to be more sophisticated.

**Example:**
```dart
// Regular merge
decoration: decoration?.merge(other.decoration) ?? other.decoration,

// tryToMerge merge
decoration: DecorationDto.tryToMerge(decoration, other.decoration),
```

### Type Discovery Integration

The code generator uses these mappings to:
1. Determine which utility to use for a given type
2. Resolve DTOs to their Flutter equivalents
3. Handle special cases like typedefs and abstract types
4. Generate appropriate merge logic

---

## Common Generation Features

### 1. Null Safety
- All generated code is null-safe
- Proper null handling in merge operations
- Optional parameters with null defaults

### 2. Documentation
- Generated doc comments with usage examples
- Parameter descriptions
- Deprecation notices when applicable

### 3. Performance Optimizations
- `late final` fields for utilities
- Efficient merge algorithms
- Minimal object allocation

### 4. Debug Support
- `debugFillProperties` implementations
- Diagnostic information for Flutter Inspector
- Clear toString representations

### 5. Animation Support
- Lerp methods throughout with detailed interpolation logic
- Step vs smooth interpolation based on property type
- Tween classes for animations with null-safe handling

**Interpolation Patterns:**
- **Smooth interpolation**: Uses Flutter's built-in lerp methods (e.g., `AlignmentGeometry.lerp`, `EdgeInsetsGeometry.lerp`)
- **Step interpolation**: Uses conditional logic for non-interpolatable values (e.g., `t < 0.5 ? _$this.property : other.property`)
- **Custom lerping**: Uses `MixHelpers.lerpDouble` and `MixHelpers.lerpMatrix4` for special types
- **Fallback handling**: Returns current instance when other is null, handles default values properly

---

## Code Generation Annotations and Options

### Annotation Types and Their Triggers

#### A. `@MixableSpec()` - Spec Generation
**Purpose:** Generates spec mixins, attributes, utilities, and tweens for widget styling.

**Options:**
- `methods` - Controls which methods to generate within the spec class
  - `GeneratedSpecMethods.all` (default) - `copyWith`, `equals`, `lerp`
  - `GeneratedSpecMethods.skipCopyWith` - Skip `copyWith` method
  - `GeneratedSpecMethods.skipLerp` - Skip `lerp` method for non-animatable specs
- `components` - Controls external generated components
  - `GeneratedSpecComponents.all` (default) - utility, attribute, resolvableExtension, tween
  - `GeneratedSpecComponents.skipUtility` - Skip utility class generation
  - `GeneratedSpecComponents.skipTween` - Skip tween class for non-animatable specs

**Example:**
```dart
@MixableSpec()  // Generates all components and methods
final class BoxSpec extends Spec<BoxSpec> with _$BoxSpec {
  // ... spec properties
}
```

#### B. `@MixableType()` - DTO Generation
**Purpose:** Generates DTO mixins and extension methods for data transfer objects.

**Options:**
- `components` - Controls what gets generated
  - `GeneratedPropertyComponents.all` (default) - utility and resolvableExtension
  - `GeneratedPropertyComponents.skipUtility` - Skip utility class (used for base classes)
  - `GeneratedPropertyComponents.skipResolvableExtension` - Skip extension methods
- `mergeLists` - Controls list merging behavior (default: `true`)

**Example:**
```dart
@MixableType(components: GeneratedPropertyComponents.skipUtility)
final class BorderDto extends BoxBorderDto<Border> with _$BorderDto {
  // Generates mixin and extensions but no utility (parent class handles it)
}
```

#### C. `@MixableUtility()` - Utility Generation
**Purpose:** Generates utility mixins for enum values and scalar types.

**Options:**
- `methods` - Controls which methods to generate
  - `GeneratedUtilityMethods.all` (default) - includes `call` method
  - `GeneratedUtilityMethods.skipCallMethod` - Skip generic `call` method
- `referenceType` - Type to use for constructor methods

**Example:**
```dart
@MixableUtility(referenceType: Alignment)  // Uses Alignment constructors
final class AlignmentUtility<T> extends MixUtility<T, AlignmentGeometry> {
  // Generates methods based on Alignment static members
}
```

#### D. `@MixableField()` - Property-Level Customization
**Purpose:** Customizes generation for individual properties within specs.

**Options:**
- `dto` - Specifies custom DTO type for the property
- `utilities` - List of utility configurations for nested property access
- `isLerpable` - Controls lerp behavior (default: `true`)

**Property Path Mapping:**
```dart
const _boxDecor = MixableFieldUtility(
  type: BoxDecoration,
  properties: [
    (path: 'color', alias: 'color'),           // Direct access
    (path: 'border', alias: 'border'),         // Nested object
    (path: 'border.directional', alias: 'borderDirectional'), // Deep nesting
    (path: 'gradient.linear', alias: 'linearGradient'),       // Multiple levels
  ],
);

@MixableField(utilities: [_boxDecor])
final Decoration? decoration;
```

### Generation Decision Matrix

| Annotation | Generates Mixin | Generates Utility | Generates Extensions | Generates Tween |
|------------|----------------|-------------------|-------------------|-----------------|
| `@MixableSpec()` | ✅ Spec Mixin | ✅ Spec Utility | ❌ | ✅ Spec Tween |
| `@MixableType()` | ✅ DTO Mixin | ✅ DTO Utility* | ✅ Extension Methods | ❌ |
| `@MixableUtility()` | ✅ Utility Mixin | ❌ | ❌ | ❌ |

*Can be skipped with `GeneratedPropertyComponents.skipUtility`

### Special Generation Cases

#### A. Inheritance-Based Skipping
When a DTO extends another DTO (like `BorderDto` extending `BoxBorderDto`), utilities are often skipped for the child class to avoid duplication:

```dart
@MixableType(components: GeneratedPropertyComponents.skipUtility)
final class BorderDto extends BoxBorderDto<Border> {
  // Parent handles utility generation
}
```

#### B. Reference Type Constructors
For scalar utilities, `referenceType` tells the generator to create methods based on the reference type's static members:

```dart
@MixableUtility(referenceType: Alignment)
final class AlignmentUtility<T> extends MixUtility<T, AlignmentGeometry> {
  // Generates: topLeft(), center(), bottomRight(), etc.
}
```

#### C. Non-Lerpable Properties
Properties that shouldn't be interpolated use `isLerpable: false`:

```dart
@MixableField(isLerpable: false)
final AnimationConfig? animated;  // Uses step interpolation in lerp method
```

#### D. Complex Utility Nesting
The `MixableFieldUtility` creates nested utility access patterns:

```dart
// From: decoration.gradient.linear.begin()
// Generated: late final linearGradient = LinearGradientUtility(...)
// Generated: late final begin = linearGradient.begin
```

### Annotation Decision Flow

1. **For Widget Specs:** Use `@MixableSpec()` - generates complete spec ecosystem
2. **For DTOs:** Use `@MixableType()` - generates DTO mixins and conversions
3. **For Utilities:** Use `@MixableUtility()` - generates utility mixins
4. **For Properties:** Use `@MixableField()` - customizes individual property generation
5. **For Constructors:** Use `@MixableConstructor()` - includes specific constructors in generation

This annotation system provides fine-grained control over what gets generated while maintaining consistent patterns across the framework.

---

## Summary

The Mix framework's code generation system provides:

1. **Consistent APIs** - All generated code follows predictable patterns
2. **Type Safety** - Strong typing with proper generic constraints
3. **Performance** - Optimized code with minimal overhead
4. **Developer Experience** - Intuitive APIs with good documentation
5. **Maintainability** - Changes to generation templates affect all generated code uniformly

The type registry acts as the central configuration, mapping types to their utilities and representations, enabling the code generator to produce appropriate implementations for each type in the system.