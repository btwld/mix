import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/attribute_generator.dart';
import '../../../helpers/custom_matchers.dart';

void main() {
  const linearGradient = LinearGradient(colors: Colors.accents);

  final linearGradientDto = LinearGradientDto(
    colors: Colors.accents,
  );
  final boxShadowDto = BoxShadowDto(
    color: Colors.black,
    offset: const Offset(1, 1),
    blurRadius: 5.0,
    spreadRadius: 5.0,
  );
  final otherBoxShadowDto = BoxShadowDto(
    color: Colors.black,
    offset: const Offset(2, 2),
    blurRadius: 10.0,
    spreadRadius: 10.0,
  );

  group('BoxDecorationDto', () {
    test('merge returns merged object correctly', () {
      final decoration1 = BoxDecorationDto(color: Colors.red);
      final decoration2 = BoxDecorationDto(gradient: linearGradientDto);

      final merged = decoration1.merge(decoration2);
      expect(merged.color, resolvesTo(Colors.red));
      expect(merged.gradient, linearGradientDto);
    });
    test('resolve returns correct BoxDecoration with default values', () {
      final attr = BoxDecorationDto();
      expect(attr, resolvesTo(const BoxDecoration()));
    });
    test('resolve returns correct BoxDecoration with specific values', () {
      final attr = BoxDecorationDto(
        color: Colors.red,
        gradient: linearGradientDto,
      );
      expect(attr, resolvesTo(const BoxDecoration(
        color: Colors.red,
        gradient: linearGradient,
      )));
    });
    test('Equality holds when all properties are the same', () {
      final decoration1 = BoxDecorationDto(color: Colors.red);
      final decoration2 = BoxDecorationDto(color: Colors.red);
      expect(decoration1, decoration2);
    });
    test('Equality fails when properties are different', () {
      final decoration1 = BoxDecorationDto(color: Colors.red);
      final decoration2 = BoxDecorationDto(color: Colors.blue);
      expect(decoration1, isNot(decoration2));
    });
  });

  group('ShapeDecorationDto', () {
    test('merge returns merged object correctly', () {
      final decoration1 = ShapeDecorationDto(color: Colors.red);
      final decoration2 = ShapeDecorationDto(gradient: linearGradientDto);
      final merged = decoration1.merge(decoration2);
      expect(merged.color, resolvesTo(Colors.red));
      expect(merged.gradient, linearGradientDto);
    });
    test('resolve returns correct ShapeDecoration with default values', () {
      const shapeDecoration = ShapeDecoration(shape: CircleBorder());
      final attr = ShapeDecorationDto(shape: CircleBorderDto());

      expect(attr, resolvesTo(shapeDecoration));
    });
    test('resolve returns correct ShapeDecoration with specific values', () {
      final boxShadow = RandomGenerator.boxShadow();

      final decoration1 = ShapeDecorationDto(
        shape: CircleBorderDto(),
        gradient: linearGradientDto,
        shadows: [BoxShadowDto.value(boxShadow)],
      );

      expect(decoration1, resolvesTo(ShapeDecoration(
        shape: const CircleBorder(),
        gradient: linearGradient,
        shadows: [boxShadow],
      )));

      expect(decoration1.gradient, linearGradientDto);
      expect(decoration1.color, isNull);
      expect(decoration1.shape, CircleBorderDto());
      expect(decoration1.shadows, [BoxShadowDto.value(boxShadow)]);
    });
    test('Equality holds when all properties are the same', () {
      final decoration1 = ShapeDecorationDto(color: Colors.red);
      final decoration2 = ShapeDecorationDto(color: Colors.red);
      expect(decoration1, decoration2);
    });
    test('Equality fails when properties are different', () {
      final decoration1 = ShapeDecorationDto(color: Colors.red);
      final decoration2 = ShapeDecorationDto(color: Colors.blue);
      expect(decoration1, isNot(decoration2));
    });
  });

  group('DecorationDto Merge Tests', () {
    final linearGradientDto = LinearGradientDto(
      colors: const [Colors.red, Colors.blue],
    );
    final otherLinearGradientDto = LinearGradientDto(
      colors: const [Colors.yellow, Colors.green],
    );

    test('BoxDecorationDto merges with another BoxDecorationDto', () {
      final boxDeco1 = BoxDecorationDto(
        color: Colors.red,
        gradient: linearGradientDto,
        boxShadow: [boxShadowDto],
      );
      final boxDeco2 = BoxDecorationDto(
        color: Colors.blue,
        gradient: otherLinearGradientDto,
        boxShadow: [otherBoxShadowDto],
      );

      final merged = boxDeco1.merge(boxDeco2);

      expect(merged, isA<BoxDecorationDto>());
      expect(merged.color, resolvesTo(Colors.blue));
      expect(merged.gradient!.stops, resolvesTo([0.0, 1.0]));
      expect(merged.boxShadow, [otherBoxShadowDto]);
    });

    test('ShapeDecorationDto merges with another ShapeDecorationDto', () {
      final shapeDeco1 = ShapeDecorationDto(
        color: Colors.red,
        shape: const RoundedRectangleBorderDto(),
        gradient: linearGradientDto,
        shadows: [boxShadowDto],
      );
      final shapeDeco2 = ShapeDecorationDto(
        color: Colors.blue,
        shape: const BeveledRectangleBorderDto(),
        gradient: otherLinearGradientDto,
        shadows: [otherBoxShadowDto],
      );

      final merged = shapeDeco1.merge(shapeDeco2);

      expect(merged, isA<ShapeDecorationDto>());
      expect(merged.shape, isA<BeveledRectangleBorderDto>());
      expect(merged.color, resolvesTo(Colors.blue));
      expect(merged.gradient, otherLinearGradientDto);
      expect(merged.shadows, [otherBoxShadowDto]);
    });

    group('ShapeDecorationDto merge tests', () {
      test('Merge two ShapeDecorationDto', () {
        final shapeDeco1 = ShapeDecorationDto(
          color: Colors.red,
          shape: CircleBorderDto(),
          shadows: [boxShadowDto],
          image: DecorationImageDto(fit: BoxFit.contain),
        );
        final shapeDeco2 = ShapeDecorationDto(
          color: Colors.blue,
          gradient: LinearGradientDto(
            colors: const [Colors.yellow, Colors.green],
          ),
        );

        final merged = shapeDeco1.merge(shapeDeco2);

        expect(merged, isA<ShapeDecorationDto>());
        expect(merged.color, resolvesTo(Colors.blue));
        expect(merged.gradient, shapeDeco2.gradient);
        expect(merged.shape, shapeDeco1.shape);
        expect(merged.shadows, shapeDeco1.shadows);
        expect(merged.image, shapeDeco1.image);
      });

      test('merge with a BoxDecoration when isMergeable true', () {
        final firstBorderRadius = BorderRadiusDto.value(
          const BorderRadius.all(Radius.circular(10)),
        );
        final secondBorderRadius = BorderRadiusDto.value(
          const BorderRadius.all(Radius.circular(20)),
        );
        final shapeDeco1 = ShapeDecorationDto(
          color: Colors.red,
          shape: RoundedRectangleBorderDto(borderRadius: firstBorderRadius),
          shadows: [boxShadowDto],
          image: DecorationImageDto(fit: BoxFit.contain),
        );

        final boxDeco1 = BoxDecorationDto(
          color: Colors.red,
          borderRadius: secondBorderRadius,
          boxShadow: [otherBoxShadowDto],
          image: DecorationImageDto(fit: BoxFit.contain),
        );
        final merged =
            DecorationDto.tryToMerge(shapeDeco1, boxDeco1)
                as ShapeDecorationDto;
        final shapeBorder = (merged.shape as RoundedRectangleBorderDto);

        expect(boxDeco1.isMergeable, true);
        expect(merged, isA<ShapeDecorationDto>());
        expect(merged.color, resolvesTo(Colors.red));
        expect(
          merged.shape,
          RoundedRectangleBorderDto(borderRadius: secondBorderRadius),
        );
        expect(merged.shadows, boxDeco1.boxShadow);
        expect(merged.image, boxDeco1.image);
        expect(shapeBorder.borderRadius, secondBorderRadius);
      });

      test('do not merge with a BoxDecoration when isMergeable false', () {
        final shapeDeco1 = ShapeDecorationDto(
          color: Colors.red,
          shape: StarBorderDto(),
          shadows: [boxShadowDto],
          image: DecorationImageDto(fit: BoxFit.contain),
        );

        final boxDeco1 = BoxDecorationDto(
          image: DecorationImageDto(fit: BoxFit.fill),
          backgroundBlendMode: BlendMode.clear,
        );

        final merged = DecorationDto.tryToMerge(shapeDeco1, boxDeco1);

        expect(boxDeco1.isMergeable, false);
        expect(merged, isA<BoxDecorationDto>());
        expect(merged?.color, resolvesTo(Colors.red));
        expect(merged?.boxShadow, shapeDeco1.boxShadow);
        expect(merged?.image, boxDeco1.image);
      });
    });

    group('BoxDecorationDto merge tests', () {
      test('Merge two BoxDecorationDto', () {
        final firstBorderRadius = BorderRadiusDto.value(
          const BorderRadius.all(Radius.circular(10)),
        );
        final secondBorderRadius = BorderRadiusDto.value(
          const BorderRadius.all(Radius.circular(20)),
        );

        final borderSide = BorderSideDto(color: Colors.yellow, width: 1);
        final boxDeco1 = BoxDecorationDto(
          color: Colors.red,
          shape: BoxShape.circle,
          boxShadow: [boxShadowDto],
          border: BorderDto(top: borderSide),
          borderRadius: firstBorderRadius,
          image: DecorationImageDto(fit: BoxFit.contain),
          backgroundBlendMode: BlendMode.clear,
        );
        final boxDeco2 = BoxDecorationDto(
          color: Colors.blue,
          gradient: LinearGradientDto(
            colors: const [Colors.yellow, Colors.green],
          ),
          border: BorderDto(bottom: borderSide),
          borderRadius: secondBorderRadius,
          image: DecorationImageDto(fit: BoxFit.cover),
          backgroundBlendMode: BlendMode.colorBurn,
        );

        final merged = boxDeco1.merge(boxDeco2);

        expect(merged, isA<BoxDecorationDto>());
        expect(merged.color, resolvesTo(Colors.blue));
        expect(merged.gradient, boxDeco2.gradient);
        expect(merged.boxShadow, boxDeco1.boxShadow);
        expect(merged.border, BorderDto(top: borderSide, bottom: borderSide));
        expect(merged.borderRadius, secondBorderRadius);
        expect(merged.image, boxDeco2.image);

        expect(merged.backgroundBlendMode, boxDeco2.backgroundBlendMode);
      });

      test('Merge ShapeDecorationDto when isMergeable is true', () {
        final firstBorderRadius = BorderRadiusDto.value(
          const BorderRadius.all(Radius.circular(10)),
        );
        final secondBorderRadius = BorderRadiusDto.value(
          const BorderRadius.all(Radius.circular(20)),
        );

        final borderSide = BorderSideDto(color: Colors.yellow, width: 1);
        final boxDeco1 = BoxDecorationDto(
          color: Colors.red,
          shape: BoxShape.circle,
          boxShadow: [boxShadowDto],
          border: BorderDto(top: borderSide),
          borderRadius: firstBorderRadius,
          image: DecorationImageDto(fit: BoxFit.contain),
        );
        final shapeDeco1 = ShapeDecorationDto(
          color: Colors.red,
          shape: RoundedRectangleBorderDto(borderRadius: secondBorderRadius),
          shadows: [boxShadowDto],
          image: DecorationImageDto(fit: BoxFit.contain),
        );

        final merged =
            DecorationDto.tryToMerge(boxDeco1, shapeDeco1) as BoxDecorationDto;

        expect(shapeDeco1.isMergeable, true);
        expect(merged, isA<BoxDecorationDto>());
        expect(merged.color, resolvesTo(Colors.red));
        expect(merged.shape, resolvesTo(BoxShape.rectangle));
        expect(merged.boxShadow, shapeDeco1.shadows);
        expect(merged.image, shapeDeco1.image);
        expect(merged.borderRadius, secondBorderRadius);
      });
    });
  });
}
