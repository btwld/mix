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
    final cardStyle = BoxStyler()
        .size(120, 120)
        .borderRounded(16)
        .color(Colors.cyan)
        .alignment(.center)
        .animate(.easeInOut(220.ms))
        .scale(1)
        .onHovered(.color(Colors.cyanAccent).scale(1.2));

    return cardStyle(
      child: const Text(
        'Hover',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
    // #enddocregion showcase
  }
}
