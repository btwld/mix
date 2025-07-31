import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Example())),
    );
  }
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
