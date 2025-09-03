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
        .height(50)
        .width(100)
        .borderRounded(10)
        .linearGradient(
          colors: [
            Colors.deepPurple.shade700,
            Colors.deepPurple.shade200
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
        .shadowOnly(
          color: Colors.deepPurple.shade700,
          blurRadius: 10,
          offset: Offset(0, 4),
        );

    return Box(style: style);
  }
}
