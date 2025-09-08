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
  bool _translated = false;

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.black)
        .height(100)
        .width(100)
        .borderRounded(10)
        .transform(Matrix4.identity())
        .translate(0, _translated ? 100 : -100)
        .animate(AnimationConfig.spring(300.ms, bounce: 0.6));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        Box(style: style),
        TextButton(
          onPressed: () {
            setState(() {
              _translated = !_translated;
            });
          },
          child: Text('Play'),
        ),
      ],
    );
  }
}
