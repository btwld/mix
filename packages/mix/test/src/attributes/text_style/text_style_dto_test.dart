import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('TextStyleDto', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('main constructor creates TextStyleDto with all properties', () {
        final shadowDto = ShadowDto(
          color: Colors.black,
          offset: const Offset(2, 2),
          blurRadius: 4.0,
        );

        final dto = TextStyleDto(
          color: Colors.red,
          backgroundColor: Colors.yellow,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          letterSpacing: 1.5,
          debugLabel: 'test',
          wordSpacing: 2.0,
          textBaseline: TextBaseline.alphabetic,
          shadows: [shadowDto],
          fontFeatures: const [FontFeature.enable('liga')],
          decoration: TextDecoration.underline,
          decorationColor: Colors.blue,
          decorationStyle: TextDecorationStyle.dashed,
          fontVariations: const [FontVariation('wght', 400)],
          height: 1.2,
          foreground: Paint()..color = Colors.green,
          background: Paint()..color = Colors.white,
          decorationThickness: 2.0,
          fontFamily: 'Roboto',
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );

        expect(dto.color, resolvesTo(Colors.red));
        expect(dto.backgroundColor, resolvesTo(Colors.yellow));
        expect(dto.fontSize, resolvesTo(16.0));
        expect(dto.fontWeight, resolvesTo(FontWeight.bold));
        expect(dto.fontStyle, resolvesTo(FontStyle.italic));
        expect(dto.letterSpacing, resolvesTo(1.5));
        expect(dto.debugLabel, resolvesTo('test'));
        expect(dto.wordSpacing, resolvesTo(2.0));
        expect(dto.textBaseline, resolvesTo(TextBaseline.alphabetic));
        expect(dto.shadows?.length, 1);
        expect(dto.shadows?[0].mixValue, equals(shadowDto));
        expect(dto.fontFeatures?.length, 1);
        expect(dto.decoration, resolvesTo(TextDecoration.underline));
        expect(dto.decorationColor, resolvesTo(Colors.blue));
        expect(dto.decorationStyle, resolvesTo(TextDecorationStyle.dashed));
        expect(dto.fontVariations?.length, 1);
        expect(dto.height, resolvesTo(1.2));
        expect(dto.foreground?.value, isA<Paint>());
        expect(dto.background?.value, isA<Paint>());
        expect(dto.decorationThickness, resolvesTo(2.0));
        expect(dto.fontFamily, resolvesTo('Roboto'));
        expect(dto.fontFamilyFallback?.length, 2);
      });

      test('value constructor from TextStyle', () {
        const textStyle = TextStyle(
          color: Colors.blue,
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          decoration: TextDecoration.lineThrough,
          decorationColor: Colors.red,
          shadows: [
            Shadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 2.0),
          ],
        );

        final dto = TextStyleDto.value(textStyle);

        expect(dto.color, resolvesTo(Colors.blue));
        expect(dto.fontSize, resolvesTo(18.0));
        expect(dto.fontWeight, resolvesTo(FontWeight.w600));
        expect(dto.letterSpacing, resolvesTo(0.5));
        expect(dto.decoration, resolvesTo(TextDecoration.lineThrough));
        expect(dto.decorationColor, resolvesTo(Colors.red));
        expect(dto.shadows?.length, 1);
        expect(dto.shadows?[0].mixValue?.color, resolvesTo(Colors.grey));
      });

      test('props constructor with Prop values', () {
        const dto = TextStyleDto.props(
          color: Prop.value(Colors.green),
          fontSize: Prop.value(20.0),
          fontWeight: Prop.value(FontWeight.w300),
        );

        expect(dto.color, resolvesTo(Colors.green));
        expect(dto.fontSize, resolvesTo(20.0));
        expect(dto.fontWeight, resolvesTo(FontWeight.w300));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns TextStyleDto for non-null TextStyle', () {
        const textStyle = TextStyle(color: Colors.red, fontSize: 14.0);
        final dto = TextStyleDto.maybeValue(textStyle);

        expect(dto, isNotNull);
        expect(dto?.color, resolvesTo(Colors.red));
        expect(dto?.fontSize, resolvesTo(14.0));
      });

      test('maybeValue returns null for null TextStyle', () {
        final dto = TextStyleDto.maybeValue(null);
        expect(dto, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to TextStyle with all properties', () {
        final dto = TextStyleDto(
          color: Colors.purple,
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

        expect(
          dto,
          resolvesTo(
            const TextStyle(
              color: Colors.purple,
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
            ),
          ),
        );
      });

      test('resolves with default values for null properties', () {
        const dto = TextStyleDto.props();
        final context = createEmptyMixData();
        final resolved = dto.resolve(context);

        expect(resolved.color, isNull);
        expect(resolved.fontSize, isNull);
        expect(resolved.fontWeight, isNull);
      });

      test('resolves shadows correctly', () {
        final dto = TextStyleDto(
          shadows: [
            ShadowDto(
              color: Colors.black,
              offset: const Offset(2, 2),
              blurRadius: 4.0,
            ),
            ShadowDto(
              color: Colors.grey,
              offset: const Offset(1, 1),
              blurRadius: 2.0,
            ),
          ],
        );

        final context = createEmptyMixData();
        final resolved = dto.resolve(context);

        expect(resolved.shadows?.length, 2);
        expect(resolved.shadows?[0].color, Colors.black);
        expect(resolved.shadows?[1].color, Colors.grey);
      });

      test('resolves Paint properties correctly', () {
        final foregroundPaint = Paint()
          ..color = const Color(0xFFFF0000)
          ..strokeWidth = 2.0;
        final backgroundPaint = Paint()
          ..color = const Color(0xFF0000FF)
          ..style = PaintingStyle.fill;

        final dto = TextStyleDto(
          foreground: foregroundPaint,
          background: backgroundPaint,
        );

        final context = createEmptyMixData();
        final resolved = dto.resolve(context);

        expect(resolved.foreground?.color, const Color(0xFFFF0000));
        expect(resolved.foreground?.strokeWidth, 2.0);
        expect(resolved.background?.color, const Color(0xFF0000FF));
        expect(resolved.background?.style, PaintingStyle.fill);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another TextStyleDto - all properties', () {
        final dto1 = TextStyleDto(
          color: Colors.red,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          shadows: [ShadowDto(color: Colors.black, blurRadius: 2.0)],
          fontFeatures: const [FontFeature.enable('liga')],
          fontVariations: const [FontVariation('wght', 400)],
        );

        final dto2 = TextStyleDto(
          color: Colors.blue,
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
          wordSpacing: 2.0,
          shadows: [ShadowDto(color: Colors.grey, blurRadius: 4.0)],
          fontFeatures: const [FontFeature.enable('kern')],
          fontVariations: const [FontVariation('slnt', -10)],
        );

        final merged = dto1.merge(dto2);

        expect(merged.color, resolvesTo(Colors.blue));
        expect(merged.fontSize, resolvesTo(20.0));
        expect(merged.fontWeight, resolvesTo(FontWeight.bold));
        expect(merged.fontStyle, resolvesTo(FontStyle.italic));
        expect(merged.letterSpacing, resolvesTo(1.0));
        expect(merged.wordSpacing, resolvesTo(2.0));
        expect(merged.shadows?.length, 1);
        expect(merged.shadows?[0].mixValue?.color, resolvesTo(Colors.grey));
        expect(merged.fontFeatures?.length, 1);
        expect(merged.fontVariations?.length, 1);
      });

      test('merge with partial properties', () {
        final dto1 = TextStyleDto(
          color: Colors.red,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        );

        final dto2 = TextStyleDto(
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
          letterSpacing: 1.5,
        );

        final merged = dto1.merge(dto2);

        expect(merged.color, resolvesTo(Colors.red));
        expect(merged.fontSize, resolvesTo(20.0));
        expect(merged.fontWeight, resolvesTo(FontWeight.bold));
        expect(merged.fontStyle, resolvesTo(FontStyle.italic));
        expect(merged.letterSpacing, resolvesTo(1.5));
      });

      test('merge with null returns original', () {
        final dto = TextStyleDto(color: Colors.green, fontSize: 18.0);

        final merged = dto.merge(null);
        expect(merged, same(dto));
      });

      test('merge decoration properties', () {
        final dto1 = TextStyleDto(
          decoration: TextDecoration.underline,
          decorationColor: Colors.red,
          decorationStyle: TextDecorationStyle.solid,
          decorationThickness: 1.0,
        );

        final dto2 = TextStyleDto(
          decoration: TextDecoration.lineThrough,
          decorationColor: Colors.blue,
          decorationStyle: TextDecorationStyle.dashed,
          decorationThickness: 2.0,
        );

        final merged = dto1.merge(dto2);

        expect(merged.decoration, resolvesTo(TextDecoration.lineThrough));
        expect(merged.decorationColor, resolvesTo(Colors.blue));
        expect(merged.decorationStyle, resolvesTo(TextDecorationStyle.dashed));
        expect(merged.decorationThickness, resolvesTo(2.0));
      });

      test('merge font family properties', () {
        final dto1 = TextStyleDto(
          fontFamily: 'Roboto',
          fontFamilyFallback: const ['Arial'],
        );

        final dto2 = TextStyleDto(
          fontFamily: 'Helvetica',
          fontFamilyFallback: const ['Verdana', 'Georgia'],
        );

        final merged = dto1.merge(dto2);

        expect(merged.fontFamily, resolvesTo('Helvetica'));
        expect(merged.fontFamilyFallback?.length, 2);
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal TextStyleDtos', () {
        final dto1 = TextStyleDto(
          color: Colors.red,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontVariations: const [FontVariation('wght', 400)],
        );

        final dto2 = TextStyleDto(
          color: Colors.red,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontVariations: const [FontVariation('wght', 400)],
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equal TextStyleDtos', () {
        final dto1 = TextStyleDto(color: Colors.red, fontSize: 16.0);
        final dto2 = TextStyleDto(color: Colors.blue, fontSize: 16.0);

        expect(dto1, isNot(equals(dto2)));
      });

      test('equality with lists', () {
        final dto1 = TextStyleDto(
          shadows: [ShadowDto(color: Colors.black, blurRadius: 2.0)],
          fontFeatures: const [FontFeature.enable('liga')],
          fontVariations: const [FontVariation('wght', 400)],
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );

        final dto2 = TextStyleDto(
          shadows: [ShadowDto(color: Colors.black, blurRadius: 2.0)],
          fontFeatures: const [FontFeature.enable('liga')],
          fontVariations: const [FontVariation('wght', 400)],
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });
    });

    // Edge Cases
    group('Edge Cases', () {
      test('handles empty lists correctly', () {
        final dto = TextStyleDto(
          shadows: const [],
          fontFeatures: const [],
          fontVariations: const [],
          fontFamilyFallback: const [],
        );

        final context = createEmptyMixData();
        final resolved = dto.resolve(context);

        expect(resolved.shadows, isNull);
        expect(resolved.fontFeatures, isNull);
        expect(resolved.fontVariations, isNull);
        expect(resolved.fontFamilyFallback, isNull);
      });

      test('handles foreground paint without color', () {
        final foregroundPaint = Paint()..color = const Color(0xFF00FF00);

        final dto = TextStyleDto(foreground: foregroundPaint);

        final context = createEmptyMixData();
        final resolved = dto.resolve(context);

        // Only foreground is set
        expect(resolved.color, isNull);
        expect(resolved.foreground?.color, const Color(0xFF00FF00));
      });

      test('handles null debugLabel', () {
        final dto = TextStyleDto(color: Colors.red, debugLabel: null);

        final context = createEmptyMixData();
        final resolved = dto.resolve(context);

        expect(resolved.debugLabel, isNull);
      });

      test('handles extreme font weights', () {
        final dto1 = TextStyleDto(fontWeight: FontWeight.w100);
        final dto2 = TextStyleDto(fontWeight: FontWeight.w900);

        expect(dto1.fontWeight, resolvesTo(FontWeight.w100));
        expect(dto2.fontWeight, resolvesTo(FontWeight.w900));
      });

      test('handles negative letter spacing', () {
        final dto = TextStyleDto(letterSpacing: -0.5);
        expect(dto.letterSpacing, resolvesTo(-0.5));
      });
    });

    // Integration Tests
    group('Integration Tests', () {
      test('TextStyleDto used in Text widget context', () {
        final dto = TextStyleDto(
          color: Colors.black,
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto',
        );

        final context = createEmptyMixData();
        final resolved = dto.resolve(context);

        expect(resolved.color, Colors.black);
        expect(resolved.fontSize, 14.0);
        expect(resolved.fontWeight, FontWeight.normal);
        expect(resolved.fontFamily, 'Roboto');
      });

      test('complex merge scenario', () {
        final baseStyle = TextStyleDto(
          color: Colors.black,
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto',
        );

        final headingStyle = TextStyleDto(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        );

        final primaryStyle = TextStyleDto(color: Colors.blue);

        final merged = baseStyle.merge(headingStyle).merge(primaryStyle);

        expect(merged.color, resolvesTo(Colors.blue));
        expect(merged.fontSize, resolvesTo(24.0));
        expect(merged.fontWeight, resolvesTo(FontWeight.bold));
        expect(merged.fontFamily, resolvesTo('Roboto'));
      });
    });
  });
}
