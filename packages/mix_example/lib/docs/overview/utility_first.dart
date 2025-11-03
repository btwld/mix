import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  // 1
  // ignore: unused_local_variable
  final boxStyle = BoxStyler()
      .width(100)
      .paddingAll(10)
      .alignment(Alignment.center)
      .color(Colors.red);

  // 2
  BoxStyler().alignment(Alignment.centerRight);

  BoxStyler().paddingAll(16);

  BoxStyler().paddingX(12).paddingY(8);
  BoxStyler().paddingOnly(horizontal: 12, vertical: 8);

  // 4
  BoxStyler().borderAll(color: Colors.red);
  BoxStyler().borderTop(color: Colors.red, width: 2);

  // 5
  BoxStyler borderTop(Color color) => BoxStyler().borderTop(color: color);
  borderTop(Colors.red);
  // ignore: unused_local_variable
  final style = borderTop(Colors.red).paddingAll(8);

  // 6
  BoxStyler borderRedTop() => BoxStyler().borderRedTop();

  borderRedTop();
}

extension on BoxStyler {
  BoxStyler borderRedTop() => borderTop(color: Colors.red);
}
