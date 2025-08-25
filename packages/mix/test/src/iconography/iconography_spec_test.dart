import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('IconographySpec', () {
    test('should create with default values', () {
      const spec = IconographySpec();

      expect(spec.size, isNull);
      expect(spec.fill, isNull);
      expect(spec.weight, isNull);
      expect(spec.grade, isNull);
      expect(spec.opticalSize, isNull);
      expect(spec.color, isNull);
      expect(spec.opacity, isNull);
      expect(spec.shadows, isNull);
      expect(spec.applyTextScaling, isNull);
    });

    test('should create with specific values', () {
      const shadows = [Shadow(color: Colors.black, offset: Offset(1, 1))];
      const spec = IconographySpec(
        size: 24.0,
        fill: 0.8,
        weight: 400.0,
        grade: 0.0,
        opticalSize: 24.0,
        color: Colors.blue,
        opacity: 0.9,
        shadows: shadows,
        applyTextScaling: true,
      );

      expect(spec.size, equals(24.0));
      expect(spec.fill, equals(0.8));
      expect(spec.weight, equals(400.0));
      expect(spec.grade, equals(0.0));
      expect(spec.opticalSize, equals(24.0));
      expect(spec.color, equals(Colors.blue));
      expect(spec.opacity, equals(0.9));
      expect(spec.shadows, equals(shadows));
      expect(spec.applyTextScaling, equals(true));
    });

    test('should copyWith correctly', () {
      const originalSpec = IconographySpec(
        size: 16.0,
        color: Colors.red,
        opacity: 0.8,
      );

      final copiedSpec = originalSpec.copyWith(
        size: 24.0,
        fill: 0.5,
      );

      expect(copiedSpec.size, equals(24.0));
      expect(copiedSpec.fill, equals(0.5));
      expect(copiedSpec.color, equals(Colors.red));
      expect(copiedSpec.opacity, equals(0.8));
      expect(copiedSpec.weight, isNull);
    });

    test('should lerp correctly', () {
      const spec1 = IconographySpec(
        size: 16.0,
        opacity: 0.5,
        applyTextScaling: false,
      );
      const spec2 = IconographySpec(
        size: 24.0,
        opacity: 1.0,
        applyTextScaling: true,
      );

      final lerpedSpec = spec1.lerp(spec2, 0.5);

      expect(lerpedSpec.size, equals(20.0));
      expect(lerpedSpec.opacity, equals(0.75));
      expect(lerpedSpec.applyTextScaling, equals(true)); // snap interpolation at t=0.5 takes the 'other' value
    });

    test('should lerp with null other', () {
      const spec1 = IconographySpec(size: 16.0);
      final lerpedSpec = spec1.lerp(null, 0.5);
      expect(lerpedSpec, equals(spec1));
    });

    test('should have correct equality', () {
      const spec1 = IconographySpec(
        size: 24.0,
        color: Colors.blue,
        opacity: 0.8,
      );
      const spec2 = IconographySpec(
        size: 24.0,
        color: Colors.blue,
        opacity: 0.8,
      );
      const spec3 = IconographySpec(
        size: 16.0,
        color: Colors.blue,
        opacity: 0.8,
      );

      expect(spec1, equals(spec2));
      expect(spec1, isNot(equals(spec3)));
    });

    test('should handle complex shadow interpolation', () {
      const shadow1 = Shadow(color: Colors.black, blurRadius: 2.0);
      const shadow2 = Shadow(color: Colors.grey, blurRadius: 4.0);
      const spec1 = IconographySpec(shadows: [shadow1]);
      const spec2 = IconographySpec(shadows: [shadow2]);

      final lerpedSpec = spec1.lerp(spec2, 0.5);
      expect(lerpedSpec.shadows, isNotNull);
      expect(lerpedSpec.shadows!.length, equals(1));
      expect(lerpedSpec.shadows![0].blurRadius, equals(3.0));
    });
  });
}