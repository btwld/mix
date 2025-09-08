/// Hover Scale Animation Example
///
/// This example shows how to create smooth animations that respond to hover
/// interactions. The box scales up when the mouse hovers over it.
///
/// Key concepts:
/// - Using .onHovered() variant for hover states
/// - Applying .scale() transformation
/// - Adding .animate() for smooth transitions
/// - Transform alignment with .transformAlignment()
library;

import '../../helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.black)
        .height(100)
        .width(100)
        .borderRounded(10)
        .transform(Matrix4.identity())
        .onHovered(
          BoxStyler()
              .color(Colors.blue)
              .scale(1.5)
              .animate(AnimationConfig.easeInOut(1000.ms)),
        )
        .animate(AnimationConfig.spring(300.ms, bounce: 0.4));

    return Box(style: style);
  }
}
