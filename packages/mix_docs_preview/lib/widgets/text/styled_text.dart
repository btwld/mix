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
    final style = TextStyler()
        .fontSize(24)
        .fontWeight(.bold)
        .color(Colors.blue);

    return StyledText('Hello Mix', style: style);
  }
}
