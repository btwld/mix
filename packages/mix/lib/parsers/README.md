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
      ..addIfNotNull('color', value.color, MixParsers.get<Color>()?.encode)
      ..addIfNotNull('size', value.size, MixParsers.get<Size>()?.encode)
      ..addIfNotNull('duration', value.duration, MixParsers.get<Duration>()?.encode);
    
    return builder.build();
  }

  @override
  ComplexType? decode(Object? json) {
    return switch (json) {
      Map<String, Object?> map => ComplexType(
        color: MixParsers.get<Color>()?.decode(map['color']),
        size: MixParsers.get<Size>()?.decode(map['size']),
        duration: MixParsers.get<Duration>()?.decode(map['duration']),
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
// Always check if parser exists before using
final colorParser = MixParsers.get<Color>();
if (colorParser != null) {
  final encoded = colorParser.encode(someColor);
  final decoded = colorParser.decode(jsonData);
}
```

### Safe Parser Usage
```dart
class MyWidgetParser extends Parser<MyWidget> {
  @override
  Object? encode(MyWidget? value) {
    if (value == null) return null;
    
    final builder = MapBuilder()
      ..addIfNotNull('color', value.color, MixParsers.get<Color>()?.encode)
      ..addIfNotNull('padding', value.padding, MixParsers.get<EdgeInsets>()?.encode);
    
    // Handle unknown types - store raw or skip
    if (value.customProperty != null) {
      final customParser = MixParsers.get<CustomType>();
      if (customParser != null) {
        builder.addIfNotNull('custom', value.customProperty, customParser.encode);
      } else {
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
        color: MixParsers.get<Color>()?.decode(map['color']),
        padding: MixParsers.get<EdgeInsets>()?.decode(map['padding']),
        // Handle missing parser gracefully
        customProperty: _decodeCustom(map['custom']),
      ),
      _ => null,
    };
  }
  
  CustomType? _decodeCustom(Object? json) {
    final parser = MixParsers.get<CustomType>();
    return parser?.decode(json); // Returns null if parser missing
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