import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexWidgetSpecUtility', () {
    group('Constructor', () {
      test('', () {
        final attribute = IconStyle(
          color: Colors.blue,
          size: 24.0,
          weight: 400.0,
          grade: 0.0,
          opticalSize: 24.0,
          shadows: [ShadowMix(color: Colors.black, offset: Offset(1, 1))],
          textDirection: TextDirection.ltr,
          applyTextScaling: true,
          fill: 1.0,
        );

        expect(attribute.$color, resolvesTo(Colors.blue));
        expect(attribute.$size, resolvesTo(24.0));
        expect(attribute.$weight, resolvesTo(400.0));
        expect(attribute.$grade, resolvesTo(0.0));
        expect(attribute.$opticalSize, resolvesTo(24.0));
        expect(attribute.$shadows, isNotNull);
        expect(attribute.$textDirection, resolvesTo(TextDirection.ltr));
        expect(attribute.$applyTextScaling, resolvesTo(true));
        expect(attribute.$fill, resolvesTo(1.0));
      });

      test('', () {
        final attribute = IconStyle();

        expect(attribute.$color, isNull);
        expect(attribute.$size, isNull);
        expect(attribute.$weight, isNull);
        expect(attribute.$grade, isNull);
        expect(attribute.$opticalSize, isNull);
        expect(attribute.$shadows, isNull);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$applyTextScaling, isNull);
        expect(attribute.$fill, isNull);
      });
    });

    group('Factory Constructors', () {
      test('', () {
        final iconMix = IconStyle.color(Colors.red);

        expect(iconMix.$color, resolvesTo(Colors.red));
      });

      test('', () {
        final iconMix = IconStyle.size(32.0);

        expect(iconMix.$size, resolvesTo(32.0));
      });

      test('', () {
        final iconMix = IconStyle.weight(500.0);

        expect(iconMix.$weight, resolvesTo(500.0));
      });

      test('', () {
        final animation = AnimationConfig.linear(Duration(seconds: 1));
        final iconMix = IconStyle.animate(animation);

        expect(iconMix.$animation, animation);
      });

      test('', () {
        final variant = ContextVariant.brightness(Brightness.dark);
        final style = IconStyle.color(Colors.white);
        final iconMix = IconStyle.variant(variant, style);

        expect(iconMix.$variants, isNotNull);
        expect(iconMix.$variants!.length, 1);
      });
    });

    group('value constructor', () {
      test('', () {
        const spec = IconWidgetSpec(
          color: Colors.green,
          size: 28.0,
          weight: 600.0,
        );

        final attribute = IconStyle.value(spec);

        expect(attribute.$color, resolvesTo(Colors.green));
        expect(attribute.$size, resolvesTo(28.0));
        expect(attribute.$weight, resolvesTo(600.0));
      });

      test('maybeValue returns null for null spec', () {
        expect(IconStyle.maybeValue(null), isNull);
      });

      test('maybeValue returns attribute for non-null spec', () {
        const spec = IconWidgetSpec(color: Colors.purple, size: 20.0);
        final attribute = IconStyle.maybeValue(spec);

        expect(attribute, isNotNull);
        expect(attribute!.$color, resolvesTo(Colors.purple));
        expect(attribute.$size, resolvesTo(20.0));
      });
    });

    group('Utility Methods', () {
      test('color utility works correctly', () {
        final attribute = IconStyle().color(Colors.orange);

        expect(attribute.$color, resolvesTo(Colors.orange));
      });

      test('size utility works correctly', () {
        final attribute = IconStyle().size(36.0);

        expect(attribute.$size, resolvesTo(36.0));
      });

      test('weight utility works correctly', () {
        final attribute = IconStyle().weight(700.0);

        expect(attribute.$weight, resolvesTo(700.0));
      });

      test('grade utility works correctly', () {
        final attribute = IconStyle().grade(25.0);

        expect(attribute.$grade, resolvesTo(25.0));
      });

      test('opticalSize utility works correctly', () {
        final attribute = IconStyle().opticalSize(48.0);

        expect(attribute.$opticalSize, resolvesTo(48.0));
      });

      test('textDirection utility works correctly', () {
        final attribute = IconStyle().textDirection(TextDirection.rtl);

        expect(attribute.$textDirection, resolvesTo(TextDirection.rtl));
      });

      test('applyTextScaling utility works correctly', () {
        final attribute = IconStyle().applyTextScaling(false);

        expect(attribute.$applyTextScaling, resolvesTo(false));
      });

      test('fill utility works correctly', () {
        final attribute = IconStyle().fill(0.5);

        expect(attribute.$fill, resolvesTo(0.5));
      });

      test('animate method sets animation config', () {
        final animation = AnimationConfig.linear(Duration(milliseconds: 500));
        final attribute = IconStyle().animate(animation);

        expect(attribute.$animation, equals(animation));
      });
    });

    group('Variant Methods', () {
      test('', () {
        final variant = ContextVariant.brightness(Brightness.dark);
        final style = IconStyle.color(Colors.white);
        final iconMix = IconStyle().variant(variant, style);

        expect(iconMix.$variants, isNotNull);
        expect(iconMix.$variants!.length, 1);
      });

      test('variants method sets multiple variants', () {
        final variants = [
          VariantStyle(
            ContextVariant.brightness(Brightness.dark),
            IconStyle.color(Colors.white),
          ),
          VariantStyle(
            ContextVariant.brightness(Brightness.light),
            IconStyle.color(Colors.black),
          ),
        ];
        final iconMix = IconStyle().variants(variants);

        expect(iconMix.$variants, isNotNull);
        expect(iconMix.$variants!.length, 2);
      });
    });

    group('Resolution', () {
      test('', () {
        final attribute = IconStyle(
          color: Colors.cyan,
          size: 36.0,
          weight: 700.0,
          grade: 50.0,
          opticalSize: 36.0,
          textDirection: TextDirection.ltr,
          applyTextScaling: true,
          fill: 1.0,
        );

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.color, Colors.cyan);
        expect(spec.size, 36.0);
        expect(spec.weight, 700.0);
        expect(spec.grade, 50.0);
        expect(spec.opticalSize, 36.0);
        expect(spec.textDirection, TextDirection.ltr);
        expect(spec.applyTextScaling, true);
        expect(spec.fill, 1.0);
      });

      test('resolves with null values correctly', () {
        final attribute = IconStyle().color(Colors.yellow).size(18.0);

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.color, Colors.yellow);
        expect(spec.size, 18.0);
        expect(spec.weight, isNull);
        expect(spec.grade, isNull);
        expect(spec.opticalSize, isNull);
        expect(spec.shadows, isNull);
        expect(spec.textDirection, isNull);
        expect(spec.applyTextScaling, isNull);
        expect(spec.fill, isNull);
      });
    });
  });
}
