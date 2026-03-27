/// Simple Box Example
///
/// This example demonstrates the basic usage of the Box widget with Mix styling.
/// Shows how to apply color, dimensions, and border radius to create a simple
/// styled container.

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

    return Box(
      style: style,
      child: const Text('Hello Mix', style: TextStyle(color: Colors.white)),
    );
  }
}
