import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/src/schema/shared/color_schema.dart';

void main() {
  group('colorSchema', () {
    test('parses rgba() strings', () {
      final result = colorSchema.safeParse('rgba(59, 130, 246, 0.5)');

      expect(result.isOk, isTrue);
      expect(result.getOrNull(), const Color.fromRGBO(59, 130, 246, 0.5));
    });

    test('parses rgba() strings with alpha 1', () {
      final result = colorSchema.safeParse('rgba(255, 255, 255, 1)');

      expect(result.isOk, isTrue);
      expect(result.getOrNull(), const Color(0xFFFFFFFF));
    });

    test('parses rgb() strings', () {
      final result = colorSchema.safeParse('rgb(59, 130, 246)');

      expect(result.isOk, isTrue);
      expect(result.getOrNull(), const Color(0xFF3B82F6));
    });

    test('parses case-insensitive rgb()/rgba() strings', () {
      final rgbResult = colorSchema.safeParse('RGB(59, 130, 246)');
      final rgbaResult = colorSchema.safeParse('RGBA(59, 130, 246, 0.5)');

      expect(rgbResult.isOk, isTrue);
      expect(rgbResult.getOrNull(), const Color(0xFF3B82F6));
      expect(rgbaResult.isOk, isTrue);
      expect(rgbaResult.getOrNull(), const Color.fromRGBO(59, 130, 246, 0.5));
    });

    test('parses flexible alpha numeric syntax currently supported', () {
      final leadingDot = colorSchema.safeParse('rgba(59, 130, 246, .5)');
      final trailingDot = colorSchema.safeParse('rgba(59, 130, 246, 1.)');
      final exponent = colorSchema.safeParse('rgba(59, 130, 246, 5e-1)');

      expect(leadingDot.isOk, isTrue);
      expect(
        leadingDot.getOrNull(),
        const Color.fromRGBO(59, 130, 246, 0.5),
      );
      expect(trailingDot.isOk, isTrue);
      expect(trailingDot.getOrNull(), const Color(0xFF3B82F6));
      expect(exponent.isOk, isTrue);
      expect(exponent.getOrNull(), const Color.fromRGBO(59, 130, 246, 0.5));
    });

    test('parses six-digit hex strings', () {
      final result = colorSchema.safeParse('#3B82F6');

      expect(result.isOk, isTrue);
      expect(result.getOrNull(), const Color(0xFF3B82F6));
    });

    test('parses eight-digit CSS hex strings with trailing alpha', () {
      final result = colorSchema.safeParse('#3B82F680');

      expect(result.isOk, isTrue);
      expect(result.getOrNull(), const Color(0x803B82F6));
    });

    test('rejects malformed function names', () {
      final result = colorSchema.safeParse('hsl(59, 130, 246)');

      expect(result.isFail, isTrue);
    });

    test('rejects wrong arity', () {
      final result = colorSchema.safeParse('rgba(59, 130, 246)');

      expect(result.isFail, isTrue);
    });

    test('rejects out-of-range rgb values', () {
      final result = colorSchema.safeParse('rgba(256, 130, 246, 0.5)');

      expect(result.isFail, isTrue);
    });

    test('rejects alpha outside 0..1', () {
      final result = colorSchema.safeParse('rgba(59, 130, 246, 1.5)');

      expect(result.isFail, isTrue);
    });

    test('rejects negative alpha values', () {
      final result = colorSchema.safeParse('rgba(59, 130, 246, -0.1)');

      expect(result.isFail, isTrue);
    });

    test('rejects non-finite alpha values', () {
      final result = colorSchema.safeParse('rgba(59, 130, 246, NaN)');

      expect(result.isFail, isTrue);
    });

    test('rejects unsupported legacy integer payloads', () {
      final result = colorSchema.safeParse(0xFF336699);

      expect(result.isFail, isTrue);
    });
  });
}
