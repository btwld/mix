import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('IconographySpecMix', () {
    test('should create with default values', () {
      final mix = IconographySpecMix();

      expect(mix.$size, isNull);
      expect(mix.$fill, isNull);
      expect(mix.$weight, isNull);
      expect(mix.$grade, isNull);
      expect(mix.$opticalSize, isNull);
      expect(mix.$color, isNull);
      expect(mix.$opacity, isNull);
      expect(mix.$shadows, isNull);
      expect(mix.$applyTextScaling, isNull);
    });

    test('should create with specific values', () {
      final shadows = [ShadowMix(color: Colors.black, blurRadius: 2.0)];
      final mix = IconographySpecMix(
        size: 24.0,
        fill: 0.8,
        weight: 400.0,
        color: Colors.blue,
        shadows: shadows,
      );

      expect(mix.$size, isNotNull);
      expect(mix.$fill, isNotNull);
      expect(mix.$weight, isNotNull);
      expect(mix.$color, isNotNull);
      expect(mix.$shadows, isNotNull);
    });

    test('should create with factory constructors', () {
      final mixFromSize = IconographySpecMix.size(24.0);
      final mixFromColor = IconographySpecMix.color(Colors.red);
      final mixFromOpacity = IconographySpecMix.opacity(0.8);
      final mixFromSmall = IconographySpecMix.small();
      final mixFromMedium = IconographySpecMix.medium();
      final mixFromLarge = IconographySpecMix.large();

      expect(mixFromSize.$size, isNotNull);
      expect(mixFromColor.$color, isNotNull);
      expect(mixFromOpacity.$opacity, isNotNull);
      expect(mixFromSmall.$size, isNotNull);
      expect(mixFromMedium.$size, isNotNull);
      expect(mixFromLarge.$size, isNotNull);
    });

    test('should create from IconographySpec value', () {
      const spec = IconographySpec(
        size: 20.0,
        color: Colors.green,
        opacity: 0.7,
        fill: 0.5,
      );

      final mix = IconographySpecMix.value(spec);

      expect(mix.$size, isNotNull);
      expect(mix.$color, isNotNull);
      expect(mix.$opacity, isNotNull);
      expect(mix.$fill, isNotNull);
    });

    test('should merge correctly', () {
      final mix1 = IconographySpecMix(
        size: 16.0,
        color: Colors.red,
      );
      final mix2 = IconographySpecMix(
        opacity: 0.8,
        fill: 0.6,
      );

      final merged = mix1.merge(mix2);

      expect(merged.$size, isNotNull);
      expect(merged.$color, isNotNull);
      expect(merged.$opacity, isNotNull);
      expect(merged.$fill, isNotNull);
    });

    test('should chain methods correctly', () {
      final chained = IconographySpecMix()
          .size(20.0)
          .color(Colors.purple)
          .opacity(0.9)
          .fill(0.7)
          .weight(500.0)
          .applyTextScaling(true);

      expect(chained.$size, isNotNull);
      expect(chained.$color, isNotNull);
      expect(chained.$opacity, isNotNull);
      expect(chained.$fill, isNotNull);
      expect(chained.$weight, isNotNull);
      expect(chained.$applyTextScaling, isNotNull);
    });

    testWidgets('should resolve correctly', (tester) async {
      final shadows = [ShadowMix(color: Colors.black, blurRadius: 3.0)];
      final mix = IconographySpecMix(
        size: 32.0,
        color: Colors.orange,
        opacity: 0.6,
        fill: 0.4,
        weight: 600.0,
        grade: 50.0,
        opticalSize: 32.0,
        shadows: shadows,
        applyTextScaling: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final resolved = mix.resolve(context);

              expect(resolved.size, equals(32.0));
              expect(resolved.color, equals(Colors.orange));
              expect(resolved.opacity, equals(0.6));
              expect(resolved.fill, equals(0.4));
              expect(resolved.weight, equals(600.0));
              expect(resolved.grade, equals(50.0));
              expect(resolved.opticalSize, equals(32.0));
              expect(resolved.shadows, isNotNull);
              expect(resolved.shadows!.length, equals(1));
              expect(resolved.applyTextScaling, equals(false));

              return Container();
            },
          ),
        ),
      );
    });

    test('should have correct equality', () {
      final mix1 = IconographySpecMix(
        size: 24.0,
        color: Colors.blue,
      );
      final mix2 = IconographySpecMix(
        size: 24.0,
        color: Colors.blue,
      );
      final mix3 = IconographySpecMix(
        size: 16.0,
        color: Colors.blue,
      );

      expect(mix1, equals(mix2));
      expect(mix1, isNot(equals(mix3)));
    });

    test('maybeValue should handle nulls', () {
      expect(IconographySpecMix.maybeValue(null), isNull);

      const spec = IconographySpec(size: 18.0, opacity: 0.5);
      final mix = IconographySpecMix.maybeValue(spec);
      expect(mix, isNotNull);
      expect(mix!.$size, isNotNull);
      expect(mix.$opacity, isNotNull);
    });

    test('should handle shadow mixing correctly', () {
      final shadows1 = [ShadowMix(color: Colors.red, blurRadius: 1.0)];
      final shadows2 = [ShadowMix(color: Colors.blue, blurRadius: 2.0)];
      
      final mix1 = IconographySpecMix(shadows: shadows1);
      final mix2 = IconographySpecMix(shadows: shadows2);
      
      final merged = mix1.merge(mix2);
      expect(merged.$shadows, isNotNull);
    });

    test('should handle all font variation properties', () {
      final mix = IconographySpecMix(
        weight: 700.0,
        grade: 25.0,
        opticalSize: 48.0,
        fill: 1.0,
      );

      expect(mix.$weight, isNotNull);
      expect(mix.$grade, isNotNull);
      expect(mix.$opticalSize, isNotNull);
      expect(mix.$fill, isNotNull);
    });

    test('should support factory shortcuts', () {
      final smallMix = IconographySpecMix.small();
      final mediumMix = IconographySpecMix.medium();
      final largeMix = IconographySpecMix.large();

      expect(smallMix.$size, isNotNull);
      expect(mediumMix.$size, isNotNull);
      expect(largeMix.$size, isNotNull);
    });
  });
}