import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/encode.dart';

void main() {
  test('R-12 payloadColor matches Ack Flutter codec canonical hex', () {
    expect(payloadColor(const Color(0xFF336699)), '#336699');
    expect(payloadColor(const Color(0xCC336699)), '#CC336699');
  });

  test('R-12 payloadAlignment emits named constants before object form', () {
    expect(payloadAlignment(Alignment.center), 'center');
    expect(payloadAlignment(const Alignment(0.25, -0.5)), {
      'x': 0.25,
      'y': -0.5,
    });
  });

  test('R-12 payloadEdgeInsets supports scalar and sparse object forms', () {
    expect(payloadEdgeInsets(all: 8), 8);
    expect(payloadEdgeInsets(top: 4), {'top': 4});
  });
}
