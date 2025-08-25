import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('TypographySpecMix', () {
    test('should create with default values', () {
      final mix = TypographySpecMix();

      expect(mix.$style, isNull);
      expect(mix.$textAlign, isNull);
      expect(mix.$softWrap, isNull);
      expect(mix.$overflow, isNull);
      expect(mix.$maxLines, isNull);
      expect(mix.$textWidthBasis, isNull);
      expect(mix.$textHeightBehavior, isNull);
    });

    test('should create with TextStyleMix', () {
      final styleMix = TextStyleMix(color: Colors.red);
      final mix = TypographySpecMix(style: styleMix);

      expect(mix.$style, isNotNull);
      expect(mix.$textAlign, isNull);
    });

    test('should create with factory constructors', () {
      final mixFromStyle = TypographySpecMix.style(TextStyleMix(fontSize: 16));
      final mixFromAlign = TypographySpecMix.textAlign(TextAlign.center);
      final mixFromOverflow = TypographySpecMix.overflow(TextOverflow.ellipsis);

      expect(mixFromStyle.$style, isNotNull);
      expect(mixFromAlign.$textAlign, isNotNull);
      expect(mixFromOverflow.$overflow, isNotNull);
    });

    test('should create from TypographySpec value', () {
      const spec = TypographySpec(
        style: TextStyle(color: Colors.blue),
        textAlign: TextAlign.right,
        maxLines: 2,
      );

      final mix = TypographySpecMix.value(spec);

      expect(mix.$style, isNotNull);
      expect(mix.$textAlign, isNotNull);
      expect(mix.$maxLines, isNotNull);
    });

    test('should merge correctly', () {
      final mix1 = TypographySpecMix(
        style: TextStyleMix(fontSize: 14),
        textAlign: TextAlign.left,
      );
      final mix2 = TypographySpecMix(
        style: TextStyleMix(color: Colors.green),
        overflow: TextOverflow.fade,
      );

      final merged = mix1.merge(mix2);

      expect(merged.$style, isNotNull);
      expect(merged.$textAlign, isNotNull);
      expect(merged.$overflow, isNotNull);
    });

    test('should chain methods correctly', () {
      final chained = TypographySpecMix()
          .fontSize(18)
          .color(Colors.purple)
          .textAlign(TextAlign.center)
          .maxLines(3);

      expect(chained.$style, isNotNull);
      expect(chained.$textAlign, isNotNull);
      expect(chained.$maxLines, isNotNull);
    });

    testWidgets('should resolve correctly', (tester) async {
      final mix = TypographySpecMix(
        style: TextStyleMix(fontSize: 16, color: Colors.red),
        textAlign: TextAlign.center,
        maxLines: 2,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final resolved = mix.resolve(context);

              expect(resolved.style?.fontSize, equals(16));
              expect(resolved.style?.color, equals(Colors.red));
              expect(resolved.textAlign, equals(TextAlign.center));
              expect(resolved.maxLines, equals(2));

              return Container();
            },
          ),
        ),
      );
    });

    test('should have correct equality', () {
      final mix1 = TypographySpecMix(
        style: TextStyleMix(color: Colors.red),
        textAlign: TextAlign.center,
      );
      final mix2 = TypographySpecMix(
        style: TextStyleMix(color: Colors.red),
        textAlign: TextAlign.center,
      );
      final mix3 = TypographySpecMix(
        style: TextStyleMix(color: Colors.blue),
        textAlign: TextAlign.center,
      );

      expect(mix1, equals(mix2));
      expect(mix1, isNot(equals(mix3)));
    });

    test('maybeValue should handle nulls', () {
      expect(TypographySpecMix.maybeValue(null), isNull);

      const spec = TypographySpec(textAlign: TextAlign.justify);
      final mix = TypographySpecMix.maybeValue(spec);
      expect(mix, isNotNull);
      expect(mix!.$textAlign, isNotNull);
    });
  });
}