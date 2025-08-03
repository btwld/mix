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
    final style = Style.text()
        .fontSize(20)
        .fontWeight(FontWeight.w700)
        .textModifier(UppercaseStringModifier())
        .color(Colors.red);

    return StyledText('I love Mix', style: style);
  }
}
