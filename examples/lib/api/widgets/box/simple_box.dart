/// Simple Box Example
///
/// This example demonstrates the basic usage of the Box widget with Mix styling.
/// Shows how to apply color, dimensions, and border radius to create a simple
/// styled container.
///
/// Key concepts:
/// - Using BoxStyler() to create box styles (recommended)
/// - Alternative: Using $box accessor for BoxMutableStyler
/// - Setting color, width, and height properties
/// - Applying border radius with borderRounded()
// ignore_for_file: unused_local_variable, avoid-commented-out-code

library;

import '../../../helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    // RECOMMENDED: BoxStyler() API
    final boxStyle = BoxStyler()
        .color(Colors.red)
        .size(100, 100)
        .borderRounded(10);

    // ALTERNATIVE: $box accessor (returns BoxMutableStyler)
    // Provides the same fluent API as BoxStyler()
    final fluentStyle = $box
        .color(Colors.red)
        .height(100)
        .width(100)
        .borderRounded(10);

    // LEGACY: Builder pattern with cascade notation
    // Still works but BoxStyler() or $box is preferred
    final builderStyle = $box
      ..color.red()
      ..height(100)
      ..width(100)
      ..borderRadius.circular(10);

    return Box(style: boxStyle);
    // or
    // return simpleBox();
  }
}
