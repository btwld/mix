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

  BoxStyler get _box => BoxStyler()
      .size(240, 100)
      .color(Colors.blue)
      .alignment(.center)
      .borderRounded(12)
      .border(.color(Colors.black).width(1).style(.solid));

  TextStyler get _text => TextStyler().color(Colors.white).fontSize(18);

  @override
  Widget build(BuildContext context) {
    return _box(child: _text('Hello Mix'));
  }
}
