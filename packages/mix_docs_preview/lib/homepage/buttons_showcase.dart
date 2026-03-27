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
    final Button = BoxStyler()
        .paddingX(24)
        .paddingY(12)
        .borderRounded(10)
        .alignment(.center)
        .animate(.easeInOut(180.ms))
        .onPressed(.scale(0.95))
        .wrap(.defaultText(
          TextStyler().fontSize(14).fontWeight(.w600),
        ));

    // ignore: non_constant_identifier_names
    final Solid = Button
        .color(Colors.deepPurple)
        .wrap(.defaultText(.color(Colors.white)));

    // ignore: non_constant_identifier_names
    final Outlined = Button
        .borderAll(color: Colors.deepPurple, width: 1.5)
        .wrap(.defaultText(.color(Colors.deepPurple)));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Pressable(
          onPress: () {},
          child: Solid(child: const Text('Solid')),
        ),
        const SizedBox(width: 12),
        Pressable(
          onPress: () {},
          child: Outlined(child: const Text('Outlined')),
        ),
      ],
    );
  }
}
