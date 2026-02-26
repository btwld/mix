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

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../helpers.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.black)
        .size(100, 100)
        .borderRounded(10)
        .scale(1)
        .onHovered(BoxStyler().color(Colors.blue).scale(1.5))
        .animate(.spring(800.ms));

    return Box(style: style);
  }
}
