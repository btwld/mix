# Simplified Mix 2.0 API Architecture

## Core Insight

By making utility methods accept DTOs/values directly and leveraging static factories on DTOs, we eliminate an entire layer of complexity. No more nested utility chains!

## Architecture Overview

### 1. DTOs as Value Builders

DTOs become the primary way to create values with static factories. All DTOs follow a consistent pattern:
- Properties are nullable `Prop<T>?` types
- Factory constructors accept raw values
- Private constructors accept `Prop<T>?` instances
- Use `Prop.maybeValue()` for nullable conversions
- Use `Prop.value()` for non-null conversions

```dart
// EdgeInsetsDto with static factories
class EdgeInsetsDto extends EdgeInsetsGeometryDto<EdgeInsets> {
  // Properties are nullable Prop<T>?
  final Prop<double>? top;
  final Prop<double>? bottom;
  final Prop<double>? left;
  final Prop<double>? right;
  
  // Factory constructor accepts raw values
  factory EdgeInsetsDto({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return EdgeInsetsDto._(
      top: Prop.maybeValue(top),
      bottom: Prop.maybeValue(bottom),
      left: Prop.maybeValue(left),
      right: Prop.maybeValue(right),
    );
  }
  
  // Private constructor accepts Prop<T>? instances
  const EdgeInsetsDto._({
    this.top,
    this.bottom,
    this.left,
    this.right,
  });
  
  // Static factories for common patterns
  EdgeInsetsDto.all(double value)
    : this._(
        top: Prop.value(value),
        bottom: Prop.value(value),
        left: Prop.value(value),
        right: Prop.value(value),
      );
  
  EdgeInsetsDto.symmetric({double horizontal = 0, double vertical = 0})
    : this._(
        top: Prop.value(vertical),
        bottom: Prop.value(vertical),
        left: Prop.value(horizontal),
        right: Prop.value(horizontal),
      );
  
  EdgeInsetsDto.only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) : this._(
        top: top > 0 ? Prop.value(top) : null,
        bottom: bottom > 0 ? Prop.value(bottom) : null,
        left: left > 0 ? Prop.value(left) : null,
        right: right > 0 ? Prop.value(right) : null,
      );
  
  EdgeInsetsDto.none() : this.all(0);
  
  // Resolve uses resolveProp helper
  @override
  EdgeInsets resolve(MixContext mix) {
    return EdgeInsets.only(
      left: resolveProp(mix, left) ?? 0,
      top: resolveProp(mix, top) ?? 0,
      right: resolveProp(mix, right) ?? 0,
      bottom: resolveProp(mix, bottom) ?? 0,
    );
  }
  
  // Merge uses mergeProp helper
  @override
  EdgeInsetsDto merge(EdgeInsetsDto? other) {
    if (other == null) return this;
    
    return EdgeInsetsDto._(
      top: mergeProp(top, other.top),
      bottom: mergeProp(bottom, other.bottom),
      left: mergeProp(left, other.left),
      right: mergeProp(right, other.right),
    );
  }
}

// BorderRadiusDto with static factories
class BorderRadiusDto extends BorderRadiusGeometryDto<BorderRadius> {
  final Prop<Radius>? topLeft;
  final Prop<Radius>? topRight;
  final Prop<Radius>? bottomLeft;
  final Prop<Radius>? bottomRight;
  
  factory BorderRadiusDto({
    Radius? topLeft,
    Radius? topRight,
    Radius? bottomLeft,
    Radius? bottomRight,
  }) {
    return BorderRadiusDto._(
      topLeft: Prop.maybeValue(topLeft),
      topRight: Prop.maybeValue(topRight),
      bottomLeft: Prop.maybeValue(bottomLeft),
      bottomRight: Prop.maybeValue(bottomRight),
    );
  }
  
  const BorderRadiusDto._({
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
  });
  
  static BorderRadiusDto all(Radius radius) => BorderRadiusDto._(
    topLeft: Prop.value(radius),
    topRight: Prop.value(radius),
    bottomLeft: Prop.value(radius),
    bottomRight: Prop.value(radius),
  );
  
  static BorderRadiusDto circular(double radius) => all(Radius.circular(radius));
  
  static BorderRadiusDto zero = BorderRadiusDto._();
}
```

### 2. Simplified Utilities

Utilities become simple builders that accept values/DTOs directly:

```dart
class BoxSpecUtility<T extends SpecAttribute> 
    extends SpecUtility<T, BoxSpecAttribute> {
  
  // Immutable attribute that accumulates changes
  final BoxSpecAttribute attribute;
  
  // Constructor
  BoxSpecUtility(
    super.builder, {
    BoxSpecAttribute? attribute,
  }) : attribute = attribute ?? const BoxSpecAttribute();
  
  // Default factory for direct usage
  factory BoxSpecUtility() => BoxSpecUtility((attr) => attr);
  
  // Direct methods that accept DTOs/values
  
  BoxSpecUtility<T> padding(EdgeInsetsGeometryDto value) {
    return BoxSpecUtility(
      builder,
      attribute: attribute.merge(BoxSpecAttribute(padding: value)),
    );
  }
  
  BoxSpecUtility<T> margin(EdgeInsetsGeometryDto value) {
    return BoxSpecUtility(
      builder,
      attribute: attribute.merge(BoxSpecAttribute(margin: value)),
    );
  }
  
  BoxSpecUtility<T> alignment(AlignmentGeometry value) {
    return BoxSpecUtility(
      builder,
      attribute: attribute.merge(BoxSpecAttribute(alignment: value)),
    );
  }
  
  BoxSpecUtility<T> constraints(BoxConstraintsDto value) {
    return BoxSpecUtility(
      builder,
      attribute: attribute.merge(BoxSpecAttribute(constraints: value)),
    );
  }
  
  BoxSpecUtility<T> decoration(DecorationDto value) {
    return BoxSpecUtility(
      builder,
      attribute: attribute.merge(BoxSpecAttribute(decoration: value)),
    );
  }
  
  // Convenience methods for common decorations
  BoxSpecUtility<T> color(Color value) {
    return decoration(BoxDecorationDto(color: ColorDto(value)));
  }
  
  BoxSpecUtility<T> borderRadius(BorderRadiusDto value) {
    return decoration(BoxDecorationDto(borderRadius: value));
  }
  
  BoxSpecUtility<T> border(BorderDto value) {
    return decoration(BoxDecorationDto(border: value));
  }
  
  BoxSpecUtility<T> boxShadow(List<BoxShadowDto> shadows) {
    return decoration(BoxDecorationDto(boxShadow: shadows));
  }
  
  // Size methods
  BoxSpecUtility<T> size(double width, double height) {
    return BoxSpecUtility(
      builder,
      attribute: attribute.merge(BoxSpecAttribute(width: width, height: height)),
    );
  }
  
  BoxSpecUtility<T> width(double value) {
    return BoxSpecUtility(
      builder,
      attribute: attribute.merge(BoxSpecAttribute(width: value)),
    );
  }
  
  BoxSpecUtility<T> height(double value) {
    return BoxSpecUtility(
      builder,
      attribute: attribute.merge(BoxSpecAttribute(height: value)),
    );
  }
  
  // Transform
  BoxSpecUtility<T> transform(Matrix4 value) {
    return BoxSpecUtility(
      builder,
      attribute: attribute.merge(BoxSpecAttribute(transform: value)),
    );
  }
  
  // Clip behavior
  BoxSpecUtility<T> clipBehavior(Clip value) {
    return BoxSpecUtility(
      builder,
      attribute: attribute.merge(BoxSpecAttribute(clipBehavior: value)),
    );
  }
  
  // Variants with function pattern
  BoxSpecUtility<T> onHover(BoxSpecAttribute Function(BoxSpecUtility) configure) {
    final hoverUtility = BoxSpecUtility();
    final hoverAttribute = configure(hoverUtility).attribute;
    
    // Implementation depends on variant strategy
    // Could store in modifiers or create wrapper
    return this;
  }
  
  BoxSpecUtility<T> onFocus(BoxSpecAttribute Function(BoxSpecUtility) configure) {
    final focusUtility = BoxSpecUtility();
    final focusAttribute = configure(focusUtility).attribute;
    
    return this;
  }
  
  // Build the final attribute
  T build() => builder(attribute);
  
  // Override attributeValue for SpecUtility
  @override
  BoxSpecAttribute? get attributeValue => attribute;
}
```

### 3. TextStyleUtility Simplified

```dart
class TextStyleUtility<T extends StyleElement>
    extends DtoUtility<T, TextStyleDto, TextStyle> {
  
  final TextStyleDto dto;
  
  TextStyleUtility(
    super.builder, {
    TextStyleDto? dto,
  }) : dto = dto ?? TextStyleDto.empty(),
       super(valueToDto: _textStyleToDto);
  
  factory TextStyleUtility() => TextStyleUtility((dto) => dto);
  
  // Direct methods accepting values
  // DTO factory handles conversion internally
  
  TextStyleUtility<T> color(Color value) {
    return TextStyleUtility(
      builder,
      dto: dto.merge(TextStyleDto(color: value)),
    );
  }
  
  TextStyleUtility<T> backgroundColor(Color value) {
    return TextStyleUtility(
      builder,
      dto: dto.merge(TextStyleDto(backgroundColor: value)),
    );
  }
  
  TextStyleUtility<T> fontSize(double value) {
    return TextStyleUtility(
      builder,
      dto: dto.merge(TextStyleDto(fontSize: value)),
    );
  }
  
  TextStyleUtility<T> fontWeight(FontWeight value) {
    return TextStyleUtility(
      builder,
      dto: dto.merge(TextStyleDto(fontWeight: value)),
    );
  }
  
  TextStyleUtility<T> fontStyle(FontStyle value) {
    return TextStyleUtility(
      builder,
      dto: dto.merge(TextStyleDto(fontStyle: value)),
    );
  }
  
  TextStyleUtility<T> fontFamily(String value) {
    return TextStyleUtility(
      builder,
      dto: dto.merge(TextStyleDto(fontFamily: value)),
    );
  }
  
  TextStyleUtility<T> letterSpacing(double value) {
    return TextStyleUtility(
      builder,
      dto: dto.merge(TextStyleDto(letterSpacing: value)),
    );
  }
  
  TextStyleUtility<T> height(double value) {
    return TextStyleUtility(
      builder,
      dto: dto.merge(TextStyleDto(height: value)),
    );
  }
  
  TextStyleUtility<T> decoration(TextDecoration value) {
    return TextStyleUtility(
      builder,
      dto: dto.merge(TextStyleDto(decoration: value)),
    );
  }
  
  TextStyleUtility<T> shadows(List<Shadow> values) {
    return TextStyleUtility(
      builder,
      dto: dto.merge(TextStyleDto(
        shadows: values.map((s) => ShadowDto(
          color: s.color,
          offset: s.offset,
          blurRadius: s.blurRadius,
        )).toList(),
      )),
    );
  }
  
  // Convenience methods
  TextStyleUtility<T> bold() => fontWeight(FontWeight.bold);
  TextStyleUtility<T> italic() => fontStyle(FontStyle.italic);
  TextStyleUtility<T> underline() => decoration(TextDecoration.underline);
  
  // Build returns the DTO
  T build() => builder(dto);
  
  @override
  TextStyleDto get attributeValue => dto;
}
```

## Key Implementation Patterns

### DTO Property Pattern

All DTOs must follow this consistent pattern for properties:

1. **Nullable Prop<T>? Properties**: All properties use nullable `Prop<T>?` types
2. **Factory Constructor**: Accepts raw values and converts using `Prop.maybeValue()`
3. **Private Constructor**: Accepts `Prop<T>?` instances directly
4. **Resolution**: Uses `resolveProp()` helper function
5. **Merging**: Uses `mergeProp()` helper function

```dart
// Standard DTO pattern
class SomeDto extends Mix<SomeType> {
  // 1. Properties are nullable Prop<T>?
  final Prop<Color>? color;
  final Prop<double>? size;
  
  // 2. Factory constructor accepts raw values
  factory SomeDto({
    Color? color,
    double? size,
  }) {
    return SomeDto._(
      color: Prop.maybeValue(color),  // Converts nullable values
      size: Prop.maybeValue(size),
    );
  }
  
  // 3. Private constructor accepts Prop<T>?
  const SomeDto._({
    this.color,
    this.size,
  });
  
  // 4. Resolution uses resolveProp helper
  @override
  SomeType resolve(MixContext mix) {
    return SomeType(
      color: resolveProp(mix, color) ?? defaultColor,
      size: resolveProp(mix, size) ?? defaultSize,
    );
  }
  
  // 5. Merging uses mergeProp helper
  @override
  SomeDto merge(SomeDto? other) {
    if (other == null) return this;
    
    return SomeDto._(
      color: mergeProp(color, other.color),
      size: mergeProp(size, other.size),
    );
  }
}
```

### Helper Functions

The framework provides these essential helper functions:

```dart
// Resolves a Prop<T>? to its value, handling tokens and context
T? resolveProp<T>(MixContext context, Prop<T>? prop);

// Merges two Prop<T>? values, with 'other' taking precedence
Prop<T>? mergeProp<T>(Prop<T>? current, Prop<T>? other);

// For lists of simple Prop<T>
List<T>? resolvePropList<T>(MixContext context, List<Prop<T>>? props);
List<Prop<T>>? mergePropList<T>(List<Prop<T>>? current, List<Prop<T>>? other);

// For lists of Mix types (DTOs)
List<T>? resolveMixPropList<T>(MixContext context, List<MixProp<T, Mix<T>>>? props);
List<MixProp<T, M>>? mergeMixPropList<T, M extends Mix<T>>(
  List<MixProp<T, M>>? current, 
  List<MixProp<T, M>>? other
);
```

### Lists in DTOs

DTOs handle lists differently based on the type:

```dart
class ComplexDto extends Mix<ComplexType> {
  // For lists of simple types, use List<Prop<T>>?
  final List<Prop<String>>? tags;
  final List<Prop<FontFeature>>? fontFeatures;
  
  // For lists of Mix types (other DTOs), use List<MixProp<T, DTO>>?
  final List<MixProp<Shadow, ShadowDto>>? shadows;
  
  factory ComplexDto({
    List<String>? tags,
    List<FontFeature>? fontFeatures,
    List<ShadowDto>? shadows,
  }) {
    return ComplexDto._(
      // Simple types use Prop.value
      tags: tags?.map(Prop.value).toList(),
      fontFeatures: fontFeatures?.map(Prop.value).toList(),
      // Mix types use MixProp.value
      shadows: shadows?.map(MixProp<Shadow, ShadowDto>.value).toList(),
    );
  }
  
  @override
  ComplexType resolve(MixContext mix) {
    return ComplexType(
      tags: resolvePropList(mix, tags),
      fontFeatures: resolvePropList(mix, fontFeatures),
      shadows: resolveMixPropList(mix, shadows),
    );
  }
  
  @override
  ComplexDto merge(ComplexDto? other) {
    if (other == null) return this;
    
    return ComplexDto._(
      tags: mergePropList(tags, other.tags),
      fontFeatures: mergePropList(fontFeatures, other.fontFeatures),
      shadows: mergeMixPropList(shadows, other.shadows),
    );
  }
}
```

### Static Factory Patterns

Static factories should use `Prop.value()` for non-null values:

```dart
// Named constructors for common patterns
EdgeInsetsDto.all(double value)
  : this._(
      top: Prop.value(value),     // Non-null, use Prop.value
      bottom: Prop.value(value),
      left: Prop.value(value),
      right: Prop.value(value),
    );

// Static methods for variations
static BorderRadiusDto circular(double radius) => BorderRadiusDto._(
  topLeft: Prop.value(Radius.circular(radius)),
  topRight: Prop.value(Radius.circular(radius)),
  bottomLeft: Prop.value(Radius.circular(radius)),
  bottomRight: Prop.value(Radius.circular(radius)),
);
```

## Usage Examples

### Current API vs New API

```dart
// ❌ OLD: Nested utility chains
final oldBox = BoxSpecUtility.self
  .padding.all(16)
  .margin.symmetric(horizontal: 8)
  .alignment.center()
  .color.red()
  .border.all(color: Colors.black);

// ✅ NEW: Direct methods with DTOs
final newBox = BoxSpecUtility()
  .padding(EdgeInsetsDto.all(16))
  .margin(EdgeInsetsDto.symmetric(horizontal: 8))
  .alignment(Alignment.center)
  .color(Colors.red)
  .border(BorderDto(
    // Note: BorderDto.all() needs to be implemented
    color: Colors.black,
    width: 1,
    style: BorderStyle.solid,
  ));
```

### With Future Dot Notation

```dart
// When dot notation is available
final box = BoxSpecUtility()
  .padding(.all(16))                    // EdgeInsetsDto.all(16)
  .margin(.symmetric(horizontal: 8))    // EdgeInsetsDto.symmetric(horizontal: 8)
  .alignment(.center)                   // Alignment.center
  .color(.red)                          // Colors.red
  .borderRadius(.circular(8));          // BorderRadiusDto.circular(8)
```

### Complex Examples

```dart
// Card with shadow
final card = BoxSpecUtility()
  .color(Colors.white)
  .padding(EdgeInsetsDto.all(16))
  .margin(EdgeInsetsDto.symmetric(vertical: 8))
  .borderRadius(BorderRadiusDto.circular(12))
  .boxShadow([
    BoxShadowDto(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ]);

// Text styling
final heading = TextStyleUtility()
  .fontSize(24)
  .fontWeight(FontWeight.bold)
  .color(Colors.black87)
  .letterSpacing(0.5)
  .height(1.2);

// With variants
final button = BoxSpecUtility()
  .color(Colors.blue)
  .padding(EdgeInsetsDto.symmetric(horizontal: 24, vertical: 12))
  .borderRadius(BorderRadiusDto.circular(8))
  .onHover((box) => box
    .color(Colors.blue.shade700)
    .transform(Matrix4.identity()..scale(1.05))
  )
  .onFocus((box) => box
    .border(BorderDto.all(color: Colors.blue.shade900, width: 2))
  );
```

## Benefits of This Architecture

### 1. **Reduced Complexity**
- Eliminates nested utility chains
- One less layer of abstraction
- Simpler mental model

### 2. **Better API Surface**
- Methods clearly show what they accept
- IDE autocomplete is more helpful
- Less discovery needed

### 3. **Type Safety**
- Direct type checking on method parameters
- No ambiguity about what values are accepted
- Compile-time verification

### 4. **Future-Ready**
- Perfect for dot notation: `.padding(.all(16))`
- DTOs with static factories align with language direction
- Clean, modern API

### 5. **Easier to Maintain**
- Less generated code needed
- Simpler utility implementation
- Clear separation of concerns

### 6. **Performance**
- Fewer object allocations
- Direct method calls instead of property chains
- Simpler resolution path

## Migration Strategy

1. **Phase 1**: Add direct methods to utilities alongside existing sub-utilities
2. **Phase 2**: Deprecate sub-utility usage patterns
3. **Phase 3**: Remove sub-utilities in next major version

```dart
class BoxSpecUtility {
  // Phase 1: Both patterns supported
  @Deprecated('Use padding(EdgeInsetsDto.all(16)) instead')
  late final padding = EdgeInsetsGeometryUtility(...);
  
  BoxSpecUtility<T> padding(EdgeInsetsGeometryDto value) { ... }
}
```

## Conclusion

This simplified architecture:
- **Removes entire layer** of sub-utilities
- **Leverages DTOs** as value builders
- **Simplifies utilities** to just accept and accumulate values
- **Improves developer experience** with clearer API
- **Prepares for future** Dart language features

The key insight: DTOs with static factories + utilities with direct methods = clean, intuitive API!