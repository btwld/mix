import '../../helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

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
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {
    //     appear = true;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.black)
        .height(100)
        .width(100)
        .borderRounded(10)
        .onHovered(BoxStyler().color(Colors.blue))
        .onPressed(
          BoxStyler().color(Colors.red).animate(AnimationConfig.easeIn(200.ms)),
        );
    // .animate(AnimationConfig.easeIn(2.s));
    // .translate(appear ? 0 : -50, 0)
    // .scale(appear ? 1 : 0.1)
    // .animate(AnimationConfig.easeInOut(500.ms));

    return Box(style: style);
  }
}
