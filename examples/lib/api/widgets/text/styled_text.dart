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
    final style = TextStyler()
        .style(
          TextStyleMix.create(
            color: .value<Color>(
              Colors.red,
            ).directives([OpacityColorDirective(0.2)]),
          ),
        )
        .fontSize(20)
        .fontWeight(.w700)
        .titlecase();

    return StyledText('I love Mix', style: style);
  }
}
