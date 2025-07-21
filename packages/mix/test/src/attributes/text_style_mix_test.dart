import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
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

        expect(textStyleMix.color, isProp(Colors.blue));
        expect(textStyleMix.backgroundColor, isProp(Colors.yellow));
        expect(textStyleMix.fontSize, isProp(16.0));
        expect(textStyleMix.fontWeight, isProp(FontWeight.bold));
        expect(textStyleMix.fontStyle, isProp(FontStyle.italic));
        expect(textStyleMix.letterSpacing, isProp(1.5));
        expect(textStyleMix.wordSpacing, isProp(2.0));
        expect(textStyleMix.height, isProp(1.2));
        expect(textStyleMix.decorationThickness, isProp(2.0));
        expect(textStyleMix.fontFamily, isProp('Roboto'));
        expect(textStyleMix.decoration, isProp(TextDecoration.underline));
        expect(textStyleMix.decorationColor, isProp(Colors.red));
        expect(textStyleMix.decorationStyle, isProp(TextDecorationStyle.solid));
        expect(textStyleMix.textBaseline, isProp(TextBaseline.alphabetic));
        expect(textStyleMix.debugLabel, isProp('test-style'));
      });

      test('only constructor with lists creates correct properties', () {
        final textStyleMix = TextStyleMix.only(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
          shadows: [ShadowMix.only(blurRadius: 5.0, color: Colors.black)],
        );

        expect(textStyleMix.fontFamilyFallback, hasLength(2));
        expect(textStyleMix.fontFamilyFallback![0], isProp('Arial'));
        expect(textStyleMix.fontFamilyFallback![1], isProp('Helvetica'));

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

        expect(textStyleMix.color, isProp(Colors.green));
        expect(textStyleMix.fontSize, isProp(18.0));
        expect(textStyleMix.fontWeight, isProp(FontWeight.w500));
        expect(textStyleMix.fontStyle, isProp(FontStyle.normal));
        expect(textStyleMix.letterSpacing, isProp(0.5));
        expect(textStyleMix.height, isProp(1.4));
        expect(textStyleMix.fontFamily, isProp('Arial'));
        expect(textStyleMix.decoration, isProp(TextDecoration.lineThrough));
      });

      test('maybeValue returns null for null input', () {
        final result = TextStyleMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns TextStyleMix for non-null input', () {
        const textStyle = TextStyle(fontSize: 14.0);
        final result = TextStyleMix.maybeValue(textStyle);

        expect(result, isNotNull);
        expect(result!.fontSize, isProp(14.0));
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

        final context = MockBuildContext();
        final resolved = textStyleMix.resolve(context);

        expect(resolved.color, Colors.blue);
        expect(resolved.fontSize, 16.0);
        expect(resolved.fontWeight, FontWeight.bold);
        expect(resolved.fontFamily, 'Roboto');
      });

      test('resolves with list properties', () {
        final textStyleMix = TextStyleMix.only(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
          shadows: [
            ShadowMix.only(blurRadius: 5.0, color: Colors.black),
            ShadowMix.only(blurRadius: 10.0, color: Colors.grey),
          ],
        );

        final context = MockBuildContext();
        final resolved = textStyleMix.resolve(context);

        expect(resolved.fontFamilyFallback, ['Arial', 'Helvetica']);
        expect(resolved.shadows, hasLength(2));
        expect(resolved.shadows![0].blurRadius, 5.0);
        expect(resolved.shadows![1].blurRadius, 10.0);
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

        expect(merged.color, isProp(Colors.blue));
        expect(merged.fontSize, isProp(18.0));
        expect(merged.fontWeight, isProp(FontWeight.normal));
        expect(merged.fontStyle, isProp(FontStyle.italic));
        expect(merged.letterSpacing, isProp(1.0));
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
        expect(merged.fontFamilyFallback![0], isProp('Arial'));
        expect(merged.fontFamilyFallback![1], isProp('Helvetica'));
        expect(merged.fontFamilyFallback![2], isProp('Times'));

        expect(merged.shadows, hasLength(2));
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
