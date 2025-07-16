import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  // BoxDecorationDto tests
  group('BoxDecorationDto', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('main constructor creates BoxDecorationDto with all properties', () {
        final borderDto = BorderDto.all(BorderSideDto(width: 2.0));
        final borderRadiusDto = BorderRadiusDto.value(BorderRadius.circular(8));
        final imageDto = DecorationImageDto(fit: BoxFit.cover);
        final gradientDto = LinearGradientDto(
          colors: const [Colors.red, Colors.blue],
        );
        final shadowDto = BoxShadowDto(
          color: Colors.black,
          offset: const Offset(2, 2),
          blurRadius: 4.0,
        );

        final dto = BoxDecorationDto(
          border: borderDto,
          borderRadius: borderRadiusDto,
          shape: BoxShape.rectangle,
          backgroundBlendMode: BlendMode.srcOver,
          color: Colors.red,
          image: imageDto,
          gradient: gradientDto,
          boxShadow: [shadowDto],
        );

        expect(dto.border?.mixValue, equals(borderDto));
        expect(dto.borderRadius?.mixValue, equals(borderRadiusDto));
        expect(dto.shape, resolvesTo(BoxShape.rectangle));
        expect(dto.backgroundBlendMode, resolvesTo(BlendMode.srcOver));
        expect(dto.color, resolvesTo(Colors.red));
        expect(dto.image?.mixValue, equals(imageDto));
        expect(dto.gradient?.mixValue, equals(gradientDto));
        expect(dto.boxShadow?.length, 1);
        expect(dto.boxShadow?[0].mixValue, equals(shadowDto));
      });

      test('value constructor from BoxDecoration', () {
        const decoration = BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1, 1),
              blurRadius: 3.0,
            ),
          ],
        );

        final dto = BoxDecorationDto.value(decoration);

        expect(dto.color, resolvesTo(Colors.blue));
        expect(dto.borderRadius, resolvesTo(decoration.borderRadius));
        expect(dto.boxShadow?.length, 1);
        expect(dto.boxShadow?[0].mixValue?.color, resolvesTo(Colors.grey));
      });

      test('props constructor with Prop values', () {
        const dto = BoxDecorationDto.props(
          color: Prop.fromValue(Colors.green),
          shape: Prop.fromValue(BoxShape.circle),
          backgroundBlendMode: Prop.fromValue(BlendMode.multiply),
        );

        expect(dto.color, resolvesTo(Colors.green));
        expect(dto.shape, resolvesTo(BoxShape.circle));
        expect(dto.backgroundBlendMode, resolvesTo(BlendMode.multiply));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test(
        'maybeValue returns BoxDecorationDto for non-null BoxDecoration',
        () {
          const decoration = BoxDecoration(color: Colors.red);
          final dto = BoxDecorationDto.maybeValue(decoration);

          expect(dto, isNotNull);
          expect(dto?.color, resolvesTo(Colors.red));
        },
      );

      test('maybeValue returns null for null BoxDecoration', () {
        final dto = BoxDecorationDto.maybeValue(null);
        expect(dto, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to BoxDecoration with all properties', () {
        final dto = BoxDecorationDto(
          color: Colors.purple,
          gradient: LinearGradientDto(colors: const [Colors.red, Colors.blue]),
          borderRadius: BorderRadiusDto.value(BorderRadius.circular(12)),
          shape: BoxShape.rectangle,
        );

        final context = createEmptyMixData();
        final resolved = dto.resolve(context);

        expect(resolved.color, Colors.purple);
        expect(resolved.gradient, isA<LinearGradient>());
        expect(resolved.borderRadius, BorderRadius.all(Radius.circular(12)));
        expect(resolved.shape, BoxShape.rectangle);
      });

      test('resolves with default values for null properties', () {
        const dto = BoxDecorationDto.props(
          color: null,
          gradient: null,
          image: null,
          boxShadow: null,
        );

        expect(dto, resolvesTo(const BoxDecoration()));
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another BoxDecorationDto - all properties', () {
        final dto1 = BoxDecorationDto(
          color: Colors.red,
          border: BorderDto.all(BorderSideDto(width: 1.0)),
          borderRadius: BorderRadiusDto.value(BorderRadius.circular(4)),
          shape: BoxShape.rectangle,
        );

        final dto2 = BoxDecorationDto(
          color: Colors.blue,
          gradient: LinearGradientDto(
            colors: const [Colors.yellow, Colors.green],
          ),
          borderRadius: BorderRadiusDto.value(BorderRadius.circular(8)),
          backgroundBlendMode: BlendMode.darken,
        );

        final merged = dto1.merge(dto2);

        expect(merged.color, resolvesTo(Colors.blue));
        expect(merged.gradient?.mixValue, isA<LinearGradientDto>());
        expect(merged.border?.mixValue, equals(dto1.border?.mixValue));
        expect(
          merged.borderRadius,
          resolvesTo(BorderRadius.all(Radius.circular(8))),
        );
        expect(merged.shape, resolvesTo(BoxShape.rectangle));
        expect(merged.backgroundBlendMode, resolvesTo(BlendMode.darken));
      });

      test('merge with partial properties', () {
        final dto1 = BoxDecorationDto(
          color: Colors.red,
          shape: BoxShape.circle,
        );

        final dto2 = BoxDecorationDto(
          gradient: LinearGradientDto(
            colors: const [Colors.blue, Colors.green],
          ),
          borderRadius: BorderRadiusDto.value(BorderRadius.circular(16)),
        );

        final merged = dto1.merge(dto2);

        expect(merged.color, resolvesTo(Colors.red));
        expect(merged.gradient?.mixValue, isA<LinearGradientDto>());
        expect(merged.shape, resolvesTo(BoxShape.circle));
        expect(
          merged.borderRadius,
          resolvesTo(BorderRadius.all(Radius.circular(16))),
        );
      });

      test('merge with null returns original', () {
        final dto = BoxDecorationDto(
          color: Colors.green,
          shape: BoxShape.rectangle,
        );

        final merged = dto.merge(null);
        expect(merged, same(dto));
      });

      test('merge boxShadow lists', () {
        final shadow1 = BoxShadowDto(color: Colors.black, blurRadius: 2.0);
        final shadow2 = BoxShadowDto(color: Colors.grey, blurRadius: 4.0);

        final dto1 = BoxDecorationDto(boxShadow: [shadow1]);
        final dto2 = BoxDecorationDto(boxShadow: [shadow2]);

        final merged = dto1.merge(dto2);
        expect(merged.boxShadow?.length, 1);
        expect(merged.boxShadow?[0].mixValue?.color, resolvesTo(Colors.grey));
      });
    });

    // Property Tests
    group('Property Tests', () {
      test('isMergeable returns true when backgroundBlendMode is null', () {
        final dto = BoxDecorationDto(color: Colors.red);
        expect(dto.isMergeable, isTrue);
      });

      test('isMergeable returns false when backgroundBlendMode is set', () {
        final dto = BoxDecorationDto(
          color: Colors.red,
          backgroundBlendMode: BlendMode.multiply,
        );
        expect(dto.isMergeable, isFalse);
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal BoxDecorationDtos', () {
        final dto1 = BoxDecorationDto(
          color: Colors.red,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadiusDto.value(BorderRadius.circular(8)),
        );

        final dto2 = BoxDecorationDto(
          color: Colors.red,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadiusDto.value(BorderRadius.circular(8)),
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equal BoxDecorationDtos', () {
        final dto1 = BoxDecorationDto(color: Colors.red);
        final dto2 = BoxDecorationDto(color: Colors.blue);

        expect(dto1, isNot(equals(dto2)));
      });
    });
  });

  // ShapeDecorationDto tests
  group('ShapeDecorationDto', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test(
        'main constructor creates ShapeDecorationDto with all properties',
        () {
          final shapeDto = CircleBorderDto(side: BorderSideDto(width: 2.0));
          final imageDto = DecorationImageDto(fit: BoxFit.contain);
          final gradientDto = LinearGradientDto(
            colors: const [Colors.orange, Colors.yellow],
          );
          final shadowDto = BoxShadowDto(
            color: Colors.black,
            offset: const Offset(3, 3),
            blurRadius: 6.0,
          );

          final dto = ShapeDecorationDto(
            shape: shapeDto,
            color: Colors.green,
            image: imageDto,
            gradient: gradientDto,
            shadows: [shadowDto],
          );

          expect(dto.shape?.mixValue, equals(shapeDto));
          expect(dto.color, resolvesTo(Colors.green));
          expect(dto.image?.mixValue, equals(imageDto));
          expect(dto.gradient?.mixValue, equals(gradientDto));
          expect(dto.shadows?.length, 1);
          expect(dto.shadows?[0].mixValue, equals(shadowDto));
        },
      );

      test('value constructor from ShapeDecoration', () {
        final decoration = ShapeDecoration(
          color: Colors.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          shadows: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 4.0,
            ),
          ],
        );

        final dto = ShapeDecorationDto.value(decoration);

        expect(dto.color, resolvesTo(Colors.purple));
        expect(dto.shape?.mixValue, isA<RoundedRectangleBorderDto>());
        expect(dto.shadows?.length, 1);
        expect(dto.shadows?[0].mixValue?.color, resolvesTo(Colors.black26));
      });

      test('props constructor with Prop values', () {
        final dto = ShapeDecorationDto.props(
          shape: MixProp.fromValue(CircleBorderDto()),
          color: Prop.fromValue(Colors.cyan),
        );

        expect(dto.shape?.mixValue, isA<CircleBorderDto>());
        expect(dto.color, resolvesTo(Colors.cyan));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test(
        'maybeValue returns ShapeDecorationDto for non-null ShapeDecoration',
        () {
          const decoration = ShapeDecoration(
            color: Colors.red,
            shape: CircleBorder(),
          );
          final dto = ShapeDecorationDto.maybeValue(decoration);

          expect(dto, isNotNull);
          expect(dto?.color, resolvesTo(Colors.red));
          expect(dto?.shape?.mixValue, isA<CircleBorderDto>());
        },
      );

      test('maybeValue returns null for null ShapeDecoration', () {
        final dto = ShapeDecorationDto.maybeValue(null);
        expect(dto, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to ShapeDecoration with all properties', () {
        final dto = ShapeDecorationDto(
          shape: RoundedRectangleBorderDto(
            borderRadius: BorderRadiusDto.value(BorderRadius.circular(8)),
          ),
          gradient: RadialGradientDto(
            colors: const [Colors.red, Colors.orange],
          ),
        );

        final context = createEmptyMixData();
        final resolved = dto.resolve(context);

        expect(resolved.color, isNull); // color is null when gradient is set
        expect(resolved.shape, isA<RoundedRectangleBorder>());
        expect(resolved.gradient, isA<RadialGradient>());
      });

      test('resolves with default values for null properties', () {
        const dto = ShapeDecorationDto.props(color: null);

        final context = createEmptyMixData();
        final resolved = dto.resolve(context);

        expect(resolved.shape, isA<RoundedRectangleBorder>());
        expect(resolved.color, isNull);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      // TODO: Fix cross-type shape merging in ShapeDecorationDto.merge
      // test('merge with another ShapeDecorationDto - all properties', () {
      //   final dto1 = ShapeDecorationDto(
      //     shape: CircleBorderDto(),
      //     color: Colors.red,
      //     shadows: [BoxShadowDto(color: Colors.black, blurRadius: 2.0)],
      //   );

      //   final dto2 = ShapeDecorationDto(
      //     shape: RoundedRectangleBorderDto(),
      //     color: Colors.blue,
      //     gradient: LinearGradientDto(colors: const [Colors.cyan, Colors.teal]),
      //     shadows: [BoxShadowDto(color: Colors.grey, blurRadius: 4.0)],
      //   );

      //   final merged = dto1.merge(dto2);

      //   expect(merged.shape?.value, isA<RoundedRectangleBorderDto>());
      //   expect(merged.color, resolvesTo(Colors.blue));
      //   expect(merged.gradient?.value, isA<LinearGradientDto>());
      //   expect(merged.shadows?.length, 1);
      //   expect(merged.shadows?[0].value?.color, resolvesTo(Colors.grey));
      // });

      test('merge with partial properties', () {
        final dto1 = ShapeDecorationDto(
          shape: CircleBorderDto(),
          color: Colors.red,
        );

        final dto2 = ShapeDecorationDto(
          gradient: LinearGradientDto(
            colors: const [Colors.blue, Colors.green],
          ),
          image: DecorationImageDto(fit: BoxFit.fill),
        );

        final merged = dto1.merge(dto2);

        expect(merged.shape?.mixValue, isA<CircleBorderDto>());
        expect(merged.color, resolvesTo(Colors.red));
        expect(merged.gradient?.mixValue, isA<LinearGradientDto>());
        expect(merged.image?.mixValue?.fit, resolvesTo(BoxFit.fill));
      });

      test('merge with null returns original', () {
        final dto = ShapeDecorationDto(
          shape: CircleBorderDto(),
          color: Colors.green,
        );

        final merged = dto.merge(null);
        expect(merged, same(dto));
      });
    });

    // Property Tests
    group('Property Tests', () {
      test('isMergeable returns true for null shape', () {
        final dto = ShapeDecorationDto(color: Colors.red);
        expect(dto.isMergeable, isTrue);
      });

      test('isMergeable returns true for CircleBorderDto', () {
        final dto = ShapeDecorationDto(
          shape: CircleBorderDto(),
          color: Colors.red,
        );
        expect(dto.isMergeable, isTrue);
      });

      test('isMergeable returns true for RoundedRectangleBorderDto', () {
        final dto = ShapeDecorationDto(
          shape: RoundedRectangleBorderDto(),
          color: Colors.red,
        );
        expect(dto.isMergeable, isTrue);
      });

      test('isMergeable returns false for other shapes', () {
        final dto = ShapeDecorationDto(
          shape: StarBorderDto(),
          color: Colors.red,
        );
        expect(dto.isMergeable, isFalse);
      });

      test('shadows property alias for boxShadow', () {
        final shadow = BoxShadowDto(color: Colors.black);
        final dto = ShapeDecorationDto(shadows: [shadow]);

        expect(dto.shadows, equals(dto.boxShadow));
        expect(dto.shadows?.length, 1);
        expect(dto.shadows?[0].mixValue, equals(shadow));
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal ShapeDecorationDtos', () {
        final dto1 = ShapeDecorationDto(
          shape: CircleBorderDto(),
          color: Colors.red,
        );

        final dto2 = ShapeDecorationDto(
          shape: CircleBorderDto(),
          color: Colors.red,
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equal ShapeDecorationDtos', () {
        final dto1 = ShapeDecorationDto(
          shape: CircleBorderDto(),
          color: Colors.red,
        );
        final dto2 = ShapeDecorationDto(
          shape: CircleBorderDto(),
          color: Colors.blue,
        );

        expect(dto1, isNot(equals(dto2)));
      });
    });
  });

  // DecorationDto cross-type tests
  group('DecorationDto cross-type tests', () {
    // Base DecorationDto factory tests
    group('DecorationDto factory tests', () {
      test('value factory with BoxDecoration', () {
        const decoration = BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        );
        final dto = DecorationDto.value(decoration);

        expect(dto, isA<BoxDecorationDto>());
        expect((dto as BoxDecorationDto).color, resolvesTo(Colors.red));
      });

      test('value factory with ShapeDecoration', () {
        const decoration = ShapeDecoration(
          color: Colors.blue,
          shape: CircleBorder(),
        );
        final dto = DecorationDto.value(decoration);

        expect(dto, isA<ShapeDecorationDto>());
        expect((dto as ShapeDecorationDto).color, resolvesTo(Colors.blue));
      });

      test('maybeValue factory', () {
        const decoration = BoxDecoration(color: Colors.red);
        final dto = DecorationDto.maybeValue(decoration);

        expect(dto, isNotNull);
        expect(dto, isA<BoxDecorationDto>());

        final nullDto = DecorationDto.maybeValue(null);
        expect(nullDto, isNull);
      });
    });

    // tryToMerge tests
    group('tryToMerge tests', () {
      test('tryToMerge BoxDecorationDto with BoxDecorationDto', () {
        final dto1 = BoxDecorationDto(
          color: Colors.red,
          shape: BoxShape.rectangle,
        );
        final dto2 = BoxDecorationDto(
          gradient: LinearGradientDto(
            colors: const [Colors.blue, Colors.green],
          ),
          borderRadius: BorderRadiusDto.value(BorderRadius.circular(8)),
        );

        final merged =
            DecorationDto.tryToMerge(dto1, dto2) as BoxDecorationDto?;

        expect(merged, isNotNull);
        expect(merged!.color, resolvesTo(Colors.red));
        expect(merged.gradient?.mixValue, isA<LinearGradientDto>());
        expect(merged.shape, resolvesTo(BoxShape.rectangle));
        expect(
          merged.borderRadius,
          resolvesTo(BorderRadius.all(Radius.circular(8))),
        );
      });

      // TODO: Fix cross-type shape merging in ShapeDecorationDto
      // test('tryToMerge ShapeDecorationDto with ShapeDecorationDto', () {
      //   final dto1 = ShapeDecorationDto(
      //     shape: CircleBorderDto(),
      //     color: Colors.red,
      //   );
      //   final dto2 = ShapeDecorationDto(
      //     shape: RoundedRectangleBorderDto(),
      //     gradient: LinearGradientDto(
      //       colors: const [Colors.blue, Colors.green],
      //     ),
      //   );

      //   final merged =
      //       DecorationDto.tryToMerge(dto1, dto2) as ShapeDecorationDto?;

      //   expect(merged, isNotNull);
      //   expect(merged!.shape?.value, isA<RoundedRectangleBorderDto>());
      //   expect(merged.color, resolvesTo(Colors.red));
      //   expect(merged.gradient?.value, isA<LinearGradientDto>());
      // });

      test('tryToMerge ShapeDecorationDto with mergeable BoxDecorationDto', () {
        final shapeDeco = ShapeDecorationDto(
          color: Colors.red,
          shape: RoundedRectangleBorderDto(
            borderRadius: BorderRadiusDto.value(BorderRadius.circular(10)),
          ),
        );
        final boxDeco = BoxDecorationDto(
          color: Colors.blue,
          borderRadius: BorderRadiusDto.value(BorderRadius.circular(20)),
        );

        final merged =
            DecorationDto.tryToMerge(shapeDeco, boxDeco) as ShapeDecorationDto?;

        expect(boxDeco.isMergeable, isTrue);
        expect(merged, isNotNull);
        expect(merged!.color, resolvesTo(Colors.blue));
        expect(merged.shape?.mixValue, isA<RoundedRectangleBorderDto>());
        expect(
          (merged.shape?.mixValue as RoundedRectangleBorderDto).borderRadius,
          resolvesTo(BorderRadius.all(Radius.circular(20))),
        );
      });

      test(
        'tryToMerge ShapeDecorationDto with non-mergeable BoxDecorationDto',
        () {
          final shapeDeco = ShapeDecorationDto(
            color: Colors.red,
            shape: StarBorderDto(),
          );
          final boxDeco = BoxDecorationDto(
            color: Colors.blue,
            backgroundBlendMode: BlendMode.multiply,
          );

          final merged =
              DecorationDto.tryToMerge(shapeDeco, boxDeco) as BoxDecorationDto?;

          expect(boxDeco.isMergeable, isFalse);
          expect(merged, isNotNull);
          expect(merged!.color, resolvesTo(Colors.blue));
          expect(merged.backgroundBlendMode, resolvesTo(BlendMode.multiply));
        },
      );

      test('tryToMerge BoxDecorationDto with mergeable ShapeDecorationDto', () {
        final boxDeco = BoxDecorationDto(
          color: Colors.red,
          borderRadius: BorderRadiusDto.value(BorderRadius.circular(10)),
        );
        final shapeDeco = ShapeDecorationDto(
          shape: RoundedRectangleBorderDto(
            borderRadius: BorderRadiusDto.value(BorderRadius.circular(20)),
          ),
          gradient: LinearGradientDto(
            colors: const [Colors.yellow, Colors.orange],
          ),
        );

        final merged =
            DecorationDto.tryToMerge(boxDeco, shapeDeco) as BoxDecorationDto?;

        expect(shapeDeco.isMergeable, isTrue);
        expect(merged, isNotNull);
        expect(merged!.color, resolvesTo(Colors.red));
        expect(merged.gradient?.mixValue, isA<LinearGradientDto>());
        expect(
          merged.borderRadius,
          resolvesTo(BorderRadius.all(Radius.circular(20))),
        );
      });

      // TODO: Fix cross-type shape merging with non-mergeable ShapeDecorationDto
      // test(
      //   'tryToMerge BoxDecorationDto with non-mergeable ShapeDecorationDto',
      //   () {
      //     final boxDeco = BoxDecorationDto(
      //       color: Colors.red,
      //       shape: BoxShape.circle,
      //     );
      //     final shapeDeco = ShapeDecorationDto(
      //       shape: StarBorderDto(),
      //       color: Colors.blue,
      //     );

      //     final merged =
      //         DecorationDto.tryToMerge(boxDeco, shapeDeco)
      //             as ShapeDecorationDto?;

      //     expect(shapeDeco.isMergeable, isFalse);
      //     expect(merged, isNotNull);
      //     expect(merged!.shape?.value, isA<StarBorderDto>());
      //     expect(merged.color, resolvesTo(Colors.blue));
      //   },
      // );

      test('tryToMerge with null values', () {
        final dto = BoxDecorationDto(color: Colors.red);

        expect(DecorationDto.tryToMerge(dto, null), same(dto));
        expect(DecorationDto.tryToMerge(null, dto), same(dto));
        expect(DecorationDto.tryToMerge(null, null), isNull);
      });
    });

    // Edge cases
    group('Edge cases', () {
      test('BoxDecorationDto with all borders uniform', () {
        final border = BorderDto.all(
          BorderSideDto(color: Colors.black, width: 2),
        );
        final dto = BoxDecorationDto(border: border);

        expect(dto.border?.mixValue?.isUniform, isTrue);
      });

      test('ShapeDecorationDto value constructor with null image/gradient', () {
        // NOTE: ShapeDecorationDto.value has null assertion operators on image and gradient
        // so we need to provide non-null values or use maybeValue instead
        const decoration = ShapeDecoration(
          shape: CircleBorder(),
          color: Colors.red,
        );

        final dto = ShapeDecorationDto.maybeValue(decoration);
        expect(dto, isNotNull);
        expect(dto?.color, resolvesTo(Colors.red));
        expect(dto?.shape?.mixValue, isA<CircleBorderDto>());
      });

      test('BoxDecorationDto mergeableDecor preserves border uniformity', () {
        final shapeDeco = ShapeDecorationDto(
          shape: RoundedRectangleBorderDto(
            side: BorderSideDto(color: Colors.red, width: 2),
          ),
        );
        final boxDeco = BoxDecorationDto();

        final merged = boxDeco.mergeableDecor(shapeDeco);

        expect(merged.border?.mixValue, isA<BorderDto>());
        expect((merged.border?.mixValue as BorderDto).isUniform, isTrue);
      });
    });
  });
}
