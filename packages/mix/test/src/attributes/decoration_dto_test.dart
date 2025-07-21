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
        final borderDto = BorderDto.all(BorderSideDto.only(width: 2.0));
        final borderRadiusDto = BorderRadiusDto.value(BorderRadius.circular(8));
        final imageDto = DecorationImageDto.only(fit: BoxFit.cover);
        final gradientDto = LinearGradientDto.only(
          colors: const [Colors.red, Colors.blue],
        );
        final shadowDto = BoxShadowDto.only(
          color: Colors.black,
          offset: const Offset(2, 2),
          blurRadius: 4.0,
        );

        final dto = BoxDecorationDto.only(
          border: borderDto,
          borderRadius: borderRadiusDto,
          shape: BoxShape.rectangle,
          backgroundBlendMode: BlendMode.srcOver,
          color: Colors.red,
          image: imageDto,
          gradient: gradientDto,
          boxShadow: [shadowDto],
        );

        expect(dto.color, resolvesTo(Colors.red));
        expect(dto.shape, resolvesTo(BoxShape.rectangle));
        expect(dto.backgroundBlendMode, resolvesTo(BlendMode.srcOver));
        expect(dto, resolvesTo(isA<BoxDecoration>()));
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
        expect(dto, resolvesTo(isA<BoxDecoration>()));
      });

      test('props constructor with Prop values', () {
        final dto = BoxDecorationDto(
          color: Prop(Colors.green),
          shape: Prop(BoxShape.circle),
          backgroundBlendMode: Prop(BlendMode.multiply),
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
        final dto = BoxDecorationDto.only(
          color: Colors.purple,
          gradient: LinearGradientDto.only(
            colors: const [Colors.red, Colors.blue],
          ),
          borderRadius: BorderRadiusDto.value(BorderRadius.circular(12)),
          shape: BoxShape.rectangle,
        );

        final context = MockBuildContext();
        final resolved = dto.resolve(context);

        expect(resolved.color, Colors.purple);
        expect(resolved.gradient, isA<LinearGradient>());
        expect(resolved.borderRadius, BorderRadius.all(Radius.circular(12)));
        expect(resolved.shape, BoxShape.rectangle);
      });

      test('resolves with default values for null properties', () {
        final dto = BoxDecorationDto(
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
      test('merge with another BoxDecorationDto', () {
        final dto1 = BoxDecorationDto.only(
          color: Colors.red,
          shape: BoxShape.rectangle,
        );

        final dto2 = BoxDecorationDto.only(
          color: Colors.blue,
          gradient: LinearGradientDto.only(
            colors: const [Colors.yellow, Colors.green],
          ),
        );

        final merged = dto1.merge(dto2);

        expect(merged.color, resolvesTo(Colors.blue));
        expect(merged, resolvesTo(isA<BoxDecoration>()));
      });

      test('merge with null returns original', () {
        final dto = BoxDecorationDto.only(
          color: Colors.green,
          shape: BoxShape.rectangle,
        );

        final merged = dto.merge(null);
        expect(merged, same(dto));
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal BoxDecorationDtos', () {
        final dto1 = BoxDecorationDto.only(
          color: Colors.red,
          shape: BoxShape.rectangle,
        );

        final dto2 = BoxDecorationDto.only(
          color: Colors.red,
          shape: BoxShape.rectangle,
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equal BoxDecorationDtos', () {
        final dto1 = BoxDecorationDto.only(color: Colors.red);
        final dto2 = BoxDecorationDto.only(color: Colors.blue);

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
          final shapeDto = CircleBorderDto.only(
            side: BorderSideDto.only(width: 2.0),
          );
          final imageDto = DecorationImageDto.only(fit: BoxFit.contain);
          final gradientDto = LinearGradientDto.only(
            colors: const [Colors.orange, Colors.yellow],
          );
          final shadowDto = BoxShadowDto.only(
            color: Colors.black,
            offset: const Offset(3, 3),
            blurRadius: 6.0,
          );

          final dto = ShapeDecorationDto.only(
            shape: shapeDto,
            color: Colors.green,
            image: imageDto,
            gradient: gradientDto,
            shadows: [shadowDto],
          );

          expect(dto.color, resolvesTo(Colors.green));
          expect(dto, resolvesTo(isA<ShapeDecoration>()));
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
        expect(dto, resolvesTo(isA<ShapeDecoration>()));
      });

      test('props constructor with Prop values', () {
        final dto = ShapeDecorationDto(
          shape: MixProp(CircleBorderDto()),
          color: Prop(Colors.cyan),
        );

        expect(dto.color, resolvesTo(Colors.cyan));
        expect(dto, resolvesTo(isA<ShapeDecoration>()));
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
        final dto = ShapeDecorationDto.only(
          shape: RoundedRectangleBorderDto.only(
            borderRadius: BorderRadiusDto.value(BorderRadius.circular(8)),
          ),
          gradient: RadialGradientDto.only(
            colors: const [Colors.red, Colors.orange],
          ),
        );

        final context = MockBuildContext();
        final resolved = dto.resolve(context);

        expect(resolved.color, isNull); // color is null when gradient is set
        expect(resolved.shape, isA<RoundedRectangleBorder>());
        expect(resolved.gradient, isA<RadialGradient>());
      });

      test('resolves with default values for null properties', () {
        final dto = ShapeDecorationDto(color: null);

        final context = MockBuildContext();
        final resolved = dto.resolve(context);

        expect(resolved.shape, isA<RoundedRectangleBorder>());
        expect(resolved.color, isNull);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with partial properties', () {
        final dto1 = ShapeDecorationDto.only(
          shape: CircleBorderDto(),
          color: Colors.red,
        );

        final dto2 = ShapeDecorationDto.only(
          gradient: LinearGradientDto.only(
            colors: const [Colors.blue, Colors.green],
          ),
          image: DecorationImageDto.only(fit: BoxFit.fill),
        );

        final merged = dto1.merge(dto2);

        expect(merged.color, resolvesTo(Colors.red));
        expect(merged, resolvesTo(isA<ShapeDecoration>()));
      });

      test('merge with null returns original', () {
        final dto = ShapeDecorationDto.only(
          shape: CircleBorderDto(),
          color: Colors.green,
        );

        final merged = dto.merge(null);
        expect(merged, same(dto));
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal ShapeDecorationDtos', () {
        final dto1 = ShapeDecorationDto.only(
          shape: CircleBorderDto(),
          color: Colors.red,
        );

        final dto2 = ShapeDecorationDto.only(
          shape: CircleBorderDto(),
          color: Colors.red,
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equal ShapeDecorationDtos', () {
        final dto1 = ShapeDecorationDto.only(
          shape: CircleBorderDto(),
          color: Colors.red,
        );
        final dto2 = ShapeDecorationDto.only(
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

    // Basic merge tests
    group('merge tests', () {
      test('merge BoxDecorationDto with BoxDecorationDto', () {
        final dto1 = BoxDecorationDto.only(
          color: Colors.red,
          shape: BoxShape.rectangle,
        );
        final dto2 = BoxDecorationDto.only(
          gradient: LinearGradientDto.only(
            colors: const [Colors.blue, Colors.green],
          ),
        );

        final merged = dto1.merge(dto2);

        expect(merged.color, resolvesTo(Colors.red));
        expect(merged, resolvesTo(isA<BoxDecoration>()));
      });

      test('merge with null values', () {
        final dto = BoxDecorationDto.only(color: Colors.red);

        expect(dto.merge(null), same(dto));
      });
    });
  });
}
