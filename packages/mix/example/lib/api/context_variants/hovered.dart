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
        .color(Colors.red)
        .height(100)
        .width(100)
        .borderRadius(.all(.circular(10)))
        .onHovered(BoxStyle().color(Colors.blue));

    return Box(style: style);
  }
}
