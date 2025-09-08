# Token Migration Guide

This guide helps you migrate from the old token system to the new generic `Token<T>` system.

## Overview

The new token system introduces a single generic `Token<T>` class that replaces all the specific token types:
- `ColorToken` → `Token<Color>`
- `SpaceToken` → `Token<double>`
- `TextStyleToken` → `Token<TextStyle>`
- `RadiusToken` → `Token<Radius>`

## Migration Steps

### 1. Update Token Definitions

**Before:**
```dart
const primaryColor = ColorToken('primary');
const largeSpace = SpaceToken('large');
const headingStyle = TextStyleToken('heading');
const smallRadius = RadiusToken('small');
```

**After:**
```dart
const primaryColor = Token<Color>('primary');
const largeSpace = Token<double>('large');
const headingStyle = Token<TextStyle>('heading');
const smallRadius = Token<Radius>('small');
```

### 2. Update Theme Definitions

The theme data structure remains the same - the new tokens are compatible:

```dart
MixTheme(
  data: MixThemeData(
    colors: {
      primaryColor: Colors.blue,  // Works with both old and new
    },
    spaces: {
      largeSpace: 24.0,
    },
    textStyles: {
      headingStyle: TextStyle(fontSize: 24),
    },
    radii: {
      smallRadius: Radius.circular(8),
    },
  ),
);
```

### 3. Update Usage in Styles

**With Utility Methods (Recommended):**
```dart
// Old way
Style(
  $box.color.ref(ColorToken('primary')),
  $box.padding.all.ref(SpaceToken('large')),
);

// New way
Style(
  $box.color.token(Token<Color>('primary')),
  $box.padding.all.token(Token<double>('large')),
);
```

**With DTOs:**
```dart
// Old way
ColorDto(ColorToken('primary')());
SpaceDto(SpaceToken('large')());

// New way  
ColorDto.token(Token<Color>('primary'));
SpaceDto.token(Token<double>('large'));
```

### 4. Gradual Migration

The old token system continues to work alongside the new system. You can migrate gradually:

1. Start using `Token<T>` for new code
2. Update existing code when convenient
3. Both systems work during the transition

### 5. Type Safety Benefits

The new system provides better type safety:

```dart
// Compile-time type checking
const colorToken = Token<Color>('primary');
const spaceToken = Token<double>('large');

// This won't compile (type mismatch)
// $box.color.token(spaceToken);  // Error: Expected Token<Color>
```

## Common Patterns

### Creating Token Constants
```dart
class AppTokens {
  // Colors
  static const primary = Token<Color>('primary');
  static const secondary = Token<Color>('secondary');
  
  // Spacing
  static const small = Token<double>('small');
  static const medium = Token<double>('medium');
  static const large = Token<double>('large');
  
  // Text Styles
  static const heading1 = Token<TextStyle>('heading1');
  static const body = Token<TextStyle>('body');
  
  // Radius
  static const rounded = Token<Radius>('rounded');
}
```

### Using with Material Tokens
```dart
// Material tokens work with the new system
final style = Style(
  $box.color.token($material.colorScheme.primary),
  $text.style.token($material.textTheme.headlineLarge),
);
```

## Troubleshooting

### SpaceToken Negative Values
The old `SpaceToken` used negative hashcodes as references. The new system handles this automatically:

```dart
// Old hack
final spaceRef = -spaceToken.hashCode;

// New system - no hack needed
final spaceRef = Token<double>('large')();
```

### Custom Token Types
Currently, only these types are supported:
- `Color`
- `double` (for spacing)
- `TextStyle`
- `Radius`
- `Breakpoint`

For other types, you'll see helpful error messages guiding you to use supported types.

## Benefits of Migration

1. **Type Safety**: Compile-time type checking prevents errors
2. **Consistency**: Single pattern for all token types
3. **Clarity**: Generic syntax makes token types explicit
4. **Future-Proof**: Foundation for expanded token support

## Need Help?

- Check the [example app](../example) for migration examples
- Review the [API documentation](https://pub.dev/documentation/mix/latest/)
- Report issues on [GitHub](https://github.com/leoafarias/mix/issues)
