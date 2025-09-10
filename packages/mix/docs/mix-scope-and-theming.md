# MixScope and Theming Guide

This guide explains how theming works in Mix using MixScope, tokens, and Material integration. It covers setup, usage patterns, and practical examples.

## Overview

- MixScope is an InheritedModel that provides design tokens and configuration to descendant widgets
- Aspects enable efficient rebuilds:
  - "tokens": rebuild when token values change
  - "modifierOrder": rebuild when the modifier ordering changes
- Tokens are type-safe and can resolve values dynamically from BuildContext

## Core Concepts

### MixToken<T>
- Declares a named, type-safe token
- Can be called to resolve via the reference system or resolved with context

```dart
// Declaration
const primary = ColorToken('color.primary');
const spacingMd = SpaceToken('space.md');
const h1 = TextStyleToken('text.h1');

// Resolution options
final color1 = primary();                 // via reference system
final color2 = primary.resolve(context);  // via BuildContext
```

### TokenDefinition<T>
- Binds a MixToken to a concrete value (static or computed) used by MixScope

```dart
TokenDefinition(primary, Colors.blue);
```

### ValueBuilder<T>
- A resolver function type: `T Function(BuildContext context)`
- MixScope stores a `Map<MixToken, ValueBuilder>` internally

## Setting Up MixScope

### 1) Basic setup with typed token maps

```dart
MixScope(
  colors: {
    ColorToken('brand.primary'): Colors.blue,
  },
  spaces: {
    SpaceToken('space.md'): 16.0,
  },
  radii: {
    RadiusToken('radius.pill'): const Radius.circular(20),
  },
  textStyles: {
    TextStyleToken('text.h1'): const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  },
  child: MyApp(),
)
```

### 2) Using TokenDefinition for custom sets

```dart
MixScope(
  tokens: {
    TokenDefinition(ColorToken('brand.primary'), Colors.blue),
    TokenDefinition(SpaceToken('space.md'), 16.0),
  },
  child: MyApp(),
)
```

### 3) Material integration

Use Material tokens resolved from the current Material Theme.

```dart
MixScope.withMaterial(
  // Optionally add/override custom tokens
  colors: {
    ColorToken('brand.primary'): Colors.indigo,
  },
  child: MyApp(),
)
```

Notes:
- withMaterial reads Theme.of(context) at build time and maps Material tokens
- You can combine Material tokens with your own TokenDefinition set via `tokens:` as well

## Accessing Tokens

### In widget/utility code

```dart
final scope = MixScope.of(context, 'tokens');
final brand = scope.getToken(ColorToken('brand.primary'), context);
```

Or directly on the token:

```dart
final brand = ColorToken('brand.primary').resolve(context);
```

### In styles (typical usage)

```dart
// Example from an app style
final $primary = ColorToken('brand.primary');
final $spacing = SpaceToken('space.md');

final style = BoxStyler()
  .color($primary())
  .padding(.all($spacing()));
```

## Modifier Ordering

MixScope can define the default order Mix modifiers are applied. You can provide a list of Type to `orderOfModifiers`. Widgets can depend on the "modifierOrder" aspect and rebuild only when the order changes.

```dart
MixScope(
  orderOfModifiers: [/* e.g., OpacityModifier, PaddingModifier, ... */],
  child: MyApp(),
)
```

## Combining/Overriding Scopes

You can merge scopes or create nested scopes to override subsets of tokens for parts of the tree.

```dart
final base = MixScope(
  colors: { ColorToken('brand.primary'): Colors.blue },
  child: const SizedBox(),
);

final feature = MixScope(
  colors: { ColorToken('brand.primary'): Colors.green },
  child: const SizedBox(),
);

final combined = MixScope.combine(
  scopes: [base, feature],
  child: MyApp(),
);
```

Or simply nest a child scope where needed:

```dart
MixScope(
  colors: { ColorToken('brand.primary'): Colors.blue },
  child: FeatureShell(
    child: MixScope(
      colors: { ColorToken('brand.primary'): Colors.green },
      child: FeatureWidget(),
    ),
  ),
)
```

## Hands‑On Tutorial

This tutorial creates brand color and spacing tokens, applies them, and integrates Material.

1) Define tokens

```dart
const $brandPrimary = ColorToken('brand.primary');
const $contentPadding = SpaceToken('layout.content.padding');
```

2) Provide tokens at the app root

```dart
void main() {
  runApp(
    MixScope(
      colors: { $brandPrimary: Colors.blue },
      spaces: { $contentPadding: 20.0 },
      child: const MyApp(),
    ),
  );
}
```

3) Use tokens in your UI/styles

```dart
class MyButton extends StatelessWidget {
  const MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color($brandPrimary())
        .padding(.all($contentPadding()))
        .borderRadius(.all(const Radius.circular(12)));

    return Box(style: style, child: const Text('Press me'));
  }
}
```

4) Switch to Material integration (optional)

```dart
void main() {
  runApp(
    MixScope.withMaterial(
      // Add or override your own tokens
      colors: { $brandPrimary: Colors.indigo },
      child: const MyApp(),
    ),
  );
}
```

## Best Practices

- Prefer semantic token names, e.g., `brand.primary`, `layout.content.padding`
- Keep tokens type-safe using the provided token classes (ColorToken, SpaceToken, RadiusToken, TextStyleToken, BreakpointToken)
- Centralize token declarations for discoverability
- Use nested scopes for feature- or screen-level overrides
- Leverage `withMaterial` when you want automatic alignment with Material Theme

## Troubleshooting

- No MixScope found
  - Error: "No MixScope found" — ensure your app is wrapped with MixScope at the root
- Token not found
  - Ensure the token is provided in MixScope via typed maps or TokenDefinition
- Type mismatch
  - Check that the token type matches the expected type at usage site
- Rebuild performance
  - Depend on aspect "tokens" or "modifierOrder" when appropriate to limit rebuilds

## Notes on Older Docs

If you encounter references to `MixScopeData` in older documents, note that the current implementation exposes token resolution directly from `MixScope` (an InheritedModel with aspects), storing `Map<MixToken, ValueBuilder>`. Use the APIs above.

