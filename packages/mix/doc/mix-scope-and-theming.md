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

### Token Values
- MixScope stores concrete values mapped by `MixToken<T>` keys.
- Provide them via the typed maps in the MixScope constructor or in `MixScope.withMaterial`.

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
  doubles: {
    DoubleToken('elevation.card'): 2.0,
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
  fontWeights: {
    FontWeightToken('weight.semibold'): FontWeight.w600,
  },
  borders: {
    BorderSideToken('border.default'): const BorderSide(width: 1),
  },
  shadows: {
    ShadowToken('shadow.sm'): const [Shadow(blurRadius: 2, offset: Offset(0, 1))],
  },
  boxShadows: {
    BoxShadowToken('shadow.card'): const [
      BoxShadow(blurRadius: 8, spreadRadius: 0, offset: Offset(0, 4)),
    ],
  },
  child: MyApp(),
)
```

### 2) Using the generic `tokens:` map

You can also combine values into a single `Map<MixToken, Object>` via `tokens:`:

```dart
MixScope(
  tokens: {
    ColorToken('brand.primary'): Colors.blue,
    SpaceToken('space.md'): 16.0,
    ShadowToken('shadow.sm'): const [Shadow(blurRadius: 2, offset: Offset(0, 1))],
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
- `withMaterial` reads `Theme.of(context)` at build time and maps Material tokens.
- You can combine Material tokens with your own values via any of the typed maps or the generic `tokens:`.

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
final $cardShadow = BoxShadowToken('shadow.card');

final style = BoxStyler()
  .color($primary())
  .padding(.all($spacing()));
  // For APIs that take lists of shadows/boxShadows
  // .boxShadow($cardShadow())
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

When you place a new `MixScope` inside an existing one, the inner scope becomes the *nearest* scope for its subtree and **completely replaces** the parent for token resolution. Any token that the parent defined but the child did not is no longer visible:

```dart
MixScope(
  colors: { ColorToken('brand.primary'): Colors.blue },
  spaces: { SpaceToken('space.md'): 16.0 },
  child: FeatureShell(
    child: MixScope(
      // Only overrides the color, but space.md is now gone
      colors: { ColorToken('brand.primary'): Colors.green },
      child: FeatureWidget(), // SpaceToken('space.md') will throw an error
    ),
  ),
)
```

In the example above, `FeatureWidget` can resolve `brand.primary` (green), but `space.md` is lost because the inner scope does not carry the parent's tokens. To keep upstream tokens available while adding or overriding a subset, use `MixScope.combine` or `MixScope.inherit`.

### MixScope.combine

`MixScope.combine` takes a list of `MixScope` instances and folds them into a single scope. Token maps are merged in order: later scopes override earlier ones when the same token appears in both.

```dart
final base = MixScope(
  colors: { ColorToken('brand.primary'): Colors.blue },
  spaces: { SpaceToken('space.md'): 16.0 },
  child: const SizedBox(),
);

final feature = MixScope(
  colors: { ColorToken('brand.primary'): Colors.green },
  child: const SizedBox(),
);

// Merged result: brand.primary -> green, space.md -> 16.0
final combined = MixScope.combine(
  scopes: [base, feature],
  child: MyApp(),
);
```

This is useful when you have multiple scope definitions (e.g. a base theme and a feature-level override) and want to merge them explicitly before placing them in the tree.

### MixScope.inherit

`MixScope.inherit` is a convenience for the most common case: you already have a parent `MixScope` in the tree and want to add (or override) a few tokens without losing the rest. It reads the nearest parent scope at build time and merges it with the tokens you provide. Parent tokens come first, then yours, so your entries win when keys collide:

```dart
MixScope(
  colors: {
    ColorToken('brand.primary'): Colors.blue,
    ColorToken('custom.accent'): Colors.orange,
  },
  spaces: { SpaceToken('space.md'): 16.0 },
  child: MixScope.inherit(
    // Only adds a new space token; all parent tokens remain available
    spaces: { SpaceToken('custom.gap'): 12.0 },
    child: MySubtree(), // resolves brand.primary, custom.accent, space.md, and custom.gap
  ),
)
```

## Hands-On Tutorial

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
- Keep tokens type-safe using the provided token classes (ColorToken, SpaceToken, DoubleToken, RadiusToken, TextStyleToken, BreakpointToken, ShadowToken, BoxShadowToken, BorderSideToken, FontWeightToken)
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
