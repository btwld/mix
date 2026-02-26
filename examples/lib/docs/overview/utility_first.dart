import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  // 1
  // ignore: unused_local_variable
  final boxStyle = BoxStyler.width(
    100,
  ).padding(.all(10)).alignment(.center).color(Colors.red);

  // 2
  BoxStyler.alignment(.centerRight);

  BoxStyler.padding(.all(16));

  BoxStyler.padding(.symmetric(horizontal: 12, vertical: 8));
  BoxStyler.padding(.symmetric(horizontal: 12, vertical: 8));

  // 4
  BoxStyler.border(.all(.color(Colors.red)));
  BoxStyler.border(.top(.color(Colors.red).width(2)));

  // 5
  BoxStyler borderTop(Color color) => BoxStyler.border(.top(.color(color)));
  borderTop(Colors.red);
  // ignore: unused_local_variable
  final style = borderTop(Colors.red).padding(.all(8));

  // 6
  BoxStyler borderRedTop() => .new().borderRedTop();

  borderRedTop();
}

extension on BoxStyler {
  BoxStyler borderRedTop() => border(.top(.color(Colors.red)));
}
