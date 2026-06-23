import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/encode.dart';

void main() {
  test('payloadColor matches Ack Flutter codec canonical hex', () {
    expect(payloadColor(const Color(0xFF336699)), '#336699');
    expect(payloadColor(const Color(0xCC336699)), '#CC336699');
  });

  test('payloadAlignment emits named constants before object form', () {
    expect(payloadAlignment(Alignment.center), 'center');
    expect(payloadAlignment(const Alignment(0.25, -0.5)), {
      'x': 0.25,
      'y': -0.5,
    });
  });

  test('payloadOffset and shadow helpers emit sparse value objects', () {
    expect(payloadOffset(const Offset(2, 4)), {'x': 2.0, 'y': 4.0});
    expect(
      payloadShadow(
        const Shadow(
          color: Color(0x33000000),
          offset: Offset(0, 1),
          blurRadius: 2,
        ),
      ),
      {
        'color': '#33000000',
        'offset': {'x': 0.0, 'y': 1.0},
        'blurRadius': 2.0,
      },
    );
    expect(
      payloadBoxShadow(
        const BoxShadow(
          color: Color(0x1A000000),
          offset: Offset(0, 4),
          blurRadius: 6,
          spreadRadius: -1,
        ),
      ),
      {
        'color': '#1A000000',
        'offset': {'x': 0.0, 'y': 4.0},
        'blurRadius': 6.0,
        'spreadRadius': -1.0,
      },
    );
  });

  test('payloadEdgeInsets supports scalar and sparse object forms', () {
    expect(payloadEdgeInsets(all: 8), 8);
    expect(payloadEdgeInsets(top: 4), {'top': 4});
  });
}
