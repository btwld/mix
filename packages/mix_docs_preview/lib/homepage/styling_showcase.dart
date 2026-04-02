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
    final boxStyle = BoxStyler()
        .size(120, 120)
        .borderRounded(16)
        .color(Colors.deepPurple);

    return boxStyle();
    // #enddocregion showcase
  }
}
