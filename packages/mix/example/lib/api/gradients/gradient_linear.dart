import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../helpers.dart';

final $primaryColor = ColorToken('primary');
final $secondaryColor = ColorToken('secondary');

void main() {
  runMixApp(
    MixScope(
      colors: {$primaryColor: Colors.red, $secondaryColor: Colors.blue},
      child: Example(),
    ),
  );
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .height(100)
        .width(200)
        .borderRounded(16)
        .color($primaryColor())
        .shadowOnly(
          color: $primaryColor(),
          offset: Offset(0, 8),
          blurRadius: 20,
        )
        .linearGradient(
          colors: [$primaryColor(), $secondaryColor()],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    return Box(style: style);
  }
}
