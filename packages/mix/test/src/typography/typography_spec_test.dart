import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('TypographySpec', () {
    test('should create with default values', () {
      const spec = TypographySpec();

      expect(spec.style, isNull);
      expect(spec.textAlign, isNull);
      expect(spec.softWrap, isNull);
      expect(spec.overflow, isNull);
      expect(spec.maxLines, isNull);
      expect(spec.textWidthBasis, isNull);
      expect(spec.textHeightBehavior, isNull);
    });

    test('should create with specific values', () {
      const style = TextStyle(color: Colors.red);
      const spec = TypographySpec(
        style: style,
        textAlign: TextAlign.center,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        textWidthBasis: TextWidthBasis.longestLine,
      );

      expect(spec.style, equals(style));
      expect(spec.textAlign, equals(TextAlign.center));
      expect(spec.softWrap, equals(false));
      expect(spec.overflow, equals(TextOverflow.ellipsis));
      expect(spec.maxLines, equals(2));
      expect(spec.textWidthBasis, equals(TextWidthBasis.longestLine));
    });

    test('should copyWith correctly', () {
      const originalSpec = TypographySpec(
        style: TextStyle(color: Colors.red),
        textAlign: TextAlign.left,
      );

      final copiedSpec = originalSpec.copyWith(
        textAlign: TextAlign.center,
        overflow: TextOverflow.fade,
      );

      expect(copiedSpec.style, equals(originalSpec.style));
      expect(copiedSpec.textAlign, equals(TextAlign.center));
      expect(copiedSpec.overflow, equals(TextOverflow.fade));
      expect(copiedSpec.softWrap, isNull);
    });

    test('should lerp correctly', () {
      const spec1 = TypographySpec(
        style: TextStyle(fontSize: 12),
        maxLines: 1,
      );
      const spec2 = TypographySpec(
        style: TextStyle(fontSize: 18),
        maxLines: 3,
      );

      final lerpedSpec = spec1.lerp(spec2, 0.5);

      expect(lerpedSpec.style?.fontSize, equals(15));
      expect(lerpedSpec.maxLines, equals(3)); // snap interpolation at t=0.5 takes the 'other' value
    });

    test('should have correct equality', () {
      const spec1 = TypographySpec(
        style: TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      );
      const spec2 = TypographySpec(
        style: TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      );
      const spec3 = TypographySpec(
        style: TextStyle(color: Colors.blue),
        textAlign: TextAlign.center,
      );

      expect(spec1, equals(spec2));
      expect(spec1, isNot(equals(spec3)));
    });
  });
}