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
    final style = BoxMix()
        .color(Colors.red)
        .height(100)
        .width(100)
        .borderRadius(BorderRadiusMix.all(Radius.circular(10)))
        .onPressed(BoxMix.color(Colors.blue));

    return Pressable(
      onPress: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Pressed!')));
      },
      child: Box(style: style),
    );
  }
}
