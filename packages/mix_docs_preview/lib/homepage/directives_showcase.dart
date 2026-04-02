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
    final titleStyle = TextStyler()
        .fontSize(20)
        .fontWeight(.w700)
        .color(Colors.white)
        .uppercase();

    final subtitleStyle = TextStyler()
        .fontSize(14)
        .color(Colors.white70)
        .capitalize();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleStyle('hello world'),
        const SizedBox(height: 4),
        subtitleStyle('style transforms built in'),
      ],
    );
    // #enddocregion showcase
  }
}
