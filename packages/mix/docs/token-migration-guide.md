# Token Migration Guide

## Overview

This guide provides accurate information about the current Mix token system. The Mix framework uses `MixToken<T>` with `MixScope` and `MixScopeData` for theme management.

## Current Token System

### MixToken<T> - The Current Implementation

The Mix framework uses a generic `MixToken<T>` class for all design tokens:

```dart
@immutable
class MixToken<T> {
  final String name;
  const MixToken(this.name);
  
  @override
  operator ==(Object other) => 
      identical(this, other) || (other is MixToken && other.name == name);
  
  @override
  int get hashCode => Object.hash(name, T);
}
```

**Key Points:**
- Simple data container with name and type information
- No `call()` method - tokens are resolved via the scope system
- Type-safe with generic type parameter `T`

## Theme System - MixScope & MixScopeData

### MixScope Widget

`MixScope` is an `InheritedWidget` that provides theme data down the widget tree:

```dart
class MixScope extends InheritedWidget {
  const MixScope({required this.data, super.key, required super.child});
  
  static MixScopeData of(BuildContext context) { ... }
  static MixScopeData? maybeOf(BuildContext context) { ... }
  
  final MixScopeData data;
}
```

### MixScopeData - Theme Data Container

`MixScopeData` holds the actual theme data and tokens:

```dart
class MixScopeData {
  // Multiple factory constructors for different use cases
  
  factory MixScopeData({
    Map<MixToken, ValueResolver>? tokens,
    List<Type>? orderOfModifiers,
  });
  
  static MixScopeData static({
    Map<MixToken, Object>? tokens,
    List<Type>? orderOfModifiers,
  });
  
  factory MixScopeData.withMaterial({
    Map<MixToken, ValueResolver>? tokens,
    List<Type>? orderOfModifiers,
  });
  
  static MixScopeData fromResolvers({
    Map<MixToken, ValueResolver>? tokens,
    List<Type>? orderOfModifiers,
  });
  
  T getToken<T>(MixToken<T> token, BuildContext context);
  MixScopeData merge(MixScopeData other);
}
```

## Token Creation and Usage

### 1. Creating Tokens

```dart
// Create type-safe tokens using specific token types
const primaryColor = ColorToken('primary');
const largeSpace = SpaceToken('large');
const headingStyle = TextStyleToken('heading');
const roundedCorner = RadiusToken('rounded');
```

### 2. Theme Setup

#### Static Theme (Simple Values)

```dart
void main() {
  runApp(
    MixScope(
      data: MixScopeData.static(
        tokens: {
          primaryColor: Colors.blue,
          largeSpace: 24.0,
          headingStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          roundedCorner: Radius.circular(8),
        },
      ),
      child: MyApp(),
    ),
  );
}
```

#### Dynamic Theme with Context-Aware Resolvers

```dart
void main() {
  runApp(
    MixScope(
      data: MixScopeData.fromResolvers(
        tokens: {
          primaryColor: (context) => Theme.of(context).colorScheme.primary,
          largeSpace: (context) => MediaQuery.of(context).size.width * 0.1,
          headingStyle: (context) => Theme.of(context).textTheme.headlineLarge!,
        },
      ),
      child: MyApp(),
    ),
  );
}
```

#### Material Design Integration

```dart
void main() {
  runApp(
    MixScope(
      data: MixScopeData.withMaterial(
        tokens: {
          // Your custom tokens in addition to Material tokens
          customColor: Colors.purple,
        },
      ),
      child: MyApp(),
    ),
  );
}
```

### 3. Using Tokens in Styles

#### Current Recommended Pattern

```dart
// Using .token() method (current standard)
final style = Style(
  $box.color.token(primaryColor),
  $box.padding.all.token(largeSpace),
  $text.style.token(headingStyle),
);
```

#### Deprecated Pattern (Still Works)

```dart
// Using .ref() method (deprecated, will be removed)
final style = Style(
  $box.color.ref(primaryColor),        // ❌ Deprecated
  $box.padding.all.ref(largeSpace),    // ❌ Deprecated
);
```

### 4. Using Tokens in DTOs

```dart
// SpaceDto with tokens
final spacing = SpaceDto.token(largeSpace);

// Prop<T> with tokens
final colorProp = Prop.token(primaryColor);
```

## Material Design Tokens

Mix provides pre-defined Material Design tokens through the `MaterialTokens` class:

```dart
const _md = MaterialTokens();

// Color scheme tokens
_md.colorScheme.primary
_md.colorScheme.secondary
_md.colorScheme.surface
_md.colorScheme.background

// Text theme tokens
_md.textTheme.displayLarge
_md.textTheme.headlineLarge
_md.textTheme.bodyMedium
_md.textTheme.labelSmall
```

### Using Material Tokens

```dart
final style = Style(
  $box.color.token(_md.colorScheme.primary),
  $text.style.token(_md.textTheme.headlineLarge),
);
```

### Material Theme Integration

```dart
final materialMixScope = MixScopeData.fromResolvers(
  tokens: {
    _md.colorScheme.primary: (c) => c.colorScheme.primary,
    _md.colorScheme.secondary: (c) => c.colorScheme.secondary,
    _md.textTheme.displayLarge: (c) => c.textTheme.displayLarge!,
    // Automatically resolves from Material ThemeData
  },
);
```

## Token Resolution

### How Tokens Are Resolved

1. **MixScope provides theme data** via `InheritedWidget`
2. **MixContext accesses tokens** through `MixScope.of(context)`
3. **Token resolution happens** via `MixScopeData.getToken<T>(token, context)`
4. **ValueResolver functions** provide the actual values

```dart
// Token resolution flow
MixToken<T> 
  → MixContext.getToken<T>(token)
  → MixScopeData.getToken<T>(token, context)
  → ValueResolver<T>(context)
  → T (resolved value)
```

### ValueResolver System

```dart
// ValueResolver is a simple function type
typedef ValueResolver<T> = T Function(BuildContext context);

// Examples
final colorResolver: ValueResolver<Color> = (context) => 
    Theme.of(context).colorScheme.primary;

final spacingResolver: ValueResolver<double> = (context) => 
    MediaQuery.of(context).size.width * 0.05;
```

### Error Handling

```dart
T getToken<T>(MixToken<T> token, BuildContext context) {
  final resolver = _tokens?[token];
  if (resolver == null) {
    throw StateError('Token "${token.name}" not found in scope');
  }
  
  final resolved = resolver(context);
  if (resolved is T) {
    return resolved;
  }
  
  throw StateError(
    'Token "${token.name}" resolved to ${resolved.runtimeType}, expected $T',
  );
}
```

## Best Practices

### 1. Define Token Constants

```dart
class AppTokens {
  // Colors
  static const primary = ColorToken('primary');
  static const secondary = ColorToken('secondary');
  static const surface = ColorToken('surface');
  
  // Spacing
  static const xs = SpaceToken('xs');
  static const sm = SpaceToken('sm');
  static const md = SpaceToken('md');
  static const lg = SpaceToken('lg');
  static const xl = SpaceToken('xl');
  
  // Typography
  static const heading1 = TextStyleToken('heading1');
  static const heading2 = TextStyleToken('heading2');
  static const body = TextStyleToken('body');
  static const caption = TextStyleToken('caption');
  
  // Radius
  static const rounded = RadiusToken('rounded');
  static const circular = RadiusToken('circular');
}
```

### 2. Organize Theme Data

```dart
class AppTheme {
  static MixScopeData light() {
    return MixScopeData.static(
      tokens: {
        AppTokens.primary: Colors.blue,
        AppTokens.secondary: Colors.blue.shade100,
        AppTokens.surface: Colors.white,
        AppTokens.md: 16.0,
        AppTokens.lg: 24.0,
        AppTokens.body: TextStyle(fontSize: 16, color: Colors.black87),
        AppTokens.rounded: Radius.circular(8),
      },
    );
  }
  
  static MixScopeData dark() {
    return MixScopeData.static(
      tokens: {
        AppTokens.primary: Colors.blue.shade300,
        AppTokens.secondary: Colors.blue.shade800,
        AppTokens.surface: Colors.grey.shade900,
        AppTokens.md: 16.0,
        AppTokens.lg: 24.0,
        AppTokens.body: TextStyle(fontSize: 16, color: Colors.white70),
        AppTokens.rounded: Radius.circular(8),
      },
    );
  }
}
```

### 3. Use Type-Safe Patterns

```dart
// Good: Type-safe token creation
const primaryColor = ColorToken('primary');

// Good: Clear naming convention
const headerTextStyle = TextStyleToken('text.header');

// Good: Consistent usage
$box.color.token(primaryColor)
$text.style.token(headerTextStyle)
```

## Testing

### Widget Testing with MixScope

```dart
await tester.pumpWithMixScope(
  MyWidget(),
  theme: MixScopeData.static(
    tokens: {
      AppTokens.primary: Colors.red,
      AppTokens.spacing: 20.0,
    },
  ),
);
```

### Token Resolution Testing

```dart
final mixContext = MixContext.create(context, Style());
final colorProp = Prop<Color>.token(AppTokens.primary);

expect(colorProp, resolvesTo(Colors.blue, context: mixContext));
```

## Migration Steps (For Deprecated Patterns)

### Step 1: Replace .ref() with .token()

```dart
// Before (deprecated)
$box.color.ref(primaryColor)

// After (current)
$box.color.token(primaryColor)
```

### Step 2: Ensure Proper Theme Setup

Make sure you're using `MixScope` and `MixScopeData`:

```dart
// Current correct pattern
MixScope(
  data: MixScopeData.static(tokens: {...}),
  child: MyApp(),
)
```

## Common Patterns

### 1. Responsive Tokens

```dart
// Different values based on screen size
final responsiveSpacing = MixScopeData.fromResolvers(
  tokens: {
    AppTokens.contentPadding: (context) {
      final width = MediaQuery.of(context).size.width;
      return width > 600 ? 32.0 : 16.0;
    },
  },
);
```

### 2. Theme-aware Tokens

```dart
// Tokens that adapt to Material Theme
final adaptiveTheme = MixScopeData.fromResolvers(
  tokens: {
    AppTokens.surface: (context) => Theme.of(context).colorScheme.surface,
    AppTokens.onSurface: (context) => Theme.of(context).colorScheme.onSurface,
  },
);
```

### 3. Light/Dark Theme Tokens

```dart
// Define separate token maps for light and dark themes
class AppTokens {
  static const primary = ColorToken('primary');
  static const secondary = ColorToken('secondary');
  static const background = ColorToken('background');
  static const text = ColorToken('text');
}

final lightTokens = <MixToken, Object>{
  AppTokens.primary: Colors.blue,
  AppTokens.secondary: Colors.blue.shade100,
  AppTokens.background: Colors.white,
  AppTokens.text: Colors.black87,
};

final darkTokens = <MixToken, Object>{
  AppTokens.primary: Colors.lightBlue,
  AppTokens.secondary: Colors.blue.shade800,
  AppTokens.background: Colors.grey.shade900,
  AppTokens.text: Colors.white70,
};

// Simple brightness check before MixScope
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final tokens = brightness == Brightness.light ? lightTokens : darkTokens;
    
    return MixScope(
      tokens: tokens,
      child: MaterialApp(
        // Your app content
      ),
    );
  }
}
```

### 4. Semantic Tokens

```dart
// Semantic naming for better maintainability
const actionPrimary = ColorToken('action.primary');
const actionSecondary = ColorToken('action.secondary');
const actionDanger = ColorToken('action.danger');

const contentPadding = SpaceToken('layout.content.padding');
const sectionSpacing = SpaceToken('layout.section.spacing');
```

## Supported Token Types

The current system supports tokens for:

- **`Color`** - Colors and gradients
- **`double`** - Spacing, sizing, and numeric values
- **`TextStyle`** - Typography styles
- **`Radius`** - Border radius values
- **`Breakpoint`** - Responsive breakpoints

## Troubleshooting

### Common Issues

1. **Token not found**: Ensure token is defined in `MixScopeData`
2. **Type mismatch**: Check token type matches expected type
3. **Deprecated warnings**: Replace `.ref()` with `.token()`
4. **Theme not accessible**: Ensure `MixScope` is an ancestor widget

### Debug Tips

```dart
// Check if token exists in scope
final scope = MixScope.of(context);
final hasToken = scope._tokens?.containsKey(myToken) ?? false;

// Get token value for debugging
final tokenValue = scope.getToken(myToken, context);
```

## Conclusion

The Mix token system uses `MixToken<T>` with `MixScope` and `MixScopeData` for a type-safe, context-aware theme system. Key points:

1. **Use `MixScope` and `MixScopeData`** for theme setup
2. **Create tokens with `MixToken<T>`** for type safety
3. **Use `.token()` instead of `.ref()`** in utilities
4. **Leverage Material Design tokens** when appropriate
5. **Use static themes for simple cases, resolvers for dynamic values**

The system is stable, type-safe, and production-ready with comprehensive Material Design integration.
