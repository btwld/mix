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
    final style = Style.box()
        .color(Colors.black)
        .height(100)
        .width(100)
        .borderRadius(BorderRadiusMix.all(Radius.circular(10)))
        .transform(Matrix4.identity())
        .transformAlignment(Alignment.center)
        .onHovered(BoxMix.color(Colors.blue).scale(1.5))
        .animate(AnimationConfig.easeInOut(300.ms));

    return Box(style: style);
  }
}
