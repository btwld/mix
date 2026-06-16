# Examples

Worked examples that show current Mix APIs in complete Flutter snippets.

## Themed Profile Page

Tokens define the visual vocabulary, `MixScope` provides concrete values, and Stylers consume token refs with `$token()` or `$token.mix()`.

```dart
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

final $primary = ColorToken('primary');
final $background = ColorToken('background');
final $surface = ColorToken('surface');
final $onPrimary = ColorToken('on.primary');
final $onSurface = ColorToken('on.surface');
final $heading = TextStyleToken('heading');
final $body = TextStyleToken('body');
final $spaceSm = SpaceToken('space.sm');
final $spaceMd = SpaceToken('space.md');
final $spaceLg = SpaceToken('space.lg');
final $radiusMd = RadiusToken('radius.md');

final lightColors = <ColorToken, Color>{
  $primary: Colors.blue,
  $background: Color(0xFFF5F7FA),
  $surface: Colors.white,
  $onPrimary: Colors.white,
  $onSurface: Color(0xFF1D1F24),
};

final lightTextStyles = <TextStyleToken, TextStyle>{
  $heading: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
  $body: TextStyle(fontSize: 16),
};

final lightSpaces = <SpaceToken, double>{
  $spaceSm: 8,
  $spaceMd: 16,
  $spaceLg: 24,
};

final lightRadii = <RadiusToken, Radius>{
  $radiusMd: Radius.circular(12),
};

class ThemedProfilePage extends StatelessWidget {
  const ThemedProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageStyle = FlexBoxStyler()
        .color($background())
        .paddingAll($spaceLg())
        .spacing($spaceMd());

    final cardStyle = BoxStyler()
        .color($surface())
        .paddingAll($spaceMd())
        .borderRadiusAll($radiusMd())
        .shadowOnly(
          color: Colors.black.withValues(alpha: 0.08),
          offset: Offset(0, 6),
          blurRadius: 18,
        );

    final avatarStyle = BoxStyler()
        .color($primary())
        .size(56, 56)
        .borderRadiusAll($radiusMd())
        .alignment(Alignment.center);

    final avatarTextStyle = TextStyler()
        .style($heading.mix())
        .color($onPrimary());

    final titleStyle = TextStyler()
        .style($heading.mix())
        .color($onSurface());

    final bodyStyle = TextStyler().style($body.mix()).color($onSurface());

    return MixScope(
      colors: lightColors,
      textStyles: lightTextStyles,
      spaces: lightSpaces,
      radii: lightRadii,
      child: ColumnBox(
        style: pageStyle,
        children: [
          Box(
            style: cardStyle,
            child: RowBox(
              style: FlexBoxStyler()
                  .spacing($spaceMd())
                  .crossAxisAlignment(CrossAxisAlignment.center),
              children: [
                Box(
                  style: avatarStyle,
                  child: StyledText('LF', style: avatarTextStyle),
                ),
                ColumnBox(
                  style: FlexBoxStyler()
                      .spacing($spaceSm())
                      .crossAxisAlignment(CrossAxisAlignment.start),
                  children: [
                    StyledText('Profile', style: titleStyle),
                    StyledText('Welcome back!', style: bodyStyle),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

## Dark/Light Toggle

`onDark` responds to the platform brightness in `MediaQuery`, so this example keeps the toggle local by overriding `platformBrightness`.

```dart
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

class ThemeToggle extends StatefulWidget {
  const ThemeToggle({super.key});

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = BoxStyler()
        .height(60)
        .width(60)
        .borderRounded(30)
        .color(Colors.grey.shade200)
        .alignment(Alignment.center)
        .shadowOnly(
          color: Colors.black.withValues(alpha: 0.1),
          offset: Offset(0, 4),
          blurRadius: 10,
        )
        .onDark(BoxStyler().color(Colors.grey.shade800))
        .animate(AnimationConfig.easeInOut(600.ms));

    final iconStyle = IconStyler()
        .color(Colors.grey.shade800)
        .size(28)
        .icon(Icons.dark_mode)
        .onDark(IconStyler().icon(Icons.light_mode).color(Colors.yellow))
        .animate(AnimationConfig.easeInOut(200.ms));

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        platformBrightness: isDark ? Brightness.dark : Brightness.light,
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

## Pressable Button

`PressableBox` combines gesture/focus state handling with a `BoxStyler`, so widget-state variants such as `onHovered` and `onPressed` can live in the style.

```dart
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = BoxStyler()
        .color(Colors.blue)
        .paddingX(24)
        .paddingY(12)
        .borderRounded(8)
        .alignment(Alignment.center)
        .onHovered(BoxStyler().color(Colors.blue.shade700).translate(0, -1))
        .onPressed(BoxStyler().color(Colors.blue.shade900).scale(0.98))
        .animate(AnimationConfig.easeInOut(150.ms));

    final labelStyle = TextStyler()
        .color(Colors.white)
        .fontSize(16)
        .fontWeight(FontWeight.w700);

    return PressableBox(
      style: buttonStyle,
      onPress: onPressed,
      child: StyledText(label, style: labelStyle),
    );
  }
}
```
