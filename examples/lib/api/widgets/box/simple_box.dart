/// Simple Box Example
///
/// This example demonstrates the basic usage of the Box widget with Mix styling.
/// Shows how to apply color, dimensions, and border radius to create a simple
/// styled container.
///
/// Key concepts:
/// - Using BoxStyle() to create box styles
/// - Setting color, width, and height properties
/// - Applying border radius with BorderRadiusMix
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
    // OLD Syntax
    // final boxStyle = Style(
    //   $box.color(Colors.red),
    //   $box.height(100),
    //   $box.width(100),
    //   $box.borderRadius(10),
    // );

    // NEW Fluent API with dot notation
    final fluentStyle = $box
        .color(Colors.red)
        .height(100)
        .width(100)
        .borderRounded(10);

    /// Builder Pattern Syntax for backwards compatibility
    final builderStyle = $box
      ..color.red()
      ..height(100)
      ..width(100)
      ..borderRadius.circular(10);

    final boxStyle = BoxStyler()
        .color(Colors.red)
        .size(100, 100)
        .borderRounded(10);

    return Box(style: boxStyle);
    // or
    // return simpleBox();
  }
}
