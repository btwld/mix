import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../helpers.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    // Button style that adapts to dark/light mode
    final buttonStyle = BoxStyler()
        .height(60)
        .width(60)
        .borderRounded(30)
        .color(Colors.grey.shade200)
        .animate(.easeInOut(600.ms))
        .onDark(BoxStyler().color(Colors.grey.shade800))
        .shadowOnly(
          color: Colors.black.withValues(alpha: 0.1),
          offset: Offset(0, 4),
          blurRadius: 10,
        );

    // Icon style that adapts to dark/light mode
    final iconStyle = IconStyler()
        .color(Colors.grey.shade800)
        .size(28)
        .icon(Icons.dark_mode)
        .animate(.easeInOut(200.ms))
        .onDark(IconStyler().icon(Icons.light_mode).color(Colors.yellow));

    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(platformBrightness: isDark ? .dark : .light),
      child: PressableBox(
        style: buttonStyle,
        onPress: () => setState(() => isDark = !isDark),
        child: StyledIcon(style: iconStyle),
      ),
    );
  }
}
