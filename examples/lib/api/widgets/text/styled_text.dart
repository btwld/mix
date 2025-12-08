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
        .fontSize(20)
        .fontWeight(.w700)
        .uppercase()
        .color(Colors.red);

    return StyledText('I love Mix', style: style);
  }
}
