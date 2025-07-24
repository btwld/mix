import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('TextStyleMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final textStyleMix = TextStyleMix.only(
          color: Colors.blue,
          backgroundColor: Colors.yellow,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          letterSpacing: 1.5,
          wordSpacing: 2.0,
          height: 1.2,
          decorationThickness: 2.0,
          fontFamily: 'Roboto',
          decoration: TextDecoration.underline,
          decorationColor: Colors.red,
          decorationStyle: TextDecorationStyle.solid,
          textBaseline: TextBaseline.alphabetic,
          debugLabel: 'test-style',
        );

        expectProp(textStyleMix.color, Colors.blue);
        expectProp(textStyleMix.backgroundColor, Colors.yellow);
        expectProp(textStyleMix.fontSize, 16.0);
        expectProp(textStyleMix.fontWeight, FontWeight.bold);
        expectProp(textStyleMix.fontStyle, FontStyle.italic);
        expectProp(textStyleMix.letterSpacing, 1.5);
        expectProp(textStyleMix.wordSpacing, 2.0);
        expectProp(textStyleMix.height, 1.2);
        expectProp(textStyleMix.decorationThickness, 2.0);
        expectProp(textStyleMix.fontFamily, 'Roboto');
        expectProp(textStyleMix.decoration, TextDecoration.underline);
        expectProp(textStyleMix.decorationColor, Colors.red);
        expectProp(textStyleMix.decorationStyle, TextDecorationStyle.solid);
        expectProp(textStyleMix.textBaseline, TextBaseline.alphabetic);
        expectProp(textStyleMix.debugLabel, 'test-style');
      });

      test('only constructor with lists creates correct properties', () {
        final textStyleMix = TextStyleMix.only(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
          shadows: [ShadowMix.only(blurRadius: 5.0, color: Colors.black)],
        );

        expect(textStyleMix.fontFamilyFallback, hasLength(2));
        expectProp(textStyleMix.fontFamilyFallback![0], 'Arial');
        expectProp(textStyleMix.fontFamilyFallback![1], 'Helvetica');

        expect(textStyleMix.shadows, hasLength(1));
        expect(textStyleMix.shadows![0], isA<MixProp<Shadow>>());
      });

      test('value constructor extracts properties from TextStyle', () {
        const textStyle = TextStyle(
          color: Colors.green,
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.5,
          height: 1.4,
          fontFamily: 'Arial',
          decoration: TextDecoration.lineThrough,
        );

        final textStyleMix = TextStyleMix.value(textStyle);

        expectProp(textStyleMix.color, Colors.green);
        expectProp(textStyleMix.fontSize, 18.0);
        expectProp(textStyleMix.fontWeight, FontWeight.w500);
        expectProp(textStyleMix.fontStyle, FontStyle.normal);
        expectProp(textStyleMix.letterSpacing, 0.5);
        expectProp(textStyleMix.height, 1.4);
        expectProp(textStyleMix.fontFamily, 'Arial');
        expectProp(textStyleMix.decoration, TextDecoration.lineThrough);
      });

      test('maybeValue returns null for null input', () {
        final result = TextStyleMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns TextStyleMix for non-null input', () {
        const textStyle = TextStyle(fontSize: 14.0);
        final result = TextStyleMix.maybeValue(textStyle);

        expect(result, isNotNull);
        expectProp(result!.fontSize, 14.0);
      });
    });

    group('resolve', () {
      test('resolves to TextStyle with correct properties', () {
        final textStyleMix = TextStyleMix.only(
          color: Colors.blue,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        );

        const resolvedValue = TextStyle(
          color: Colors.blue,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        );

        expect(textStyleMix, resolvesTo(resolvedValue));
      });

      test('resolves with list properties', () {
        final textStyleMix = TextStyleMix.only(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
          shadows: [
            ShadowMix.only(blurRadius: 5.0, color: Colors.black),
            ShadowMix.only(blurRadius: 10.0, color: Colors.grey),
          ],
        );

        const resolvedValue = TextStyle(
          fontFamilyFallback: ['Arial', 'Helvetica'],
          shadows: [
            Shadow(blurRadius: 5.0, color: Colors.black),
            Shadow(blurRadius: 10.0, color: Colors.grey),
          ],
        );

        expect(textStyleMix, resolvesTo(resolvedValue));
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final textStyleMix = TextStyleMix.only(fontSize: 16.0);
        final merged = textStyleMix.merge(null);

        expect(merged, same(textStyleMix));
      });

      test('merges properties correctly', () {
        final first = TextStyleMix.only(
          color: Colors.blue,
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
        );

        final second = TextStyleMix.only(
          fontSize: 18.0,
          fontStyle: FontStyle.italic,
          letterSpacing: 1.0,
        );

        final merged = first.merge(second);

        expectProp(merged.color, Colors.blue);
        expectProp(merged.fontSize, 18.0);
        expectProp(merged.fontWeight, FontWeight.normal);
        expectProp(merged.fontStyle, FontStyle.italic);
        expectProp(merged.letterSpacing, 1.0);
      });

      test('merges list properties correctly', () {
        final first = TextStyleMix.only(
          fontFamilyFallback: const ['Arial'],
          shadows: [ShadowMix.only(blurRadius: 5.0)],
        );

        final second = TextStyleMix.only(
          fontFamilyFallback: const ['Helvetica', 'Times'],
          shadows: [ShadowMix.only(blurRadius: 10.0)],
        );

        final merged = first.merge(second);

        expect(merged.fontFamilyFallback, hasLength(3));
        expectProp(merged.fontFamilyFallback![0], 'Arial');
        expectProp(merged.fontFamilyFallback![1], 'Helvetica');
        expectProp(merged.fontFamilyFallback![2], 'Times');

        expect(merged.shadows, hasLength(1));
        // Verify the shadow was replaced (second shadow overwrites first)
        final resolvedShadow = merged.shadows![0].resolve(MockBuildContext());
        expect(resolvedShadow.blurRadius, 10.0);
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final textStyleMix1 = TextStyleMix.only(
          color: Colors.blue,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        );

        final textStyleMix2 = TextStyleMix.only(
          color: Colors.blue,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        );

        expect(textStyleMix1, textStyleMix2);
        expect(textStyleMix1.hashCode, textStyleMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final textStyleMix1 = TextStyleMix.only(fontSize: 16.0);
        final textStyleMix2 = TextStyleMix.only(fontSize: 18.0);

        expect(textStyleMix1, isNot(textStyleMix2));
      });

      test('handles list equality correctly', () {
        final textStyleMix1 = TextStyleMix.only(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );

        final textStyleMix2 = TextStyleMix.only(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );

        final textStyleMix3 = TextStyleMix.only(
          fontFamilyFallback: const ['Arial', 'Times'],
        );

        expect(textStyleMix1, textStyleMix2);
        expect(textStyleMix1, isNot(textStyleMix3));
      });
    });
  });
}
