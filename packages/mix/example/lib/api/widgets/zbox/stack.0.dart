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
    final flexStyle = StackBoxMix.stack(
      StackMix.alignment(Alignment.bottomCenter),
    ).withBox(BoxMix.height(100).width(100));

    final boxStyle =
        Style.box() //
            .color(Colors.deepOrange)
            .height(100)
            .width(100);

    return ZBox(
      style: flexStyle,
      children: [
        Box(style: boxStyle),
        Box(style: boxStyle.color(Colors.grey.shade300).height(50)),
        Box(
          style: boxStyle
              .color(Colors.black)
              .height(15)
              .wrapAlign(Alignment.center),
        ),
        Box(
          style: boxStyle
              .color(Colors.grey.shade100)
              .border(
                BoxBorderMix.all(BorderSideMix.color(Colors.black).width(20)),
              )
              .wrapScale(0.50),
        ),
      ],
    );
  }
}
