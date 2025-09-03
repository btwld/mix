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
        .borderRounded(16)
        .shadowColor(Colors.purple.shade200)
        .shadowBlurRadius(20)
        .shadowOffset(Offset(0, 8))
        .linearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade400,
            Colors.pink.shade300
          ],
        );

    return Box(style: style);
  }
}