/// Simple Box Example
///
/// Demonstrates Box styling with color, padding, shadow, and a child widget.

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
    final style = BoxStyler()
        .size(200, 120)
        .color(Colors.blue)
        .borderRadius(.circular(12))
        .padding(.all(16))
        .shadow(.color(Colors.blue.shade200).blurRadius(12).offset(x: 0, y: 4));

    final label = TextStyler()
        .color(Colors.white)
        .fontSize(18)
        .fontWeight(.w600);

    return Box(
      style: style,
      child: StyledText('Hello Mix', style: label),
    );
  }
}
