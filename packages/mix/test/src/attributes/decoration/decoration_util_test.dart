import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('BoxDecorationUtility', () {
    final boxDecoration = BoxDecorationUtility(UtilityTestAttribute.new);
    test('call', () {
      final testBorder = Border.all(color: Colors.red, width: 2.0);
      final testBorderRadius = BorderRadius.circular(8.0);
      const testBoxShadow = [
        BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4.0),
      ];
      const testGradient = LinearGradient(
        colors: [Colors.blue, Colors.green],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

      final result = boxDecoration(
        border: testBorder,
        borderRadius: testBorderRadius,
        boxShadow: testBoxShadow,
        color: Colors.white,
        gradient: testGradient,
        shape: BoxShape.rectangle,
      );

      expect(result.value, isA<BoxDecorationDto>());
      expect(result.value.border?.mixValue, isA<BoxBorderDto>());
      expect(
        result.value.borderRadius?.mixValue,
        isA<BorderRadiusGeometryDto>(),
      );
      expect(
        result.value.boxShadow,
        isA<List<MixProp<BoxShadow, BoxShadowDto>>>(),
      );
      expect(result.value.color, resolvesTo(Colors.white));
      expect(result.value.gradient?.mixValue, isA<GradientDto>());
      expect(result.value.shape?.value, equals(BoxShape.rectangle));

      // Test that the values can be resolved correctly
      final resolved = result.value.resolve(EmptyMixData);
      expect(resolved.color, Colors.white);
      expect(resolved.shape, BoxShape.rectangle);
      expect(resolved.border, isA<Border>());
      expect(resolved.borderRadius, isA<BorderRadius>());
      expect(resolved.boxShadow, isA<List<BoxShadow>>());
      expect(resolved.boxShadow?.length, 1);
      expect(resolved.gradient, isA<LinearGradient>());
    });
    test('color setting', () {
      final result = boxDecoration.color(Colors.red);

      expect(result.value.color, resolvesTo(Colors.red));
    });

    test('shape setting', () {
      final result = boxDecoration.shape.circle();
      expect(result.value.shape, resolvesTo(BoxShape.circle));
    });

    test('border setting', () {
      final result = boxDecoration.border.all(color: Colors.red, width: 2.0);
      expect(
        result.value.border,
        resolvesTo(Border.all(color: Colors.red, width: 2.0)),
      );
    });

    test('borderRadius setting', () {
      final result = boxDecoration.borderRadius(10.0);
      expect(
        result.value.borderRadius,
        resolvesTo(BorderRadius.circular(10.0)),
      );
    });

    test('gradient setting', () {
      const gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.red, Colors.blue],
      );
      final result = boxDecoration.gradient.as(gradient);
      expect(
        result.value.gradient?.mixValue,
        equals(LinearGradientDto.maybeValue(gradient)),
      );
    });

    test('boxShadow setting', () {
      const boxShadow = BoxShadow(
        color: Colors.black,
        offset: Offset(5.0, 5.0),
        blurRadius: 10.0,
        spreadRadius: 2.0,
      );

      final result = boxDecoration.boxShadows([boxShadow]);

      final resultSingle = boxDecoration.boxShadow(
        blurRadius: 10.0,
        color: Colors.black,
        offset: const Offset(5.0, 5.0),
        spreadRadius: 2.0,
      );
      expect(result.value.boxShadow?.first, resolvesTo(boxShadow));
      expect(
        resultSingle.value.boxShadow?.first.mixValue,
        equals(BoxShadowDto.value(boxShadow)),
      );
    });

    test('elevation setting', () {
      final result = boxDecoration.elevation(9);
      final resolvedShadows = kElevationToShadow[9]!;
      expect(result.value.boxShadow?.length, equals(resolvedShadows.length));
      for (int i = 0; i < resolvedShadows.length; i++) {
        expect(result.value.boxShadow![i], resolvesTo(resolvedShadows[i]));
      }
    });
  });

  // ShapeDecorationUtility
  group('ShapeDecorationUtility', () {
    final shapeDecoration = ShapeDecorationUtility(UtilityTestAttribute.new);
    const boxShadow = BoxShadow(
      color: Colors.black,
      offset: Offset(5.0, 5.0),
      blurRadius: 10.0,
    );

    const linearGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.red, Colors.blue],
    );

    // call()
    test('call() returns correct instance', () {
      final result = shapeDecoration(
        gradient: linearGradient,
        shadows: const [boxShadow],
      );

      expect(result.value.color, isNull);
      expect(
        result.value.gradient?.mixValue,
        equals(LinearGradientDto.maybeValue(linearGradient)),
      );
      expect(
        result.value.shadows,
        isA<List<MixProp<BoxShadow, BoxShadowDto>>>(),
      );
      expect(result.value.shadows?.length, 1);

      // Test that it resolves correctly
      final resolved = result.value.resolve(EmptyMixData);
      expect(resolved.color, isNull);
      expect(resolved.gradient, isA<LinearGradient>());
      expect(resolved.shadows, isA<List<BoxShadow>>());
      expect(resolved.shadows?.length, 1);
      expect(resolved.shadows?.first.color, Colors.black);
      expect(resolved.shadows?.first.offset, const Offset(5.0, 5.0));
      expect(resolved.shadows?.first.blurRadius, 10.0);
    });

    // color()
    test('color() returns correct instance', () {
      final result = shapeDecoration.color(Colors.blue);

      expect(result.value.color, resolvesTo(Colors.blue));
    });

    // gradient()
    test('gradient() returns correct instance', () {
      final result = shapeDecoration.gradient.as(linearGradient);

      expect(
        result.value.gradient?.mixValue,
        equals(LinearGradientDto.maybeValue(linearGradient)),
      );
    });

    // shadows()
    test('shadows() returns correct instance', () {
      final result = shapeDecoration.shadows([boxShadow]);

      expect(result.value.shadows?.first, resolvesTo(boxShadow));
    });

    // shape()
    test('shape() returns correct instance', () {
      final result = shapeDecoration.shape.circle();

      expect(result.value.shape?.mixValue, equals(CircleBorderDto()));
    });
  });
}
