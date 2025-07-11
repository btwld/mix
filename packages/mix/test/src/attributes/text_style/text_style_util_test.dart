import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('TextStyleUtility', () {
    final textStyle = TextStyleUtility(UtilityTestAttribute.new);
    test('call() creates TextStyleDto correctly', () {
      final yellowPaint = Paint()..color = Colors.yellow;
      final purplePaint = Paint()..color = Colors.purple;
      final attr = textStyle(
        backgroundColor: Colors.blue,
        color: Colors.red,
        debugLabel: 'debugLabel',
        decoration: TextDecoration.underline,
        decorationColor: Colors.green,
        decorationStyle: TextDecorationStyle.dashed,
        fontFamily: 'Roboto',
        fontFeatures: [const FontFeature.alternative(4)],
        fontSize: 16.0,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        height: 2.0,
        letterSpacing: 1.0,
        shadows: [
          const Shadow(
            color: Colors.black,
            offset: Offset(1.0, 1.0),
            blurRadius: 1.0,
          ),
        ],
        textBaseline: TextBaseline.ideographic,
        wordSpacing: 2.0,
        fontVariations: const [
          FontVariation('wght', 900),
        ],
      );

      final attrWithPaint = textStyle(
        background: purplePaint,
        foreground: yellowPaint,
      );

      final resolvedValue = attr.value.resolve(EmptyMixData);
      final resolvedWithPaint = attrWithPaint.value.resolve(EmptyMixData);

      expect(resolvedValue.fontWeight, FontWeight.bold);
      expect(resolvedValue.fontStyle, FontStyle.italic);
      expect(resolvedValue.fontSize, 16.0);
      expect(resolvedValue.letterSpacing, 1.0);
      expect(resolvedValue.wordSpacing, 2.0);
      expect(resolvedValue.textBaseline, TextBaseline.ideographic);
      expect(resolvedValue.shadows?.length, 1);
      expect(resolvedValue.shadows?.first.blurRadius, 1.0);
      expect(resolvedValue.shadows?.first.color, Colors.black);
      expect(resolvedValue.shadows?.first.offset, const Offset(1.0, 1.0));
      expect(resolvedValue.color, Colors.red);
      expect(resolvedValue.backgroundColor, Colors.blue);
      expect(resolvedValue.fontFeatures?.length, 1);
      expect(
        resolvedValue.fontFeatures?.first,
        const FontFeature.alternative(4),
      );
      expect(resolvedValue.decoration, TextDecoration.underline);
      expect(resolvedValue.decorationColor, Colors.green);
      expect(resolvedValue.decorationStyle, TextDecorationStyle.dashed);
      expect(resolvedValue.fontVariations, [const FontVariation('wght', 900)]);

      expect(resolvedValue.debugLabel, 'debugLabel');
      expect(resolvedValue.height, 2.0);
      expect(resolvedWithPaint.foreground, yellowPaint);
      expect(resolvedWithPaint.background, purplePaint);
    });

    test('color() creates TextStyleDto correctly', () {
      final attribute = textStyle(color: Colors.red);
      
      expect(attribute.value, resolvesTo(const TextStyle(color: Colors.red)));
    });

    test('backgroundColor() creates TextStyleDto correctly', () {
      final attribute = textStyle(backgroundColor: Colors.blue);
      
      expect(attribute.value, resolvesTo(const TextStyle(backgroundColor: Colors.blue)));
    });

    test('fontFamily() creates TextStyleDto correctly', () {
      final attribute = textStyle(fontFamily: 'Roboto');
      
      expect(attribute.value, resolvesTo(const TextStyle(fontFamily: 'Roboto')));
    });

    test('fontSize() creates TextStyleDto correctly', () {
      final attribute = textStyle(fontSize: 16.0);
      
      expect(attribute.value, resolvesTo(const TextStyle(fontSize: 16.0)));
    });

    test('fontWeight() creates TextStyleDto correctly', () {
      final attribute = textStyle.fontWeight.bold();
      
      expect(attribute.value, resolvesTo(const TextStyle(fontWeight: FontWeight.bold)));
    });

    test('fontStyle() creates TextStyleDto correctly', () {
      final attribute = textStyle.fontStyle.italic();
      
      expect(attribute.value, resolvesTo(const TextStyle(fontStyle: FontStyle.italic)));
    });

    test('letterSpacing() creates TextStyleDto correctly', () {
      final attribute = textStyle(letterSpacing: 1.0);
      
      expect(attribute.value, resolvesTo(const TextStyle(letterSpacing: 1.0)));
    });

    test('wordSpacing() creates TextStyleDto correctly', () {
      final attribute = textStyle(wordSpacing: 2.0);
      
      expect(attribute.value, resolvesTo(const TextStyle(wordSpacing: 2.0)));
    });

    test('textBaseline() creates TextStyleDto correctly', () {
      final attribute = textStyle.textBaseline.ideographic();
      
      expect(attribute.value, resolvesTo(const TextStyle(textBaseline: TextBaseline.ideographic)));
    });

    test('shadows() creates TextStyleDto correctly', () {
      const shadow = Shadow(
        color: Colors.black,
        offset: Offset(1.0, 1.0),
        blurRadius: 1.0,
      );
      final attribute = textStyle(
        shadows: [shadow],
      );

      final resolved = attribute.value.resolve(EmptyMixData);

      expect(resolved.shadows?.length, 1);
      expect(resolved.shadows?.first.blurRadius, 1.0);
      expect(resolved.shadows?.first.color, Colors.black);
      expect(resolved.shadows?.first.offset, const Offset(1.0, 1.0));
      expect(resolved.shadows?.first, shadow);
    });

    test('fontFeatures() creates TextStyleDto correctly', () {
      final attribute = textStyle.fontFeatures([
        const FontFeature.alternative(4),
      ]);

      final resolvedValue = attribute.value.resolve(EmptyMixData);

      expect(resolvedValue.fontFeatures?.length, 1);
      expect(
        resolvedValue.fontFeatures?.first,
        const FontFeature.alternative(4),
      );
    });

    test('decoration() creates TextStyleDto correctly', () {
      final attribute = textStyle.decoration.underline();
      
      expect(attribute.value, resolvesTo(const TextStyle(decoration: TextDecoration.underline)));
    });

    test('decorationColor() creates TextStyleDto correctly', () {
      final attribute = textStyle(decorationColor: Colors.green);
      
      expect(attribute.value, resolvesTo(const TextStyle(decorationColor: Colors.green)));
    });

    test('decorationStyle() creates TextStyleDto correctly', () {
      final attribute = textStyle.decorationStyle.dashed();
      
      expect(attribute.value, resolvesTo(const TextStyle(decorationStyle: TextDecorationStyle.dashed)));
    });

    test('foreground() creates TextStyleDto correctly', () {
      final yellowPaint = Paint()..color = Colors.yellow;
      final attribute = textStyle.foreground(yellowPaint);

      final resolvedValue = attribute.value.resolve(EmptyMixData);

      expect(resolvedValue.foreground, yellowPaint);
    });

    test('background() creates TextStyleDto correctly', () {
      final purplePaint = Paint()..color = Colors.purple;
      final attribute = textStyle.background(purplePaint);

      final resolvedValue = attribute.value.resolve(EmptyMixData);

      expect(resolvedValue.background, purplePaint);
    });

    test('fontVariations() creates TextStyleDto correctly', () {
      final attribute = textStyle(
        fontVariations: const [
          FontVariation('wght', 900),
        ],
      );

      final resolvedValue = attribute.value.resolve(EmptyMixData);

      expect(resolvedValue.fontVariations, [const FontVariation('wght', 900)]);
    });
  });
}
