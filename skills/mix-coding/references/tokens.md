# Tokens and Theming Reference

Use Mix tokens for semantic values that should change by theme, brand,
platform, or scope. Tokens are provided by `MixScope` and consumed through
Stylers.

## Define Tokens

```dart
final $primary = ColorToken('color.primary');
final $surface = ColorToken('color.surface');
final $onSurface = ColorToken('color.on_surface');
final $spaceMd = SpaceToken('space.md');
final $radiusMd = RadiusToken('radius.md');
final $heading = TextStyleToken('text.heading');
```

Use stable semantic names rather than raw visual names when possible.

## Provide Tokens with MixScope

```dart
MixScope(
  colors: {
    $primary: Colors.blue,
    $surface: Colors.white,
    $onSurface: Colors.black,
  },
  spaces: {
    $spaceMd: 16,
  },
  radii: {
    $radiusMd: const Radius.circular(12),
  },
  textStyles: {
    $heading: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  },
  child: child,
);
```

You can also use the generic `tokens:` map:

```dart
MixScope(
  tokens: {
    $primary: Colors.blue,
    $spaceMd: 16.0,
  },
  child: child,
);
```

## Use Tokens in Styles

Call the token to create a style reference.

```dart
final cardStyle = BoxStyler()
    .color($surface())
    .paddingAll($spaceMd())
    .borderRadiusAll($radiusMd());

final titleStyle = TextStyler()
    .style($heading.mix())
    .color($onSurface());
```

Resolve tokens only when you need concrete Flutter values outside a Mix style:

```dart
final primaryColor = $primary.resolve(context);
```

## Built-in Token Types

| Token | Value type | Notes |
|---|---|---|
| `ColorToken` | `Color` | background, foreground, border colors |
| `SpaceToken` | `double` | spacing and sizing; call returns a `DoubleRef` |
| `DoubleToken` | `double` | generic numeric values; call returns a `DoubleRef` |
| `RadiusToken` | `Radius` | corner radius values |
| `TextStyleToken` | `TextStyle` | use `.mix()` for `TextStyler.style(...)` |
| `BorderSideToken` | `BorderSide` | border side values |
| `ShadowToken` | `List<Shadow>` | text/icon shadow lists |
| `BoxShadowToken` | `List<BoxShadow>` | box shadow lists |
| `FontWeightToken` | `FontWeight` | font weight values |
| `DurationToken` | `Duration` | animation timing |
| `BreakpointToken` | `Breakpoint` | responsive variants |

`ShadowToken` and `BoxShadowToken` are list-based in current source. Their
`.mix()` methods return list mix refs for APIs that accept `ShadowListMix` or
`BoxShadowListMix`.

## Shadow Tokens

When an API needs `List<BoxShadowMix>`, resolve a `BoxShadowToken` and convert values.

```dart
final $cardShadow = BoxShadowToken('shadow.card');

final shadowStyle = BoxStyler().shadows(
  $cardShadow.resolve(context).map(BoxShadowMix.value).toList(),
);
```

For common app code, a direct style is often simpler:

```dart
final cardStyle = BoxStyler().shadow(
  .color(Colors.black26).offset(y: 4).blurRadius(12),
);
```

## Theme Organization

Group related tokens in files and provide values near app root.

```dart
class AppTokens {
  static const primary = ColorToken('color.primary');
  static const surface = ColorToken('color.surface');
  static const spaceMd = SpaceToken('space.md');
}

final lightTokens = <MixToken, Object>{
  AppTokens.primary: Colors.blue,
  AppTokens.surface: Colors.white,
  AppTokens.spaceMd: 16.0,
};
```

Then scope them:

```dart
MixScope(
  tokens: lightTokens,
  child: const App(),
);
```

## Source Files

- `packages/mix/lib/src/theme/mix_theme.dart`
- `packages/mix/lib/src/theme/tokens/mix_token.dart`
- `packages/mix/lib/src/theme/tokens/value_tokens.dart`
- `packages/mix/lib/src/theme/tokens/token_refs.dart`
- `packages/mix/doc/mix-scope-and-theming.md`
- `packages/mix/doc/token-migration-guide.md`
- `packages/mix/test/src/theme/tokens/shadow_list_token_integration_test.dart`
