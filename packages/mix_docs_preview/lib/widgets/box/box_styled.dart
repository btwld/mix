/// Box widget example matching the widgets/box.mdx code snippet.
///
/// Blue 200x100 box with border radius 12, padding 16, and "Hello Mix" text.
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
        .width(200)
        .height(100)
        .color(Colors.blue)
        .borderRounded(12)
        .paddingAll(16);

    return Box(style: style, child: Text('Hello Mix'));
  }
}
