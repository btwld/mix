# Token migration

This note covers migration from the old scope-data and resolver APIs.
For normal scope setup, partial overrides and Material integration, see
[MixScope and theming](mix-scope-and-theming.md). The portable
[token reference](../../../skills/mix/references/design-tokens.md) covers agent use.

## Replace scope data with direct maps

Remove `MixScopeData` and `ValueResolver` setup. Pass concrete values to a scope:

```dart
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const primary = ColorToken('brand.primary');
const space = SpaceToken('space.md');

final app = MixScope(
  colors: {primary: Colors.blue},
  spaces: {space: 24.0},
  child: MyApp(),
);
```

Use `tokens:` for values not covered by a typed map. Replace private imports
such as `src/theme/tokens/color_token.dart` with `package:mix/mix.dart`.
For partial subtree overrides use `MixScope.inherit`; plain nesting shadows.

## Keep identity and value separate

`MixToken<T>` is abstract. Concrete tokens compare by concrete runtime type and
name: recreating `ColorToken('brand.primary')` addresses the same token, while
different concrete token classes sharing a name remain distinct. Use semantic
names consistently; do not compare tokens only by their displayed names.

```dart
final style = BoxStyler().color(primary()).padding(.all(space()));
final value = primary.resolve(context);
```

`token()` returns an ergonomic deferred reference, not the resolved value.
Use references inside Mix styles; resolve explicitly when a Flutter API needs a
concrete value. A `ContextToken` computes its default from context even without a
scope; a supplied scope value overrides it.

## Choose the correct token shape

| Token | Value |
|---|---|
| `ColorToken` | `Color` |
| `SpaceToken`, `DoubleToken` | `double` |
| `RadiusToken` | `Radius` |
| `TextStyleToken` | `TextStyle` |
| `BreakpointToken` | `Breakpoint` |
| `BorderSideToken` | `BorderSide` |
| `FontWeightToken` | `FontWeight` |
| `DurationToken` | `Duration` |
| `ShadowToken` | `List<Shadow>` |
| `BoxShadowToken` | `List<BoxShadow>` |

For text style composition, use `textToken.mix()` where the API expects a
`TextStyleMix`; `textToken()` returns the Flutter-shaped reference.
For arbitrary custom values, implement a `MixToken<T>` subclass and resolve it
directly or wrap it in `Prop.token(token)` at an explicit Prop boundary.

## Shadows are list-based

Replace single shadow values with lists, even when there is only one:

```dart
const cardShadow = BoxShadowToken('shadow.card');

MixScope(
  boxShadows: {
    cardShadow: const [BoxShadow(blurRadius: 8, offset: Offset(0, 4))],
  },
  child: MyApp(),
);
```

The same rule applies to `ShadowToken` and `List<Shadow>`.

## Custom token references are bounded

The reference dispatcher supports the built-in value shapes above. A custom
subclass works with inherited `call()` only when `T` has a supported reference
shape. Unsupported types throw `UnsupportedError`; they do not magically become
a generic `Prop<T>`. Custom `call()` implementations must supply a compatible
reference shape themselves.

Direct resolution and explicit `Prop.token(customToken)` do not need the
Flutter-shaped call shim. Keep custom values out of APIs that cannot represent
them.

## Double references are sentinels

`SpaceToken` and `DoubleToken` use an erased extension type backed by a
registered negative nano-double. `Prop.value` recognizes the sentinel and
recovers its token source. These numbers are reserved internals: arithmetic on
a reference before resolution is not arithmetic on the eventual token value,
and a plain number equal to a registered sentinel is indistinguishable at
runtime. Ordinary unregistered numbers remain values.

Use an explicit Prop when the boundary permits it:

```dart
final Prop<double> spacing = Prop.token(space);
```

## Replace convenience setters separately

Token migration does not require old styling spellings. Prefer:

```dart
BoxStyler().padding(.all(space())).color(primary());
TextStyler().style(const TextStyleToken('text.body').mix());
```

For deprecated spacing, border, constraint and shadow setters, see the
[retired-convenience table](../../../skills/mix/references/styler-api-policy.md#retired-conveniences).
Nullable inputs and directional sides need care; the table records fallback
and ordering rules rather than assuming every replacement is one setter.

## Verify the boundary

Pump a scope with known token values, resolve the styled widget below it, and
assert the resulting spec. Exercise subtree overrides and any custom token
shape. Missing ordinary tokens and type mismatches should surface as errors.
See the [testing reference](../../../skills/mix/references/testing.md).
