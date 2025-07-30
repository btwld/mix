# Modifier Code Generator Builder Specification

## Overview

This document outlines the requirements and specifications for building a Freezed-style code generator for Mix modifiers. The generator will automatically create all the boilerplate code required for modifiers while allowing developers to focus only on the unique aspects of their modifier.

## Type Registry System

The generator uses a type registry to determine how to handle different property types:

```dart
// Type registry maps Dart types to their Mix equivalents
class MixTypeRegistry {
  static const Map<String, String> mixTypes = {
    'EdgeInsetsGeometry': 'EdgeInsetsGeometryMix',
    'BoxConstraints': 'BoxConstraintsMix',
    'Border': 'BorderMix',
    'BorderRadius': 'BorderRadiusMix',
    'BoxShadow': 'BoxShadowMix',
    'Decoration': 'DecorationMix',
    'TextStyle': 'TextStyleMix',
    // Add more mappings as needed
  };
  
  static bool hasMixType(String dartType) => mixTypes.containsKey(dartType);
  static String getMixType(String dartType) => mixTypes[dartType]!;
}
```

## Annotation Syntax

### Basic Annotation

```dart
@mixableModifier
abstract class MyModifier extends Modifier<MyModifier> with _$MyModifier {
  const MyModifier._();
  
  const factory MyModifier({
    // properties - can be nullable or non-nullable
    required String name,
    double? width,
    EdgeInsetsGeometry? padding,
  }) = _MyModifier;
  
  Widget build(Widget child);
}
```

## User-Written Code Requirements

### 1. Class Declaration
- Must extend `Modifier<ModifierName>`
- Must mixin `_$ModifierName`
- Should be an `abstract` class
- Must include `part 'filename.g.dart';`

### 2. Private Constructor
- Must have a private const constructor: `const ModifierName._();`

### 3. Factory Constructor
- Must redirect to generated implementation: `= _ModifierName;`
- Properties can be nullable or non-nullable as per widget requirements
- Can use `required` keyword for mandatory properties

### 4. Build Method
- Must be abstract in the base class
- Implementation will be in the generated class
- Must accept a `Widget child` parameter

### 5. Custom Lerp (Optional)
- Can override the `lerp` method in the main class for custom behavior
- If not overridden, default lerp will be generated

## Generated Code Structure

### 1. Base Mixin (`_$ModifierName`)

```dart
mixin _$AlignModifier {
  // Properties match the factory constructor exactly
  AlignmentGeometry? get alignment;
  double? get widthFactor;
  double? get heightFactor;
  
  // Generated methods
  AlignModifier copyWith({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  });
  
  List<Object?> get props;
}
```

### 2. Implementation Class (`_ModifierName`)

```dart
class _AlignModifier extends AlignModifier with Diagnosticable {
  // Properties respect original nullability
  @override
  final AlignmentGeometry? alignment;
  @override
  final double? widthFactor;
  @override
  final double? heightFactor;

  const _AlignModifier({
    this.alignment,
    this.widthFactor,
    this.heightFactor,
  }) : super._();

  @override
  AlignModifier copyWith({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return AlignModifier(
      alignment: alignment ?? this.alignment,
      widthFactor: widthFactor ?? this.widthFactor,
      heightFactor: heightFactor ?? this.heightFactor,
    );
  }

  // Default lerp implementation (only if not overridden in main class)
  @override
  AlignModifier lerp(AlignModifier? other, double t) {
    if (other == null) return this;

    return AlignModifier(
      alignment: AlignmentGeometry.lerp(alignment, other.alignment, t),
      widthFactor: MixHelpers.lerpDouble(widthFactor, other.widthFactor, t),
      heightFactor: MixHelpers.lerpDouble(heightFactor, other.heightFactor, t),
    );
  }

  @override
  List<Object?> get props => [alignment, widthFactor, heightFactor];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(DoubleProperty('widthFactor', widthFactor))
      ..add(DoubleProperty('heightFactor', heightFactor));
  }
}
```

### 3. Attribute Class with Factory Methods

**Important**: All properties in the attribute are ALWAYS nullable, regardless of the modifier's properties.

```dart
class AlignModifierAttribute extends ModifierAttribute<AlignModifier>
    with Diagnosticable {
  // ALL properties are nullable with Prop wrappers
  final Prop<AlignmentGeometry>? alignment;
  final Prop<double>? widthFactor;
  final Prop<double>? heightFactor;

  const AlignModifierAttribute.raw({
    this.alignment,
    this.widthFactor,
    this.heightFactor,
  });

  // Constructor always accepts nullable values
  AlignModifierAttribute({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) : this.raw(
         alignment: Prop.maybe(alignment),
         widthFactor: Prop.maybe(widthFactor),
         heightFactor: Prop.maybe(heightFactor),
       );

  // Factory constructor for creating attribute with all properties
  static AlignModifierAttribute call({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return AlignModifierAttribute(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
    );
  }

  // Factory methods for individual properties (non-nullable)
  static AlignModifierAttribute alignment(AlignmentGeometry alignment) {
    return AlignModifierAttribute(alignment: alignment);
  }

  static AlignModifierAttribute widthFactor(double widthFactor) {
    return AlignModifierAttribute(widthFactor: widthFactor);
  }

  static AlignModifierAttribute heightFactor(double heightFactor) {
    return AlignModifierAttribute(heightFactor: heightFactor);
  }

  // Token factory methods
  static AlignModifierAttribute alignmentToken(MixToken<AlignmentGeometry> token) {
    return AlignModifierAttribute.raw(
      alignment: Prop.token(token),
    );
  }

  static AlignModifierAttribute widthFactorToken(MixToken<double> token) {
    return AlignModifierAttribute.raw(
      widthFactor: Prop.token(token),
    );
  }

  static AlignModifierAttribute heightFactorToken(MixToken<double> token) {
    return AlignModifierAttribute.raw(
      heightFactor: Prop.token(token),
    );
  }

  // Instance methods that merge with current values
  AlignModifierAttribute withAlignment(AlignmentGeometry alignment) {
    return merge(AlignModifierAttribute(alignment: alignment));
  }

  AlignModifierAttribute withWidthFactor(double widthFactor) {
    return merge(AlignModifierAttribute(widthFactor: widthFactor));
  }

  AlignModifierAttribute withHeightFactor(double heightFactor) {
    return merge(AlignModifierAttribute(heightFactor: heightFactor));
  }

  @override
  AlignModifier resolve(BuildContext context) {
    return AlignModifier(
      alignment: MixHelpers.resolve(context, alignment),
      widthFactor: MixHelpers.resolve(context, widthFactor),
      heightFactor: MixHelpers.resolve(context, heightFactor),
    );
  }

  @override
  AlignModifierAttribute merge(AlignModifierAttribute? other) {
    if (other == null) return this;

    return AlignModifierAttribute.raw(
      alignment: MixHelpers.merge(alignment, other.alignment),
      widthFactor: MixHelpers.merge(widthFactor, other.widthFactor),
      heightFactor: MixHelpers.merge(heightFactor, other.heightFactor),
    );
  }

  @override
  List<Object?> get props => [alignment, widthFactor, heightFactor];
}
```

## Type Registry Examples

### 1. Modifier with Mix Type (Padding)

**User writes:**
```dart
@mixableModifier
abstract class PaddingModifier extends Modifier<PaddingModifier> with _$PaddingModifier {
  const PaddingModifier._();

  const factory PaddingModifier({
    required EdgeInsetsGeometry padding, // Non-nullable in modifier
  }) = _PaddingModifier;

  @override
  Widget build(Widget child) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}
```

**Generated Attribute (using type registry):**
```dart
class PaddingModifierAttribute extends ModifierAttribute<PaddingModifier> {
  // Always nullable, uses MixProp because EdgeInsetsGeometry is in registry
  final MixProp<EdgeInsetsGeometry>? padding;

  const PaddingModifierAttribute.raw({
    this.padding,
  });

  // Constructor accepts Mix type from registry
  PaddingModifierAttribute({
    EdgeInsetsGeometryMix? padding, // Mix type from registry
  }) : this.raw(
         padding: MixProp.maybe(padding),
       );

  // Factory method uses Mix type
  static PaddingModifierAttribute padding(EdgeInsetsGeometryMix padding) {
    return PaddingModifierAttribute(padding: padding);
  }

  // Token method
  static PaddingModifierAttribute paddingToken(MixToken<EdgeInsetsGeometry> token) {
    return PaddingModifierAttribute.raw(
      padding: MixProp.token(token),
    );
  }

  @override
  PaddingModifier resolve(BuildContext context) {
    return PaddingModifier(
      padding: MixHelpers.resolve(context, padding)!, // Note: ! because modifier expects non-null
    );
  }
}
```

### 2. Modifier with Required and Optional Properties

**User writes:**
```dart
@mixableModifier
abstract class ContainerModifier extends Modifier<ContainerModifier> with _$ContainerModifier {
  const ContainerModifier._();

  const factory ContainerModifier({
    required BoxConstraints constraints,
    Color? color,
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
  }) = _ContainerModifier;

  @override
  Widget build(Widget child) {
    return Container(
      constraints: constraints,
      color: color,
      decoration: decoration,
      padding: padding,
      child: child,
    );
  }
}
```

**Generated Attribute:**
```dart
class ContainerModifierAttribute extends ModifierAttribute<ContainerModifier> {
  // All nullable, uses registry to determine types
  final MixProp<BoxConstraints>? constraints; // MixProp because BoxConstraintsMix exists
  final Prop<Color>? color;                   // Prop because no ColorMix in registry
  final MixProp<Decoration>? decoration;       // MixProp because DecorationMix exists
  final MixProp<EdgeInsetsGeometry>? padding; // MixProp because EdgeInsetsGeometryMix exists

  const ContainerModifierAttribute.raw({
    this.constraints,
    this.color,
    this.decoration,
    this.padding,
  });

  ContainerModifierAttribute({
    BoxConstraintsMix? constraints,      // Mix type from registry
    Color? color,                        // Regular type
    DecorationMix? decoration,           // Mix type from registry
    EdgeInsetsGeometryMix? padding,      // Mix type from registry
  }) : this.raw(
         constraints: MixProp.maybe(constraints),
         color: Prop.maybe(color),
         decoration: MixProp.maybe(decoration),
         padding: MixProp.maybe(padding),
       );

  @override
  ContainerModifier resolve(BuildContext context) {
    return ContainerModifier(
      constraints: MixHelpers.resolve(context, constraints)!, // ! for required
      color: MixHelpers.resolve(context, color),
      decoration: MixHelpers.resolve(context, decoration),
      padding: MixHelpers.resolve(context, padding),
    );
  }
}
```

## Default Lerp Behavior

The generator will create appropriate lerp implementations based on property types:

### Types with Lerp Methods
- Check if type has static `lerp` method
- Use it if available: `TypeName.lerp(a, b, t)`

### Primitive Types
| Dart Type | Default Lerp Method |
|-----------|-------------------|
| `int` | Step function (t < 0.5) |
| `double` | `MixHelpers.lerpDouble` |
| `bool` | Step function |
| `String` | Step function |

### Types with No Lerp
- Enums, callbacks, complex objects: Step function `t < 0.5 ? value : other.value`

## Generator Implementation Notes

### 1. Type Registry Integration
```dart
// During generation
for (final param in constructorParams) {
  final dartType = param.type.getDisplayString();
  
  if (MixTypeRegistry.hasMixType(dartType)) {
    // Use MixProp and Mix type
    final mixType = MixTypeRegistry.getMixType(dartType);
    // Generate: final MixProp<$dartType>? $paramName;
    // Constructor param: $mixType? $paramName
  } else {
    // Use regular Prop
    // Generate: final Prop<$dartType>? $paramName;
    // Constructor param: $dartType? $paramName
  }
}
```

### 2. Nullability Handling
- **Modifier**: Preserve original nullability from factory constructor
- **Attribute**: Always make properties nullable
- **Resolve**: Add `!` operator for required properties when resolving

### 3. Factory Method Generation
- Static `call` method with all nullable parameters
- Individual property factory methods (non-nullable parameters)
- Token methods for each property
- Instance methods prefixed with `with` for merging

### 4. Import Management
- Auto-import Mix types from registry
- Import required Flutter widgets
- Import MixHelpers and other utilities

## Testing Strategy

### 1. Type Registry Tests
- Test correct type mapping
- Test Mix type detection
- Test fallback to Prop for unknown types

### 2. Nullability Tests
- Test required properties in modifier
- Test all-nullable properties in attribute
- Test resolve with proper null handling

### 3. Integration Tests
- Test with various widget configurations
- Test with mix of required and optional properties
- Test with registry types and non-registry types

## Future Enhancements

1. **Extensible Type Registry**
   ```dart
   @MixableModifier(
     typeRegistry: CustomTypeRegistry,
   )
   ```

2. **Custom Type Mappings**
   ```dart
   @RegisterMixType('MyCustomType', 'MyCustomTypeMix')
   class MyModifier...
   ```

3. **Auto-detect Mix Types**
   - Scan codebase for Mix type definitions
   - Automatically populate registry