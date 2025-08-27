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
    final flexStyle = StackBoxStyle.stack(
      StackMix.alignment(Alignment.bottomCenter),
    ).box(BoxMix().height(100).width(100));

    final boxStyle = Style.box(
        .color(Colors.deepOrange)
        .height(100)
        .width(100)
    );

    return ZBox(
      style: flexStyle,
      children: [
        Box(style: boxStyle),
        Box(
          style: Style.box(
            .color(Colors.grey.shade300)
            .height(50)
            .width(100)
          ),
        ),
        Box(
          style: Style.box(
            .color(Colors.black)
            .height(15)
            .width(100)
            .wrapAlign(Alignment.center)
          ),
        ),
        Box(
          style: Style.box(
            .color(Colors.grey.shade100)
            .height(100)
            .width(100)
            .border(
              .all(
                .color(Colors.black)
                .width(20)
              )
            )
            .wrapScale(0.50)
          ),
        ),
      ],
    );
  }
}