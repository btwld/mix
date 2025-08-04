/// Simple Box Example
/// 
/// This example demonstrates the basic usage of the Box widget with Mix styling.
/// Shows how to apply color, dimensions, and border radius to create a simple
/// styled container.
/// 
/// Key concepts:
/// - Using Style.box() to create box styles
/// - Setting color, width, and height properties
/// - Applying border radius with BorderRadiusMix

import 'package:example/helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runMixApp( Example());
}


class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Style.box(
        .color(Colors.red)
        .height(100)
        .width(100)
        .borderRadius(BorderRadiusMix.all(Radius.circular(10)))
    );

    return Box(style: style);
  }
}
