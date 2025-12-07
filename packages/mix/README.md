<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/leoafarias/mix/main/assets/dark.svg">
  <img alt="Mix logo" src="https://raw.githubusercontent.com/leoafarias/mix/main/assets/light.svg">
</picture>

![GitHub stars](https://img.shields.io/github/stars/btwld/mix?style=for-the-badge&logo=GitHub&logoColor=black&labelColor=white&color=dddddd)
[![Pub Version](https://img.shields.io/pub/v/mix?label=version&style=for-the-badge)](https://pub.dev/packages/mix/changelog)
![Pub Likes](https://img.shields.io/pub/likes/mix?label=Pub%20Likes&style=for-the-badge)
![Pub Points](https://img.shields.io/pub/points/mix?label=Pub%20Points&style=for-the-badge) [![MIT Licence](https://img.shields.io/github/license/leoafarias/mix?style=for-the-badge&longCache=true)](https://opensource.org/licenses/mit-license.php) [![Awesome Flutter](https://img.shields.io/badge/awesome-flutter-purple?longCache=true&style=for-the-badge)](https://github.com/Solido/awesome-flutter)

Mix is a simple and intuitive styling system for Flutter, enabling the creation of beautiful and consistent UIs with ease.

Mix brings industry-proven design system concepts to Flutter. It separates style semantics from widgets while maintaining an easy-to-understand and manageable relationship between them.

-  Easily compose, merge, and apply styles across widgets.
-  Write cleaner, more maintainable styling definitions.
-  Apply styles conditionally based on the BuildContext.

## Why Mix?

Flutter developers often face challenges when it comes to styling widgets and maintaining a consistent look and feel across their apps. Flutter is heavily dependent on the Material Design System and theming, and that can be challenging, especially when creating your own design system.

Mix addresses these challenges by creating a styling system that uses utility functions for a more intuitive and composable way to style. This approach can be kept consistent across widgets and files.

## Goals with Mix

- Define visual properties outside the widget's build method while still allowing access to the BuildContext. This is done by having the style definition resolved during widget build, similar to how the current `Theme.of` works, but with much more flexibility.
- Ensure consistent styling throughout your app. By having separate style definitions, you can reuse not only specific values, like colors and typography, but also entire style definitions across other styles.
- Quickly adapt to changing design requirements. By promoting style composability and inheritance, you can more easily maintain a `DRY` approach to managing your design system.
- Create adaptive designs and layouts by leveraging style variants, which are based on existing styles but can be applied conditionally or responsively.
- Type-safe composability. Mix leverages the power of Dart's type system and class to create a type-safe styling experience.

## Guiding Principles

-  **Simple Abstraction**: A low-cost layer over the Flutter API, letting you style widgets without altering their core behavior, ensuring they remain compatible and predictable.
-  **Consistent**: Even though we are creating a new styling system, we should always keep the styling API consistent with its Flutter equivalents.
-  **Composable**: Styles should be easily composable by combining simple, reusable elements, promoting code reuse and maintainability.
-  **Extensible**: Mix should allow for reasonable overrides and reuse of its utilities, making it easy to fit your own needs.

## Key Features

### **Powerful Styling API**:

Styles are easily defined using Styler classes like `BoxStyler` and `TextStyler`, which provide a fluent, chainable API for defining style properties:

```dart
final cardStyle = BoxStyler()
    .height(100)
    .width(240)
    .color(Colors.purple)
    .borderRounded(12)
    .paddingAll(16);

// Apply the style to a Box widget
Box(
  style: cardStyle,
  child: StyledText(
    'Hello Mix',
    style: TextStyler().color(Colors.white).fontSize(18),
  ),
);
```

Learn more about [styling](https://fluttermix.com/docs/guides/styling)

### **BuildContext Responsive Styling**:

Mix allows you to define styles that are context-aware, applying styles conditionally based on the BuildContext.

```dart
final style = BoxStyler()
    .color(Colors.black)
    .onDark(BoxStyler().color(Colors.white))
    .onLight(BoxStyler().color(Colors.black));
```

Learn more about [dynamic styling](https://fluttermix.com/docs/guides/dynamic-styling)

### **Design Tokens and Theming**:

Mix goes beyond the Material `Theme` definitions by allowing the definition of design tokens and properties that can be used across all styling utilities.

### **Utility-First Approach**:

A complete set of utility primitives allows you to define styling properties and values in a more intuitive and composable way.

```dart
BoxStyler()
    .paddingAll(20)           // Padding 20 on all sides
    .paddingX(16)             // Padding 16 on left and right
    .paddingY(8)              // Padding 8 on top and bottom
    .paddingTop(20)           // Padding 20 on top
    .paddingLeft(20);         // Padding 20 on left
```

Learn more about [utilities](https://fluttermix.com/docs/overview/utility-first)

## Contributors

<a href="https://github.com/btwld/mix/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=btwld/mix" />
</a>
