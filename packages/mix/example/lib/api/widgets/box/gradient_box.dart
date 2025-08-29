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
        .height(50)
        .width(100)
        .borderRadius(.all(.circular(10)))
        .gradient(
          .linear(
            .colors([
              Colors.deepPurple.shade700,
              Colors.deepPurple.shade200
            ])
            .begin(.topLeft)
            .end(.bottomRight)
          ),
        )
        .shadow(
          .color(Colors.deepPurple.shade700)
          .blurRadius(10)
          .offset(Offset(0, 4))
        );

    return Box(style: style);
  }
}
