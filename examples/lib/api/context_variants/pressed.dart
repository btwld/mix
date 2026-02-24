import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../helpers.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.red)
        .height(100)
        .width(100)
        .borderRounded(10)
        .onPressed(BoxStyler().color(Colors.blue));

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
