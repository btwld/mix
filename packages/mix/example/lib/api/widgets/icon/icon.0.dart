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
    final style =
        Style.icon( //
            .size(30)
            .color(Colors.blueAccent)
        );

    return StyledIcon(Icons.format_paint_rounded, style: style);
  }
}
