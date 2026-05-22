import 'package:flutter_test/flutter_test.dart';
// ignore: implementation_imports
import 'package:mix_schema/src/core/numeric_codecs.dart';

void main() {
  group('doubleFromNum', () {
    final codec = doubleFromNum();

    test('rejects NaN on encode', () {
      final result = codec.safeEncode(double.nan);
      expect(result.isFail, isTrue);
    });

    test('rejects positive infinity on encode', () {
      final result = codec.safeEncode(double.infinity);
      expect(result.isFail, isTrue);
    });

    test('rejects negative infinity on encode', () {
      final result = codec.safeEncode(double.negativeInfinity);
      expect(result.isFail, isTrue);
    });

    test('rejects NaN on decode', () {
      final result = codec.safeParse(double.nan);
      expect(result.isFail, isTrue);
    });

    test('rejects positive infinity on decode', () {
      final result = codec.safeParse(double.infinity);
      expect(result.isFail, isTrue);
    });

    test('rejects negative infinity on decode', () {
      final result = codec.safeParse(double.negativeInfinity);
      expect(result.isFail, isTrue);
    });

    test('accepts finite doubles on encode', () {
      expect(codec.safeEncode(0.0).getOrThrow(), 0.0);
      expect(codec.safeEncode(-1.5).getOrThrow(), -1.5);
      expect(codec.safeEncode(1e9).getOrThrow(), 1e9);
    });

    test('decodes integer JSON literals to double', () {
      expect(codec.safeParse(7).getOrThrow(), 7.0);
    });

    test('decodes double JSON literals', () {
      expect(codec.safeParse(3.14).getOrThrow(), 3.14);
    });

    test('round-trips finite values', () {
      final encoded = codec.safeEncode(42.5).getOrThrow();
      expect(codec.safeParse(encoded).getOrThrow(), 42.5);
    });
  });
}
