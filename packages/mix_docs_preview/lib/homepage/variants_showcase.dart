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
    // ignore: non_constant_identifier_names
    final Card = BoxStyler()
        .width(120)
        .height(120)
        .borderRounded(16)
        .color(Colors.cyan)
        .alignment(.center)
        .animate(.easeInOut(220.ms))
        .onHovered(
          .color(Colors.cyanAccent)
          .scale(1.2)
          .shadow(
            .color(Colors.cyanAccent)
            .blurRadius(24),
          ),
        );

    // ignore: non_constant_identifier_names
    final Label = TextStyler()
        .color(Colors.white)
        .fontSize(16)
        .onHovered(
          .color(Colors.black),
        );

    return Pressable(
      onPress: () {},
      child: Card(child: Label('Hover')),
    );
  }
}
