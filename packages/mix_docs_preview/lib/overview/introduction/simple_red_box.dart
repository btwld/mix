/// Introduction preview — simple red box.
///
/// Minimal example: BoxStyler with color, size, and border radius.

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
        .color(Colors.red)
        .size(100, 100)
        .borderRounded(10);

    return Box(style: boxStyle);
  }
}
