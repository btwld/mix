import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../helpers.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  bool appear = false;

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.black)
        .height(100)
        .width(100)
        .borderRounded(10)
        .onHovered(
          BoxStyler() //
              .color(Colors.blue),
        )
        .onPressed(
          BoxStyler() //
              .color(Colors.red)
              .animate(AnimationConfig.easeIn(200.ms)),
        );

    return Box(style: style);
  }
}
