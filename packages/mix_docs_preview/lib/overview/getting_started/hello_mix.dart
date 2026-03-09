/// Getting Started - Hello Mix
///
/// Matches the "Your first Mix widget" example from the docs:
/// a blue card with "Hello Mix" text and border.

library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'package:mix_docs_preview/helpers.dart';

void main() {
  runMixApp(const Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final cardStyle = BoxStyler()
        .height(100)
        .width(240)
        .color(Colors.blue)
        .borderRounded(12)
        .borderAll(color: Colors.black, width: 1, style: BorderStyle.solid);

    return Box(
      style: cardStyle,
      child: StyledText(
        'Hello Mix',
        style: TextStyler.color(Colors.white).fontSize(18),
      ),
    );
  }
}
