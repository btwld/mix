// ignore_for_file: unused_local_variable

import '../../helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  // 1
  final style = BoxStyler.color(Colors.red)
      .height(100)
      .width(100)
      .borderRadius(.circular(10))
      .onHovered(.color(Colors.blue));

  // 2
  final styleA = BoxStyler.color(Colors.red)
      .height(100)
      .width(100)
      .borderRadius(.circular(10))
      .onHovered(.color(Colors.blue).width(200));

  final styleB = styleA.onHovered(.color(Colors.green));

  final result = BoxStyler.color(
    Colors.green,
  ).height(100).width(200).borderRadius(.circular(10));

  // 3
  final hoverStyle = BoxStyler()
      .onDark(.color(Colors.blue))
      .onLight(.color(Colors.green));

  final nestedStyle = BoxStyler.color(
    Colors.red,
  ).height(100).width(100).borderRadius(.circular(10)).onHovered(hoverStyle);

  runMixApp(
    Row(
      mainAxisSize: .min,
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
