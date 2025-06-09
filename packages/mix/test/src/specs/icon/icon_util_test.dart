import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('IconUtility', () {
    final iconUtility = IconSpecUtility(MixUtility.selfBuilder);

    test('only() returns correct instance', () {
      final icon = iconUtility.only(
        color: const ColorDto(Colors.red),
        size: 24.0,
        textDirection: TextDirection.ltr,
        weight: 500.0,
        grade: 200.0,
        opticalSize: 48.0,
        fill: 1.0,
        applyTextScaling: false,
      );

      expect(icon.color, const ColorDto(Colors.red));
      expect(icon.size, 24.0);
      expect(icon.textDirection, TextDirection.ltr);
      expect(icon.weight, 500.0);
      expect(icon.grade, 200.0);
      expect(icon.opticalSize, 48.0);
      expect(icon.fill, 1.0);
      expect(icon.applyTextScaling, false);
    });

    test('color utility returns correct instance', () {
      final icon = iconUtility.color(Colors.blue);
      expect(icon.color, const ColorDto(Colors.blue));
    });

    test('size utility returns correct instance', () {
      final icon = iconUtility.size(32.0);
      expect(icon.size, 32.0);
    });

    test('textDirection utility returns correct instance', () {
      final icon = iconUtility.textDirection(TextDirection.rtl);
      expect(icon.textDirection, TextDirection.rtl);
    });

    test('shadows utility returns correct instance', () {
      const shadow = ShadowDto(
        color: ColorDto(Colors.black),
        offset: Offset(2, 2),
        blurRadius: 4,
      );
      final icon = iconUtility.only(shadows: [shadow]);
      expect(icon.shadows, [shadow]);
    });

    test('grade utility returns correct instance', () {
      final icon = iconUtility.grade(200);
      expect(icon.grade, 200);
    });

    test('weight utility returns correct instance', () {
      final icon = iconUtility.weight(500);
      expect(icon.weight, 500);
    });

    test('opticalSize utility returns correct instance', () {
      final icon = iconUtility.opticalSize(48);
      expect(icon.opticalSize, 48);
    });

    test('fill utility returns correct instance', () {
      final icon = iconUtility.fill(1);
      expect(icon.fill, 1);
    });

    test('applyTextScaling utility returns correct instance', () {
      final icon = iconUtility.applyTextScaling(false);
      expect(icon.applyTextScaling, false);
    });

    group('Fluent chaining', () {
      test('should chain multiple properties', () {
        final icon = iconUtility.chain
          ..color.red()
          ..size(20)
          ..weight(600);

        expect(icon.attributeValue!.color, const ColorDto(Colors.red));
        expect(icon.attributeValue!.size, 20);
        expect(icon.attributeValue!.weight, 600);
      });
    });

    group('Immutability', () {
      test('should create new instances on each call', () {
        final icon1 = iconUtility.color(Colors.red);
        final icon2 = iconUtility.color(Colors.blue);

        expect(icon1, isNot(same(icon2)));
        expect(icon1.color, isNot(equals(icon2.color)));
      });
    });

    group('Integration with Style', () {
      test('should work within Style composition', () {
        final style = Style(
          iconUtility.color(Colors.green),
          iconUtility.size(28),
        );

        expect(style.styles.length,
            1); // Attributes are merged into one IconSpecAttribute
      });
    });
  });
}
