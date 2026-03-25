/// Preview for guides/styling — style composition example.
///
/// Shows base, solid, and soft styles side by side to demonstrate
/// how styles compose via chaining.
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
    final base = BoxStyler()
        .paddingX(16)
        .paddingY(8)
        .borderRounded(8)
        .color(Colors.black);

    final solid = base.color(Colors.blue);

    final soft = base.color(Colors.blue.shade100);

    final labelStyle = TextStyler().color(Colors.white).fontSize(14);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        Box(
          style: base,
          child: StyledText('Base', style: labelStyle),
        ),
        Box(
          style: solid,
          child: StyledText('Solid', style: labelStyle),
        ),
        Box(
          style: soft,
          child: StyledText(
            'Soft',
            style: labelStyle.color(Colors.blue.shade900),
          ),
        ),
      ],
    );
  }
}
