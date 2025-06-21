# Mix Parsers

Unified JSON serialization system for Flutter widgets and properties.

## Overview

Parsers convert Flutter objects to/from JSON format with type safety and error handling. All parsers extend `Parser<T>` base class and follow consistent patterns.

## Base Utilities

### `Parser<T>` Base Class
- `encode(T? value) → Object?` - Convert to JSON
- `decode(Object? json) → T?` - Convert from JSON  
- `tryDecode(Object? json) → ParseResult<T>` - Safe parsing with errors

### `JsonMapExtension`
```dart
map.get<String>('key')           // Type-safe access
map.getDouble('width')           // Numeric conversion
map.getListOf('items', decoder)  // List parsing with type filtering
```

### `MapBuilder` 
```dart
final builder = MapBuilder()
  ..addIfNotNull('color', value.color, ColorParser.instance.encode)
  ..add('required', someValue);
return builder.isEmpty ? null : builder.build();
```

## Existing Parsers

### Core Types
- `AlignmentParser` - Alignment, AlignmentDirectional
- `ColorParser` - Color (hex, int values)
- `DurationParser` - Duration (milliseconds, map format)
- `SizeParser` - Size (width/height, special values)
- `OffsetParser` - Offset coordinates

### Layout & Spacing  
- `EdgeInsetsParser` - Padding/margins (symmetric, directional)
- `BoxConstraintsParser` - Min/max width/height constraints

### Visual Styling
- `BorderParser` - Border (all sides, symmetric, individual)
- `BorderSideParser` - Individual border sides
- `BorderRadiusParser` - Corner radius (uniform, per-corner)
- `BoxShadowParser` - Drop shadows
- `BoxDecorationParser` - Background decoration
- `GradientParser` - Linear, radial, sweep gradients

### Typography
- `TextStyleParser` - Font styling (color, size, weight, etc.)
- `FontWeightParser` - Font weights (numeric, named)
- `TextHeightBehaviorParser` - Text height behavior
- `TextScalerParser` - Text scaling
- `StrutStyleParser` - Text strut styling

### Animation & Transform
- `CurveParser` - Animation curves
- `Matrix4Parser` - 3D transformations
- `RectParser` - Rectangle bounds

### Registration
- `base/enum_parser.dart` - Generic enum parsing  
- `parsers.dart` - MixParsers registry (104 registered types)

### Quick Registry Reference
**Core Flutter Types:** AlignmentGeometry, Color, Size, Offset, Rect, Duration  
**Layout:** EdgeInsets, BoxConstraints, Border, BorderRadius, BorderSide  
**Styling:** BoxDecoration, BoxShadow, Gradient, TextStyle, FontWeight  
**Animation:** Curve, Matrix4  
**Enums:** TextAlign, FontStyle, BlendMode, BoxFit, Clip, etc.

## Creating New Parsers

### 1. Basic Structure
```dart
class MyTypeParser extends Parser<MyType> {
  static const instance = MyTypeParser();
  const MyTypeParser();

  @override
  Object? encode(MyType? value) {
    if (value == null) return null;
    // Return JSON-compatible object
    return {'property': value.property};
  }

  @override
  MyType? decode(Object? json) {
    if (json == null) return null;
    
    return switch (json) {
      Map<String, Object?> map => MyType(
        property: map.get('property'),
      ),
      _ => null,
    };
  }
}
```

### 2. Register Parser
```dart
// In parsers.dart, add to the _parsers map:
static final _parsers = <Type, Parser>{
  // ... existing parsers
  MyType: const MyTypeParser(),
};

// Also add import and export:
import 'my_type_parser.dart';
export 'my_type_parser.dart';
```

### 3. Use Existing Parsers
```dart
class ComplexTypeParser extends Parser<ComplexType> {
  @override
  Object? encode(ComplexType? value) {
    if (value == null) return null;
    
    final builder = MapBuilder()
      ..addIfNotNull('color', value.color, MixParsers.encode<Color>)
      ..addIfNotNull('size', value.size, MixParsers.encode<Size>)
      ..addIfNotNull('duration', value.duration, MixParsers.encode<Duration>);
    
    return builder.build();
  }

  @override
  ComplexType? decode(Object? json) {
    return switch (json) {
      Map<String, Object?> map => ComplexType(
        color: MixParsers.decode<Color>(map['color']),
        size: MixParsers.decode<Size>(map['size']),
        duration: MixParsers.decode<Duration>(map['duration']),
      ),
      _ => null,
    };
  }
}
```

### 4. Use Utilities
```dart
// Map building
final builder = MapBuilder()
  ..addIfNotNull('optional', value.optional)
  ..add('required', value.required);

// List parsing  
final items = map.getListOf('items', ItemParser.instance.decode);

// Safe access
final width = map.getDouble('width') ?? 0.0;
```

## Handling Missing Parsers

### Check Parser Exists
```dart
// Use the direct encode/decode methods
final encoded = MixParsers.encode<Color>(someColor);
final decoded = MixParsers.decode<Color>(jsonData);

// For safe parsing with error handling
final result = MixParsers.tryDecode<Color>(jsonData);
if (result.isSuccess) {
  final color = result.value;
}
```

### Safe Parser Usage
```dart
class MyWidgetParser extends Parser<MyWidget> {
  @override
  Object? encode(MyWidget? value) {
    if (value == null) return null;
    
    final builder = MapBuilder()
      ..addIfNotNull('color', value.color, MixParsers.encode<Color>)
      ..addIfNotNull('padding', value.padding, MixParsers.encode<EdgeInsets>);
    
    // Handle unknown types - store raw or skip
    if (value.customProperty != null) {
      try {
        builder.addIfNotNull('custom', value.customProperty, MixParsers.encode<CustomType>);
      } catch (e) {
        // Fallback: store as raw value or skip
        builder.add('custom', value.customProperty.toString());
      }
    }
    
    return builder.build();
  }

  @override
  MyWidget? decode(Object? json) {
    return switch (json) {
      Map<String, Object?> map => MyWidget(
        color: MixParsers.decode<Color>(map['color']),
        padding: MixParsers.decode<EdgeInsets>(map['padding']),
        // Handle missing parser gracefully
        customProperty: _decodeCustom(map['custom']),
      ),
      _ => null,
    };
  }
  
  CustomType? _decodeCustom(Object? json) {
    try {
      return MixParsers.decode<CustomType>(json);
    } catch (e) {
      return null; // Returns null if parser missing or decode fails
    }
  }
}
```

### Create Missing Parsers
1. **Identify the missing type** from error logs or null parser checks
2. **Create parser** following the structure above  
3. **Register in `MixParsers._parsers` map**
4. **Add import/export** to `parsers.dart`
5. **Test encoding/decoding** roundtrip

## Best Practices

### Encoding
- Use JSON-compatible types (Map, List, String, num, bool)
- Return `null` for null input
- Use `MapBuilder` for complex objects
- Minimize output size (omit defaults)

### Decoding  
- Handle `null` input gracefully
- Use switch expressions for type matching
- Provide sensible defaults
- Use `JsonMapExtension` for map access

### Error Handling
- Use `tryDecode()` for validation
- Return `null` for invalid input (don't throw)
- Provide helpful error messages in `tryDecode`

### Performance
- Use `static const instance` pattern
- Cache parser instances in registry
- Avoid heavy computation in encode/decode