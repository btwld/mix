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
    final Label = TextStyler()
        .fontSize(14)
        .fontWeight(.w600)
        .color(Colors.white);

    // ignore: non_constant_identifier_names
    final Solid = BoxStyler()
        .paddingX(24)
        .paddingY(12)
        .borderRounded(10)
        .color(Colors.deepPurple)
        .alignment(.center)
        .animate(.easeInOut(180.ms))
        .onPressed(.scale(0.95));

    // ignore: non_constant_identifier_names
    final Outlined = BoxStyler()
        .paddingX(24)
        .paddingY(12)
        .borderRounded(10)
        .borderAll(color: Colors.deepPurple, width: 1.5)
        .alignment(.center)
        .animate(.easeInOut(180.ms))
        .onPressed(.scale(0.95));

    // ignore: non_constant_identifier_names
    final OutlinedLabel = Label.color(Colors.deepPurple);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Pressable(
          onPress: () {},
          child: Solid(child: Label('Solid')),
        ),
        const SizedBox(width: 12),
        Pressable(
          onPress: () {},
          child: Outlined(child: OutlinedLabel('Outlined')),
        ),
      ],
    );
  }
}
