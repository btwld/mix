import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../helpers.dart';

void main() {
  runMixApp(const Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return MixScope(
      tokens: tokenDefinitions,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Box(style: boxStyle),
          StyledText('Hello, World!', style: textStyle),
          Box(style: buttonStyle),
          Box(style: tokenStyle),
        ],
      ),
    );
  }
}

// 1
final boxStyle = BoxStyler()
    .height(100)
    .width(100)
    .color(Colors.purple)
    .borderRounded(10);

final textStyle = TextStyler()
    .fontSize(20)
    .fontWeight(FontWeight.bold)
    .color(Colors.black);

// 2
final buttonStyle = BoxStyler()
    .height(50)
    .borderRounded(25)
    .color(Colors.blue)
    .onHovered(BoxStyler().color(Colors.blue.shade700))
    .onDark(BoxStyler().color(Colors.blue.shade200));

// 3
final $primaryColor = ColorToken('primary');
final $borderRadius = RadiusToken('borderRadius');

final tokenDefinitions = <MixToken, Object>{
  $primaryColor: Colors.blue,
  $borderRadius: Radius.circular(8),
};

final tokenStyle = BoxStyler()
    .color($primaryColor())
    .width(100)
    .height(100)
    .borderRadius(BorderRadiusGeometryMix.all($borderRadius()));
