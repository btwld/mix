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

## Overlays and separate routes

`InheritedTheme.captureAll` captures Flutter inherited themes, but does not
capture `MixScope`: it is an `InheritedModel`. An overlay entry or route outside
a local scope therefore sees the destination's scope, if any.

Use the existing `MixScope.combine` API to reapply the **nearest effective
scope** around the overlay content. Capture it while the source context is
mounted, before inserting the entry or pushing the route:

```dart
Widget captureMixScope(BuildContext context, Widget child) {
  final scope = context.getInheritedWidgetOfExactType<MixScope>();
  return scope == null
      ? child
      : MixScope.combine(scopes: [scope], child: child);
}

// In an event callback, with a context below the local MixScope:
final content = captureMixScope(
  context,
  InheritedTheme.captureAll(context, const MyOverlayContent()),
);
final entry = OverlayEntry(builder: (_) => content);
Overlay.of(context).insert(entry);
// The owner must remove and dispose the entry when it is no longer needed.
```

This preserves tokens and modifier order without collecting all ancestor
scopes. A plain nested scope must continue to hide its ancestors' tokens;
`MixScope.inherit` has already merged its ancestor values into the nearest
scope. Merging every ancestor again would undo that boundary. When no source
scope exists, return the child unchanged so it can use the destination's scope.

This is a snapshot of the supplied configuration, not a live subscription.
Later source-scope changes do not update the entry automatically. Recapture and
rebuild it when needed, or put a shared `MixScope` above the navigator/overlay.
For capture during widget building, `MixScope.maybeOf(context)` can establish
a dependency; the event-callback example uses a non-listening lookup instead.
Reapplied scopes retain normal `tokens`/`modifierOrder` aspect notifications.

Resolver functions stored in the token map are preserved, not evaluated during
capture. They receive the **destination** context when resolved. Reapply any
other inherited dependencies they need, or provide concrete token values when
the source's resolved values must be frozen. Mutable token values and modifier
lists are not deep-copied; do not mutate them in place.

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

Resolution concatenates the style-local order, the nearest scope's order, and
the package default, keeping the first occurrence of each type. Local ordering
takes priority; scoped types absent from the local list retain their order
after it. Remaining configured modifier types are appended in stable order.
The resolved list runs outermost to innermost; the renderer wraps in reverse.
See the [modifier reference](../../../skills/mix/references/widget-modifiers-directives.md)
for composition and exact types.

## Diagnose a missing value

- Check the token's concrete class and name, not just its displayed name.
- Check the nearest scope: a plain nested scope hides ancestor values.
- Match the value type to the token type; shadow tokens take lists.
- Use `MixScope.inherit` when a feature needs partial overrides.
- Replace old `MixScopeData` setup with direct maps; use public
  `package:mix/mix.dart` imports.
