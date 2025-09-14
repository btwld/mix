# Token System Guide

## Overview

This guide provides accurate information about the current Mix token system. The Mix framework uses `MixToken<T>` with `MixScope` for theme management and design token resolution.

## Current Token System

### MixToken<T> - The Token Implementation

The Mix framework uses a generic `MixToken<T>` abstract class for all design tokens:

```dart
@immutable
abstract class MixToken<T> {
  final String name;
  const MixToken(this.name);
  
  /// Returns a token reference that can be used in styling
  T call() => getReferenceValue(this);
  
  /// Resolves token to actual value within the given context
  T resolve(BuildContext context) => MixScope.tokenOf(this, context);
  
  @override
  operator ==(Object other) => 
      identical(this, other) || (other is MixToken && other.name == name);
  
  @override
  int get hashCode => Object.hash(name, T);
}
```

**Key Points:**
- Abstract base class with name and type information
- `call()` method returns token references for styling
- `resolve()` method gets actual values from context
- Type-safe with generic type parameter `T`

## Available Token Types

All token types are consolidated in `value_tokens.dart`:

### ColorToken
```dart
class ColorToken extends MixToken<Color> {
  const ColorToken(super.name);
  
  @override
  ColorRef call() => ColorRef(Prop.token(this));
}
```

### SpaceToken (for spacing/sizing)
```dart
class SpaceToken extends MixToken<double> {
  const SpaceToken(super.name);
  
  @override
  double call() => SpaceRef.token(this);  // Extension type
}
```

### RadiusToken
```dart
class RadiusToken extends MixToken<Radius> {
  const RadiusToken(super.name);
  
  @override
  RadiusRef call() => RadiusRef(Prop.token(this));
}
```

### TextStyleToken
```dart
class TextStyleToken extends MixToken<TextStyle> {
  const TextStyleToken(super.name);
  
  @override
  TextStyleRef call() => TextStyleRef(Prop.token(this));
}
```

### BreakpointToken
```dart
class BreakpointToken extends MixToken<Breakpoint> {
  const BreakpointToken(super.name);
  
  @override
  BreakpointRef call() => BreakpointRef(Prop.token(this));
}
```

### BoxShadowToken
```dart
class BoxShadowToken extends MixToken<BoxShadow> {
  const BoxShadowToken(super.name);
  
  @override
  BoxShadowRef call() => BoxShadowRef(Prop.token(this));
}
```

### ShadowToken
```dart
class ShadowToken extends MixToken<Shadow> {
  const ShadowToken(super.name);
  
  @override
  ShadowRef call() => ShadowRef(Prop.token(this));
}
```

## Token Reference System

### Token Refs
Each token type has a corresponding reference type that implements the target interface:

- **ColorRef**: Implements `Color` interface
- **RadiusRef**: Implements `Radius` interface  
- **TextStyleRef**: Implements `TextStyle` interface
- **BoxShadowRef**: Implements `BoxShadow` interface
- **ShadowRef**: Implements `Shadow` interface
- **BreakpointRef**: Implements `Breakpoint` interface

### Extension Type Refs (Primitives)
For primitive types, extension types are used:

- **SpaceRef**: Extension type for `double` values (spacing, sizing)

```dart
// Extension type example
extension type const SpaceRef(double _value) implements double {
  static SpaceRef token(MixToken<double> token) {
    // Creates unique reference value and registers token
    final hash = token.hashCode.abs() % 100000;
    final ref = SpaceRef(-(0.000001 + hash * 0.000001));
    _tokenRegistry[ref] = token;
    return ref;
  }
}
```

## Theme System - MixScope

### MixScope Widget

`MixScope` is an `InheritedModel` that provides theme data down the widget tree:

```dart
class MixScope extends InheritedModel<String> {
  /// Creates a MixScope with typed token maps
  factory MixScope({
    Map<MixToken, Object>? tokens,
    Map<ColorToken, Color>? colors,
    Map<TextStyleToken, TextStyle>? textStyles,
    Map<SpaceToken, double>? spaces,
    Map<RadiusToken, Radius>? radii,
    Map<BreakpointToken, Breakpoint>? breakpoints,
    List<Type>? orderOfModifiers,
    required Widget child,
    Key? key,
  });
  
  /// Access MixScope from context
  static MixScope of(BuildContext context, [String? aspect]);
  
  /// Resolve token value from nearest MixScope
  static T tokenOf<T>(MixToken<T> token, BuildContext context);
  
  /// Type-safe token resolution with error handling
  T getToken<T>(MixToken<T> token, BuildContext context);
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
const cardShadow = BoxShadowToken('card.shadow');
```

### 2. Theme Setup

#### Basic Theme Setup
```dart
void main() {
  runApp(
    MixScope(
      colors: {
        primaryColor: Colors.blue,
      },
      spaces: {
        largeSpace: 24.0,
      },
      textStyles: {
        headingStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      },
      radii: {
        roundedCorner: Radius.circular(8),
      },
      child: MyApp(),
    ),
  );
}
```

#### Using Generic Token Map
```dart
void main() {
  runApp(
    MixScope(
      tokens: {
        primaryColor: Colors.blue,
        largeSpace: 24.0,
        headingStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        roundedCorner: Radius.circular(8),
      },
      child: MyApp(),
    ),
  );
}
```

#### Material Design Integration
```dart
void main() {
  runApp(
    MixScope.withMaterial(
      colors: {
        // Your custom colors in addition to Material colors
        primaryColor: Colors.purple,
      },
      child: MyApp(),
    ),
  );
}
```

### 3. Using Tokens in Styles

#### Current Standard Pattern
```dart
// Using .token() method (current standard)
final style = Style(
  $box.color.token(primaryColor),
  $box.padding.all.token(largeSpace),
  $text.style.token(headingStyle),
);
```

#### Direct Token Call (Returns Refs)
```dart
// Token call() method returns refs for styling
final colorRef = primaryColor(); // Returns ColorRef
final spaceRef = largeSpace();   // Returns SpaceRef
final styleRef = headingStyle(); // Returns TextStyleRef

// Use refs in styling utilities
final style = Style(
  $box.color(colorRef),
  $box.padding.all(spaceRef),
  $text.style(styleRef),
);
```

### 4. Using Tokens in Properties

```dart
// SpaceDto with tokens
final spacing = SpaceDto.token(largeSpace);

// Prop<T> with tokens  
final colorProp = Prop.token(primaryColor);
```

## Token Resolution

### How Tokens Are Resolved

1. **MixScope provides theme data** via `InheritedModel`
2. **Token references** created via `call()` method
3. **Token resolution happens** via `MixScope.tokenOf<T>(token, context)`
4. **Type-safe resolution** with error handling

```dart
// Token resolution flow
MixToken<T> 
  → token() creates TokenRef/ExtensionType
  → MixScope.tokenOf<T>(token, context)
  → T (resolved value)
```

### Token Reference Flow
```dart
// Example resolution flow
const primaryColor = ColorToken('primary');

// 1. Create reference
final colorRef = primaryColor(); // Returns ColorRef

// 2. Use in styling 
$box.color(colorRef)

// 3. During resolution, token is extracted and resolved
// colorRef contains Prop.token(primaryColor)
// MixScope resolves primaryColor to actual Color value
```

### Error Handling

```dart
T getToken<T>(MixToken<T> token, BuildContext context) {
  final value = _tokens?[token];
  if (value == null) {
    throw StateError('Token "${token.name}" not found in scope');
  }
  
  if (value is T) {
    return value as T;
  }
  
  throw StateError(
    'Token "${token.name}" resolved to ${value.runtimeType}, expected $T',
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
  
  // Shadows
  static const cardShadow = BoxShadowToken('card.shadow');
  static const textShadow = ShadowToken('text.shadow');
}
```

### 2. Organize Theme Data

```dart
class AppTheme {
  static Map<ColorToken, Color> get lightColors => {
    AppTokens.primary: Colors.blue,
    AppTokens.secondary: Colors.blue.shade100,
    AppTokens.surface: Colors.white,
  };
  
  static Map<ColorToken, Color> get darkColors => {
    AppTokens.primary: Colors.blue.shade300,
    AppTokens.secondary: Colors.blue.shade800,
    AppTokens.surface: Colors.grey.shade900,
  };
  
  static Map<SpaceToken, double> get spacing => {
    AppTokens.xs: 4.0,
    AppTokens.sm: 8.0,
    AppTokens.md: 16.0,
    AppTokens.lg: 24.0,
    AppTokens.xl: 32.0,
  };
  
  static Map<TextStyleToken, TextStyle> get typography => {
    AppTokens.heading1: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    AppTokens.heading2: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    AppTokens.body: TextStyle(fontSize: 16),
    AppTokens.caption: TextStyle(fontSize: 12, color: Colors.grey),
  };
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
await tester.pumpWidget(
  MixScope(
    colors: {
      AppTokens.primary: Colors.red,
    },
    spaces: {
      AppTokens.md: 20.0,
    },
    child: MyWidget(),
  ),
);
```

### Token Resolution Testing

```dart
testWidgets('token resolves correctly', (tester) async {
  const token = ColorToken('test');
  
  await tester.pumpWidget(
    MixScope(
      colors: {token: Colors.blue},
      child: Builder(
        builder: (context) {
          final resolved = MixScope.tokenOf(token, context);
          expect(resolved, equals(Colors.blue));
          return Container();
        },
      ),
    ),
  );
});
```

## Common Patterns

### 1. Theme-aware Components

```dart
class ThemedContainer extends StatelessWidget {
  const ThemedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Box(
      style: Style(
        $box.color.token(AppTokens.surface),
        $box.padding.all.token(AppTokens.md),
        $box.borderRadius.all.token(AppTokens.rounded),
      ),
      child: Text('Themed content'),
    );
  }
}
```

### 2. Light/Dark Theme Support

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isLight = brightness == Brightness.light;
    
    return MixScope(
      colors: isLight ? AppTheme.lightColors : AppTheme.darkColors,
      spaces: AppTheme.spacing,
      textStyles: AppTheme.typography,
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
```

### 3. Responsive Tokens

```dart
class ResponsiveSpacing {
  static double getSpacing(BuildContext context, SpaceToken token) {
    final width = MediaQuery.of(context).size.width;
    final baseValue = MixScope.tokenOf(token, context);
    
    // Scale spacing based on screen size
    if (width > 600) {
      return baseValue * 1.5;
    }
    return baseValue;
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

- **`Color`** - Colors and color values
- **`double`** - Spacing, sizing, and numeric values (via SpaceToken)
- **`TextStyle`** - Typography styles
- **`Radius`** - Border radius values
- **`Breakpoint`** - Responsive breakpoints
- **`BoxShadow`** - Box shadow effects
- **`Shadow`** - Text shadow effects

## Migration from Old System

### Key Changes
1. **MixScopeData replaced by MixScope**: Use MixScope constructor directly
2. **ValueResolvers removed**: Use direct value maps
3. **Token consolidation**: All tokens now in `value_tokens.dart`
4. **Ref system**: Tokens return refs via `call()` method
5. **Simplified API**: Type-specific maps for cleaner setup

### Migration Steps

#### Step 1: Update Theme Setup
```dart
// Old (remove)
MixScope(
  data: MixScopeData.static(tokens: {...}),
  child: MyApp(),
)

// New
MixScope(
  colors: {primaryColor: Colors.blue},
  spaces: {largeSpace: 24.0},
  child: MyApp(),
)
```

#### Step 2: Update Imports
```dart
// Old imports (remove these)
import 'package:mix/src/theme/tokens/color_token.dart';
import 'package:mix/src/theme/tokens/space_token.dart';

// New import (consolidated)
import 'package:mix/mix.dart'; // All tokens available via public API
```

#### Step 3: Update Usage
```dart
// Usage remains the same
$box.color.token(primaryColor)
$box.padding.all.token(largeSpace)
```

## Troubleshooting

### Common Issues

1. **Token not found**: Ensure token is defined in MixScope
2. **Type mismatch**: Check token type matches expected type  
3. **Theme not accessible**: Ensure MixScope is an ancestor widget
4. **Import errors**: Use public API imports (package:mix/mix.dart)

### Debug Tips

```dart
// Check if token exists in scope
final scope = MixScope.of(context);
final hasToken = scope.tokens?.containsKey(myToken) ?? false;

// Get token value for debugging
final tokenValue = scope.getToken(myToken, context);
```

## Conclusion

The Mix token system uses `MixToken<T>` with `MixScope` for a type-safe, streamlined theme system. Key points:

1. **Use `MixScope`** for theme setup with type-specific maps
2. **Create tokens with specific token classes** for type safety
3. **Use `.token()` method** in styling utilities
4. **Token references** automatically created via `call()` method
5. **Consolidated token types** in single `value_tokens.dart` file

The system is simplified, type-safe, and production-ready with comprehensive token type support.