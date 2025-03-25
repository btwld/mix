import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/attribute_generator.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('BoxDecorationUtility', () {
    final boxDecoration = BoxDecorationUtility(UtilityTestAttribute.new);
    test('call', () {
      final refBoxDecoration = RandomGenerator.boxDecoration();

      final result = boxDecoration(
        border: refBoxDecoration.border,
        borderRadius: refBoxDecoration.borderRadius,
        boxShadow: refBoxDecoration.boxShadow,
        color: refBoxDecoration.color,
        gradient: refBoxDecoration.gradient,
        shape: refBoxDecoration.shape,
      );

      expect(result.value, equals(refBoxDecoration.toDto()));

      expect(result.value, isA<BoxDecorationDto>());
      expect(result.value.border, isA<BoxBorderDto>());
      expect(result.value.borderRadius, isA<BorderRadiusGeometryDto>());
      expect(result.value.boxShadow, isA<List<BoxShadowDto>>());
      expect(result.value.color, isA<ColorDto>());
      expect(result.value.gradient, isA<GradientDto>());
      expect(result.value.shape, isA<BoxShape>());

      expect(
        result.value.border,
        equals(refBoxDecoration.border!.toDto()),
      );
      expect(
        result.value.borderRadius,
        equals(refBoxDecoration.borderRadius!.toDto()),
      );
      expect(
        result.value.boxShadow,
        equals(refBoxDecoration.boxShadow?.map((e) => e.toDto())),
      );
      expect(result.value.color, equals(refBoxDecoration.color!.toDto()));
      expect(
        result.value.gradient,
        equals(refBoxDecoration.gradient!.toDto()),
      );
      expect(result.value.shape, equals(refBoxDecoration.shape));
    });
    test('color setting', () {
      final result = boxDecoration.color(Colors.red);

      expect(result.value.color, equals(Colors.red.toDto()));
    });

    test('shape setting', () {
      final result = boxDecoration.shape.circle();
      expect(result.value.shape, equals(BoxShape.circle));
    });

    test('border setting', () {
      final result = boxDecoration.border.all(color: Colors.red, width: 2.0);
      expect(
        result.value.border?.resolve(EmptyMixData),
        equals(Border.all(color: Colors.red, width: 2.0)),
      );
    });

    test('borderRadius setting', () {
      final result = boxDecoration.borderRadius(10.0);
      expect(
        result.value.borderRadius?.resolve(EmptyMixData),
        equals(BorderRadius.circular(10.0)),
      );
    });

    test('gradient setting', () {
      const gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.red, Colors.blue],
      );
      final result = boxDecoration.gradient.as(gradient);
      expect(result.value.gradient, equals(gradient.toDto()));
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
      expect(result.value.boxShadow, equals([boxShadow].toDto()));
      expect(resultSingle.value.boxShadow?.first, equals(boxShadow.toDto()));
    });

    test('elevation setting', () {
      final result = boxDecoration.elevation(9);
      final boxShadows =
          result.value.boxShadow?.map((e) => e.resolve(EmptyMixData));
      expect(boxShadows, equals(kElevationToShadow[9]!));
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
        color: Colors.blue,
        gradient: linearGradient,
        shadows: const [boxShadow],
      );

      expect(result.value.color, equals(Colors.blue.toDto()));
      expect(
        result.value.gradient,
        equals(linearGradient.toDto()),
      );
      expect(
        result.value.shadows,
        equals(const [boxShadow].map((e) => e.toDto()).toList()),
      );
    });

    // color()
    test('color() returns correct instance', () {
      final result = shapeDecoration.color(Colors.blue);

      expect(result.value.color, equals(Colors.blue.toDto()));
    });

    // gradient()
    test('gradient() returns correct instance', () {
      final result = shapeDecoration.gradient.as(linearGradient);

      expect(
        result.value.gradient,
        equals(linearGradient.toDto()),
      );
    });

    // shadows()
    test('shadows() returns correct instance', () {
      final result = shapeDecoration.shadows([boxShadow]);

      expect(
        result.value.shadows,
        equals(const [boxShadow].map((e) => e.toDto()).toList()),
      );
    });

    // shape()
    test('shape() returns correct instance', () {
      final result = shapeDecoration.shape.circle();

      expect(result.value.shape, equals(const CircleBorderDto()));
    });
  });
}
