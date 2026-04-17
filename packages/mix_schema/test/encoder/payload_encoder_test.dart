import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/encode.dart';

void main() {
  group('payload encoders', () {
    test('encodes colors as #RRGGBBAA', () {
      expect(payloadColor(const Color(0x803B82F6)), '#3B82F680');
      expect(payloadColor(const Color(0xFFFFFFFF)), '#FFFFFFFF');
    });

    test('encodes alignment geometry using LTR resolution by default', () {
      expect(payloadAlignment(Alignment.centerLeft), {'x': -1.0, 'y': 0.0});
      expect(payloadAlignment(AlignmentDirectional.centerStart), {
        'x': -1.0,
        'y': 0.0,
      });
    });

    test('encodes offsets', () {
      expect(payloadOffset(const Offset(3, 4)), {'dx': 3.0, 'dy': 4.0});
    });

    test('encodes circular and elliptical radii', () {
      expect(payloadRadius(const Radius.circular(6)), {'x': 6.0});
      expect(payloadRadius(const Radius.elliptical(6, 8)), {
        'x': 6.0,
        'y': 8.0,
      });
    });
  });
}
