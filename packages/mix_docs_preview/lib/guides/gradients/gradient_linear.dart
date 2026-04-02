import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'package:mix_docs_preview/helpers.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler.size(200, 100)
        .borderRounded(16)
        .shadow(
          .color(Colors.purple.shade200).offset(x: 0, y: 8).blurRadius(20),
        )
        .linearGradient(
          colors: [Colors.purple.shade400, Colors.pink.shade300],
          begin: .topLeft,
          end: .bottomRight,
        );

    return Box(style: style);
  }
}
