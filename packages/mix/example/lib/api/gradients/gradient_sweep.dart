import 'dart:math' as math;

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
        .height(120)
        .width(120)
        .borderRounded(60)
        .shadowOnly(
          color: Colors.purple.shade300,
          blurRadius: 25,
          spreadRadius: 2,
        )
        .sweepGradient(
          colors: [
            Colors.blue.shade400,
            Colors.purple.shade400,
            Colors.pink.shade400,
            Colors.orange.shade400,
            Colors.blue.shade400,
          ],
          center: Alignment.center,
          startAngle: 0,
          endAngle: math.pi * 2,
        );

    return Box(style: style);
  }
}
