import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('TextStyleDto', () {
    test('from constructor sets all values correctly', () {
      final attr = TextStyleDto(
        color: Colors.red,
        fontVariations: const [],
      );
      final result = attr.resolve(EmptyMixData);
      expect(result.color, Colors.red);
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

      final merged = attr1.merge(attr2).resolve(EmptyMixData);

      expect(merged.color, Colors.blue);
      expect(merged.fontSize, 30.0);
      expect(merged.decoration, TextDecoration.lineThrough);
      expect(merged.decorationColor, Colors.red);
      expect(merged.decorationStyle, TextDecorationStyle.dotted);
      expect(merged.fontWeight, FontWeight.w100);
      expect(merged.fontStyle, FontStyle.normal);
      expect(merged.fontVariations, [const FontVariation('wght', 400)]);
      expect(merged.letterSpacing, 2.0);
      expect(merged.wordSpacing, 3.0);
      expect(merged.height, 3.0);
      expect(merged.textBaseline, TextBaseline.alphabetic);
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
      final textStyle = attr.resolve(EmptyMixData);
      expect(textStyle.color, Colors.red);
      expect(textStyle.fontSize, 24.0);
      expect(textStyle.decoration, TextDecoration.underline);
      expect(textStyle.decorationColor, Colors.blue);
      expect(textStyle.decorationStyle, TextDecorationStyle.dashed);
      expect(textStyle.fontWeight, FontWeight.bold);
      expect(textStyle.fontStyle, FontStyle.italic);
      expect(textStyle.fontVariations, [const FontVariation('wght', 900)]);
      expect(textStyle.letterSpacing, 1.0);
      expect(textStyle.wordSpacing, 2.0);
      expect(textStyle.height, 2.0);
      expect(textStyle.textBaseline, TextBaseline.ideographic);

      return const Placeholder();
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
      final attr = TextStyleDto.from(style);
      expect(attr, isA<TextStyleDto>());
      // Resolve the DTO to get actual values
      final resolved = attr.resolve(EmptyMixData);
      expect(resolved.color, Colors.blue);
      expect(resolved.fontSize, 18.0);
      expect(resolved.fontWeight, FontWeight.bold);
    },
  );

  // Token resolver test removed - not supported in current pattern
}
