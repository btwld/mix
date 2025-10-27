import '../../helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .height(100)
        .width(200)
        .borderRounded(16)
        .shadowOnly(
          color: Colors.purple.shade200,
          offset: Offset(0, 8),
          blurRadius: 20,
        )
        .linearGradient(
          colors: [Colors.purple.shade400, Colors.pink.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    return Box(style: style);
  }
}
