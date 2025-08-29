import 'dart:math' as math;

import 'package:example/helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final style = BoxStyle()
        .height(120)
        .width(120)
        .borderRadius(.circular(60))
        .shadow(
          .color(Colors.purple.shade300)
          .blurRadius(25)
          .spreadRadius(2)
        )
        .gradient(
          .sweep(
            .center(.center)
            .startAngle(0)
            .endAngle(math.pi * 2)
            .colors([
              Colors.blue.shade400,
              Colors.purple.shade400,
              Colors.pink.shade400,
              Colors.orange.shade400,
              Colors.blue.shade400,
            ])
          ),
    );

    return Box(style: style);
  }
}