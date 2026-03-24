<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/leoafarias/mix/main/assets/dark.svg">
  <img alt="Mix logo" src="https://raw.githubusercontent.com/leoafarias/mix/main/assets/light.svg">
</picture>

![GitHub stars](https://img.shields.io/github/stars/btwld/mix?style=for-the-badge&logo=GitHub&logoColor=black&labelColor=white&color=dddddd)
[![Pub Version](https://img.shields.io/pub/v/mix?label=version&style=for-the-badge)](https://pub.dev/packages/mix/changelog)
![Pub Likes](https://img.shields.io/pub/likes/mix?label=Pub%20Likes&style=for-the-badge)
![Pub Points](https://img.shields.io/pub/points/mix?label=Pub%20Points&style=for-the-badge)
[![MIT Licence](https://img.shields.io/github/license/leoafarias/mix?style=for-the-badge&longCache=true)](https://opensource.org/licenses/mit-license.php)
[![Awesome Flutter](https://img.shields.io/badge/awesome-flutter-purple?longCache=true&style=for-the-badge)](https://github.com/Solido/awesome-flutter)

**Mix** is a styling system for Flutter that separates style definitions from widget structure. It provides a composable, type-safe way to define and apply styles.

- Compose, merge, and apply styles across widgets
- Write maintainable styling definitions separate from widget code
- Apply styles conditionally based on `BuildContext`

## Why Mix?

Mix provides utility functions for intuitive, composable styling that stays consistent across widgets and files—without being tied to Material Design.

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

## Understanding the Styler Pattern

Mix provides two constructor patterns for Styler classes:

### Fluent API: `BoxStyler()`

The default constructor gives you a chainable API:

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .paddingAll(16)
    .borderRounded(8);
```

Use this when defining styles with direct values and chaining properties.

### Prop-Based API: `BoxStyler.create()`

The `.create()` constructor accepts `Prop<T>` for advanced composition (tokens, directives):

```dart
final style = BoxStyler.create(
  color: Prop.token($primaryColor),
  padding: Prop.value(EdgeInsets.all(16)),
);
```

Use this when working with design tokens or number directives like `multiply()` or `clamp()`.

## Key Features

### Styling API

Define styles with a fluent, chainable API. Style composition and override are supported—later attributes override earlier ones when chained:

```dart
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

final boxStyle = BoxStyler()
    .height(100)
    .width(100)
    .color(Colors.purple)
    .borderRounded(10);

final textStyle = TextStyler()
    .fontSize(20)
    .fontWeight(.bold)
    .color(Colors.black);

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

Styles adapt to interactions and context (hover, press, dark mode, breakpoints) in one place:

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

- **Implicit** — Values (state or variants) animate smoothly with `.animate(AnimationConfig....)`
- **Phase** — Multi-step flows (e.g. tap → compress → expand) with `.phaseAnimation(...)`
- **Keyframe** — Full control with tracks and keyframes

[Animations guide →](https://fluttermix.com/docs/guides/animations)

### Utility-First Approach

Stylers expose small, composable utilities you combine (e.g. `color`, `border`, `padding`, `borderRadius`). The API follows Flutter naming so it stays familiar:

```dart
BoxStyler()
    .paddingAll(20)
    .paddingX(16)
    .paddingY(8)
    .borderAll(color: Colors.red);
```

[Utility-first overview →](https://fluttermix.com/docs/overview/utility-first)

## Getting Started

### Prerequisites

- **Dart SDK**: 3.11.0 or higher
- **Flutter**: Latest stable recommended

### Installation

```bash
flutter pub add mix --pre-release
```

Or in `pubspec.yaml`:

```yaml
dependencies:
  mix: <latest>
```

```dart
import 'package:mix/mix.dart';
```

### First widget

```dart
final cardStyle = BoxStyler()
    .height(100)
    .width(240)
    .color(Colors.blue)
    .borderRounded(12)
    .borderAll(color: Colors.black, width: 1, style: orderStyle.solid);

Box(
  style: cardStyle,
  child: StyledText(
    'Hello Mix',
    style: TextStyler().color(Colors.white).fontSize(18),
  ),
);
```

[Getting started →](https://fluttermix.com/docs/overview/getting-started)

## Documentation

- [Introduction](https://fluttermix.com/docs/overview/introduction)
- [Getting started](https://fluttermix.com/docs/overview/getting-started)
- [Styling](https://fluttermix.com/docs/guides/styling)
- [Dynamic styling](https://fluttermix.com/docs/guides/dynamic-styling)
- [Design tokens](https://fluttermix.com/docs/guides/design-token)
- [Animations](https://fluttermix.com/docs/guides/animations)
- [Widgets](https://fluttermix.com/docs/widgets/box) (Box, Text, Icon, Flexbox, Stack, etc.)
- [Best practices](https://fluttermix.com/docs/overview/best-practices)

## Contributors

<a href="https://github.com/btwld/mix/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=btwld/mix" />
</a>
