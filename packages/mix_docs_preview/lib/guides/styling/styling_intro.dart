/// Preview for guides/styling — first example.
///
/// Blue 240x100 box with border radius 12 and "Hello" text,
/// matching the introductory snippet in styling.mdx.
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
    final boxStyle = BoxStyler()
        .width(240)
        .height(100)
        .color(Colors.blue)
        .borderRounded(12);

    return Box(style: boxStyle, child: Text('Hello'));
  }
}
