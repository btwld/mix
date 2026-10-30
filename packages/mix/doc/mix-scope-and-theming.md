# MixScope and theming

`MixScope` is an `InheritedModel` providing token values and modifier ordering.
Consumers can depend on the `tokens` or `modifierOrder` aspect so changes to one
need not notify dependents of the other. For token identity, reference limits,
and migration, see [Token migration](token-migration-guide.md).

## Provide values

```dart
const primary = ColorToken('brand.primary');
const space = SpaceToken('space.md');

MixScope(
  colors: {primary: Colors.blue},
  spaces: {space: 16.0},
  child: MyApp(),
);
```

Typed maps cover colors, spaces, doubles, radii, text styles, breakpoints,
shadows, box shadows, borders, and font weights. Use `tokens:` for a generic
`Map<MixToken, Object>`, including custom types and durations. Typed maps are
merged after the generic map, so a typed entry wins on duplicate keys.

```dart
MixScope(
  tokens: {primary: Colors.blue, space: 16.0},
  child: MyApp(),
);
```

## Reference versus resolution

```dart
final reference = primary(); // Deferred token reference, not a resolved color.
final style = BoxStyler().color(reference).padding(.all(space()));

// Where a BuildContext is available:
final color = primary.resolve(context);
```

Ordinary tokens need a matching scope value. `ContextToken` can compute a
fallback without a scope, and a scope entry overrides that fallback. A plain
nested scope can therefore hide ordinary tokens while context-backed defaults
remain available.

For direct scoped access, use `MixScope.tokenOf(token, context)` or
`MixScope.of(context, 'tokens').getToken(token, context)`. A missing scope or
missing ordinary token is an error, rather than a silent fallback.

## Partial overrides

A plain nested `MixScope` **shadows** the ancestor; it does not merge token maps.
Use `MixScope.inherit` to preserve ancestor values and override only a subset:

```dart
MixScope(
  colors: {
    primary: Colors.blue,
    ColorToken('brand.surface'): Colors.white,
  },
  child: MixScope.inherit(
    colors: {primary: Colors.green},
    child: FeatureWidget(),
  ),
);
```

`inherit` obtains a context below the ancestor through a `Builder`; it returns
a `Widget`, not a `MixScope`. With no ancestor it acts like a plain scope.

For explicit reusable scope objects, `MixScope.combine(scopes: [base, feature],
child: MyApp())` merges left to right. Later tokens override earlier tokens;
a later non-null modifier order replaces the earlier order.

## Material integration

```dart
MixScope.withMaterial(
  colors: {primary: Colors.indigo},
  child: MyApp(),
);
```

`withMaterial` reads the surrounding `Theme` at build time, supplies Material
tokens, and adds custom overrides. Place it below the theme it should read.
The same typed maps and generic `tokens:` map are available.

## Modifier ordering

```dart
MixScope(
  orderOfModifiers: [OpacityModifier, PaddingModifier],
  child: MyApp(),
);
```

Resolution chooses a style-local order first, then the nearest scope's order,
then the package default. Remaining configured modifier types are appended in
stable order. The resolved list runs outermost to innermost; the renderer wraps
in reverse. A local order overrides the inherited one rather than extending it.
See the [modifier reference](../../../skills/mix/references/widget-modifiers-directives.md)
for composition and exact types.

## Diagnose a missing value

- Check the token's concrete class and name, not just its displayed name.
- Check the nearest scope: a plain nested scope hides ancestor values.
- Match the value type to the token type; shadow tokens take lists.
- Use `MixScope.inherit` when a feature needs partial overrides.
- Replace old `MixScopeData` setup with direct maps; use public
  `package:mix/mix.dart` imports.
