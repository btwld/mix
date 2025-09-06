# DTO Testing Guide

This guide outlines comprehensive testing for Mix DTOs, covering all critical functionality with practical patterns.

## Understanding DTO Architecture

DTOs in Mix use a sophisticated property system:
- **Prop<T>**: Handles simple values, tokens, and directives
- **MixProp<V, T extends Mix<V>>**: Handles nested DTOs with proper merging
- **Token Resolution**: Design tokens resolve through MixContext with MixScope
- **Intelligent Merging**: Property-level composition that preserves unspecified values

## Essential Test Coverage

Every DTO test MUST cover these core behaviors:

### 1. Constructor Testing
Test all constructor patterns that DTOs follow:

```dart
group('constructor', () {
  test('main factory assigns properties correctly', () {
    final dto = BorderSideDto(
      width: 2.0,
      color: Colors.red,
      style: BorderStyle.solid,
    );
    
    expect(dto, resolvesTo(BorderSide(
      width: 2.0,
      color: Colors.red,
      style: BorderStyle.solid,
    )));
  });

  test('.value factory creates from Flutter type', () {
    const borderSide = BorderSide(width: 3.0, color: Colors.blue);
    final dto = BorderSideDto.value(borderSide);
    
    expect(dto, resolvesTo(borderSide));
  });

  test('.maybeValue handles null correctly', () {
    expect(BorderSideDto.maybeValue(null), isNull);
    expect(
      BorderSideDto.maybeValue(const BorderSide(width: 1.0)),
      isNotNull,
    );
  });
});
```

### 2. Resolution Testing
```dart
group('resolve', () {
  test('returns correct Flutter type', () {
    final dto = TextStyleDto(fontSize: 16.0, color: Colors.black);
    
    expect(dto, resolvesTo(const TextStyle(
      fontSize: 16.0,
      color: Colors.black,
    )));
  });

  test('uses default values for null properties', () {
    final dto = BorderSideDto(width: 2.0); // color and style are null
    
    expect(dto, resolvesTo(const BorderSide(
      width: 2.0,
      color: Color(0xFF000000), // Flutter's default
      style: BorderStyle.solid,  // Flutter's default
    )));
  });
});
```

### 3. Merging Behavior
```dart
group('merge', () {
  test('correctly combines properties', () {
    final base = BorderSideDto(width: 1.0, color: Colors.red);
    final override = BorderSideDto(width: 2.0); // color not specified
    
    final merged = base.merge(override);
    
    expect(merged, resolvesTo(const BorderSide(
      width: 2.0,      // From override
      color: Colors.red, // Preserved from base
    )));
  });

  test('returns self when merging with null', () {
    final dto = BorderSideDto(width: 1.0);
    expect(dto.merge(null), same(dto));
  });

  test('nested DTOs merge correctly', () {
    final dto1 = BoxDecorationDto(
      border: BorderDto(top: BorderSideDto(width: 1.0)),
    );
    final dto2 = BoxDecorationDto(
      border: BorderDto(top: BorderSideDto(color: Colors.red)),
    );
    
    final merged = dto1.merge(dto2);
    
    expect(merged, resolvesTo(BoxDecoration(
      border: Border(top: BorderSide(width: 1.0, color: Colors.red)),
    )));
  });
});
```

### 4. Equality and Hash Code
```dart
group('equality', () {
  test('equals with same values', () {
    final dto1 = BorderSideDto(width: 1.0);
    final dto2 = BorderSideDto(width: 1.0);
    
    expect(dto1, equals(dto2));
    expect(dto1.hashCode, equals(dto2.hashCode));
  });

  test('not equals with different values', () {
    final dto1 = BorderSideDto(width: 1.0);
    final dto2 = BorderSideDto(width: 2.0);
    
    expect(dto1, isNot(equals(dto2)));
  });
});
```

### 5. Token Resolution Testing
```dart
group('token resolution', () {
  testWidgets('resolves tokens from context', (tester) async {
    const colorToken = ColorToken('primary');
    final dto = BorderSideDto.props(
      color: Prop.token(colorToken),
      width: Prop.value(2.0),
    );
    
    await tester.pumpWithMixScope(
      Container(),
      theme: MixScopeData(tokens: {colorToken: Colors.blue}),
    );
    
    final context = tester.element(find.byType(Container));
    final mixContext = MixContext.create(context, const Style.empty());
    
    expect(dto, resolvesTo(
      const BorderSide(width: 2.0, color: Colors.blue),
      context: mixContext,
    ));
  });

  test('handles missing tokens gracefully', () {
    const token = ColorToken('undefined');
    final dto = BorderSideDto.props(
      color: Prop.token(token),
    );
    
    // Expect either graceful fallback or error based on your design
    expect(
      () => dto.resolve(EmptyMixData),
      throwsStateError, // or check for default value
    );
  });
});
```

### 6. Complex DTO Testing
For DTOs with cross-type merging (like BoxBorderDto):

```dart
group('cross-type merging', () {
  test('BorderDto merges with BorderDirectionalDto', () {
    final border = BorderDto.all(BorderSideDto(width: 1.0));
    final directional = BorderDirectionalDto(
      start: BorderSideDto(color: Colors.red),
    );
    
    final merged = BoxBorderDto.tryToMerge(border, directional);
    
    expect(merged, isA<BorderDirectionalDto>());
    expect(merged, resolvesTo(BorderDirectional(
      top: BorderSide(width: 1.0),
      bottom: BorderSide(width: 1.0),
      start: BorderSide(width: 1.0, color: Colors.red),
      end: BorderSide(width: 1.0),
    )));
  });
});
```

## Testing Utilities

### Creating Test Contexts

```dart
// Simple empty context for basic tests
final context = EmptyMixData;

// Note: For token testing, use widget tests with pumpWithMixScope
// instead of trying to create contexts with tokens manually
```

### Widget Testing with MixScope

```dart
// For tests that need proper widget tree and token resolution
testWidgets('widget test with tokens', (tester) async {
  await tester.pumpWithMixScope(
    YourWidget(),
    theme: MixScopeData(tokens: {
      ColorToken('primary'): Colors.blue,
    }),
  );
  
  // Your test assertions
});
```

## Test File Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('YourDto', () {
    group('constructor', () {
      test('main factory assigns properties correctly', () {
        // Test property assignment
      });
      
      test('.value factory creates from Flutter type', () {
        // Test value factory
      });
      
      test('.maybeValue handles null', () {
        // Test nullable factory
      });
    });

    group('resolve', () {
      test('returns correct Flutter type', () {
        // Test basic resolution
      });

      test('uses defaults for null properties', () {
        // Test default behavior
      });
    });

    group('merge', () {
      test('combines properties correctly', () {
        // Test merging
      });

      test('preserves unspecified properties', () {
        // Test property preservation
      });

      test('returns self when merging with null', () {
        // Test null merge
      });
    });

    group('equality', () {
      test('equals with same values', () {
        // Test equality
      });

      test('not equals with different values', () {
        // Test inequality
      });
    });

    group('token resolution', () {
      testWidgets('resolves tokens from context', (tester) async {
        // Test token resolution
      });
    });
  });
}
```

## Best Practices

### 1. Use Custom Matchers
Always use `resolvesTo` for cleaner assertions:
```dart
// ✅ GOOD
expect(dto, resolvesTo(expectedValue));

// ❌ AVOID
expect(dto.resolve(EmptyMixData), equals(expectedValue));
```

### 2. Test Edge Cases
```dart
test('handles all-null DTO', () {
  final dto = BorderSideDto(); // All properties null
  expect(() => dto.resolve(EmptyMixData), returnsNormally);
});

test('handles empty lists', () {
  final dto = TextStyleDto(fontVariations: const []);
  expect(dto, resolvesTo(const TextStyle(fontVariations: [])));
});
```

### 3. Test Property Preservation
When testing merges, verify unspecified properties are preserved:
```dart
final base = TextStyleDto(
  fontSize: 16.0,
  color: Colors.red,
  fontWeight: FontWeight.bold,
);
final override = TextStyleDto(fontSize: 20.0); // Only fontSize

final merged = base.merge(override);

expect(merged, resolvesTo(const TextStyle(
  fontSize: 20.0,         // Overridden
  color: Colors.red,      // Preserved
  fontWeight: FontWeight.bold, // Preserved
)));
```

### 4. Avoid Over-Engineering
- Don't create complex test utilities unless truly needed
- Use existing helpers (EmptyMixData, resolvesTo, etc.)
- Keep tests focused and readable

## Common Testing Patterns

### Testing DTOs with Lists
```dart
test('merges list properties correctly', () {
  final dto1 = TextStyleDto(fontVariations: [FontVariation('wght', 400)]);
  final dto2 = TextStyleDto(fontVariations: [FontVariation('wght', 700)]);
  
  final merged = dto1.merge(dto2);
  
  // Lists typically replace, not append
  expect(merged.fontVariations?.value, hasLength(1));
  expect(merged.fontVariations?.value?.first.value, 700);
});
```

### Testing Nested DTOs
```dart
test('resolves nested DTOs', () {
  final dto = BoxDecorationDto(
    color: Colors.blue,
    border: BorderDto.all(BorderSideDto(width: 2.0)),
    gradient: LinearGradientDto(colors: [Colors.red, Colors.blue]),
  );
  
  expect(dto, resolvesTo(BoxDecoration(
    color: Colors.blue,
    border: Border.all(width: 2.0),
    gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
  )));
});
```

## Migration Notes

The framework has evolved to use:
- `Prop<T>` for simple properties instead of direct values
- `MixProp<V, T>` for nested DTOs
- `MixScope` instead of MixTheme for token resolution
- `resolvesTo` matcher for cleaner test assertions

When updating tests, focus on the behavior rather than implementation details. The goal is to ensure DTOs correctly resolve, merge, and handle edge cases.