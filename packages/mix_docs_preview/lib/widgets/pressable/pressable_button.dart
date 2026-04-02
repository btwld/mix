/// Pressable Button Example
///
/// Demonstrates PressableBox with hover, press, and disabled state variants,
/// plus smooth animation transitions.

library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_docs_preview/helpers.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = BoxStyler()
        .color(Colors.blue)
        .padding(.symmetric(horizontal: 24, vertical: 12))
        .borderRadius(.circular(10))
        .shadow(.color(Colors.blue.shade200).blurRadius(8).offset(x: 0, y: 2))
        .onHovered(
          .color(Colors.blue.shade700).shadow(
            .color(Colors.blue.shade300).blurRadius(12).offset(x: 0, y: 4),
          ),
        )
        .onPressed(.color(Colors.blue.shade900).scale(0.97))
        .animate(.ease(150.ms));

    final labelStyle = TextStyler()
        .color(Colors.white)
        .fontSize(16)
        .fontWeight(.w600);

    return PressableBox(
      onPress: () {},
      style: buttonStyle,
      child: StyledText('Press Me', style: labelStyle),
    );
  }
}
