import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/attribute_generator.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  const linearGradient = LinearGradient(colors: Colors.accents);

  final linearGradientDto = LinearGradientDto(
    colors: Colors.accents.map(ColorDto.new).toList(),
  );
  const boxShadowDto = BoxShadowDto(
    color: ColorDto.value(Colors.black),
    offset: Offset(1, 1),
    blurRadius: 5.0,
    spreadRadius: 5.0,
  );
  const otherBoxShadowDto = BoxShadowDto(
    color: ColorDto.value(Colors.black),
    offset: Offset(2, 2),
    blurRadius: 10.0,
    spreadRadius: 10.0,
  );

  group('BoxDecorationDto', () {
    test('merge returns merged object correctly', () {
      final decoration1 = BoxDecorationDto(color: Colors.red.toDto());
      final decoration2 = BoxDecorationDto(gradient: linearGradientDto);

      final merged = decoration1.merge(decoration2);
      expect(merged.color, decoration1.color);
      expect(merged.gradient, decoration2.gradient);
    });
    test('resolve returns correct BoxDecoration with default values', () {
      const attr = BoxDecorationDto();
      final decoration = attr.resolve(EmptyMixData);
      expect(decoration, const BoxDecoration());

      return const Placeholder();
    });
    test('resolve returns correct BoxDecoration with specific values', () {
      final attr = BoxDecorationDto(
        color: Colors.red.toDto(),
        gradient: linearGradientDto,
      );
      final decoration = attr.resolve(EmptyMixData);
      expect(decoration.color, Colors.red);
      expect(decoration.gradient, linearGradient);

      return const Placeholder();
    });
    test('Equality holds when all properties are the same', () {
      final decoration1 = BoxDecorationDto(color: Colors.red.toDto());
      final decoration2 = BoxDecorationDto(color: Colors.red.toDto());
      expect(decoration1, decoration2);
    });
    test('Equality fails when properties are different', () {
      final decoration1 = BoxDecorationDto(color: Colors.red.toDto());
      final decoration2 = BoxDecorationDto(color: Colors.blue.toDto());
      expect(decoration1, isNot(decoration2));
    });
  });

  group('ShapeDecorationDto', () {
    test('merge returns merged object correctly', () {
      final decoration1 = ShapeDecorationDto(color: Colors.red.toDto());
      final decoration2 = ShapeDecorationDto(gradient: linearGradientDto);
      final merged = decoration1.merge(decoration2);
      expect(merged.color, decoration1.color);
      expect(merged.gradient, decoration2.gradient);
    });
    test('resolve returns correct ShapeDecoration with default values', () {
      const shapeDecoration = ShapeDecoration(shape: CircleBorder());
      const attr = ShapeDecorationDto(shape: CircleBorderDto());

      final decoration = attr.resolve(EmptyMixData);
      expect(decoration, shapeDecoration);
    });
    test('resolve returns correct ShapeDecoration with specific values', () {
      final boxShadow = RandomGenerator.boxShadow();

      final decoration1 = ShapeDecorationDto(
        shape: const CircleBorderDto(),
        gradient: linearGradientDto,
        shadows: [boxShadow.toDto()],
      );

      final resolvedValue = decoration1.resolve(EmptyMixData);

      expect(decoration1.gradient, linearGradientDto);
      expect(decoration1.color, isNull);
      expect(decoration1.shape, const CircleBorderDto());
      expect(decoration1.shadows, [boxShadow.toDto()]);

      expect(resolvedValue.gradient, linearGradient);
      expect(resolvedValue.color, isNull);
      expect(resolvedValue.shape, const CircleBorder());
      expect(resolvedValue.shadows, [boxShadow]);
    });
    test('Equality holds when all properties are the same', () {
      final decoration1 = ShapeDecorationDto(color: Colors.red.toDto());
      final decoration2 = ShapeDecorationDto(color: Colors.red.toDto());
      expect(decoration1, decoration2);
    });
    test('Equality fails when properties are different', () {
      final decoration1 = ShapeDecorationDto(color: Colors.red.toDto());
      final decoration2 = ShapeDecorationDto(color: Colors.blue.toDto());
      expect(decoration1, isNot(decoration2));
    });
  });

  group('DecorationDto Merge Tests', () {
    const linearGradientDto = LinearGradientDto(
      colors: [ColorDto.value(Colors.red), ColorDto.value(Colors.blue)],
    );
    const otherLinearGradientDto = LinearGradientDto(
      colors: [ColorDto.value(Colors.yellow), ColorDto.value(Colors.green)],
    );

    test('BoxDecorationDto merges with another BoxDecorationDto', () {
      const boxDeco1 = BoxDecorationDto(
        color: ColorDto.value(Colors.red),
        gradient: linearGradientDto,
        boxShadow: [boxShadowDto],
      );
      const boxDeco2 = BoxDecorationDto(
        color: ColorDto.value(Colors.blue),
        gradient: otherLinearGradientDto,
        boxShadow: [otherBoxShadowDto],
      );

      final merged = boxDeco1.merge(boxDeco2);

      expect(merged, isA<BoxDecorationDto>());
      expect(merged.color, const ColorDto.value(Colors.blue));
      expect(merged.gradient!.stops, otherLinearGradientDto.stops);
      expect(merged.boxShadow, [otherBoxShadowDto]);
    });

    test('ShapeDecorationDto merges with another ShapeDecorationDto', () {
      const shapeDeco1 = ShapeDecorationDto(
        color: ColorDto.value(Colors.red),
        shape: RoundedRectangleBorderDto(),
        gradient: linearGradientDto,
        shadows: [boxShadowDto],
      );
      const shapeDeco2 = ShapeDecorationDto(
        color: ColorDto.value(Colors.blue),
        shape: BeveledRectangleBorderDto(),
        gradient: otherLinearGradientDto,
        shadows: [otherBoxShadowDto],
      );

      final merged = shapeDeco1.merge(shapeDeco2);

      expect(merged, isA<ShapeDecorationDto>());
      expect(merged.shape, isA<BeveledRectangleBorderDto>());
      expect(merged.color, const ColorDto.value(Colors.blue));
      expect(merged.gradient, otherLinearGradientDto);
      expect(merged.shadows, [otherBoxShadowDto]);
    });

    group('ShapeDecorationDto merge tests', () {
      test('Merge two ShapeDecorationDto', () {
        const shapeDeco1 = ShapeDecorationDto(
          color: ColorDto.value(Colors.red),
          shape: CircleBorderDto(),
          shadows: [boxShadowDto],
          image: DecorationImageDto(fit: BoxFit.contain),
        );
        const shapeDeco2 = ShapeDecorationDto(
          color: ColorDto.value(Colors.blue),
          gradient: LinearGradientDto(
            colors: [
              ColorDto.value(Colors.yellow),
              ColorDto.value(Colors.green)
            ],
          ),
        );

        final merged = shapeDeco1.merge(shapeDeco2);

        expect(merged, isA<ShapeDecorationDto>());
        expect(merged.color, const ColorDto.value(Colors.blue));
        expect(merged.gradient, shapeDeco2.gradient);
        expect(merged.shape, shapeDeco1.shape);
        expect(merged.shadows, shapeDeco1.shadows);
        expect(merged.image, shapeDeco1.image);
      });

      test(
        'merge with a BoxDecoration when isMergeable true',
        () {
          final firstBorderRadius =
              const BorderRadius.all(Radius.circular(10)).toDto();
          final secondBorderRadius =
              const BorderRadius.all(Radius.circular(20)).toDto();
          final shapeDeco1 = ShapeDecorationDto(
            color: const ColorDto.value(Colors.red),
            shape: RoundedRectangleBorderDto(
              borderRadius: firstBorderRadius,
            ),
            shadows: const [boxShadowDto],
            image: const DecorationImageDto(fit: BoxFit.contain),
          );

          final boxDeco1 = BoxDecorationDto(
            color: const ColorDto.value(Colors.red),
            borderRadius: secondBorderRadius,
            boxShadow: const [otherBoxShadowDto],
            image: const DecorationImageDto(fit: BoxFit.contain),
          );
          final merged = DecorationDto.tryToMerge(shapeDeco1, boxDeco1)
              as ShapeDecorationDto;
          final shapeBorder = (merged.shape as RoundedRectangleBorderDto);

          expect(boxDeco1.isMergeable, true);
          expect(merged, isA<ShapeDecorationDto>());
          expect(merged.color, boxDeco1.color);
          expect(merged.shape,
              RoundedRectangleBorderDto(borderRadius: secondBorderRadius));
          expect(merged.shadows, boxDeco1.boxShadow);
          expect(merged.image, boxDeco1.image);
          expect(shapeBorder.borderRadius, boxDeco1.borderRadius);
        },
      );

      test('do not merge with a BoxDecoration when isMergeable false', () {
        const shapeDeco1 = ShapeDecorationDto(
          color: ColorDto.value(Colors.red),
          shape: StarBorderDto(),
          shadows: [boxShadowDto],
          image: DecorationImageDto(fit: BoxFit.contain),
        );

        const boxDeco1 = BoxDecorationDto(
          image: DecorationImageDto(fit: BoxFit.fill),
          backgroundBlendMode: BlendMode.clear,
        );

        final merged = DecorationDto.tryToMerge(shapeDeco1, boxDeco1);

        expect(boxDeco1.isMergeable, false);
        expect(merged, isA<BoxDecorationDto>());
        expect(merged?.color, shapeDeco1.color);
        expect(merged?.boxShadow, shapeDeco1.boxShadow);
        expect(merged?.image, boxDeco1.image);
      });
    });

    group('BoxDecorationDto merge tests', () {
      test('Merge two BoxDecorationDto', () {
        final firstBorderRadius =
            const BorderRadius.all(Radius.circular(10)).toDto();
        final secondBorderRadius =
            const BorderRadius.all(Radius.circular(20)).toDto();

        const borderSide = BorderSideDto(
          color: ColorDto.value(Colors.yellow),
          width: 1,
        );
        final boxDeco1 = BoxDecorationDto(
          color: const ColorDto.value(Colors.red),
          shape: BoxShape.circle,
          boxShadow: const [boxShadowDto],
          border: const BorderDto(
            top: borderSide,
          ),
          borderRadius: firstBorderRadius,
          image: const DecorationImageDto(fit: BoxFit.contain),
          backgroundBlendMode: BlendMode.clear,
        );
        final boxDeco2 = BoxDecorationDto(
          color: const ColorDto.value(Colors.blue),
          gradient: const LinearGradientDto(
            colors: [
              ColorDto.value(Colors.yellow),
              ColorDto.value(Colors.green)
            ],
          ),
          border: const BorderDto(
            bottom: borderSide,
          ),
          borderRadius: secondBorderRadius,
          image: const DecorationImageDto(fit: BoxFit.cover),
          backgroundBlendMode: BlendMode.colorBurn,
        );

        final merged = boxDeco1.merge(boxDeco2);

        expect(merged, isA<BoxDecorationDto>());
        expect(merged.color, boxDeco2.color);
        expect(merged.gradient, boxDeco2.gradient);
        expect(merged.boxShadow, boxDeco1.boxShadow);
        expect(merged.border,
            const BorderDto(top: borderSide, bottom: borderSide));
        expect(merged.borderRadius, boxDeco2.borderRadius);
        expect(merged.image, boxDeco2.image);

        expect(merged.backgroundBlendMode, boxDeco2.backgroundBlendMode);
      });

      test('Merge ShapeDecorationDto when isMergeable is true', () {
        final firstBorderRadius =
            const BorderRadius.all(Radius.circular(10)).toDto();
        final secondBorderRadius =
            const BorderRadius.all(Radius.circular(20)).toDto();

        const borderSide = BorderSideDto(
          color: ColorDto.value(Colors.yellow),
          width: 1,
        );
        final boxDeco1 = BoxDecorationDto(
          color: const ColorDto.value(Colors.red),
          shape: BoxShape.circle,
          boxShadow: const [boxShadowDto],
          border: const BorderDto(
            top: borderSide,
          ),
          borderRadius: firstBorderRadius,
          image: const DecorationImageDto(fit: BoxFit.contain),
        );
        final shapeDeco1 = ShapeDecorationDto(
          color: const ColorDto.value(Colors.red),
          shape: RoundedRectangleBorderDto(
            borderRadius: secondBorderRadius,
          ),
          shadows: const [boxShadowDto],
          image: const DecorationImageDto(fit: BoxFit.contain),
        );

        final merged =
            DecorationDto.tryToMerge(boxDeco1, shapeDeco1) as BoxDecorationDto;

        expect(shapeDeco1.isMergeable, true);
        expect(merged, isA<BoxDecorationDto>());
        expect(merged.color, shapeDeco1.color);
        expect(merged.shape, BoxShape.rectangle);
        expect(merged.boxShadow, shapeDeco1.shadows);
        expect(merged.image, shapeDeco1.image);
        expect(merged.borderRadius, secondBorderRadius);
      });
    });
  });
}
