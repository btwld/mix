/// Preview for overview/comparison — Mix vs plain Flutter.
library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_docs_preview/helpers.dart';

void main() => runMixApp(const Example());

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CustomMixWidget()],
      ),
    );
  }
}

class CustomMixWidget extends StatelessWidget {
  const CustomMixWidget({super.key});
  Color get accentColor => Colors.deepPurpleAccent;
  Color get surfaceColor => Colors.deepPurpleAccent.withValues(alpha: 0.1);

  TextStyler get customTextStyle =>
      TextStyler().fontSize(16).fontWeight(.w500).color(accentColor);

  BoxStyler get customBoxStyle => BoxStyler()
      .padding(.symmetric(horizontal: 12, vertical: 8))
      .borderRounded(10)
      .color(surfaceColor)
      .borderAll(color: surfaceColor)
      .animate(.easeInOut(100.ms))
      .scale(1)
      .onHovered(
        .color(
          accentColor.withValues(alpha: 0.0),
        ).borderAll(color: accentColor),
      )
      .onPressed(.scale(0.96));

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPress: () {},
      child: Box(
        style: customBoxStyle,
        child: StyledText('Click me', style: customTextStyle),
      ),
    );
  }
}

class CustomFlutterWidget extends StatefulWidget {
  const CustomFlutterWidget({super.key});

  @override
  State<CustomFlutterWidget> createState() => _CustomFlutterWidgetState();
}

class _CustomFlutterWidgetState extends State<CustomFlutterWidget> {
  bool _isHovered = false;
  bool _isPressed = false;

  Color get accentColor => Colors.deepPurpleAccent;
  Color get surfaceColor => Colors.deepPurpleAccent.withValues(alpha: 0.1);

  static const _duration = Duration(milliseconds: 100);
  static const _curve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    final bgColor = _isHovered
        ? accentColor.withValues(alpha: 0.0)
        : surfaceColor;
    final borderColor = _isHovered ? accentColor : surfaceColor;
    final scale = _isPressed ? 0.96 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {},
        child: AnimatedScale(
          scale: scale,
          duration: _duration,
          curve: _curve,
          child: AnimatedContainer(
            duration: _duration,
            curve: _curve,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: Text(
              'Click me',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: accentColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
