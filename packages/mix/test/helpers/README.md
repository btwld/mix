# Mix Custom Test Matchers

## Overview

This directory contains custom test matchers designed to make testing Mix system objects cleaner and more readable. Following the 80/20 rule, we've focused on the core matchers that solve the majority of testing pain points.

## Key Benefits

1. **Eliminates Boilerplate**: No more `.resolve(MockBuildContext())` calls everywhere
2. **Better Readability**: Tests read like natural language
3. **Clearer Intent**: `resolvesTo(value)` is more expressive than manual resolution
4. **Better Error Messages**: Custom matchers provide context-specific error messages
5. **Consistency**: All Mix-related tests use the same patterns

## Core Matchers (80% of use cases)

### `resolvesTo<T>(T expectedValue)`

The most important matcher - checks if a Mix<T> resolves to the expected value.

```dart
// BEFORE: Verbose and repetitive
expect(colorMix.resolve(MockBuildContext()), Colors.red);
expect(borderSide.width.resolve(MockBuildContext()), 2.0);

// AFTER: Clean and readable
expect(colorMix, resolvesTo(Colors.red));
expect(borderSide.width, resolvesTo(2.0));
```

### `equivalentTo<T>(Mix<T> other)`

Checks if two Mix objects are equivalent when resolved.

```dart
// BEFORE: Manual resolution comparison
expect(mix1.resolve(context), mix2.resolve(context));

// AFTER: Clear intent
expect(mix1, equivalentTo(mix2));
```

## Usage Examples

### Scalar DTO Testing

```dart
test('Mix<String> operations', () {
  const dto = Mix.value('test');
  expect(dto, resolvesTo('test'));
  
  const dto1 = Mix.value('first');
  const dto2 = Mix.value('second');
  const composite = Mix.composite([dto1, dto2]);
  expect(composite, resolvesTo('second')); // Last value wins
  
  final merged = dto1.merge(dto2);
  expect(merged, resolvesTo('second'));
  expect(merged, equivalentTo(dto2));
});
```

### BorderSideDto Testing

```dart
test('BorderSideDto properties', () {
  final borderSide = BorderSideDto(
    color: Colors.red,
    width: 2.0,
    style: BorderStyle.solid,
  );

  // Clean, readable assertions
  expect(borderSide.color, resolvesTo(Colors.red));
  expect(borderSide.width, resolvesTo(2.0));
  expect(borderSide.style, resolvesTo(BorderStyle.solid));
});
```

### BoxShadowDto Testing

```dart
test('BoxShadowDto properties', () {
  final boxShadow = BoxShadowDto(
    color: Colors.black,
    blurRadius: 10.0,
    offset: const Offset(2, 2),
    spreadRadius: 5.0,
  );

  expect(boxShadow.color, resolvesTo(Colors.black));
  expect(boxShadow.blurRadius, resolvesTo(10.0));
  expect(boxShadow.offset, resolvesTo(const Offset(2, 2)));
  expect(boxShadow.spreadRadius, resolvesTo(5.0));
});
```

### Merge Testing

```dart
test('DTO merging', () {
  final dto1 = BorderSideDto(color: Colors.red, width: 1.0);
  final dto2 = BorderSideDto(width: 2.0);
  
  final merged = dto1.merge(dto2);
  
  // Properties merge correctly
  expect(merged.width, resolvesTo(2.0));      // New value
  expect(merged.color, resolvesTo(Colors.red)); // Preserved value
});
```

## Migration Guide

### Common Patterns to Replace

```dart
// ❌ REPLACE THIS:
expect(mixObject.resolve(MockBuildContext()), expectedValue);

// ✅ WITH THIS:
expect(mixObject, resolvesTo(expectedValue));
```

```dart
// ❌ REPLACE THIS:
expect(mix1.resolve(context), mix2.resolve(context));

// ✅ WITH THIS:
expect(mix1, equivalentTo(mix2));
```

```dart
// ❌ REPLACE THIS:
final resolved = dto.resolve(MockBuildContext());
expect(resolved.property, expectedValue);

// ✅ WITH THIS:
expect(dto.property, resolvesTo(expectedValue));
```

## Error Messages

The custom matchers provide clear, context-specific error messages:

```dart
// Type mismatch
expect('not a mix', resolvesTo('anything'));
// Error: Expected Mix<String>, got String

// Value mismatch
expect(Mix.value(Colors.red), resolvesTo(Colors.blue));
// Error: resolved to Color(0xfff44336) instead of Color(0xff2196f3)

// Resolution failure
expect(problematicMix, resolvesTo('anything'));
// Error: Failed to resolve: Exception: Intentional test error
```

## Best Practices

1. **Use `resolvesTo` for all Mix property assertions**
2. **Use `equivalentTo` when comparing Mix objects**
3. **Keep test assertions focused and readable**
4. **Let the matchers handle context management**
5. **Use descriptive test names that read naturally with the matchers**

## Files

- `custom_matchers.dart` - Core matcher implementations
- `custom_matchers_test.dart` - Tests demonstrating matcher usage
- `refactoring_example.dart` - Before/after examples for migration

## Future Extensions

While we've focused on the 80/20 rule, additional matchers could be added for:
- Token-specific testing
- Composite Mix validation
- Collection assertions
- Context-dependent resolution

The current implementation provides a solid foundation that can be extended as needed without over-engineering the solution.
