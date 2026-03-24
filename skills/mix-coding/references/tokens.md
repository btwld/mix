# Design Tokens Reference

Design tokens centralize visual properties (colors, spacing, typography) so styles reference semantic names instead of hardcoded values. Swap token values to switch themes.

## Patterns

### Define Tokens

```dart
import 'package:mix/mix.dart';

// Color tokens
final $primary = ColorToken('primary');
final $surface = ColorToken('surface');
final $onPrimary = ColorToken('on.primary');
final $onSurface = ColorToken('on.surface');

// Spacing tokens
final $spaceSm = SpaceToken('space.sm');
final $spaceMd = SpaceToken('space.md');
final $spaceLg = SpaceToken('space.lg');

// Radius tokens
final $radiusSm = RadiusToken('radius.sm');
final $radiusMd = RadiusToken('radius.md');
```

### Provide Token Values with MixScope

`MixScope` provides token values to all descendant widgets, similar to Flutter's `Theme`:

```dart
MixScope(
  colors: {
    $primary: Colors.blue,
    $surface: Colors.white,
    $onPrimary: Colors.white,
    $onSurface: Colors.black,
  },
  spaces: {
    $spaceSm: 8.0,
    $spaceMd: 16.0,
    $spaceLg: 24.0,
  },
  radii: {
    $radiusSm: Radius.circular(4),
    $radiusMd: Radius.circular(8),
  },
  child: MyApp(),
);
```

### Use Tokens in Styles

Use the call syntax `$token()` to reference a token in a style:

```dart
final style = BoxStyler()
    .color($primary())
    .paddingAll($spaceMd())
    .borderRadiusAll($radiusMd());
```

### Use Token Mix Reference

For `TextStyleToken`, use `.mix()` to get a `TextStyleMix`:

```dart
final $heading = TextStyleToken('heading');

// Provide the value
MixScope(
  textStyles: {
    $heading: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  },
  child: app,
);

// Use in a style
final style = TextStyler.style($heading.mix()).color($onSurface());
```

### Resolve Tokens Programmatically

Use `.resolve(context)` to get the concrete value outside of styles:

```dart
@override
Widget build(BuildContext context) {
  final primaryColor = $primary.resolve(context);
  final spacing = $spaceMd.resolve(context);
  // Use with Flutter widgets if needed
}
```

---

## Theme Switching

Define separate token maps and swap them:

```dart
final lightColors = {
  $primary: Colors.blue,
  $surface: Colors.white,
  $onSurface: Colors.black,
};

final darkColors = {
  $primary: Color(0xFF617AFA),
  $surface: Color(0xFF1C1C21),
  $onSurface: Colors.white,
};

class ThemedApp extends StatefulWidget { ... }

class _ThemedAppState extends State<ThemedApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MixScope(
      colors: isDark ? darkColors : lightColors,
      child: MaterialApp(home: MyPage()),
    );
  }
}
```

### Enum-Based Tokens

For organized token management, use enums:

```dart
enum AppColor {
  primary('primary'),
  onPrimary('on-primary'),
  surface('surface'),
  onSurface('on-surface');

  final String name;
  const AppColor(this.name);
  ColorToken get token => ColorToken(name);
}

// Usage
final style = BoxStyler().color(AppColor.primary.token());
```

### Theme Classes

Group token maps into theme classes:

```dart
class LightTheme {
  static Map<ColorToken, Color> get colors => {
    AppColor.primary.token: Colors.blue,
    AppColor.surface.token: Colors.white,
  };

  static Map<SpaceToken, double> get spaces => {
    $spaceMd: 16.0,
    $spaceLg: 24.0,
  };
}

// Apply
MixScope(
  colors: LightTheme.colors,
  spaces: LightTheme.spaces,
  child: app,
);
```

---

## Built-in Token Types

| Token Class | Value Type | Use Case |
|-------------|-----------|----------|
| `ColorToken` | `Color` | Colors and backgrounds |
| `SpaceToken` | `double` | Spacing (padding, margin) |
| `DoubleToken` | `double` | Any numeric value |
| `RadiusToken` | `Radius` | Border radii |
| `TextStyleToken` | `TextStyle` | Typography styles |
| `BorderSideToken` | `BorderSide` | Border definitions |
| `ShadowToken` | `List<Shadow>` | Text shadows |
| `BoxShadowToken` | `List<BoxShadow>` | Box shadows |
| `FontWeightToken` | `FontWeight` | Font weights |
| `DurationToken` | `Duration` | Animation durations |
| `BreakpointToken` | `Breakpoint` | Responsive breakpoints |

## MixScope Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `colors` | `Map<ColorToken, Color>` | Color token values |
| `spaces` | `Map<SpaceToken, double>` | Space token values |
| `radii` | `Map<RadiusToken, Radius>` | Radius token values |
| `textStyles` | `Map<TextStyleToken, TextStyle>` | Text style token values |
| `tokens` | `Map<MixToken, dynamic>` | Generic/custom tokens |
| `child` | `Widget` | Child widget tree |

---

## Best Practices

- Use descriptive, hierarchical names: `$colorPrimary`, `$spacingMd`
- Group related tokens in separate files (`tokens/colors.dart`, `tokens/spacing.dart`)
- Replace hardcoded values with semantic tokens for consistency
- Define tokens as top-level `final` variables
- Use enums for structured token sets in larger apps

---

## Source Files

- `examples/lib/components/tokens.dart` — Simple token definitions
- `examples/lib/docs/tutorials/theming.dart` — Full theming tutorial with theme switching
- `website/src/content/documentation/guides/design-token.mdx` — Complete token documentation
