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
        .color(Colors.red)
        .height(100)
        .width(100)
        .borderRadius(BorderRadiusMix.all(Radius.circular(10)))
        .onDisabled(BoxMix.color(Colors.grey))
    );

    return Pressable(enabled: false, child: Box(style: style));
  }
}
