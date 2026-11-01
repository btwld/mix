# Design tokens

`MixToken<T>` names a value; `MixScope` supplies values to descendants. Ordinary
tokens using `MixToken`'s default equality compare by concrete runtime type and
name, so different concrete classes with the same name remain distinct.

`ContextToken<T>` instead compares the value type `T` and resolver identity.
All context tokens have the name `context`; different resolver closures stay
unequal despite that shared name. Declare context tokens as top-level or static
finals, or reuse a stable top-level or static resolver with the same value type
when recreating them, so scope overrides match the tokens used by consumers.

## Declare, provide, reference

```dart
const primary = ColorToken('brand.primary');
const space = SpaceToken('space.md');

MixScope(
  colors: {primary: Colors.blue},
  spaces: {space: 16.0},
  child: MyApp(),
);

final style = BoxStyler().color(primary()).padding(.all(space()));
```

Calling a token creates a deferred reference. Use `primary.resolve(context)`
when a concrete value is needed. For text Mix composition use
`textToken.mix()`; `textToken()` returns a Flutter-shaped reference.

## Shapes and maps

| Token | Value / scope map |
|---|---|
| `ColorToken` | `Color` / `colors:` |
| `SpaceToken`, `DoubleToken` | `double` / `spaces:`, `doubles:` |
| `RadiusToken` | `Radius` / `radii:` |
| `TextStyleToken` | `TextStyle` / `textStyles:` |
| `BorderSideToken` | `BorderSide` / `borders:` |
| `ShadowToken`, `BoxShadowToken` | Lists / `shadows:`, `boxShadows:` |
| `FontWeightToken` | `FontWeight` / `fontWeights:` |
| `BreakpointToken` | `Breakpoint` / `breakpoints:` |
| `DurationToken`, custom tokens | Generic `tokens:` map |

Ordinary tokens need a matching scope value. `ContextToken` can compute its
fallback from context without a scope; a scope entry overrides it. Canonical
breakpoint tokens also provide defaults.

A plain nested scope shadows ancestor values. `MixScope.inherit(...)` merges
partial overrides; `MixScope.combine(scopes: [...], child: ...)` merges explicit
scopes left to right. `withMaterial(...)` reads the surrounding `Theme` and adds
explicit overrides; place it below the theme it should use.

`MixScope.of(context, 'tokens')` registers token-aspect dependency;
`MixScope.maybeOf` permits no scope. Missing ordinary tokens and wrong value
types fail; do not treat every missing token as a context default.

## Custom values and reference limits

Subclass abstract `MixToken<T>` for a custom value type. Supply it with
`tokens:` and use `token.resolve(context)` or explicit `Prop.token(token)`.
Inherited `call()` supports only known reference shapes; unsupported `T` throws
`UnsupportedError`, not a generic Prop fallback. Override it only with a
compatible reference implementation.

Double references use registered sentinels recognized by `Prop.value`; do not
perform ordinary arithmetic on them before resolution. Use an explicit Prop
when the API accepts it. Shadow tokens take lists, even for a single shadow.

For repo migration detail, see
[Token migration](https://github.com/btwld/mix/blob/main/packages/mix/doc/token-migration-guide.md).
