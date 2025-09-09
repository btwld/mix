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

        expect(textStyleMix.$color, resolvesTo(Colors.blue));
        expect(textStyleMix.$backgroundColor, resolvesTo(Colors.yellow));
        expect(textStyleMix.$fontSize, resolvesTo(16.0));
        expect(textStyleMix.$fontWeight, resolvesTo(FontWeight.bold));
        expect(textStyleMix.$fontStyle, resolvesTo(FontStyle.italic));
        expect(textStyleMix.$letterSpacing, resolvesTo(1.5));
        expect(textStyleMix.$wordSpacing, resolvesTo(2.0));
        expect(textStyleMix.$height, resolvesTo(1.2));
        expect(textStyleMix.$decorationThickness, resolvesTo(2.0));
        expect(textStyleMix.$fontFamily, resolvesTo('Roboto'));
        expect(textStyleMix.$decoration, resolvesTo(TextDecoration.underline));
        expect(textStyleMix.$decorationColor, resolvesTo(Colors.red));
        expect(
          textStyleMix.$decorationStyle,
          resolvesTo(TextDecorationStyle.solid),
        );
        expect(textStyleMix.$textBaseline, resolvesTo(TextBaseline.alphabetic));
        expect(textStyleMix.$debugLabel, resolvesTo('test-style'));
        expect(textStyleMix.$inherit, resolvesTo(false));
      });

      test('only constructor with lists creates correct properties', () {
        final textStyleMix = TextStyleMix(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
          shadows: [ShadowMix(blurRadius: 5.0, color: Colors.black)],
        );

        expect(textStyleMix.$fontFamilyFallback, hasLength(2));
        expect(textStyleMix.$fontFamilyFallback![0], resolvesTo('Arial'));
        expect(textStyleMix.$fontFamilyFallback![1], resolvesTo('Helvetica'));

        expect(textStyleMix.$shadows, hasLength(1));
        expect(textStyleMix.$shadows![0], isA<Prop<Shadow>>());
      });

      test('value constructor extracts all properties from TextStyle', () {
        const textStyle = TextStyle(
          color: Colors.green,
          backgroundColor: Colors.red,
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.5,
          wordSpacing: 2.0,
          textBaseline: TextBaseline.alphabetic,
          height: 1.4,
          leadingDistribution: TextLeadingDistribution.even,
          locale: Locale('en', 'US'),
          shadows: [
            Shadow(
              blurRadius: 3.0,
              color: Colors.black,
              offset: Offset(1.0, 1.0),
            ),
            Shadow(
              blurRadius: 5.0,
              color: Colors.grey,
              offset: Offset(2.0, 2.0),
            ),
          ],
          fontFeatures: [
            FontFeature.enable('liga'),
            FontFeature.tabularFigures(),
          ],
          fontVariations: [
            FontVariation('wght', 700.0),
            FontVariation('wdth', 100.0),
          ],
          decoration: TextDecoration.lineThrough,
          decorationColor: Colors.purple,
          decorationStyle: TextDecorationStyle.dashed,
          decorationThickness: 2.5,
          debugLabel: 'test_style',
          fontFamily: 'Arial',
          fontFamilyFallback: ['Helvetica', 'sans-serif'],
          overflow: TextOverflow.ellipsis,
          inherit: false,
        );

        final textStyleMix = TextStyleMix.value(textStyle);

        // Test basic color properties
        expect(textStyleMix.$color, resolvesTo(Colors.green));
        expect(textStyleMix.$backgroundColor, resolvesTo(Colors.red));

        // Test font properties
        expect(textStyleMix.$fontSize, resolvesTo(18.0));
        expect(textStyleMix.$fontWeight, resolvesTo(FontWeight.w500));
        expect(textStyleMix.$fontStyle, resolvesTo(FontStyle.normal));
        expect(textStyleMix.$fontFamily, resolvesTo('Arial'));

        // Test spacing properties
        expect(textStyleMix.$letterSpacing, resolvesTo(0.5));
        expect(textStyleMix.$wordSpacing, resolvesTo(2.0));
        expect(textStyleMix.$height, resolvesTo(1.4));

        // Test baseline and debug properties
        expect(textStyleMix.$textBaseline, resolvesTo(TextBaseline.alphabetic));
        expect(textStyleMix.$debugLabel, resolvesTo('test_style'));

        // Test decoration properties
        expect(
          textStyleMix.$decoration,
          resolvesTo(TextDecoration.lineThrough),
        );
        expect(textStyleMix.$decorationColor, resolvesTo(Colors.purple));
        expect(
          textStyleMix.$decorationStyle,
          resolvesTo(TextDecorationStyle.dashed),
        );
        expect(textStyleMix.$decorationThickness, resolvesTo(2.5));

        // Test inherit property
        expect(textStyleMix.$inherit, resolvesTo(false));

        // Test list properties
        expect(textStyleMix.$shadows, isNotNull);
        expect(textStyleMix.$shadows, hasLength(2));
        // Verify shadows are converted to ShadowMix
        expect(textStyleMix.$shadows![0], isA<Prop<Shadow>>());
        expect(textStyleMix.$shadows![1], isA<Prop<Shadow>>());

        expect(textStyleMix.$fontFeatures, isNotNull);
        expect(textStyleMix.$fontFeatures, hasLength(2));
        expect(
          textStyleMix.$fontFeatures![0],
          resolvesTo(const FontFeature.enable('liga')),
        );
        expect(
          textStyleMix.$fontFeatures![1],
          resolvesTo(const FontFeature.tabularFigures()),
        );

        expect(textStyleMix.$fontVariations, isNotNull);
        expect(textStyleMix.$fontVariations, hasLength(2));
        expect(
          textStyleMix.$fontVariations![0],
          resolvesTo(const FontVariation('wght', 700.0)),
        );
        expect(
          textStyleMix.$fontVariations![1],
          resolvesTo(const FontVariation('wdth', 100.0)),
        );

        expect(textStyleMix.$fontFamilyFallback, isNotNull);
        expect(textStyleMix.$fontFamilyFallback, hasLength(2));
        expect(textStyleMix.$fontFamilyFallback![0], resolvesTo('Helvetica'));
        expect(textStyleMix.$fontFamilyFallback![1], resolvesTo('sans-serif'));

        // Note: leadingDistribution, locale, and overflow are not extracted by TextStyleMix.value()
        // as they are not part of the TextStyleMix properties
      });

      test('value constructor extracts Paint properties from TextStyle', () {
        // Create Paint objects for foreground and background
        final foregroundPaint = Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke;
        final backgroundPaint = Paint()
          ..color = Colors.yellow
          ..style = PaintingStyle.fill;

        // Note: TextStyle doesn't allow both color and foreground to be set
        // So we test with foreground/background Paint objects only
        final textStyle = TextStyle(
          fontSize: 20.0,
          foreground: foregroundPaint,
          background: backgroundPaint,
        );

        final textStyleMix = TextStyleMix.value(textStyle);

        // Test Paint properties
        expect(textStyleMix.$foreground, resolvesTo(foregroundPaint));
        expect(textStyleMix.$background, resolvesTo(backgroundPaint));
        expect(textStyleMix.$fontSize, resolvesTo(20.0));

        // Color should be null when foreground is provided
        expect(textStyleMix.$color, isNull);
        expect(textStyleMix.$backgroundColor, isNull);
      });

      test('maybeValue returns null for null input', () {
        final result = TextStyleMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns TextStyleMix for non-null input', () {
        const textStyle = TextStyle(fontSize: 14.0);
        final result = TextStyleMix.maybeValue(textStyle);

        expect(result, isNotNull);
        expect(result!.$fontSize, resolvesTo(14.0));
      });
    });

    group('Factory Constructors', () {
      test('color factory creates TextStyleMix with color', () {
        final textStyleMix = TextStyleMix.color(Colors.green);

        expect(textStyleMix.$color, resolvesTo(Colors.green));
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

          expect(textStyleMix.$backgroundColor, resolvesTo(Colors.yellow));
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

        expect(textStyleMix.$fontSize, resolvesTo(18.0));
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

        expect(textStyleMix.$fontWeight, resolvesTo(FontWeight.w600));
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

        expect(textStyleMix.$fontStyle, resolvesTo(FontStyle.normal));
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

        expect(textStyleMix.$letterSpacing, resolvesTo(2.5));
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

        expect(textStyleMix.$wordSpacing, resolvesTo(3.0));
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

        expect(
          textStyleMix.$textBaseline,
          resolvesTo(TextBaseline.ideographic),
        );
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

        expect(textStyleMix.$height, resolvesTo(1.5));
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

          expect(textStyleMix.$decorationThickness, resolvesTo(3.0));
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

        expect(textStyleMix.$fontFamily, resolvesTo('Helvetica'));
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

        expect(textStyleMix.$decoration, resolvesTo(TextDecoration.underline));
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

          expect(textStyleMix.$decorationColor, resolvesTo(Colors.purple));
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

          expect(
            textStyleMix.$decorationStyle,
            resolvesTo(TextDecorationStyle.dashed),
          );
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

        expect(textStyleMix.$debugLabel, resolvesTo('test-label'));
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
          expect(textStyleMix.$fontFamilyFallback![0], resolvesTo('Arial'));
          expect(textStyleMix.$fontFamilyFallback![1], resolvesTo('Helvetica'));
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

        expect(textStyleMix.$inherit, resolvesTo(false));
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

        expect(merged.$color, resolvesTo(Colors.blue));
        expect(merged.$fontSize, resolvesTo(18.0));
        expect(merged.$fontWeight, resolvesTo(FontWeight.normal));
        expect(merged.$fontStyle, resolvesTo(FontStyle.italic));
        expect(merged.$letterSpacing, resolvesTo(1.0));
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

        expect(merged.$fontFamilyFallback, hasLength(2));
        expect(merged.$fontFamilyFallback![0], resolvesTo('Helvetica'));
        expect(merged.$fontFamilyFallback![1], resolvesTo('Times'));

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

        expect(textStyleMix.$color, resolvesTo(Colors.orange));
      });

      test('backgroundColor utility works correctly', () {
        final textStyleMix = TextStyleMix().backgroundColor(Colors.cyan);

        expect(textStyleMix.$backgroundColor, resolvesTo(Colors.cyan));
      });

      test('fontSize utility works correctly', () {
        final textStyleMix = TextStyleMix().fontSize(20.0);

        expect(textStyleMix.$fontSize, resolvesTo(20.0));
      });

      test('fontWeight utility works correctly', () {
        final textStyleMix = TextStyleMix().fontWeight(FontWeight.w300);

        expect(textStyleMix.$fontWeight, resolvesTo(FontWeight.w300));
      });

      test('fontStyle utility works correctly', () {
        final textStyleMix = TextStyleMix().fontStyle(FontStyle.italic);

        expect(textStyleMix.$fontStyle, resolvesTo(FontStyle.italic));
      });

      test('letterSpacing utility works correctly', () {
        final textStyleMix = TextStyleMix().letterSpacing(1.8);

        expect(textStyleMix.$letterSpacing, resolvesTo(1.8));
      });

      test('wordSpacing utility works correctly', () {
        final textStyleMix = TextStyleMix().wordSpacing(2.5);

        expect(textStyleMix.$wordSpacing, resolvesTo(2.5));
      });

      test('textBaseline utility works correctly', () {
        final textStyleMix = TextStyleMix().textBaseline(
          TextBaseline.alphabetic,
        );

        expect(textStyleMix.$textBaseline, resolvesTo(TextBaseline.alphabetic));
      });

      test('height utility works correctly', () {
        final textStyleMix = TextStyleMix().height(1.8);

        expect(textStyleMix.$height, resolvesTo(1.8));
      });

      test('decorationThickness utility works correctly', () {
        final textStyleMix = TextStyleMix().decorationThickness(2.5);

        expect(textStyleMix.$decorationThickness, resolvesTo(2.5));
      });

      test('fontFamily utility works correctly', () {
        final textStyleMix = TextStyleMix().fontFamily('Times');

        expect(textStyleMix.$fontFamily, resolvesTo('Times'));
      });

      test('decoration utility works correctly', () {
        final textStyleMix = TextStyleMix().decoration(TextDecoration.overline);

        expect(textStyleMix.$decoration, resolvesTo(TextDecoration.overline));
      });

      test('decorationColor utility works correctly', () {
        final textStyleMix = TextStyleMix().decorationColor(Colors.pink);

        expect(textStyleMix.$decorationColor, resolvesTo(Colors.pink));
      });

      test('decorationStyle utility works correctly', () {
        final textStyleMix = TextStyleMix().decorationStyle(
          TextDecorationStyle.dotted,
        );

        expect(
          textStyleMix.$decorationStyle,
          resolvesTo(TextDecorationStyle.dotted),
        );
      });

      test('debugLabel utility works correctly', () {
        final textStyleMix = TextStyleMix().debugLabel('utility-test');

        expect(textStyleMix.$debugLabel, resolvesTo('utility-test'));
      });

      test('fontFamilyFallback utility works correctly', () {
        final fontFamilyFallback = ['Georgia', 'serif'];
        final textStyleMix = TextStyleMix().fontFamilyFallback(
          fontFamilyFallback,
        );

        expect(textStyleMix.$fontFamilyFallback?.length, 2);
        expect(textStyleMix.$fontFamilyFallback![0], resolvesTo('Georgia'));
        expect(textStyleMix.$fontFamilyFallback![1], resolvesTo('serif'));
      });

      test('shadows utility works correctly', () {
        final shadows = [ShadowMix(blurRadius: 8.0, color: Colors.grey)];
        final textStyleMix = TextStyleMix().shadows(shadows);

        expect(textStyleMix.$shadows?.length, 1);
      });

      test('inherit utility works correctly', () {
        final textStyleMix = TextStyleMix().inherit(false);

        expect(textStyleMix.$inherit, resolvesTo(false));
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
