# Mix Type System: Complete Overview

## Table of Contents
1. [Overview](#overview)
2. [Core Type Hierarchy](#core-type-hierarchy)
3. [The Style → SpecAttribute → Spec Resolution Flow](#the-style--specattribute--spec-resolution-flow)
4. [Mixable System and Value Resolution](#mixable-system-and-value-resolution)
5. [Token System](#token-system)
6. [Merging and Composition](#merging-and-composition)
7. [Performance and Optimization](#performance-and-optimization)
8. [Use Cases and Examples](#use-cases-and-examples)
9. [Key Relationships Summary](#key-relationships-summary)

## Overview

The Mix type system is a sophisticated styling framework for Flutter that provides:

- **Type-safe styling** with compile-time validation
- **Token-based theming** for consistent design systems
- **Flexible composition** through merging and variants
- **Performance optimization** through computed styles and selective rebuilds
- **Animation support** built into the core system

### Key Design Principles

1. **Separation of Concerns**: Clear distinction between style definitions (attributes) and resolved values (specs)
2. **Composability**: Everything can be merged and combined
3. **Performance**: Lazy evaluation and surgical rebuilds
4. **Extensibility**: Easy to add new attributes and utilities
5. **Type Safety**: Compile-time validation of styling properties

## Core Type Hierarchy

### 1. StyleElement (Base Class)
```dart
abstract class StyleElement with EqualityMixin {
  Object get mergeKey => runtimeType;
  StyleElement merge(covariant StyleElement? other);
}
```

**Purpose**: Base class for all styling elements in the Mix system.

**Key Features**:
- Provides `mergeKey` for determining merge behavior
- Implements equality mixin for value comparison
- Defines merge contract for composition

### 2. SpecAttribute<Value> (Style Definitions)
```dart
abstract class SpecAttribute<Value> extends StyleElement {
  Value resolve(MixContext mix);
  SpecAttribute<Value> merge(covariant SpecAttribute<Value>? other);
}
```

**Purpose**: Represents unresolved styling attributes that can be converted to concrete values.

**Key Features**:
- Contains styling properties as DTOs (Data Transfer Objects)
- Implements `resolve()` method to convert to concrete specs
- Supports merging with other attributes of the same type

**Examples**: `BoxSpecAttribute`, `TextSpecAttribute`, `FlexSpecAttribute`

### 3. Spec<T> (Resolved Values)
```dart
abstract class Spec<T extends Spec<T>> with EqualityMixin {
  final AnimationConfig? animated;
  final WidgetModifiersConfig? modifiers;
  
  T copyWith();
  T lerp(covariant T? other, double t);
}
```

**Purpose**: Represents resolved styling specifications ready for widget consumption.

**Key Features**:
- Contains concrete Flutter widget properties
- Supports animation through `lerp()` method
- Includes built-in animation and modifier support

**Examples**: `BoxSpec`, `TextSpec`, `FlexSpec`

### 4. Mixable<Value> (Value Resolution System)
```dart
abstract class Mixable<Value> with EqualityMixin {
  Value resolve(MixContext mix);
  Mixable<Value> merge(covariant Mixable<Value>? other);
}
```

**Purpose**: Represents values that can be resolved in different ways (direct values, tokens, composites).

**Types**:
- `_ValueMixable<T>`: Direct concrete values
- `_TokenMixable<T>`: Token references
- `_CompositeMixable<T>`: Combination of multiple mixables

### 5. Style (Style Collections)
```dart
class Style extends BaseStyle<SpecAttribute> {
  final AttributeMap<SpecAttribute> styles;
  final AttributeMap<VariantAttribute> variants;
  
  Style merge(Style? other);
  Style applyVariants(List<Variant> selectedVariants);
}
```

**Purpose**: Container for collections of styling attributes and variants.

**Key Features**:
- Manages both visual attributes and variants
- Supports variant application for conditional styling
- Provides factory methods for creation and combination

## The Style → SpecAttribute → Spec Resolution Flow

### 1. Style Creation
```dart
final style = Style(
  $box.color.red(),           // Creates BoxSpecAttribute
  $text.fontSize(16),         // Creates TextSpecAttribute
  $flex.direction.column(),   // Creates FlexSpecAttribute
);
```

### 2. Context Creation and Variant Application
```dart
final mixContext = MixContext.create(context, style);
// Applies variants based on context conditions
// Resolves tokens using MixScopeData
```

### 3. Attribute Resolution
```dart
// Each SpecAttribute resolves to its corresponding Spec
final boxSpec = boxAttribute.resolve(mixContext);      // BoxSpec
final textSpec = textAttribute.resolve(mixContext);   // TextSpec
final flexSpec = flexAttribute.resolve(mixContext);   // FlexSpec
```

### 4. Computed Style Creation
```dart
final computedStyle = ComputedStyle.compute(mixContext);
// Creates optimized lookup table for O(1) spec access
```

### 5. Widget Consumption
```dart
final boxSpec = BoxSpec.of(context);  // Uses ComputedStyle.specOf<T>()
// Surgical rebuilds - only rebuilds when BoxSpec changes
```

## Mixable System and Value Resolution

### Mixable Types and Their Uses

#### 1. ValueMixable (Direct Values)
```dart
Mixable.value(Colors.red)           // Direct color value
Mixable.value(16.0)                 // Direct size value
Mixable.value(EdgeInsets.all(8))    // Direct spacing value
```

#### 2. TokenMixable (Token References)
```dart
Mixable.token($colorToken.primary)  // Token reference
Mixable.token($spacingToken.md)     // Token reference
```

#### 3. CompositeMixable (Combinations)
```dart
Mixable.composite([
  Mixable.value(Colors.red),
  Mixable.token($colorToken.primary),
])
```

### Core DTO Examples

The Mix system uses DTOs (Data Transfer Objects) that extend `Mixable<T>` to provide type-safe styling properties. Here are the key DTO types:

#### 1. EdgeInsetsDto (Spacing)
```dart
// From: packages/mix/lib/src/attributes/spacing/edge_insets_dto.dart
sealed class EdgeInsetsGeometryDto<T> extends Mixable<T> {
  // Factory methods for common spacing patterns
  EdgeInsetsDto.all(double value);
  EdgeInsetsDto.only({double? top, double? right, double? bottom, double? left});
  EdgeInsetsDto.symmetric({double? vertical, double? horizontal});
  EdgeInsetsDto.none();
  
  // Static factory from Flutter objects
  static EdgeInsetsDto from(EdgeInsets insets);
  static EdgeInsetsDto? maybeFrom(EdgeInsets? insets);
}

// Usage examples:
$box.padding.all(16)                    // EdgeInsetsDto.all(16.0)
$box.margin.only(top: 8, left: 16)     // EdgeInsetsDto.only(top: 8.0, left: 16.0)
$box.padding.symmetric(horizontal: 12)  // EdgeInsetsDto.symmetric(horizontal: 12.0)
```

#### 2. BorderDto and BorderSideDto
```dart
// From: packages/mix/lib/src/attributes/border/border_dto.dart
final class BorderSideDto extends Mixable<BorderSide> with HasDefaultValue<BorderSide> {
  final MixableProperty<Color> color;
  final MixableProperty<double> width;
  final MixableProperty<BorderStyle> style;
  final MixableProperty<double> strokeAlign;
  
  // Factory methods
  const BorderSideDto.none();
  factory BorderSideDto.from(BorderSide side);
}

final class BorderDto extends BoxBorderDto<Border> {
  final BorderSideDto? left;
  final BorderSideDto? right;
  
  // Factory methods
  const BorderDto.all(BorderSideDto side);
  const BorderDto.none();
  const BorderDto.symmetric({BorderSideDto? vertical, BorderSideDto? horizontal});
}

// Usage examples:
$box.border.all(color: Colors.red, width: 2.0)
$box.border.none()
$box.border.symmetric(vertical: BorderSideDto(color: Colors.blue))
```

#### 3. DecorationDto (BoxDecoration and ShapeDecoration)
```dart
// From: packages/mix/lib/src/attributes/decoration/decoration_dto.dart
sealed class DecorationDto<T extends Decoration> extends Mixable<T> {
  static DecorationDto? tryToMerge(DecorationDto? a, DecorationDto? b);
}

final class BoxDecorationDto extends DecorationDto<BoxDecoration> {
  final MixableProperty<Color> color;
  final MixableProperty<BlendMode> backgroundBlendMode;
  final BoxBorderDto? border;
  final BorderRadiusGeometryDto? borderRadius;
  final List<BoxShadowDto>? boxShadow;
  final GradientDto? gradient;
  final MixableProperty<BoxShape> shape;
  
  // Usage in resolve method:
  BoxDecoration resolve(MixContext mix) {
    return BoxDecoration(
      color: color.resolve(mix),
      border: border?.resolve(mix),
      borderRadius: borderRadius?.resolve(mix),
      boxShadow: boxShadow?.map((s) => s.resolve(mix)).toList(),
      gradient: gradient?.resolve(mix),
      shape: shape.resolve(mix) ?? BoxShape.rectangle,
    );
  }
}

// Usage examples:
$box.decoration(
  color: Colors.blue,
  borderRadius: BorderRadius.circular(8.0),
  boxShadow: [BoxShadowDto(...)],
)
```

#### 4. GradientDto (LinearGradient, RadialGradient, SweepGradient)
```dart
// From: packages/mix/lib/src/attributes/gradient/gradient_dto.dart
sealed class GradientDto<T extends Gradient> extends Mixable<T> with HasDefaultValue<T> {
  // Type conversion methods
  LinearGradientDto asLinearGradient();
  RadialGradientDto asRadialGradient();
  SweepGradientDto asSweepGradient();
}

final class LinearGradientDto extends GradientDto<LinearGradient> {
  final MixableProperty<AlignmentGeometry> begin;
  final MixableProperty<AlignmentGeometry> end;
  final MixableProperty<List<Color>> colors;
  final MixableProperty<List<double>> stops;
  
  LinearGradient resolve(MixContext mix) {
    return LinearGradient(
      begin: begin.resolve(mix) ?? defaultValue.begin,
      end: end.resolve(mix) ?? defaultValue.end,
      colors: colors.resolve(mix) ?? defaultValue.colors,
      stops: stops.resolve(mix),
    );
  }
}

// Usage examples:
$box.linearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Colors.blue, Colors.red],
)
```

#### 5. TextStyleDto
```dart
// From: packages/mix/lib/src/attributes/text_style/text_style_dto.dart
final class TextStyleDto extends Mixable<TextStyle> with HasDefaultValue<TextStyle> {
  final MixableProperty<Color> color;
  final MixableProperty<double> fontSize;
  final MixableProperty<FontWeight> fontWeight;
  final MixableProperty<double> letterSpacing;
  final MixableProperty<double> wordSpacing;
  final MixableProperty<double> height;
  // ... many more text properties
  
  TextStyle resolve(MixContext mix) {
    return TextStyle(
      color: color.resolve(mix),
      fontSize: fontSize.resolve(mix),
      fontWeight: fontWeight.resolve(mix),
      letterSpacing: letterSpacing.resolve(mix),
      // ... all other properties
    );
  }
}

// Usage examples:
$text.style(
  color: Colors.blue,
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
  letterSpacing: 1.2,
)
```

#### 6. BoxConstraintsDto
```dart
// From: packages/mix/lib/src/attributes/constraints/constraints_dto.dart
final class BoxConstraintsDto extends ConstraintsDto<BoxConstraints> {
  final MixableProperty<double> minWidth;
  final MixableProperty<double> maxWidth;
  final MixableProperty<double> minHeight;
  final MixableProperty<double> maxHeight;
  
  BoxConstraints resolve(MixContext mix) {
    return BoxConstraints(
      minWidth: minWidth.resolve(mix) ?? 0.0,
      maxWidth: maxWidth.resolve(mix) ?? double.infinity,
      minHeight: minHeight.resolve(mix) ?? 0.0,
      maxHeight: maxHeight.resolve(mix) ?? double.infinity,
    );
  }
}

// Usage examples:
$box.constraints(
  minWidth: 100.0,
  maxWidth: 300.0,
  minHeight: 50.0,
  maxHeight: 200.0,
)
```

### DTO Implementation Patterns

All DTOs follow these key patterns:

1. **Extend Mixable<T>**: Where T is the Flutter type they resolve to
2. **Use MixableProperty<T>**: For properties that need token support and null-safe merging
3. **Implement resolve(MixContext)**: Convert DTO to concrete Flutter object
4. **Implement merge()**: Combine two DTOs of the same type
5. **Factory methods**: `.from()`, `.maybeFrom()`, convenience constructors
6. **HasDefaultValue mixin**: For DTOs that have sensible defaults

### Color System Note
The color system has been simplified - `ColorDto` is now deprecated in favor of using `Mixable<Color>` directly:

```dart
// Deprecated: ColorDto
@Deprecated('Use Mixable<Color> directly instead of ColorDto')
typedef ColorDto = Mixable<Color>;

// Current usage:
$box.color.red()           // Creates Mixable<Color>
$box.color(Colors.blue)    // Creates Mixable<Color>
$box.color($colorToken.primary)  // Creates Mixable<Color> with token
```

### MixableDirective System
```dart
class MixableDirective<T> {
  final T Function(T) modify;
  final String? debugLabel;
}

// Usage in color utilities
$box.color.red().darken(20)  // Applies darken directive
$box.color.blue().withOpacity(0.5)  // Applies opacity directive
```

### MixableProperty (DTO Properties)
```dart
class MixableProperty<T extends Object> {
  final Mixable<T>? _mixable;
  
  factory MixableProperty.prop(T? value);
  factory MixableProperty.token(MixableToken<T> token);
  
  T? resolve(MixContext mix);
  MixableProperty<T> merge(MixableProperty<T> other);
}
```

**Purpose**: Wrapper for cleaner null-safe property handling in DTOs.

## Token System

### MixableToken<T>
```dart
class MixableToken<T> {
  final String ref;
  const MixableToken(this.ref);
}
```

### Token Definition and Resolution
```dart
// Token definition in theme
final colorTokens = {
  $colorToken.primary: Colors.blue,
  $colorToken.secondary: Colors.green,
};

// Token usage in styles
$box.color($colorToken.primary)  // References token

// Token resolution
final resolvedColor = mix.scope.getToken($colorToken.primary, context);
```

### StyledTokens Container
```dart
class StyledTokens {
  final Map<MixableToken, dynamic> _tokens;
  
  T? resolve<T>(MixableToken<T> token);
  StyledTokens merge(StyledTokens other);
}
```

## Merging and Composition

### AttributeMap Merging
```dart
class AttributeMap<T extends StyleElement> {
  static LinkedHashMap<Object, Attr> _mergeMap<Attr extends StyleElement>(
    Iterable<Attr> attributes,
  ) {
    final map = LinkedHashMap<Object, Attr>();
    for (final attribute in attributes) {
      final type = attribute.mergeKey;
      final savedAttribute = map[type];
      if (savedAttribute == null) {
        map[type] = attribute;
      } else {
        // Merge attributes of same type
        map[type] = savedAttribute.merge(attribute) as Attr;
      }
    }
    return map;
  }
}
```

### Merging Strategies

#### 1. Simple Replacement (Different Types)
```dart
// Different attribute types replace each other
Style($box.color.red(), $text.fontSize(16))
// Both attributes are kept - no merging
```

#### 2. Complex Merging (Same Types)
```dart
// Same attribute types merge properties
Style(
  $box.color.red(),
  $box.padding.all(8),
  $box.color.blue(),  // Merges with first color, blue wins
)
```

#### 3. DTO-Level Merging
```dart
// BorderDto merging example
BorderDto merge(BorderDto? other) {
  if (other == null) return this;
  return BorderDto(
    top: top?.merge(other.top) ?? other.top,
    bottom: bottom?.merge(other.bottom) ?? other.bottom,
    left: left?.merge(other.left) ?? other.left,
    right: right?.merge(other.right) ?? other.right,
  );
}
```

### Mixable Merging
```dart
Mixable<Value> merge(covariant Mixable<Value>? other) {
  if (other == null) return this;
  
  final allDirectives = mergeDirectives(other.directives);
  
  return switch ((this, other)) {
    (_, _CompositeMixable(:var items)) => Mixable.composite([
      ...items,
      this,
    ], directives: allDirectives),
    _ => Mixable.composite([this, other], directives: allDirectives),
  };
}
```

## Performance and Optimization

### ComputedStyle System
```dart
class ComputedStyle {
  final Map<Type, Spec> _specs;
  final List<WidgetModifierSpec> _modifiers;
  
  // O(1) spec lookup
  T? specOf<T extends Spec>() => _specs[T] as T?;
  
  // Selective dependency tracking
  static T? specOf<T extends Spec>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ComputedStyleProvider>()
        ?.computedStyle.specOf<T>();
  }
}
```

### Surgical Rebuilds
```dart
// Only rebuilds when BoxSpec changes, not when other specs change
Widget build(BuildContext context) {
  final boxSpec = BoxSpec.of(context);  // Selective dependency
  return Container(
    color: boxSpec.decoration?.color,
    // ...
  );
}
```

### Lazy Evaluation
- Tokens are resolved only when needed
- Specs are computed only when accessed
- Attributes are resolved only during style computation

## Use Cases and Examples

### Basic Styling
```dart
final style = Style(
  $box.color.red(),
  $box.padding.all(16),
  $box.borderRadius.all(8),
);
```

### Token-Based Theming
```dart
final style = Style(
  $box.color($colorToken.primary),
  $box.padding($spacingToken.md),
  $text.fontSize($fontSizeToken.body),
);
```

### Conditional Styling with Variants
```dart
final buttonStyle = Style(
  $box.color.blue(),
  $box.padding.all(16),
  
  // Variant for pressed state
  $press(
    $box.color.darkBlue(),
    $box.padding.all(14),
  ),
);
```

### Complex Composition
```dart
final baseStyle = Style($box.color.white());
final paddingStyle = Style($box.padding.all(16));
final borderStyle = Style($box.border.all(color: Colors.grey));

final combinedStyle = Style.combine([
  baseStyle,
  paddingStyle,
  borderStyle,
]);
```

### Utility Pattern
```dart
// Utility classes provide fluent API
class BoxSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, BoxSpecAttribute> {
  
  late final color = ColorUtility((v) => only(decoration: DecorationDto(color: v)));
  late final padding = EdgeInsetsUtility((v) => only(padding: v));
  late final border = BorderUtility((v) => only(decoration: DecorationDto(border: v)));
  
  T only({
    DecorationDto? decoration,
    EdgeInsetsDto? padding,
    // ... other properties
  }) {
    return builder(BoxSpecAttribute(
      decoration: decoration,
      padding: padding,
      // ... other properties
    ));
  }
}
```

## Key Relationships Summary

### What Can Be Passed to Style()
- **SpecAttribute instances**: Direct attributes like `BoxSpecAttribute`
- **Utility results**: Results from `$box.color.red()`
- **Other Style instances**: For composition
- **VariantAttribute instances**: For conditional styling

### What Cannot Be Passed to Style() Directly
- **Raw DTOs**: Like `EdgeInsetsDto`, `BorderDto`, `TextStyleDto`
- **Mixable instances**: Like `Mixable.value(Colors.red)`
- **Raw Flutter values**: Like `Colors.red`, `EdgeInsets.all(8)`

### The Fix Pattern
The system uses a **utility pattern** to bridge the gap:

```dart
// ❌ Cannot do this - DTOs cannot be passed directly
Style(EdgeInsetsDto.all(16))
Style(BorderDto.all(BorderSideDto(color: Colors.red)))
Style(TextStyleDto(color: Colors.blue, fontSize: 16.0))

// ✅ Use utility instead
Style($box.padding.all(16))
Style($box.border.all(color: Colors.red))
Style($text.style(color: Colors.blue, fontSize: 16.0))

// ❌ Cannot do this - Mixable instances cannot be passed directly
Style(Mixable.value(Colors.red))
Style(Mixable.token($colorToken.primary))

// ✅ Use utility instead
Style($box.color.red())
Style($box.color($colorToken.primary))
```

### Why This Pattern Exists

The utility pattern exists because:

1. **Type Safety**: Only `SpecAttribute` instances can be passed to `Style()` to ensure type safety
2. **Composition**: Utilities create the proper `SpecAttribute` containers for DTOs
3. **Consistency**: All styling goes through the same utility API
4. **Builder Pattern**: Utilities provide a fluent API for building complex styles

### Resolution Chain
1. **Style** → Contains `SpecAttribute`s
2. **SpecAttribute** → Contains DTOs as properties (like `EdgeInsetsDto`, `BorderDto`)
3. **DTOs** → Extend `Mixable<T>` for value resolution
4. **Mixable** → Resolves to concrete values via `resolve(MixContext)`
5. **Spec** → Final resolved styling specification
6. **ComputedStyle** → Optimized lookup table for specs

### Complete Example Flow

```dart
// 1. Create styles using utilities
final style = Style(
  $box.padding.all(16),              // BoxSpecUtility creates BoxSpecAttribute
  $box.color.red(),                  // BoxSpecUtility creates BoxSpecAttribute
  $text.fontSize(18),                // TextSpecUtility creates TextSpecAttribute
);

// 2. Style contains SpecAttributes
// style.styles contains:
// - BoxSpecAttribute(padding: EdgeInsetsDto.all(16), decoration: DecorationDto(color: Mixable.value(Colors.red)))
// - TextSpecAttribute(style: TextStyleDto(fontSize: Mixable.value(18.0)))

// 3. Resolution occurs during widget build
final mixContext = MixContext.create(context, style);
final computedStyle = ComputedStyle.compute(mixContext);

// 4. Each SpecAttribute resolves its DTOs
// BoxSpecAttribute.resolve() → BoxSpec(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.red))
// TextSpecAttribute.resolve() → TextSpec(style: TextStyle(fontSize: 18.0))

// 5. Widget accesses resolved specs
final boxSpec = BoxSpec.of(context);    // Gets BoxSpec from ComputedStyle
final textSpec = TextSpec.of(context);  // Gets TextSpec from ComputedStyle
```

This architecture provides a powerful, type-safe, and performant styling system that scales from simple use cases to complex design systems, with clear separation between unresolved style definitions and resolved styling specifications.