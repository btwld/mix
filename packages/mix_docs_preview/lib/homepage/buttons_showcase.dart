library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_docs_preview/helpers.dart';

void main() {
  runMixApp(const Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    // #docregion showcase
    final buttonStyle = BoxStyler()
        .height(40)
        .paddingX(14)
        .borderRounded(10)
        .alignment(.center)
        .animate(.easeInOut(180.ms))
        .scale(1)
        .onPressed(.scale(0.95))
        .wrap(.defaultText(TextStyler().fontSize(14).fontWeight(.w600)));

    final solidButtonStyle = buttonStyle
        .color(Colors.deepPurpleAccent)
        .wrap(.defaultText(.color(Colors.white)));

    final outlinedButtonStyle = buttonStyle
        .border(.color(Colors.deepPurpleAccent).width(1.5))
        .wrap(.defaultText(.color(Colors.deepPurpleAccent)));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Pressable(
          onPress: () {},
          child: solidButtonStyle(child: const Text('Solid')),
        ),
        const SizedBox(width: 12),
        Pressable(
          onPress: () {},
          child: outlinedButtonStyle(child: const Text('Outlined')),
        ),
      ],
    );
    // #enddocregion showcase
  }
}
