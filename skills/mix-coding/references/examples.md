# Examples Reference

Use these examples as source-aligned starting points. Adapt names and colors to the user's app.

## Card

```dart
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cardStyle = BoxStyler()
        .color(Colors.white)
        .paddingAll(16)
        .borderRounded(12)
        .shadow(
          .color(Colors.black.withValues(alpha: 0.12))
              .offset(y: 4)
              .blurRadius(12),
        );

    final titleStyle = TextStyler()
        .fontSize(18)
        .fontWeight(.bold)
        .color(Colors.black);

    final subtitleStyle = TextStyler()
        .fontSize(13)
        .color(Colors.grey.shade700);

    return Box(
      style: cardStyle,
      child: ColumnBox(
        style: FlexBoxStyler().spacing(4),
        children: [
          StyledText('Checking', style: titleStyle),
          StyledText('Updated today', style: subtitleStyle),
        ],
      ),
    );
  }
}
```

Concepts: `Box`, `ColumnBox`, `BoxStyler`, `TextStyler`, shadows, spacing.

Source anchors:
- `packages/mix/lib/src/specs/box/box_style.dart`
- `packages/mix/lib/src/specs/flexbox/flexbox_widget.dart`
- `packages/mix/lib/src/specs/text/text_widget.dart`

## Pressable Button

```dart
final buttonStyle = BoxStyler()
    .color(Colors.blue)
    .paddingX(20)
    .paddingY(12)
    .borderRounded(8)
    .animate(.easeInOut(180.ms))
    .onHovered(.color(Colors.blue.shade700))
    .onPressed(.color(Colors.blue.shade900))
    .onFocused(.borderAll(color: Colors.white, width: 2))
    .onDisabled(.color(Colors.grey));

final labelStyle = TextStyler()
    .color(Colors.white)
    .fontWeight(.bold);

PressableBox(
  style: buttonStyle,
  enabled: isEnabled,
  onPress: onPress,
  child: StyledText('Save', style: labelStyle),
);
```

Concepts: `PressableBox`, widget state variants, animation.

Source anchors:
- `packages/mix/lib/src/specs/pressable/pressable_widget.dart`
- `packages/mix/lib/src/style/mixins/widget_state_variant_mixin.dart`
- `packages/mix/test/src/core/style_builder_hover_test.dart`

## Responsive Layout

```dart
final shellStyle = FlexBoxStyler()
    .direction(.vertical)
    .spacing(16)
    .paddingAll(16)
    .onDesktop(
      .direction(.horizontal)
          .spacing(24)
          .paddingAll(24),
    );

FlexBox(
  style: shellStyle,
  children: [
    Box(style: sidebarStyle, child: sidebar),
    Box(style: contentStyle, child: content),
  ],
);
```

Concepts: `FlexBox`, breakpoint variants, direction changes.

Source anchors:
- `packages/mix/lib/src/specs/flexbox/flexbox_style.dart`
- `packages/mix/lib/src/style/mixins/variant_style_mixin.dart`

## Tokenized Theme

```dart
final $primary = ColorToken('color.primary');
final $surface = ColorToken('color.surface');
final $onSurface = ColorToken('color.on_surface');
final $spaceMd = SpaceToken('space.md');
final $heading = TextStyleToken('text.heading');

MixScope(
  colors: {
    $primary: Colors.blue,
    $surface: Colors.white,
    $onSurface: Colors.black,
  },
  spaces: {
    $spaceMd: 16,
  },
  textStyles: {
    $heading: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  },
  child: Builder(
    builder: (context) {
      final cardStyle = BoxStyler()
          .color($surface())
          .paddingAll($spaceMd());

      final titleStyle = TextStyler()
          .style($heading.mix())
          .color($onSurface());

      return Box(
        style: cardStyle,
        child: StyledText('Dashboard', style: titleStyle),
      );
    },
  ),
);
```

Concepts: `MixScope`, typed token maps, token call refs, `TextStyleToken.mix()`.

Source anchors:
- `packages/mix/lib/src/theme/mix_theme.dart`
- `packages/mix/lib/src/theme/tokens/value_tokens.dart`
- `packages/mix/doc/mix-scope-and-theming.md`

## Keyframe Animation

```dart
final trigger = ValueNotifier(0);

final pulseStyle = BoxStyler()
    .color(Colors.pink)
    .size(80, 80)
    .shapeCircle()
    .keyframeAnimation(
      trigger: trigger,
      timeline: [
        KeyframeTrack<double>(
          'scale',
          [
            Keyframe.easeOut(1.12, 120.ms),
            Keyframe.easeIn(1.0, 160.ms),
          ],
          initial: 1.0,
        ),
      ],
      styleBuilder: (values, style) {
        return style.scale(values.get<double>('scale'));
      },
    );

Box(style: pulseStyle);
```

Concepts: `.keyframeAnimation(...)`, `KeyframeTrack`, `Keyframe`, `ValueNotifier`.

Source anchors:
- `packages/mix/lib/src/style/mixins/animation_style_mixin.dart`
- `packages/mix/test/src/style/styler_mixin_conformance_test.dart`

## Modernizing Stale Mix Code

When a prompt contains old names, rewrite to current names before explaining.

```dart
final $spaceMd = SpaceToken('space.md');

// Stale idea: horizontal layout alias and old theme config.
// Current app-level shape:
MixScope(
  tokens: {
    $spaceMd: 16.0,
  },
  child: RowBox(
    style: FlexBoxStyler().spacing($spaceMd()),
    children: children,
  ),
);
```

Source anchors:
- `packages/mix/lib/src/specs/flexbox/flexbox_widget.dart`
- `packages/mix/lib/src/theme/mix_theme.dart`
