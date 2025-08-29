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
    final style = BoxStyler()
        .height(100)
        .width(200)
        .borderRadius(.circular(16))
        .shadow(
          .color(Colors.purple.shade200)
          .blurRadius(20)
          .offset(Offset(0, 8))
        )
        .gradient(
          .linear(
            .begin(.topLeft)
            .end(.bottomRight)
            .colors([
              Colors.purple.shade400,
              Colors.pink.shade300
            ])
          ),
        );

    return Box(style: style);
  }
}