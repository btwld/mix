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
    final style = Style.box(
        .gradient(
          GradientMix.linear(
            LinearGradientMix(
              colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        )
        .shadow(BoxShadowMix(color: Colors.deepPurple.shade700, blurRadius: 10))
        .height(50)
        .width(100)
        .borderRadius(BorderRadiusMix.all(Radius.circular(10)))
    );

    return Box(style: style);
  }
}
