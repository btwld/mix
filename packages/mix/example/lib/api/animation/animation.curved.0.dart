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
        .color(Colors.black)
        .height(100)
        .width(100)
        .borderRadius(.circular(10))
        .transform(.identity())
        .transformAlignment(.center)
        .onHovered(.color(Colors.blue).scale(1.5))
        .animate(.easeInOut(300.ms))
    );

    return Box(style: style);
  }
}
