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

      expect(
        result.value,
        equals(
          BoxDecorationDto(
            border: refBoxDecoration.border != null
                ? BorderDto.value(refBoxDecoration.border! as Border)
                : null,
            borderRadius: refBoxDecoration.borderRadius != null
                ? BorderRadiusGeometryDto.value(refBoxDecoration.borderRadius!)
                : null,
            boxShadow: refBoxDecoration.boxShadow
                ?.map((e) => BoxShadowDto.value(e))
                .toList(),
            color: refBoxDecoration.color,
            gradient: refBoxDecoration.gradient != null
                ? LinearGradientDto.maybeValue(
                    refBoxDecoration.gradient! as LinearGradient,
                  )
                : null,
            shape: refBoxDecoration.shape,
          ),
        ),
      );

      expect(result.value, isA<BoxDecorationDto>());
      expect(result.value.border, isA<BoxBorderDto>());
      expect(result.value.borderRadius, isA<BorderRadiusGeometryDto>());
      expect(result.value.boxShadow, isA<List<BoxShadowDto>>());
      expect(result.value.color, isA<Mix<Color>>());
      expect(result.value.gradient, isA<GradientDto>());
      expect(result.value.shape, isA<BoxShape>());

      expect(
        result.value.border,
        equals(BorderDto.value(refBoxDecoration.border! as Border)),
      );
      expect(
        result.value.borderRadius,
        equals(BorderRadiusGeometryDto.value(refBoxDecoration.borderRadius!)),
      );
      expect(
        result.value.boxShadow,
        equals(
          refBoxDecoration.boxShadow?.map((e) => BoxShadowDto.value(e)).toList(),
        ),
      );
      expect(result.value.color, equals(Mix.value(refBoxDecoration.color!)));
      expect(
        result.value.gradient,
        equals(
          LinearGradientDto.maybeValue(
            refBoxDecoration.gradient! as LinearGradient,
          ),
        ),
      );
      expect(result.value.shape, equals(refBoxDecoration.shape));
    });
    test('color setting', () {
      final result = boxDecoration.color(Colors.red);

      expect(result.value.color, equals(Mix.value(Colors.red)));
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
      expect(
        result.value.gradient,
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
      expect(result.value.boxShadow, equals([BoxShadowDto.value(boxShadow)]));
      expect(
        resultSingle.value.boxShadow?.first,
        equals(BoxShadowDto.value(boxShadow)),
      );
    });

    test('elevation setting', () {
      final result = boxDecoration.elevation(9);
      final boxShadows = result.value.boxShadow?.map(
        (e) => e.resolve(EmptyMixData),
      );
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

      expect(result.value.color, equals(Mix.value(Colors.blue)));
      expect(
        result.value.gradient,
        equals(LinearGradientDto.maybeValue(linearGradient)),
      );
      expect(result.value.shadows, equals([BoxShadowDto.value(boxShadow)]));
    });

    // color()
    test('color() returns correct instance', () {
      final result = shapeDecoration.color(Colors.blue);

      expect(result.value.color, equals(Mix.value(Colors.blue)));
    });

    // gradient()
    test('gradient() returns correct instance', () {
      final result = shapeDecoration.gradient.as(linearGradient);

      expect(
        result.value.gradient,
        equals(LinearGradientDto.maybeValue(linearGradient)),
      );
    });

    // shadows()
    test('shadows() returns correct instance', () {
      final result = shapeDecoration.shadows([boxShadow]);

      expect(result.value.shadows, equals([BoxShadowDto.value(boxShadow)]));
    });

    // shape()
    test('shape() returns correct instance', () {
      final result = shapeDecoration.shape.circle();

      expect(result.value.shape, equals(CircleBorderDto()));
    });
  });
}
