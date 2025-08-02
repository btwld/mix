import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('TextStyleMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final textStyleMix = TextStyleMix(
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
          inherit: false,
        );

        expectProp(textStyleMix.$color, Colors.blue);
        expectProp(textStyleMix.$backgroundColor, Colors.yellow);
        expectProp(textStyleMix.$fontSize, 16.0);
        expectProp(textStyleMix.$fontWeight, FontWeight.bold);
        expectProp(textStyleMix.$fontStyle, FontStyle.italic);
        expectProp(textStyleMix.$letterSpacing, 1.5);
        expectProp(textStyleMix.$wordSpacing, 2.0);
        expectProp(textStyleMix.$height, 1.2);
        expectProp(textStyleMix.$decorationThickness, 2.0);
        expectProp(textStyleMix.$fontFamily, 'Roboto');
        expectProp(textStyleMix.$decoration, TextDecoration.underline);
        expectProp(textStyleMix.$decorationColor, Colors.red);
        expectProp(textStyleMix.$decorationStyle, TextDecorationStyle.solid);
        expectProp(textStyleMix.$textBaseline, TextBaseline.alphabetic);
        expectProp(textStyleMix.$debugLabel, 'test-style');
        expectProp(textStyleMix.$inherit, false);
      });

      test('only constructor with lists creates correct properties', () {
        final textStyleMix = TextStyleMix(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
          shadows: [ShadowMix(blurRadius: 5.0, color: Colors.black)],
        );

        expect(textStyleMix.$fontFamilyFallback, hasLength(2));
        expectProp(textStyleMix.$fontFamilyFallback![0], 'Arial');
        expectProp(textStyleMix.$fontFamilyFallback![1], 'Helvetica');

        expect(textStyleMix.$shadows, hasLength(1));
        expect(textStyleMix.$shadows![0], isA<MixProp<Shadow>>());
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
          inherit: false,
        );

        final textStyleMix = TextStyleMix.value(textStyle);

        expectProp(textStyleMix.$color, Colors.green);
        expectProp(textStyleMix.$fontSize, 18.0);
        expectProp(textStyleMix.$fontWeight, FontWeight.w500);
        expectProp(textStyleMix.$fontStyle, FontStyle.normal);
        expectProp(textStyleMix.$letterSpacing, 0.5);
        expectProp(textStyleMix.$height, 1.4);
        expectProp(textStyleMix.$fontFamily, 'Arial');
        expectProp(textStyleMix.$decoration, TextDecoration.lineThrough);
        expectProp(textStyleMix.$inherit, false);
      });

      test('maybeValue returns null for null input', () {
        final result = TextStyleMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns TextStyleMix for non-null input', () {
        const textStyle = TextStyle(fontSize: 14.0);
        final result = TextStyleMix.maybeValue(textStyle);

        expect(result, isNotNull);
        expectProp(result!.$fontSize, 14.0);
      });
    });

    group('Factory Constructors', () {
      test('color factory creates TextStyleMix with color', () {
        final textStyleMix = TextStyleMix.color(Colors.green);

        expectProp(textStyleMix.$color, Colors.green);
        expect(textStyleMix.$backgroundColor, isNull);
        expect(textStyleMix.$fontSize, isNull);
        expect(textStyleMix.$fontWeight, isNull);
        expect(textStyleMix.$fontStyle, isNull);
        expect(textStyleMix.$letterSpacing, isNull);
        expect(textStyleMix.$wordSpacing, isNull);
        expect(textStyleMix.$textBaseline, isNull);
        expect(textStyleMix.$height, isNull);
        expect(textStyleMix.$decorationThickness, isNull);
        expect(textStyleMix.$fontFamily, isNull);
      });

      test(
        'backgroundColor factory creates TextStyleMix with backgroundColor',
        () {
          final textStyleMix = TextStyleMix.backgroundColor(Colors.yellow);

          expectProp(textStyleMix.$backgroundColor, Colors.yellow);
          expect(textStyleMix.$color, isNull);
          expect(textStyleMix.$fontSize, isNull);
          expect(textStyleMix.$fontWeight, isNull);
          expect(textStyleMix.$fontStyle, isNull);
          expect(textStyleMix.$letterSpacing, isNull);
          expect(textStyleMix.$wordSpacing, isNull);
          expect(textStyleMix.$textBaseline, isNull);
          expect(textStyleMix.$height, isNull);
          expect(textStyleMix.$decorationThickness, isNull);
          expect(textStyleMix.$fontFamily, isNull);
        },
      );

      test('fontSize factory creates TextStyleMix with fontSize', () {
        final textStyleMix = TextStyleMix.fontSize(18.0);

        expectProp(textStyleMix.$fontSize, 18.0);
        expect(textStyleMix.$color, isNull);
        expect(textStyleMix.$backgroundColor, isNull);
        expect(textStyleMix.$fontWeight, isNull);
        expect(textStyleMix.$fontStyle, isNull);
        expect(textStyleMix.$letterSpacing, isNull);
        expect(textStyleMix.$wordSpacing, isNull);
        expect(textStyleMix.$textBaseline, isNull);
        expect(textStyleMix.$height, isNull);
        expect(textStyleMix.$decorationThickness, isNull);
        expect(textStyleMix.$fontFamily, isNull);
      });

      test('fontWeight factory creates TextStyleMix with fontWeight', () {
        final textStyleMix = TextStyleMix.fontWeight(FontWeight.w600);

        expectProp(textStyleMix.$fontWeight, FontWeight.w600);
        expect(textStyleMix.$color, isNull);
        expect(textStyleMix.$backgroundColor, isNull);
        expect(textStyleMix.$fontSize, isNull);
        expect(textStyleMix.$fontStyle, isNull);
        expect(textStyleMix.$letterSpacing, isNull);
        expect(textStyleMix.$wordSpacing, isNull);
        expect(textStyleMix.$textBaseline, isNull);
        expect(textStyleMix.$height, isNull);
        expect(textStyleMix.$decorationThickness, isNull);
        expect(textStyleMix.$fontFamily, isNull);
      });

      test('fontStyle factory creates TextStyleMix with fontStyle', () {
        final textStyleMix = TextStyleMix.fontStyle(FontStyle.normal);

        expectProp(textStyleMix.$fontStyle, FontStyle.normal);
        expect(textStyleMix.$color, isNull);
        expect(textStyleMix.$backgroundColor, isNull);
        expect(textStyleMix.$fontSize, isNull);
        expect(textStyleMix.$fontWeight, isNull);
        expect(textStyleMix.$letterSpacing, isNull);
        expect(textStyleMix.$wordSpacing, isNull);
        expect(textStyleMix.$textBaseline, isNull);
        expect(textStyleMix.$height, isNull);
        expect(textStyleMix.$decorationThickness, isNull);
        expect(textStyleMix.$fontFamily, isNull);
      });

      test('letterSpacing factory creates TextStyleMix with letterSpacing', () {
        final textStyleMix = TextStyleMix.letterSpacing(2.5);

        expectProp(textStyleMix.$letterSpacing, 2.5);
        expect(textStyleMix.$color, isNull);
        expect(textStyleMix.$backgroundColor, isNull);
        expect(textStyleMix.$fontSize, isNull);
        expect(textStyleMix.$fontWeight, isNull);
        expect(textStyleMix.$fontStyle, isNull);
        expect(textStyleMix.$wordSpacing, isNull);
        expect(textStyleMix.$textBaseline, isNull);
        expect(textStyleMix.$height, isNull);
        expect(textStyleMix.$decorationThickness, isNull);
        expect(textStyleMix.$fontFamily, isNull);
      });

      test('wordSpacing factory creates TextStyleMix with wordSpacing', () {
        final textStyleMix = TextStyleMix.wordSpacing(3.0);

        expectProp(textStyleMix.$wordSpacing, 3.0);
        expect(textStyleMix.$color, isNull);
        expect(textStyleMix.$backgroundColor, isNull);
        expect(textStyleMix.$fontSize, isNull);
        expect(textStyleMix.$fontWeight, isNull);
        expect(textStyleMix.$fontStyle, isNull);
        expect(textStyleMix.$letterSpacing, isNull);
        expect(textStyleMix.$textBaseline, isNull);
        expect(textStyleMix.$height, isNull);
        expect(textStyleMix.$decorationThickness, isNull);
        expect(textStyleMix.$fontFamily, isNull);
      });

      test('textBaseline factory creates TextStyleMix with textBaseline', () {
        final textStyleMix = TextStyleMix.textBaseline(
          TextBaseline.ideographic,
        );

        expectProp(textStyleMix.$textBaseline, TextBaseline.ideographic);
        expect(textStyleMix.$color, isNull);
        expect(textStyleMix.$backgroundColor, isNull);
        expect(textStyleMix.$fontSize, isNull);
        expect(textStyleMix.$fontWeight, isNull);
        expect(textStyleMix.$fontStyle, isNull);
        expect(textStyleMix.$letterSpacing, isNull);
        expect(textStyleMix.$wordSpacing, isNull);
        expect(textStyleMix.$height, isNull);
        expect(textStyleMix.$decorationThickness, isNull);
        expect(textStyleMix.$fontFamily, isNull);
      });

      test('height factory creates TextStyleMix with height', () {
        final textStyleMix = TextStyleMix.height(1.5);

        expectProp(textStyleMix.$height, 1.5);
        expect(textStyleMix.$color, isNull);
        expect(textStyleMix.$backgroundColor, isNull);
        expect(textStyleMix.$fontSize, isNull);
        expect(textStyleMix.$fontWeight, isNull);
        expect(textStyleMix.$fontStyle, isNull);
        expect(textStyleMix.$letterSpacing, isNull);
        expect(textStyleMix.$wordSpacing, isNull);
        expect(textStyleMix.$textBaseline, isNull);
        expect(textStyleMix.$decorationThickness, isNull);
        expect(textStyleMix.$fontFamily, isNull);
      });

      test(
        'decorationThickness factory creates TextStyleMix with decorationThickness',
        () {
          final textStyleMix = TextStyleMix.decorationThickness(3.0);

          expectProp(textStyleMix.$decorationThickness, 3.0);
          expect(textStyleMix.$color, isNull);
          expect(textStyleMix.$backgroundColor, isNull);
          expect(textStyleMix.$fontSize, isNull);
          expect(textStyleMix.$fontWeight, isNull);
          expect(textStyleMix.$fontStyle, isNull);
          expect(textStyleMix.$letterSpacing, isNull);
          expect(textStyleMix.$wordSpacing, isNull);
          expect(textStyleMix.$textBaseline, isNull);
          expect(textStyleMix.$height, isNull);
          expect(textStyleMix.$fontFamily, isNull);
        },
      );

      test('fontFamily factory creates TextStyleMix with fontFamily', () {
        final textStyleMix = TextStyleMix.fontFamily('Helvetica');

        expectProp(textStyleMix.$fontFamily, 'Helvetica');
        expect(textStyleMix.$color, isNull);
        expect(textStyleMix.$backgroundColor, isNull);
        expect(textStyleMix.$fontSize, isNull);
        expect(textStyleMix.$fontWeight, isNull);
        expect(textStyleMix.$fontStyle, isNull);
        expect(textStyleMix.$letterSpacing, isNull);
        expect(textStyleMix.$wordSpacing, isNull);
        expect(textStyleMix.$textBaseline, isNull);
        expect(textStyleMix.$height, isNull);
        expect(textStyleMix.$decorationThickness, isNull);
      });

      test('decoration factory creates TextStyleMix with decoration', () {
        final textStyleMix = TextStyleMix.decoration(TextDecoration.underline);

        expectProp(textStyleMix.$decoration, TextDecoration.underline);
        expect(textStyleMix.$color, isNull);
        expect(textStyleMix.$backgroundColor, isNull);
        expect(textStyleMix.$fontSize, isNull);
        expect(textStyleMix.$fontWeight, isNull);
        expect(textStyleMix.$fontStyle, isNull);
        expect(textStyleMix.$letterSpacing, isNull);
        expect(textStyleMix.$wordSpacing, isNull);
        expect(textStyleMix.$textBaseline, isNull);
        expect(textStyleMix.$height, isNull);
        expect(textStyleMix.$decorationThickness, isNull);
        expect(textStyleMix.$fontFamily, isNull);
      });

      test(
        'decorationColor factory creates TextStyleMix with decorationColor',
        () {
          final textStyleMix = TextStyleMix.decorationColor(Colors.purple);

          expectProp(textStyleMix.$decorationColor, Colors.purple);
          expect(textStyleMix.$color, isNull);
          expect(textStyleMix.$backgroundColor, isNull);
          expect(textStyleMix.$fontSize, isNull);
          expect(textStyleMix.$fontWeight, isNull);
          expect(textStyleMix.$fontStyle, isNull);
          expect(textStyleMix.$letterSpacing, isNull);
          expect(textStyleMix.$wordSpacing, isNull);
          expect(textStyleMix.$textBaseline, isNull);
          expect(textStyleMix.$height, isNull);
          expect(textStyleMix.$decorationThickness, isNull);
          expect(textStyleMix.$fontFamily, isNull);
        },
      );

      test(
        'decorationStyle factory creates TextStyleMix with decorationStyle',
        () {
          final textStyleMix = TextStyleMix.decorationStyle(
            TextDecorationStyle.dashed,
          );

          expectProp(textStyleMix.$decorationStyle, TextDecorationStyle.dashed);
          expect(textStyleMix.$color, isNull);
          expect(textStyleMix.$backgroundColor, isNull);
          expect(textStyleMix.$fontSize, isNull);
          expect(textStyleMix.$fontWeight, isNull);
          expect(textStyleMix.$fontStyle, isNull);
          expect(textStyleMix.$letterSpacing, isNull);
          expect(textStyleMix.$wordSpacing, isNull);
          expect(textStyleMix.$textBaseline, isNull);
          expect(textStyleMix.$height, isNull);
          expect(textStyleMix.$decorationThickness, isNull);
          expect(textStyleMix.$fontFamily, isNull);
        },
      );

      test('debugLabel factory creates TextStyleMix with debugLabel', () {
        final textStyleMix = TextStyleMix.debugLabel('test-label');

        expectProp(textStyleMix.$debugLabel, 'test-label');
        expect(textStyleMix.$color, isNull);
        expect(textStyleMix.$backgroundColor, isNull);
        expect(textStyleMix.$fontSize, isNull);
        expect(textStyleMix.$fontWeight, isNull);
        expect(textStyleMix.$fontStyle, isNull);
        expect(textStyleMix.$letterSpacing, isNull);
        expect(textStyleMix.$wordSpacing, isNull);
        expect(textStyleMix.$textBaseline, isNull);
        expect(textStyleMix.$height, isNull);
        expect(textStyleMix.$decorationThickness, isNull);
        expect(textStyleMix.$fontFamily, isNull);
      });

      test(
        'fontFamilyFallback factory creates TextStyleMix with fontFamilyFallback',
        () {
          final fontFamilyFallback = ['Arial', 'Helvetica'];
          final textStyleMix = TextStyleMix.fontFamilyFallback(
            fontFamilyFallback,
          );

          expect(textStyleMix.$fontFamilyFallback?.length, 2);
          expectProp(textStyleMix.$fontFamilyFallback![0], 'Arial');
          expectProp(textStyleMix.$fontFamilyFallback![1], 'Helvetica');
          expect(textStyleMix.$color, isNull);
          expect(textStyleMix.$backgroundColor, isNull);
          expect(textStyleMix.$fontSize, isNull);
          expect(textStyleMix.$fontWeight, isNull);
          expect(textStyleMix.$fontStyle, isNull);
          expect(textStyleMix.$letterSpacing, isNull);
          expect(textStyleMix.$wordSpacing, isNull);
          expect(textStyleMix.$textBaseline, isNull);
          expect(textStyleMix.$height, isNull);
          expect(textStyleMix.$decorationThickness, isNull);
          expect(textStyleMix.$fontFamily, isNull);
        },
      );

      test('shadows factory creates TextStyleMix with shadows', () {
        final shadows = [ShadowMix(blurRadius: 5.0, color: Colors.black)];
        final textStyleMix = TextStyleMix.shadows(shadows);

        expect(textStyleMix.$shadows?.length, 1);
        expect(textStyleMix.$color, isNull);
        expect(textStyleMix.$backgroundColor, isNull);
        expect(textStyleMix.$fontSize, isNull);
        expect(textStyleMix.$fontWeight, isNull);
        expect(textStyleMix.$fontStyle, isNull);
        expect(textStyleMix.$letterSpacing, isNull);
        expect(textStyleMix.$wordSpacing, isNull);
        expect(textStyleMix.$textBaseline, isNull);
        expect(textStyleMix.$height, isNull);
        expect(textStyleMix.$decorationThickness, isNull);
        expect(textStyleMix.$fontFamily, isNull);
      });

      test('inherit factory creates TextStyleMix with inherit', () {
        final textStyleMix = TextStyleMix.inherit(false);

        expectProp(textStyleMix.$inherit, false);
        expect(textStyleMix.$color, isNull);
        expect(textStyleMix.$backgroundColor, isNull);
        expect(textStyleMix.$fontSize, isNull);
        expect(textStyleMix.$fontWeight, isNull);
        expect(textStyleMix.$fontStyle, isNull);
        expect(textStyleMix.$letterSpacing, isNull);
        expect(textStyleMix.$wordSpacing, isNull);
        expect(textStyleMix.$textBaseline, isNull);
        expect(textStyleMix.$height, isNull);
        expect(textStyleMix.$decorationThickness, isNull);
        expect(textStyleMix.$fontFamily, isNull);
      });
    });

    group('resolve', () {
      test('resolves to TextStyle with correct properties', () {
        final textStyleMix = TextStyleMix(
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
        final textStyleMix = TextStyleMix(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
          shadows: [
            ShadowMix(blurRadius: 5.0, color: Colors.black),
            ShadowMix(blurRadius: 10.0, color: Colors.grey),
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
        final textStyleMix = TextStyleMix(fontSize: 16.0);
        final merged = textStyleMix.merge(null);

        expect(merged, same(textStyleMix));
      });

      test('merges properties correctly', () {
        final first = TextStyleMix(
          color: Colors.blue,
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
        );

        final second = TextStyleMix(
          fontSize: 18.0,
          fontStyle: FontStyle.italic,
          letterSpacing: 1.0,
        );

        final merged = first.merge(second);

        expectProp(merged.$color, Colors.blue);
        expectProp(merged.$fontSize, 18.0);
        expectProp(merged.$fontWeight, FontWeight.normal);
        expectProp(merged.$fontStyle, FontStyle.italic);
        expectProp(merged.$letterSpacing, 1.0);
      });

      test('merges list properties correctly', () {
        final first = TextStyleMix(
          fontFamilyFallback: const ['Arial'],
          shadows: [ShadowMix(blurRadius: 5.0)],
        );

        final second = TextStyleMix(
          fontFamilyFallback: const ['Helvetica', 'Times'],
          shadows: [ShadowMix(blurRadius: 10.0)],
        );

        final merged = first.merge(second);

        expect(merged.$fontFamilyFallback, hasLength(3));
        expectProp(merged.$fontFamilyFallback![0], 'Arial');
        expectProp(merged.$fontFamilyFallback![1], 'Helvetica');
        expectProp(merged.$fontFamilyFallback![2], 'Times');

        expect(merged.$shadows, hasLength(1));
        // Verify the shadow was replaced (second shadow overwrites first)
        final resolvedShadow = merged.$shadows![0].resolveProp(
          MockBuildContext(),
        );
        expect(resolvedShadow.blurRadius, 10.0);
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final textStyleMix1 = TextStyleMix(
          color: Colors.blue,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        );

        final textStyleMix2 = TextStyleMix(
          color: Colors.blue,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        );

        expect(textStyleMix1, textStyleMix2);
        expect(textStyleMix1.hashCode, textStyleMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final textStyleMix1 = TextStyleMix(fontSize: 16.0);
        final textStyleMix2 = TextStyleMix(fontSize: 18.0);

        expect(textStyleMix1, isNot(textStyleMix2));
      });

      test('handles list equality correctly', () {
        final textStyleMix1 = TextStyleMix(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );

        final textStyleMix2 = TextStyleMix(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );

        final textStyleMix3 = TextStyleMix(
          fontFamilyFallback: const ['Arial', 'Times'],
        );

        expect(textStyleMix1, textStyleMix2);
        expect(textStyleMix1, isNot(textStyleMix3));
      });
    });

    group('Utility Methods', () {
      test('color utility works correctly', () {
        final textStyleMix = TextStyleMix().color(Colors.orange);

        expectProp(textStyleMix.$color, Colors.orange);
      });

      test('backgroundColor utility works correctly', () {
        final textStyleMix = TextStyleMix().backgroundColor(Colors.cyan);

        expectProp(textStyleMix.$backgroundColor, Colors.cyan);
      });

      test('fontSize utility works correctly', () {
        final textStyleMix = TextStyleMix().fontSize(20.0);

        expectProp(textStyleMix.$fontSize, 20.0);
      });

      test('fontWeight utility works correctly', () {
        final textStyleMix = TextStyleMix().fontWeight(FontWeight.w300);

        expectProp(textStyleMix.$fontWeight, FontWeight.w300);
      });

      test('fontStyle utility works correctly', () {
        final textStyleMix = TextStyleMix().fontStyle(FontStyle.italic);

        expectProp(textStyleMix.$fontStyle, FontStyle.italic);
      });

      test('letterSpacing utility works correctly', () {
        final textStyleMix = TextStyleMix().letterSpacing(1.8);

        expectProp(textStyleMix.$letterSpacing, 1.8);
      });

      test('wordSpacing utility works correctly', () {
        final textStyleMix = TextStyleMix().wordSpacing(2.5);

        expectProp(textStyleMix.$wordSpacing, 2.5);
      });

      test('textBaseline utility works correctly', () {
        final textStyleMix = TextStyleMix().textBaseline(
          TextBaseline.alphabetic,
        );

        expectProp(textStyleMix.$textBaseline, TextBaseline.alphabetic);
      });

      test('height utility works correctly', () {
        final textStyleMix = TextStyleMix().height(1.8);

        expectProp(textStyleMix.$height, 1.8);
      });

      test('decorationThickness utility works correctly', () {
        final textStyleMix = TextStyleMix().decorationThickness(2.5);

        expectProp(textStyleMix.$decorationThickness, 2.5);
      });

      test('fontFamily utility works correctly', () {
        final textStyleMix = TextStyleMix().fontFamily('Times');

        expectProp(textStyleMix.$fontFamily, 'Times');
      });

      test('decoration utility works correctly', () {
        final textStyleMix = TextStyleMix().decoration(TextDecoration.overline);

        expectProp(textStyleMix.$decoration, TextDecoration.overline);
      });

      test('decorationColor utility works correctly', () {
        final textStyleMix = TextStyleMix().decorationColor(Colors.pink);

        expectProp(textStyleMix.$decorationColor, Colors.pink);
      });

      test('decorationStyle utility works correctly', () {
        final textStyleMix = TextStyleMix().decorationStyle(
          TextDecorationStyle.dotted,
        );

        expectProp(textStyleMix.$decorationStyle, TextDecorationStyle.dotted);
      });

      test('debugLabel utility works correctly', () {
        final textStyleMix = TextStyleMix().debugLabel('utility-test');

        expectProp(textStyleMix.$debugLabel, 'utility-test');
      });

      test('fontFamilyFallback utility works correctly', () {
        final fontFamilyFallback = ['Georgia', 'serif'];
        final textStyleMix = TextStyleMix().fontFamilyFallback(
          fontFamilyFallback,
        );

        expect(textStyleMix.$fontFamilyFallback?.length, 2);
        expectProp(textStyleMix.$fontFamilyFallback![0], 'Georgia');
        expectProp(textStyleMix.$fontFamilyFallback![1], 'serif');
      });

      test('shadows utility works correctly', () {
        final shadows = [ShadowMix(blurRadius: 8.0, color: Colors.grey)];
        final textStyleMix = TextStyleMix().shadows(shadows);

        expect(textStyleMix.$shadows?.length, 1);
      });

      test('inherit utility works correctly', () {
        final textStyleMix = TextStyleMix().inherit(false);

        expectProp(textStyleMix.$inherit, false);
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final textStyleMix = TextStyleMix(
          color: Colors.red,
          backgroundColor: Colors.blue,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          letterSpacing: 1.5,
          wordSpacing: 2.0,
          textBaseline: TextBaseline.alphabetic,
          height: 1.2,
          decorationThickness: 2.0,
          fontFamily: 'Arial',
          decoration: TextDecoration.underline,
          decorationColor: Colors.green,
          decorationStyle: TextDecorationStyle.solid,
          debugLabel: 'test-style',
          fontFamilyFallback: ['Helvetica'],
          shadows: [ShadowMix(blurRadius: 5.0)],
        );

        expect(textStyleMix.props.length, 22);
        expect(textStyleMix.props, contains(textStyleMix.$color));
        expect(textStyleMix.props, contains(textStyleMix.$backgroundColor));
        expect(textStyleMix.props, contains(textStyleMix.$fontSize));
        expect(textStyleMix.props, contains(textStyleMix.$fontWeight));
        expect(textStyleMix.props, contains(textStyleMix.$fontStyle));
        expect(textStyleMix.props, contains(textStyleMix.$letterSpacing));
        expect(textStyleMix.props, contains(textStyleMix.$wordSpacing));
        expect(textStyleMix.props, contains(textStyleMix.$textBaseline));
        expect(textStyleMix.props, contains(textStyleMix.$height));
        expect(textStyleMix.props, contains(textStyleMix.$decorationThickness));
        expect(textStyleMix.props, contains(textStyleMix.$fontFamily));
        expect(textStyleMix.props, contains(textStyleMix.$decoration));
        expect(textStyleMix.props, contains(textStyleMix.$decorationColor));
        expect(textStyleMix.props, contains(textStyleMix.$decorationStyle));
        expect(textStyleMix.props, contains(textStyleMix.$debugLabel));
        expect(textStyleMix.props, contains(textStyleMix.$fontFamilyFallback));
        expect(textStyleMix.props, contains(textStyleMix.$shadows));
        expect(textStyleMix.props, contains(textStyleMix.$inherit));
      });
    });
  });
}
