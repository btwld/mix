/// Simple Box Example
///
/// This example demonstrates the basic usage of the Box widget with Mix styling.
/// Shows how to apply color, dimensions, and border radius to create a simple
/// styled container.
///
/// Key concepts:
/// - Using BoxStyler() to create box styles (recommended Mix 2.0 API)
/// - Setting color, width, height, and border radius properties
/// - Fluent method chaining for readable styling code
// ignore_for_file: unused_local_variable

library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../../helpers.dart';

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
        .borderRounded(10)
        .onHovered(BoxStyler().color(Colors.blue))
        .onFocused(BoxStyler().color(Colors.green))
        .onPressed(BoxStyler().color(Colors.yellow));

    return Row(
      children: [
        Pressable(child: Box(style: boxStyle)),
        TextButton(
          onPressed: () {
            print('pressed');
          },
          child: Text('Press me'),
        ),
      ],
    );
  }
}
