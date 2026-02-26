// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  // 1
  final style = BoxStyler()
      .width(240)
      .height(100)
      .color(Colors.blue)
      .borderRadius(.circular(12));

  // 2
  final base = BoxStyler()
      .padding(.horizontal(16).vertical(8))
      .borderRadius(.circular(8))
      .color(Colors.black)
      .wrap(
        .new().defaultTextStyle(
          style: TextStyleMix.color(Colors.deepOrange).fontWeight(.bold),
        ),
      );

  final solid = base.color(Colors.blue);

  final soft = base
      .color(Colors.blue.shade100)
      .wrap(.new().defaultTextStyle(style: TextStyleMix.color(Colors.blue)));

  // 3
  final button = BoxStyler()
      .color(Colors.blue)
      .onHovered(.color(Colors.blue.shade700))
      .onDark(.color(Colors.blue.shade200));
}
