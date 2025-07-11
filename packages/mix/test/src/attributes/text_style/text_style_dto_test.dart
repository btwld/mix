import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';

void main() {
  group('TextStyleDto', () {
    test('from constructor sets all values correctly', () {
      final attr = TextStyleDto(
        color: Colors.red,
        fontVariations: const [],
      );
      expect(attr, resolvesTo(const TextStyle(
        color: Colors.red,
        fontVariations: [],
      )));
    });
    test('merge returns merged object correctly', () {
      final attr1 = TextStyleDto(
        color: Colors.red,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        letterSpacing: 1.0,
        wordSpacing: 2.0,
        fontVariations: const [FontVariation('wght', 900)],
        textBaseline: TextBaseline.ideographic,
        decoration: TextDecoration.underline,
        decorationColor: Colors.blue,
        decorationStyle: TextDecorationStyle.dashed,
        height: 2.0,
      );

      final attr2 = TextStyleDto(
        color: Colors.blue,
        fontSize: 30.0,
        fontWeight: FontWeight.w100,
        fontStyle: FontStyle.normal,
        letterSpacing: 2.0,
        wordSpacing: 3.0,
        fontVariations: const [FontVariation('wght', 400)],
        textBaseline: TextBaseline.alphabetic,
        decoration: TextDecoration.lineThrough,
        decorationColor: Colors.red,
        decorationStyle: TextDecorationStyle.dotted,
        height: 3.0,
      );

      final merged = attr1.merge(attr2);

      expect(merged, resolvesTo(const TextStyle(
        color: Colors.blue,
        fontSize: 30.0,
        fontWeight: FontWeight.w100,
        fontStyle: FontStyle.normal,
        letterSpacing: 2.0,
        wordSpacing: 3.0,
        fontVariations: [FontVariation('wght', 400)],
        textBaseline: TextBaseline.alphabetic,
        decoration: TextDecoration.lineThrough,
        decorationColor: Colors.red,
        decorationStyle: TextDecorationStyle.dotted,
        height: 3.0,
      )));
    });
    test('resolve returns correct TextStyle with specific values', () {
      final attr = TextStyleDto(
        color: Colors.red,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        letterSpacing: 1.0,
        wordSpacing: 2.0,
        fontVariations: const [FontVariation('wght', 900)],
        textBaseline: TextBaseline.ideographic,
        decoration: TextDecoration.underline,
        decorationColor: Colors.blue,
        decorationStyle: TextDecorationStyle.dashed,
        height: 2.0,
      );
      
      expect(attr, resolvesTo(const TextStyle(
        color: Colors.red,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        letterSpacing: 1.0,
        wordSpacing: 2.0,
        fontVariations: [FontVariation('wght', 900)],
        textBaseline: TextBaseline.ideographic,
        decoration: TextDecoration.underline,
        decorationColor: Colors.blue,
        decorationStyle: TextDecorationStyle.dashed,
        height: 2.0,
      )));
    });
    test('Equality holds when all attributes are the same', () {
      final attr1 = TextStyleDto(
        color: Colors.red,
        fontVariations: const [],
      );
      final attr2 = TextStyleDto(
        color: Colors.red,
        fontVariations: const [],
      );
      expect(attr1, attr2);
    });
    test('Equality fails when attributes are different', () {
      final attr1 = TextStyleDto(
        color: Colors.red,
        fontVariations: const [],
      );
      final attr2 = TextStyleDto(
        color: Colors.blue,
        fontVariations: const [],
      );
      expect(attr1, isNot(attr2));
    });
  });
  // Token functionality test removed - not supported in current pattern

  test(
    'TextStyleExt toDto method converts TextStyle to TextStyleDto correctly',
    () {
      const style = TextStyle(
        color: Colors.blue,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      );
      final attr = TextStyleDto.value(style);
      expect(attr, isA<TextStyleDto>());
      expect(attr, resolvesTo(const TextStyle(
        color: Colors.blue,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      )));
    },
  );

  // Token resolver test removed - not supported in current pattern
}
