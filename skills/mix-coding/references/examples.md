# Examples Reference

Curated code examples organized by complexity. Each example is a complete, runnable snippet.

---

## Basic

### Styled Box

A simple colored box with rounded corners.

```dart
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

class SimpleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = BoxStyler.color(Colors.red)
        .size(100, 100)
        .borderRounded(10);

    return Box(style: style);
  }
}
```

**Concepts:** BoxStyler, fluent chaining, factory constructor
**Source:** `examples/lib/api/widgets/box/simple_box.dart`

### Gradient Box with Shadow

```dart
final style = BoxStyler.height(50)
    .width(100)
    .borderRounded(10)
    .linearGradient(
      colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade200],
      begin: .topLeft,
      end: .bottomRight,
    )
    .shadowOnly(
      color: Colors.deepPurple.shade700,
      offset: Offset(0, 4),
      blurRadius: 10,
    );

Box(style: style);
```

**Concepts:** Gradients, shadows, dot-shorthands
**Source:** `examples/lib/api/widgets/box/gradient_box.dart`

### Styled Text

```dart
final style = TextStyler()
    .fontSize(20)
    .fontWeight(.w700)
    .color(Colors.red)
    .titlecase();

StyledText('hello world', style: style);
```

**Concepts:** TextStyler, text directives, typography
**Source:** `examples/lib/api/widgets/text/styled_text.dart`

### Styled Icon

```dart
final style = IconStyler.size(30).color(Colors.blueAccent);
StyledIcon(icon: Icons.format_paint_rounded, style: style);
```

**Concepts:** IconStyler, factory constructor
**Source:** `examples/lib/api/widgets/icon/styled_icon.dart`

---

## Intermediate

### Interactive Hover Box

A box that changes color on hover:

```dart
class HoverBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.red)
        .size(100, 100)
        .borderRounded(10)
        .onHovered(.color(Colors.blue));

    return style();  // Callable shorthand
  }
}
```

**Concepts:** Variants, onHovered, callable styler
**Source:** `examples/lib/api/context_variants/hovered.dart`

### Pressable Button

```dart
class PressableButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final boxStyle = BoxStyler()
        .color(Colors.blue)
        .paddingX(24)
        .paddingY(12)
        .borderRounded(8)
        .onHovered(.color(Colors.blue.shade700))
        .onPressed(.color(Colors.blue.shade900));

    final textStyle = TextStyler()
        .color(Colors.white)
        .fontSize(16)
        .fontWeight(.bold);

    return PressableBox(
      style: boxStyle,
      onPress: () => print('pressed'),
      child: StyledText('Click Me', style: textStyle),
    );
  }
}
```

**Concepts:** PressableBox, multiple stylers, hover + press variants

### Dark/Light Mode Toggle

```dart
class ThemeToggle extends StatefulWidget { ... }

class _ThemeToggleState extends State<ThemeToggle> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = BoxStyler()
        .height(60)
        .width(60)
        .borderRounded(30)
        .color(Colors.grey.shade200)
        .animate(.easeInOut(600.ms))
        .onDark(.color(Colors.grey.shade800))
        .shadowOnly(
          color: Colors.black.withValues(alpha: 0.1),
          offset: Offset(0, 4),
          blurRadius: 10,
        );

    final iconStyle = IconStyler()
        .color(Colors.grey.shade800)
        .size(28)
        .icon(Icons.dark_mode)
        .animate(.easeInOut(200.ms))
        .onDark(.icon(Icons.light_mode).color(Colors.yellow));

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        platformBrightness: isDark ? .dark : .light,
      ),
      child: PressableBox(
        style: buttonStyle,
        onPress: () => setState(() => isDark = !isDark),
        child: StyledIcon(style: iconStyle),
      ),
    );
  }
}
```

**Concepts:** Dark/light variants, animate, PressableBox, IconStyler
**Source:** `examples/lib/api/context_variants/on_dark_light.dart`

### Horizontal Chip Layout

```dart
final chipStyle = BoxStyler()
    .shapeStadium(side: .new().color(Colors.blue.shade200))
    .color(Colors.blue.shade50)
    .padding(.horizontal(12).vertical(6));

final iconStyle = IconStyler.size(16).color(Colors.blue);
final labelStyle = TextStyler.fontSize(14).color(Colors.blue);

RowBox(
  style: FlexBoxStyler().spacing(8).crossAxisAlignment(.center),
  children: [
    StyledIcon(icon: Icons.check, style: iconStyle),
    StyledText('Complete', style: labelStyle),
  ],
);
```

**Concepts:** RowBox, FlexBoxStyler, shapeStadium, multiple stylers

---

## Advanced

### Animated Toggle with Keyframes

```dart
class AnimatedToggle extends StatefulWidget { ... }

class _AnimatedToggleState extends State<AnimatedToggle> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    final trackStyle = BoxStyler()
        .width(56)
        .height(32)
        .shapeStadium()
        .color(isOn ? Colors.green : Colors.grey.shade300);

    final thumbStyle = BoxStyler()
        .size(24, 24)
        .shapeCircle()
        .color(Colors.white)
        .shadowOnly(blurRadius: 4, color: Colors.black26);

    return GestureDetector(
      onTap: () => setState(() => isOn = !isOn),
      child: Box(
        style: trackStyle,
        child: KeyframeAnimationBuilder(
          duration: 400.ms,
          playing: isOn,
          keyframes: {
            KeyframeTrack<double>(
              property: KeyframeProperty.width,
              keyframes: [
                Keyframe(0.0, 24),
                Keyframe(0.5, 32),  // Stretch
                Keyframe(1.0, 24),
              ],
            ),
            KeyframeTrack<double>(
              property: KeyframeProperty.translateX,
              keyframes: [
                Keyframe(0.0, 0),
                Keyframe(1.0, 24),  // Slide right
              ],
            ),
          },
          builder: (context, animStyle) {
            return Box(style: thumbStyle.merge(animStyle));
          },
        ),
      ),
    );
  }
}
```

**Concepts:** KeyframeAnimationBuilder, multiple tracks, playing toggle
**Source:** `examples/lib/api/animation/keyframe.switch.dart`

### Themed Profile Page with Tokens

```dart
// tokens.dart
final $primary = ColorToken('primary');
final $surface = ColorToken('surface');
final $onSurface = ColorToken('on.surface');
final $heading = TextStyleToken('heading');
final $body = TextStyleToken('body');
final $radiusMd = RadiusToken('radius.md');
final $spaceMd = SpaceToken('space.md');

// theme.dart
final lightTheme = MixScopeConfig(
  colors: {
    $primary: Colors.blue,
    $surface: Colors.white,
    $onSurface: Colors.black,
  },
  textStyles: {
    $heading: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    $body: TextStyle(fontSize: 16),
  },
  radii: {$radiusMd: Radius.circular(12)},
  spaces: {$spaceMd: 16.0},
);

// profile_page.dart
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cardStyle = BoxStyler()
        .color($surface())
        .paddingAll($spaceMd())
        .borderRadiusAll($radiusMd());

    final titleStyle = TextStyler()
        .style($heading.mix())
        .color($onSurface());

    final bodyStyle = TextStyler()
        .style($body.mix())
        .color($onSurface());

    return ColumnBox(
      style: FlexBoxStyler().spacing($spaceMd()).marginAll($spaceMd()),
      children: [
        Box(
          style: cardStyle,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              StyledText('Profile', style: titleStyle),
              StyledText('Welcome back!', style: bodyStyle),
            ],
          ),
        ),
      ],
    );
  }
}
```

**Concepts:** Design tokens, MixScope, TextStyleToken, theme separation
**Source:** `examples/lib/docs/tutorials/theming.dart`

### Custom Context Variant

```dart
// Define variant based on InheritedWidget
class ShiftPressedVariant extends ContextVariant {
  ShiftPressedVariant()
    : super('shift_pressed', (context) {
        return ShiftPressedWidget.of(context)?.isShiftPressed ?? false;
      });
}

// Use in style
final style = BoxStyler()
    .color(Colors.grey)
    .paddingAll(8)
    .shapeStadium()
    .variant(ShiftPressedVariant(), .color(Colors.purple))
    .animate(.ease(300.ms));
```

**Concepts:** Custom ContextVariant, InheritedWidget integration, animate
**Source:** `examples/lib/api/context_variants/custom_context_variant.dart`

---

## Full Example Index

For more examples, browse these directories:
- `examples/lib/api/widgets/box/` — Box styling patterns
- `examples/lib/api/context_variants/` — All variant types
- `examples/lib/api/animation/` — All animation types
- `examples/lib/api/gradient/` — Gradient examples
- `examples/lib/docs/guides/` — Documentation guide examples
- `examples/lib/docs/tutorials/` — Step-by-step tutorials
- `examples/lib/docs/widgets/` — Widget-specific examples
