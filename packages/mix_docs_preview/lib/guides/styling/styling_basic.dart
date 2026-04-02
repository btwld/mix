/// Basic styling example for the Styling guide.
///
/// Shows the fundamental pattern: define a BoxStyler, pass it to a Box.

library;

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
    final boxStyle = BoxStyler()
        .width(240)
        .height(100)
        .color(Colors.blue)
        .borderRadius(.circular(12));

    return Box(style: boxStyle, child: Text('Hello'));
  }
}
