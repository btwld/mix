# Mix Examples

This directory contains comprehensive examples demonstrating the features and capabilities of the Mix framework for Flutter.

## Overview

Mix is a powerful styling framework for Flutter that provides:
- 🎨 **Type-safe styling** - Catch styling errors at compile time
- 🧩 **Composable properties** - Build complex styles from simple building blocks
- 🎭 **Context variants** - Responsive styling based on state (hover, pressed, etc.)
- 🎯 **Design tokens** - Consistent theming across your app
- ✨ **Smooth animations** - Built-in animation support with various easing curves
- 🔗 **Optimized for Dot Notation** - Clean, chainable syntax using Dart's newest features

### Dot Notation Syntax

Mix 2.0 is designed to take full advantage of Dart's modern syntax features. The framework uses Styler classes with a fluent, chainable API that makes styling intuitive and readable:

```dart
// Mix 2.0 Styler API with dot notation
final style = BoxStyler()
    .color(Colors.blue)
    .height(100)
    .width(100)
    .borderRounded(10)
    .onHovered(BoxStyler().scale(1.5));
```

The Styler API provides:
- Better IDE support and autocompletion
- Cleaner, more readable code
- Natural chaining without cascade operators
- Consistent syntax across all properties

#### Enabling Dot Notation

To use Mix's dot notation syntax with Dart's experimental dot shorthands, enable the feature in your `analysis_options.yaml`:

```yaml
analyzer:
  enable-experiment:
    - dot-shorthands
```

**Note**: This requires Dart SDK ≥ 3.9.0

## Getting Started with Mix

### Prerequisites

- **Dart SDK**: ≥ 3.9.0 (required for dot notation syntax)
- **Flutter**: Latest stable version

### Setting Up Your Project

```bash
# Create a new Flutter project
flutter create my_mix_app
cd my_mix_app

# Add Mix 2.0 to your dependencies
flutter pub add mix:^2.0.0-dev.1
```

### Enable Dot Notation Syntax

To use Mix's modern dot notation syntax, add this to your `analysis_options.yaml`:

```yaml
analyzer:
  enable-experiment:
    - dot-shorthands
```

This enables cleaner syntax with dot shorthands throughout your Mix code:

```dart
// With dot shorthands enabled, you can write:
BoxStyler()
    .height(100)
    .width(100)
    .color(.blue)  // Dot shorthand for Colors.blue
```

## Running the Examples

### Gallery Mode (Recommended)
Run all examples in an interactive gallery:
```bash
flutter run lib/main.dart
```

### Individual Examples
Each example can also be run standalone:
```bash
# Widget examples
flutter run lib/api/widgets/box/simple_box.dart
flutter run lib/api/widgets/box/gradient_box.dart

# Animation examples
flutter run lib/api/animation/hover_scale_animation.dart
flutter run lib/api/animation/spring_animation.dart
```

## Examples by Category

### 📦 Widget Examples

| File | Description | Key Concepts |
|------|-------------|--------------|
| [`simple_box.dart`](lib/api/widgets/box/simple_box.dart) | Basic styled container | Colors, dimensions, border radius |
| [`gradient_box.dart`](lib/api/widgets/box/gradient_box.dart) | Box with gradient and shadow | Gradients, shadows, advanced styling |
| [`icon_label_chip.dart`](lib/api/widgets/hbox/icon_label_chip.dart) | Horizontal layout chip | HBox, flex properties, gaps |
| [`card_layout.dart`](lib/api/widgets/vbox/card_layout.dart) | Vertical card layout | VBox, alignment, spacing |
| [`layered_boxes.dart`](lib/api/widgets/zbox/layered_boxes.dart) | Stacked layout example | ZBox, layering, positioning |
| [`styled_icon.dart`](lib/api/widgets/icon/styled_icon.dart) | Customized icon | Icon styling, sizes, colors |
| [`styled_text.dart`](lib/api/widgets/text/styled_text.dart) | Typography example | Text styling, fonts, weights |

### 🎬 Animation Examples

| File | Description | Key Concepts |
|------|-------------|--------------|
| [`hover_scale_animation.dart`](lib/api/animation/hover_scale_animation.dart) | Scale on hover | Hover state, transitions |
| [`auto_scale_animation.dart`](lib/api/animation/auto_scale_animation.dart) | Auto-animate on load | Automatic animations |
| [`tap_phase_animation.dart`](lib/api/animation/tap_phase_animation.dart) | Multi-phase tap animation | Phase animations, gestures |
| [`animated_switch.dart`](lib/api/animation/animated_switch.dart) | Toggle switch animation | Complex phase animations |
| [`spring_animation.dart`](lib/api/animation/spring_animation.dart) | Spring physics | Spring curves, physics-based animation |

### 🎭 Context Variants

| File | Description | Key Concepts |
|------|-------------|--------------|
| [`hovered.dart`](lib/api/context_variants/hovered.dart) | Hover state styling | Mouse interaction |
| [`pressed.dart`](lib/api/context_variants/pressed.dart) | Press state styling | Touch feedback |
| [`focused.dart`](lib/api/context_variants/focused.dart) | Focus state styling | Keyboard navigation |
| [`selected.dart`](lib/api/context_variants/selected.dart) | Selection state | Toggleable states |
| [`disabled.dart`](lib/api/context_variants/disabled.dart) | Disabled state | Conditional styling |
| [`on_dark_light.dart`](lib/api/context_variants/on_dark_light.dart) | Theme-aware styling | Dark/light mode support |

### 🎨 Design System

| File | Description | Key Concepts |
|------|-------------|--------------|
| [`theme_tokens.dart`](lib/api/design_tokens/theme_tokens.dart) | Design token usage | Tokens, theming, consistency |

## Code Examples

### Basic Box Styling
```dart
final style = BoxStyler()
    .color(Colors.red)
    .height(100)
    .width(100)
    .borderRounded(10);

Box(style: style);
```

💡 **Note**: The Styler API (`.color()`, `.height()`, etc.) is a key feature of Mix 2.0 that provides a fluent, chainable API for building styles.

### Animation with Hover
```dart
final style = BoxStyler()
    .color(Colors.black)
    .onHovered(BoxStyler().color(Colors.blue).scale(1.5))
    .animate(AnimationConfig.easeInOut(duration: Duration(milliseconds: 300)));
```

### Using Design Tokens
```dart
final $primaryColor = MixToken<Color>('primary');

final style = BoxStyler()
    .color($primaryColor())
    .borderRounded(10);

MixScope(
  tokens: {$primaryColor: Colors.blue},
  child: Box(style: style),
);
```

### Phase Animations
```dart
BoxStyler()
    .phaseAnimation(
      trigger: _isExpanded,
      phases: AnimationPhases.values,
      styleBuilder: (phase, style) => switch (phase) {
        AnimationPhases.initial => style.scale(1),
        AnimationPhases.compress => style.scale(0.75),
        AnimationPhases.expanded => style.scale(1.25),
      },
      configBuilder: (phase) => switch (phase) {
        AnimationPhases.initial => AnimationConfig.decelerate(duration: Duration(milliseconds: 200)),
        AnimationPhases.compress => AnimationConfig.decelerate(duration: Duration(milliseconds: 100)),
        AnimationPhases.expanded => AnimationConfig.bounceOut(duration: Duration(milliseconds: 600)),
      },
    )
```

## Learning Path

1. **Start with widgets** - Understand basic styling with `simple_box.dart`
2. **Explore layouts** - Learn about HBox, VBox, and ZBox
3. **Add interactivity** - Try context variants (hover, press, focus)
4. **Animate** - Progress from simple to complex animations
5. **Build systems** - Use design tokens for consistent theming

## Tips

- Use the gallery mode to explore all examples interactively
- Each example is self-contained and can be studied independently
- Check the source code comments for detailed explanations
- Experiment by modifying the examples to see how Mix responds

## Contributing

When adding new examples:
1. Use descriptive file names (e.g., `rotating_card.dart` not `example1.dart`)
2. Include header comments explaining the example
3. Keep examples focused on demonstrating specific features
4. Update this README with your new example

## Resources

- [Mix Documentation](https://github.com/btwld/mix)
- [Flutter Documentation](https://flutter.dev/docs)
- [Package on pub.dev](https://pub.dev/packages/mix)