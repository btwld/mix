<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/leoafarias/mix/main/assets/dark.svg">
  <img alt="Mix logo" src="https://raw.githubusercontent.com/leoafarias/mix/main/assets/light.svg">
</picture>

![GitHub stars](https://img.shields.io/github/stars/btwld/mix?style=for-the-badge&logo=GitHub&logoColor=black&labelColor=white&color=dddddd)
[![Pub Version](https://img.shields.io/pub/v/mix?label=version&style=for-the-badge)](https://pub.dev/packages/mix/changelog)
![Pub Likes](https://img.shields.io/pub/likes/mix?label=Pub%20Likes&style=for-the-badge)
![Pub Points](https://img.shields.io/pub/points/mix?label=Pub%20Points&style=for-the-badge) [![MIT Licence](https://img.shields.io/github/license/leoafarias/mix?style=for-the-badge&longCache=true)](https://opensource.org/licenses/mit-license.php) [![Awesome Flutter](https://img.shields.io/badge/awesome-flutter-purple?longCache=true&style=for-the-badge)](https://github.com/Solido/awesome-flutter)

**Mix** is a styling system for Flutter that separates style definitions from widget structure. It provides a composable, type-safe way to define and apply styles using a fluent API, design tokens, and context-aware variants.

- Compose, merge, and apply styles across widgets
- Write maintainable styling definitions separate from widget code
- Adapt styles conditionally based on interactions and context

## Why Mix?

Flutter's built-in styling works well for simple widgets, but as your app grows, common pain points emerge:

- **Style duplication**: The same colors, spacing, and borders are repeated across widgets with no easy way to share them.
- **Tight coupling**: Style logic lives inside `build()` methods, making it hard to reuse or test independently.
- **No conditional styling**: Adapting styles for hover, press, dark mode, or breakpoints requires manual boilerplate.

Mix solves these by giving you a dedicated styling layer that stays consistent across widgets and files — without being tied to Material Design.

## Goals

- **Define styles outside widgets** while retaining `BuildContext` access (resolved at build time, like `Theme.of`, with more flexibility)
- **Reuse style definitions** across your app for consistency
- **Adapt styles conditionally** using variants (hover, dark mode, breakpoints)
- **Type-safe composability** using Dart's type system

## Guiding Principles

- **Simple** — Thin layer over Flutter; widgets remain compatible and predictable
- **Consistent** — API mirrors Flutter naming conventions
- **Composable** — Build complex styles from simple, reusable pieces
- **Extensible** — Override and extend utilities to fit your needs

## Quick Start

### Prerequisites

- **Dart SDK**: 3.11.0 or higher
- **Flutter**: 3.41.0 or higher

### Installation

```bash
flutter pub add mix
```

Or in `pubspec.yaml`:

```yaml
dependencies:
  mix: <latest>
```

```dart
import 'package:mix/mix.dart';
```

### First Widget

```dart
final cardStyle = BoxStyler()
    .size(240, 100)
    .color(Colors.blue)
    .alignment(.center)
    .borderRounded(12)
    .border(.all(.color(Colors.black).width(1).style(.solid)));

Box(
  style: cardStyle,
  child: StyledText(
    'Hello Mix',
    style: TextStyler().color(Colors.white).fontSize(18),
  ),
);
```

## Key Features

### Styling API

Define styles with a fluent, chainable API. Later attributes override earlier ones when chained:

```dart
final boxStyle = BoxStyler()
    .height(100)
    .width(100)
    .color(Colors.purple)
    .borderRounded(10);

// Compose from a base style
final base = BoxStyler()
    .paddingX(16)
    .paddingY(8)
    .borderRounded(8)
    .color(Colors.black);
final solid = base.color(Colors.blue);
```

[Styling guide →](https://fluttermix.com/docs/guides/styling)

### Dynamic Styling (Variants)

Styles adapt to interactions and context in one place:

```dart
final buttonStyle = BoxStyler()
    .height(50)
    .borderRounded(25)
    .color(Colors.blue)
    .onHovered(.color(Colors.blue.shade700))
    .onDark(.color(Colors.blue.shade200));
```

Built-in variants include `onHovered`, `onPressed`, `onFocused`, `onDisabled`, `onDark`, `onLight`, `onBreakpoint`, `onMobile`, `onTablet`, `onDesktop`, and platform/context variants.

[Dynamic styling guide →](https://fluttermix.com/docs/guides/dynamic-styling)

### Design Tokens and Theming

Define reusable tokens and provide them via `MixScope`:

```dart
final $primary = ColorToken('primary');
final $spacingMd = SpaceToken('spacing.md');

MixScope(
  colors: { $primary: Colors.blue },
  spaces: { $spacingMd: 16.0 },
  child: MyApp(),
);

final style = BoxStyler()
    .color($primary())
    .paddingAll($spacingMd());
```

[Design tokens guide →](https://fluttermix.com/docs/guides/design-token)

### Animations

- **Implicit** — Values animate smoothly with `.animate(AnimationConfig....)`
- **Phase** — Multi-step flows (e.g. tap → compress → expand) with `.phaseAnimation(...)`
- **Keyframe** — Full control with tracks and keyframes

[Animations guide →](https://fluttermix.com/docs/guides/animations)

### Widget Modifiers

Some visual effects — opacity, clipping, visibility — aren't style properties. Modifiers let you declare widget wrappers inside your style so they stay composable and animatable.

[Widget modifiers guide →](https://fluttermix.com/docs/guides/widget-modifiers)

### Directives

Directives transform values (text casing, number scaling, color adjustments) at resolve time, keeping transformations inside the style so they survive merging.

[Directives guide →](https://fluttermix.com/docs/guides/directives)

## Packages

| Package | Description |
|---------|-------------|
| [mix](packages/mix) | Core styling framework |
| [mix_annotations](packages/mix_annotations) | Annotations for code generation |
| [mix_generator](packages/mix_generator) | build_runner generator for specs |
| [mix_lint](packages/mix_lint) | Custom linter rules |
| [mix_tailwinds](packages/mix_tailwinds) | Utility-first styling inspired by Tailwind CSS |

## Documentation

- [Introduction](https://fluttermix.com/docs/overview/introduction)
- [Getting started](https://fluttermix.com/docs/overview/getting-started)
- [Styling](https://fluttermix.com/docs/guides/styling)
- [Dynamic styling](https://fluttermix.com/docs/guides/dynamic-styling)
- [Design tokens](https://fluttermix.com/docs/guides/design-token)
- [Animations](https://fluttermix.com/docs/guides/animations)
- [Widgets](https://fluttermix.com/docs/widgets/box) (Box, Text, Icon, FlexBox, Stack, etc.)
- [Ecosystem](https://fluttermix.com/docs/ecosystem/mix-tailwinds)

## Contributors

<a href="https://github.com/btwld/mix/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=btwld/mix" />
</a>
