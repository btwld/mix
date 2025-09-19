// ignore_for_file: unused_local_variable

import 'package:example/helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  // 1
  final style = BoxStyler()
      .color(Colors.red)
      .height(100)
      .width(100)
      .borderRounded(10)
      .onHovered(BoxStyler().color(Colors.blue));

  // 2
  final styleA = BoxStyler()
      .color(Colors.red)
      .height(100)
      .width(100)
      .borderRounded(10)
      .onHovered(BoxStyler().color(Colors.blue).width(200));

  final styleB = styleA.onHovered(BoxStyler().color(Colors.green));

  final result = BoxStyler()
      .color(Colors.green)
      .height(100)
      .width(200)
      .borderRounded(10);

  // 3
  final hoverStyle = BoxStyler()
      .onDark(BoxStyler().color(Colors.blue))
      .onLight(BoxStyler().color(Colors.green));

  final nestedStyle = BoxStyler()
      .color(Colors.red)
      .height(100)
      .width(100)
      .borderRounded(10)
      .onHovered(hoverStyle);

  runMixApp(
    Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        Box(style: style),
        Box(style: styleA),
        Box(style: styleB),
        Box(style: nestedStyle),
      ],
    ),
  );
}
