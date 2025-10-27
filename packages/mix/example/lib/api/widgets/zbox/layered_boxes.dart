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
    final flexStyle = StackBoxStyler(
      constraints: .height(100).width(100),
      stackAlignment: .bottomCenter,
    );

    final boxStyle = BoxStyler()
        .color(Colors.deepOrange)
        .height(100)
        .width(100);

    return ZBox(
      style: flexStyle,
      children: [
        Box(style: boxStyle),
        Box(
          style: BoxStyler().color(Colors.grey.shade300).height(50).width(100),
        ),
        Box(
          style: BoxStyler()
              .color(Colors.black)
              .height(15)
              .width(100)
              .wrap(.align(alignment: .center)),
        ),
        Box(
          style: BoxStyler()
              .color(Colors.grey.shade100)
              .height(100)
              .width(100)
              .borderAll(color: Colors.black, width: 20)
              .wrap(.scale(0.50, 0.50)),
        ),
      ],
    );
  }
}
