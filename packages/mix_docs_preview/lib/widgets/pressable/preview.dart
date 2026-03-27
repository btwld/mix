/// Preview for widgets/pressable.
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
    final style = BoxStyler()
        .alignment(.center)
        .paddingAll(16)
        .borderRounded(8)
        .color(Colors.blue)
        .animate(.easeInOut(200.ms))
        .onHovered(.color(Colors.blue.shade700))
        .onPressed(.color(Colors.blue.shade900))
        .onFocused(.color(Colors.indigo));

    final label = TextStyler()
        .color(Colors.white)
        .fontSize(16)
        .fontWeight(.w600);

    return Pressable(
      onPress: () {},
      child: Box(style: style, child: label('Press Me')),
    );
  }
}
