<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/btwld/mix/main/assets/dark.svg">
  <img alt="Mix logo" src="https://raw.githubusercontent.com/btwld/mix/main/assets/light.svg">
</picture>

![GitHub stars](https://img.shields.io/github/stars/btwld/mix?style=for-the-badge&logo=GitHub&logoColor=black&labelColor=white&color=dddddd)
[![Pub Version](https://img.shields.io/pub/v/mix?label=version&style=for-the-badge)](https://pub.dev/packages/mix/changelog)
![Pub Likes](https://img.shields.io/pub/likes/mix?label=Pub%20Likes&style=for-the-badge)
![Pub Points](https://img.shields.io/pub/points/mix?label=Pub%20Points&style=for-the-badge)
[![MIT Licence](https://img.shields.io/github/license/btwld/mix?style=for-the-badge&longCache=true)](https://opensource.org/license/mit)
[![Awesome Flutter](https://img.shields.io/badge/awesome-flutter-purple?longCache=true&style=for-the-badge)](https://github.com/Solido/awesome-flutter)

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

## Getting Started

### Prerequisites

- **Dart SDK**: 3.12.0 or higher
- **Flutter**: 3.44.0 or higher

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
    .border(.color(Colors.black).width(1).style(.solid));

Box(
  style: cardStyle,
  child: StyledText(
    'Hello Mix',
    style: TextStyler().color(Colors.white).fontSize(18),
  ),
);
```

## Understanding the Styler Pattern

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

Define styles with a fluent, chainable API. Style composition and override are supported — later attributes override earlier ones when chained:

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

[Styling guide →](https://www.fluttermix.com/documentation/mix/guides/styling)

### Wrapping Layouts

`WrapBox` combines Box chrome with Flutter's run-based `Wrap` layout. Its Wrap
fields are available directly on `WrapBoxStyler`:

```dart
final tagCloud = WrapBoxStyler()
    .paddingAll(16)
    .spacing(8)
    .runSpacing(10)
    .wrapAlignment(WrapAlignment.center);

WrapBox(style: tagCloud, children: tags);
```

On the composite styler, `alignment` and `clipBehavior` configure the outer
Box; `wrapAlignment` and `wrapClipBehavior` configure the inner Wrap. Use
`.flow(WrapStyler(...))` when direct nested-style composition is needed. See
the runnable [WrapBox example](example/docs/layouts.md).

### Grid Layouts

`GridBox` uses fixed and fractional columns plus vertical auto rows, and can
adapt to the width offered by its own parent. Dot shorthand keeps nested track
and breakpoint declarations compact. Omit `autoRows` (or set `.autoRows(.auto())`)
when row height should follow the tallest child:

```dart
final GridBoxStyler dashboardGrid = .equalColumns(3)
    .gap(16)
    .onConstraints(
  .maxWidth(720),
  .equalColumns(1).gap(12),
);

GridBox(style: dashboardGrid, children: panels);
```

`onConstraints` observes local Grid constraints; `onBreakpoint` continues to
observe the viewport. Compatible track, row, and gap changes can use Mix's
implicit `animate` API. See the [Grid layout guide](doc/grid-layout.md) and the
runnable [Grid examples](example/docs/layouts.md).

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

[Dynamic styling guide →](https://www.fluttermix.com/documentation/mix/guides/dynamic-styling)

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

[Design tokens guide →](https://www.fluttermix.com/documentation/mix/guides/design-token)

### Animations

- **Implicit** — Values animate smoothly with `.animate(AnimationConfig....)`
- **Phase** — Multi-step flows (e.g. tap → compress → expand) with `.phaseAnimation(...)`
- **Keyframe** — Full control with tracks and keyframes

[Animations guide →](https://www.fluttermix.com/documentation/mix/guides/animations)

### Widget Modifiers

Some visual effects — opacity, clipping, visibility — aren't style properties. Modifiers let you declare widget wrappers inside your style so they stay composable and animatable.

[Widget modifiers guide →](https://www.fluttermix.com/documentation/mix/guides/widget-modifiers)

### Directives

Directives transform values (text casing, number scaling, color adjustments) at resolve time, keeping transformations inside the style so they survive merging.

[Directives guide →](https://www.fluttermix.com/documentation/mix/guides/directives)

### Utility-First Approach

Stylers expose small, composable utilities you combine. The API follows Flutter naming so it stays familiar:

```dart
BoxStyler()
    .paddingAll(20)
    .paddingX(16)
    .paddingY(8)
    .border(.color(Colors.red));
```

[Utility-first overview →](https://www.fluttermix.com/documentation/mix/overview/utility-first)

## Ecosystem

| Package | Description |
|---------|-------------|
| [mix_annotations](https://pub.dev/packages/mix_annotations) | Annotations for code generation |
| [mix_generator](https://pub.dev/packages/mix_generator) | build_runner generator for specs |
| [mix_lint](https://pub.dev/packages/mix_lint) | Custom linter rules |
| [mix_winds](https://pub.dev/packages/mix_winds) | Utility-first styling inspired by Tailwind CSS |

## Documentation

- [Introduction](https://www.fluttermix.com/documentation/mix/overview/introduction)
- [Getting started](https://www.fluttermix.com/documentation/mix/overview/getting-started)
- [Styling](https://www.fluttermix.com/documentation/mix/guides/styling)
- [Dynamic styling](https://www.fluttermix.com/documentation/mix/guides/dynamic-styling)
- [Design tokens](https://www.fluttermix.com/documentation/mix/guides/design-token)
- [Animations](https://www.fluttermix.com/documentation/mix/guides/animations)
- [Widget modifiers](https://www.fluttermix.com/documentation/mix/guides/widget-modifiers)
- [Directives](https://www.fluttermix.com/documentation/mix/guides/directives)
- [Widgets](https://www.fluttermix.com/documentation/mix/widgets/box) (Box, Text, Icon, FlexBox, WrapBox, GridBox, StackBox, etc.)

## Contributors

<a href="https://github.com/btwld/mix/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=btwld/mix" />
</a>
