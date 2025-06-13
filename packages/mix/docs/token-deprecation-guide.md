# Token Deprecation Guide

This guide outlines the deprecation of old token classes in favor of the new generic `Token<T>` system.

## Deprecated Classes

The following token classes are deprecated and will be removed in v3.0.0:

- `ColorToken` → Use `Token<Color>` instead
- `SpaceToken` → Use `Token<double>` instead  
- `TextStyleToken` → Use `Token<TextStyle>` instead
- `RadiusToken` → Use `Token<Radius>` instead

## Deprecation Timeline

- **v2.x**: Old tokens deprecated with warnings
- **v3.0**: Old tokens removed completely

## Migration Examples

### ColorToken
```dart
// Deprecated
@Deprecated('Use Token<Color> instead. This will be removed in v3.0.0.')
const primary = ColorToken('primary');

// New
const primary = Token<Color>('primary');
```

### SpaceToken
```dart
// Deprecated
@Deprecated('Use Token<double> instead. This will be removed in v3.0.0.')
const large = SpaceToken('large');

// New
const large = Token<double>('large');
```

### TextStyleToken
```dart
// Deprecated
@Deprecated('Use Token<TextStyle> instead. This will be removed in v3.0.0.')
const heading = TextStyleToken('heading');

// New
const heading = Token<TextStyle>('heading');
```

### RadiusToken
```dart
// Deprecated
@Deprecated('Use Token<Radius> instead. This will be removed in v3.0.0.')
const rounded = RadiusToken('rounded');

// New
const rounded = Token<Radius>('rounded');
```

## Suppressing Deprecation Warnings

During migration, you may want to suppress deprecation warnings:

```dart
// ignore: deprecated_member_use
const oldToken = ColorToken('primary');

// Or for entire file
// ignore_for_file: deprecated_member_use_from_same_package
```

## Why Are We Deprecating?

1. **DRY Principle**: Eliminates 5 duplicate token classes
2. **Type Safety**: Better compile-time type checking
3. **Consistency**: Single pattern for all tokens
4. **Maintainability**: One implementation to maintain

## What Stays the Same?

- Theme data structure
- Token resolution mechanism
- Runtime behavior
- Token names and values

## Need to Keep Using Old Tokens?

If you need more time to migrate:

1. Pin your Mix version to v2.x
2. Plan migration before upgrading to v3.0
3. Use the migration guide for step-by-step instructions

## Questions?

- See the [Migration Guide](token-migration-guide.md)
- Check [GitHub Discussions](https://github.com/leoafarias/mix/discussions)
- Report issues with migration
