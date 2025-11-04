import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../../helpers.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .height(50)
        .width(100)
        .borderRounded(10)
        .linearGradient(
          colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade200],
          begin: .topLeft,
          end: .bottomRight,
        )
        .shadowOnly(
          color: Colors.deepPurple.shade700,
          offset: Offset(0, 4),
          blurRadius: 10,
        );

    return Box(style: style);
  }
}
