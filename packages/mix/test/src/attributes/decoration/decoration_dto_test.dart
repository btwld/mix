import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/attribute_generator.dart';
import '../../../helpers/custom_matchers.dart';

void main() {
  const linearGradient = LinearGradient(colors: Colors.accents);

  final linearGradientDto = LinearGradientDto(colors: Colors.accents);
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
      expect(merged.gradient?.value, linearGradientDto);
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
      expect(
        attr,
        resolvesTo(
          const BoxDecoration(color: Colors.red, gradient: linearGradient),
        ),
      );
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
      expect(merged.gradient?.value, linearGradientDto);
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

      expect(
        decoration1,
        resolvesTo(
          ShapeDecoration(
            shape: const CircleBorder(),
            gradient: linearGradient,
            shadows: [boxShadow],
          ),
        ),
      );

      expect(decoration1.gradient?.value, linearGradientDto);
      expect(decoration1.color, isNull);
      expect(decoration1.shape?.value, CircleBorderDto());
      expect(decoration1.shadows?.map((s) => s.value).toList(), [
        BoxShadowDto.value(boxShadow),
      ]);
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
      expect(merged.color?.value, Colors.blue);
      expect(
        merged.gradient,
        resolvesTo(const LinearGradient(colors: [Colors.yellow, Colors.green])),
      );
      expect(merged.boxShadow, hasLength(1));
      expect(merged.boxShadow![0].value, otherBoxShadowDto);
    });

    test('ShapeDecorationDto merges with another ShapeDecorationDto', () {
      final shapeDeco1 = ShapeDecorationDto(
        color: Colors.red,
        shape: RoundedRectangleBorderDto(),
        gradient: linearGradientDto,
        shadows: [boxShadowDto],
      );
      final shapeDeco2 = ShapeDecorationDto(
        color: Colors.blue,
        shape: RoundedRectangleBorderDto(),
        gradient: otherLinearGradientDto,
        shadows: [otherBoxShadowDto],
      );

      final merged = shapeDeco1.merge(shapeDeco2);

      expect(merged, isA<ShapeDecorationDto>());
      expect(merged.shape?.value, isA<RoundedRectangleBorderDto>());
      expect(merged.color, resolvesTo(Colors.blue));
      expect(
        merged.gradient,
        resolvesTo(const LinearGradient(colors: [Colors.yellow, Colors.green])),
      );
      expect(merged.shadows, hasLength(1));
      expect(merged.shadows![0].value, otherBoxShadowDto);
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
        expect(merged.gradient?.value, shapeDeco2.gradient?.value);
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
        final shapeBorder = (merged.shape?.value as RoundedRectangleBorderDto);

        expect(boxDeco1.isMergeable, true);
        expect(merged, isA<ShapeDecorationDto>());
        expect(merged.color, resolvesTo(Colors.red));
        expect(merged.shape?.value, isA<RoundedRectangleBorderDto>());
        expect(
          (merged.shape?.value as RoundedRectangleBorderDto).borderRadius,
          resolvesTo(const BorderRadius.all(Radius.circular(20))),
        );
        expect(merged.shadows, hasLength(1));
        expect(merged.shadows![0], boxDeco1.boxShadow![0]);
        expect(merged.image?.value?.fit, resolvesTo(BoxFit.contain));
        expect(
          shapeBorder.borderRadius,
          resolvesTo(const BorderRadius.all(Radius.circular(20))),
        );
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
        expect(merged?.image?.value?.fit, resolvesTo(BoxFit.fill));
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
        expect(merged.gradient?.value, boxDeco2.gradient?.value);
        expect(merged.boxShadow, boxDeco1.boxShadow);
        expect(
          merged.border?.value,
          BorderDto(top: borderSide, bottom: borderSide),
        );
        expect(
          merged.borderRadius,
          resolvesTo(const BorderRadius.all(Radius.circular(20))),
        );
        expect(merged.image?.value?.fit, resolvesTo(BoxFit.cover));

        expect(merged.backgroundBlendMode, resolvesTo(BlendMode.colorBurn));
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
          shape: BoxShape.rectangle,
          boxShadow: [boxShadowDto],
          border: BorderDto(top: borderSide),
          borderRadius: firstBorderRadius,
          image: DecorationImageDto(fit: BoxFit.contain),
        );
        final shapeDeco1 = ShapeDecorationDto(
          shape: RoundedRectangleBorderDto(borderRadius: secondBorderRadius),
          shadows: [boxShadowDto],
          image: DecorationImageDto(fit: BoxFit.contain),
        );

        final mergedDecoration = DecorationDto.tryToMerge(
          boxDeco1,
          shapeDeco1,
        )!;

        expect(shapeDeco1.isMergeable, false);
        expect(mergedDecoration, isA<ShapeDecorationDto>());

        final merged = mergedDecoration as ShapeDecorationDto;
        expect(merged.color, resolvesTo(Colors.red));
        expect(merged.shape?.value, isA<RoundedRectangleBorderDto>());
        expect(merged.shadows, hasLength(1));
        expect(merged.shadows![0], shapeDeco1.shadows![0]);
        expect(merged.image?.value?.fit, resolvesTo(BoxFit.contain));
      });
    });
  });
}
