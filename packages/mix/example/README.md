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

Mix is designed to take full advantage of Dart's modern syntax features. The framework uses a unique dot notation pattern that makes styling intuitive and readable:

```dart
// Traditional syntax (using cascade notation)
final style = Style(
  $box.height(100)
    ..width(100)
    ..color.blue()
    ..borderRadius(10),
);

// NEW: Dot notation syntax (cleaner and more intuitive)
final style = Style.box(
  .color(Colors.blue)      // Start properties with a dot
  .height(100)
  .width(100)
  .borderRadius(.circular(10))  // Even nested properties use dots
  .onHovered(.scale(1.5))       // Variants also use dot notation
);
```

The dot notation syntax provides:
- Better IDE support and autocompletion
- Cleaner, more readable code
- Natural chaining without cascade operators
- Consistent syntax across all properties

#### Enabling Dot Notation

To use Mix's dot notation syntax, enable the experimental feature in your `analysis_options.yaml`:

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

This enables the cleaner syntax shown throughout these examples:

```dart
// Instead of: $box.height(100)..width(100)
// You can write:
Style.box(
  .height(100)
  .width(100)
  .color(Colors.blue)
)
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
final style = Style.box(
  .color(Colors.red)
  .height(100)
  .width(100)
  .borderRadius(.circular(10))
);

Box(style: style);
```

💡 **Note**: The dot notation (`.color()`, `.height()`, etc.) is a key feature of Mix that provides a fluent, chainable API for building styles.

### Animation with Hover
```dart
final style = Style.box(
  .color(Colors.black)
  .onHovered(.color(Colors.blue).scale(1.5))
  .animate(.easeInOut(300.ms))
);
```

### Using Design Tokens
```dart
final $primaryColor = MixToken<Color>('primary');

final style = Style.box(
  .color($primaryColor())
  .borderRadius(.topLeft($pill()))
);

MixScope(
  tokens: {$primaryColor: Colors.blue},
  child: Box(style: style),
);
```

### Phase Animations
```dart
.phaseAnimation(
  trigger: _isExpanded,
  phases: AnimationPhases.values,
  styleBuilder: (phase, style) => switch (phase) {
    .initial => style.scale(1),
    .compress => style.scale(0.75),
    .expanded => style.scale(1.25),
  },
  configBuilder: (phase) => switch (phase) {
    .initial => .decelerate(200.ms),
    .compress => .decelerate(100.ms),
    .expanded => .bounceOut(600.ms),
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

- [Mix Documentation](https://github.com/conceptadev/mix)
- [Flutter Documentation](https://flutter.dev/docs)
- [Package on pub.dev](https://pub.dev/packages/mix)