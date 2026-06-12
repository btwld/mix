# Design Tokens

Centralized visual properties via `MixToken` and `MixScope`.

## Overview

Design tokens define visual properties (colors, typography, spacing) in a centralized, swappable way. Mix provides token types and `MixScope` (an `InheritedModel`) to provide values to the widget tree.

## Token Workflow

```dart
// 1. Declare tokens
final $primary = ColorToken('primary');
final $spacingMd = SpaceToken('spacingMd');

// 2. Provide values via MixScope
MixScope(
  colors: { $primary: Colors.blue },
  spaces: { $spacingMd: 16.0 },
  child: MyApp(),
);

// 3. Use in styles — call() creates a token reference
final style = BoxStyler()
    .color($primary())
    .paddingAll($spacingMd());
```

The `()` call syntax on tokens creates a type-specific reference (`ColorRef`, `DoubleRef`, `RadiusRef`, etc.) that the `Prop` system recognizes as a token source and resolves from `MixScope` during style resolution.

## Built-in Token Types

| Token Type | Value Type | MixScope Parameter |
|------------|-----------|-------------------|
| `ColorToken` | `Color` | `colors:` |
| `SpaceToken` | `double` | `spaces:` |
| `DoubleToken` | `double` | `doubles:` |
| `RadiusToken` | `Radius` | `radii:` |
| `TextStyleToken` | `TextStyle` | `textStyles:` |
| `BorderSideToken` | `BorderSide` | `borders:` |
| `ShadowToken` | `List<Shadow>` | `shadows:` |
| `BoxShadowToken` | `List<BoxShadow>` | `boxShadows:` |
| `FontWeightToken` | `FontWeight` | `fontWeights:` |
| `DurationToken` | `Duration` | generic `tokens:` |
| `BreakpointToken` | `Breakpoint` | `breakpoints:` |

## MixScope

**File:** `packages/mix/lib/src/theme/mix_theme.dart`

```dart
MixScope(
  colors: { $primary: Colors.blue, $secondary: Colors.green },
  spaces: { $spacingSm: 8.0, $spacingMd: 16.0, $spacingLg: 24.0 },
  radii: { $radiusSm: Radius.circular(4), $radiusMd: Radius.circular(8) },
  textStyles: { $heading: TextStyle(fontSize: 24, fontWeight: FontWeight.bold) },
  child: MaterialApp(home: MyHomePage()),
)
```

### Key API

| Method | Description |
|--------|-------------|
| `MixScope(colors:, spaces:, radii:, ...)` | Constructor with typed token maps |
| `MixScope.withMaterial(...)` | Pre-configured with Material Design tokens |
| `MixScope.combine(scopes: [...], child: ...)` | Merge multiple scopes |
| `MixScope.of(context)` | Get nearest scope (throws if not found) |
| `MixScope.maybeOf(context)` | Get nearest scope or null |
| `MixScope.tokenOf<T>(token, context)` | Resolve a single token value |

### Token Resolution

During `Prop.resolveProp()`, `TokenSource` resolves via:
```dart
MixScope.tokenOf(token, context)
```

If no `MixScope` is found, `MixScope.of` throws a `FlutterError`. If a scope exists but a token is missing or has the wrong value type, token resolution throws `StateError`.

## Theme Switching

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MixScope(
      colors: isDark
          ? { $primary: Colors.blue.shade200, $background: Colors.grey.shade900 }
          : { $primary: Colors.blue, $background: Colors.white },
      child: MaterialApp(home: MyHomePage()),
    );
  }
}
```

## Custom Token Types

Extend `MixToken<T>` for custom value types:

```dart
class CustomToken extends MixToken<MyCustomType> {
  const CustomToken(super.name);
}
```

Arbitrary custom tokens can be supplied through the generic `tokens:` map and resolved with `MixScope.tokenOf` or `token.resolve(context)`. The convenient `token()` call syntax returns a supported reference type when Mix has one; otherwise it falls back to a `Prop<T>` reference.

## Programmatic Resolution

Resolve tokens outside of style context:

```dart
final color = MixScope.tokenOf($primary, context);
```

## MixScope.withMaterial

Pre-configures tokens that map to Material Design's `ThemeData`:

```dart
MixScope.withMaterial(
  colors: { $primary: Colors.blue },  // Override specific tokens
  child: MyApp(),
)
```

Material tokens are extracted from `Theme.of(context)` and merged with any explicit overrides.
