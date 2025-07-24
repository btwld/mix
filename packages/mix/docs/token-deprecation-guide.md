# MixToken Deprecation Guide

This guide outlines the deprecation of old token classes in favor of the new generic `MixToken<T>` system.

## Deprecated Classes

The following token classes are deprecated and will be removed in v3.0.0:

- `ColorToken` → Use `MixToken<Color>` instead
- `SpaceToken` → Use `MixToken<double>` instead  
- `TextStyleToken` → Use `MixToken<TextStyle>` instead
- `RadiusToken` → Use `MixToken<Radius>` instead

## Deprecation Timeline

- **v2.x**: Old tokens deprecated with warnings
- **v3.0**: Old tokens removed completely

## Migration Examples

### ColorToken
```dart
// Deprecated
@Deprecated('Use MixToken<Color> instead. This will be removed in v3.0.0.')
const primary = ColorToken('primary');

// New
const primary = MixToken<Color>('primary');
```

### SpaceToken
```dart
// Deprecated
@Deprecated('Use MixToken<double> instead. This will be removed in v3.0.0.')
const large = SpaceToken('large');

// New
const large = MixToken<double>('large');
```

### TextStyleToken
```dart
// Deprecated
@Deprecated('Use MixToken<TextStyle> instead. This will be removed in v3.0.0.')
const heading = TextStyleToken('heading');

// New
const heading = MixToken<TextStyle>('heading');
```

### RadiusToken
```dart
// Deprecated
@Deprecated('Use MixToken<Radius> instead. This will be removed in v3.0.0.')
const rounded = RadiusToken('rounded');

// New
const rounded = MixToken<Radius>('rounded');
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
- MixToken resolution mechanism
- Runtime behavior
- MixToken names and values

## Need to Keep Using Old MixTokens?

If you need more time to migrate:

1. Pin your Mix version to v2.x
2. Plan migration before upgrading to v3.0
3. Use the migration guide for step-by-step instructions

## Questions?

- See the [Migration Guide](token-migration-guide.md)
- Check [GitHub Discussions](https://github.com/leoafarias/mix/discussions)
- Report issues with migration
