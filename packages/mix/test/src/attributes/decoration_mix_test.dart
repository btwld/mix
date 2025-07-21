import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
import '../../helpers/mock_build_context.dart';

void main() {
  // BoxDecorationMix tests
  group('BoxDecorationMix', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('main constructor creates BoxDecorationMix with all properties', () {
        final borderMix = BorderMix.all(BorderSideMix.only(width: 2.0));
        final borderRadiusDto = BorderRadiusMix.value(BorderRadius.circular(8));
        final imageDto = DecorationImageMix.only(fit: BoxFit.cover);
        final gradientDto = LinearGradientMix.only(
          colors: const [Colors.red, Colors.blue],
        );
        final shadowDto = BoxShadowMix.only(
          color: Colors.black,
          offset: const Offset(2, 2),
          blurRadius: 4.0,
        );

        final mix = BoxDecorationMix.only(
          border: borderMix,
          borderRadius: borderRadiusDto,
          shape: BoxShape.rectangle,
          backgroundBlendMode: BlendMode.srcOver,
          color: Colors.red,
          image: imageDto,
          gradient: gradientDto,
          boxShadow: [shadowDto],
        );

        expect(mix.color, resolvesTo(Colors.red));
        expect(mix.shape, resolvesTo(BoxShape.rectangle));
        expect(mix.backgroundBlendMode, resolvesTo(BlendMode.srcOver));
        expect(mix, resolvesTo(isA<BoxDecoration>()));
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

        final mix = BoxDecorationMix.value(decoration);

        expect(mix.color, resolvesTo(Colors.blue));
        expect(mix.borderRadius, resolvesTo(decoration.borderRadius));
        expect(mix, resolvesTo(isA<BoxDecoration>()));
      });

      test('props constructor with Prop values', () {
        final mix = BoxDecorationMix(
          color: Prop(Colors.green),
          shape: Prop(BoxShape.circle),
          backgroundBlendMode: Prop(BlendMode.multiply),
        );

        expect(mix.color, resolvesTo(Colors.green));
        expect(mix.shape, resolvesTo(BoxShape.circle));
        expect(mix.backgroundBlendMode, resolvesTo(BlendMode.multiply));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test(
        'maybeValue returns BoxDecorationMix for non-null BoxDecoration',
        () {
          const decoration = BoxDecoration(color: Colors.red);
          final mix = BoxDecorationMix.maybeValue(decoration);

          expect(mix, isNotNull);
          expect(mix?.color, resolvesTo(Colors.red));
        },
      );

      test('maybeValue returns null for null BoxDecoration', () {
        final mix = BoxDecorationMix.maybeValue(null);
        expect(mix, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to BoxDecoration with all properties', () {
        final mix = BoxDecorationMix.only(
          color: Colors.purple,
          gradient: LinearGradientMix.only(
            colors: const [Colors.red, Colors.blue],
          ),
          borderRadius: BorderRadiusMix.value(BorderRadius.circular(12)),
          shape: BoxShape.rectangle,
        );

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.color, Colors.purple);
        expect(resolved.gradient, isA<LinearGradient>());
        expect(resolved.borderRadius, BorderRadius.all(Radius.circular(12)));
        expect(resolved.shape, BoxShape.rectangle);
      });

      test('resolves with default values for null properties', () {
        final mix = BoxDecorationMix(
          color: null,
          gradient: null,
          image: null,
          boxShadow: null,
        );

        expect(mix, resolvesTo(const BoxDecoration()));
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another BoxDecorationMix', () {
        final mix1 = BoxDecorationMix.only(
          color: Colors.red,
          shape: BoxShape.rectangle,
        );

        final mix2 = BoxDecorationMix.only(
          color: Colors.blue,
          gradient: LinearGradientMix.only(
            colors: const [Colors.yellow, Colors.green],
          ),
        );

        final merged = dto1.merge(mix2);

        expect(merged.color, resolvesTo(Colors.blue));
        expect(merged, resolvesTo(isA<BoxDecoration>()));
      });

      test('merge with null returns original', () {
        final mix = BoxDecorationMix.only(
          color: Colors.green,
          shape: BoxShape.rectangle,
        );

        final merged = mix.merge(null);
        expect(merged, same(mix));
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal BoxDecorationMixs', () {
        final mix1 = BoxDecorationMix.only(
          color: Colors.red,
          shape: BoxShape.rectangle,
        );

        final mix2 = BoxDecorationMix.only(
          color: Colors.red,
          shape: BoxShape.rectangle,
        );

        expect(mix1, equals(mix2));
        expect(mix1.hashCode, equals(mix2.hashCode));
      });

      test('not equal BoxDecorationMixs', () {
        final mix1 = BoxDecorationMix.only(color: Colors.red);
        final mix2 = BoxDecorationMix.only(color: Colors.blue);

        expect(mix1, isNot(equals(mix2)));
      });
    });
  });

  // ShapeDecorationMix tests
  group('ShapeDecorationMix', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test(
        'main constructor creates ShapeDecorationMix with all properties',
        () {
          final shapeDto = CircleBorderMix.only(
            side: BorderSideMix.only(width: 2.0),
          );
          final imageDto = DecorationImageMix.only(fit: BoxFit.contain);
          final gradientDto = LinearGradientMix.only(
            colors: const [Colors.orange, Colors.yellow],
          );
          final shadowDto = BoxShadowMix.only(
            color: Colors.black,
            offset: const Offset(3, 3),
            blurRadius: 6.0,
          );

          final mix = ShapeDecorationMix.only(
            shape: shapeDto,
            color: Colors.green,
            image: imageDto,
            gradient: gradientDto,
            shadows: [shadowDto],
          );

          expect(mix.color, resolvesTo(Colors.green));
          expect(mix, resolvesTo(isA<ShapeDecoration>()));
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

        final mix = ShapeDecorationMix.value(decoration);

        expect(mix.color, resolvesTo(Colors.purple));
        expect(mix, resolvesTo(isA<ShapeDecoration>()));
      });

      test('props constructor with Prop values', () {
        final mix = ShapeDecorationMix(
          shape: MixProp(CircleBorderMix()),
          color: Prop(Colors.cyan),
        );

        expect(mix.color, resolvesTo(Colors.cyan));
        expect(mix, resolvesTo(isA<ShapeDecoration>()));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test(
        'maybeValue returns ShapeDecorationMix for non-null ShapeDecoration',
        () {
          const decoration = ShapeDecoration(
            color: Colors.red,
            shape: CircleBorder(),
          );
          final mix = ShapeDecorationMix.maybeValue(decoration);

          expect(mix, isNotNull);
          expect(mix?.color, resolvesTo(Colors.red));
        },
      );

      test('maybeValue returns null for null ShapeDecoration', () {
        final mix = ShapeDecorationMix.maybeValue(null);
        expect(mix, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to ShapeDecoration with all properties', () {
        final mix = ShapeDecorationMix.only(
          shape: RoundedRectangleBorderMix.only(
            borderRadius: BorderRadiusMix.value(BorderRadius.circular(8)),
          ),
          gradient: RadialGradientMix.only(
            colors: const [Colors.red, Colors.orange],
          ),
        );

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.color, isNull); // color is null when gradient is set
        expect(resolved.shape, isA<RoundedRectangleBorder>());
        expect(resolved.gradient, isA<RadialGradient>());
      });

      test('resolves with default values for null properties', () {
        final mix = ShapeDecorationMix(color: null);

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.shape, isA<RoundedRectangleBorder>());
        expect(resolved.color, isNull);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with partial properties', () {
        final mix1 = ShapeDecorationMix.only(
          shape: CircleBorderMix(),
          color: Colors.red,
        );

        final mix2 = ShapeDecorationMix.only(
          gradient: LinearGradientMix.only(
            colors: const [Colors.blue, Colors.green],
          ),
          image: DecorationImageMix.only(fit: BoxFit.fill),
        );

        final merged = dto1.merge(mix2);

        expect(merged.color, resolvesTo(Colors.red));
        expect(merged, resolvesTo(isA<ShapeDecoration>()));
      });

      test('merge with null returns original', () {
        final mix = ShapeDecorationMix.only(
          shape: CircleBorderMix(),
          color: Colors.green,
        );

        final merged = mix.merge(null);
        expect(merged, same(mix));
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal ShapeDecorationMixs', () {
        final mix1 = ShapeDecorationMix.only(
          shape: CircleBorderMix(),
          color: Colors.red,
        );

        final mix2 = ShapeDecorationMix.only(
          shape: CircleBorderMix(),
          color: Colors.red,
        );

        expect(mix1, equals(mix2));
        expect(mix1.hashCode, equals(mix2.hashCode));
      });

      test('not equal ShapeDecorationMixs', () {
        final mix1 = ShapeDecorationMix.only(
          shape: CircleBorderMix(),
          color: Colors.red,
        );
        final mix2 = ShapeDecorationMix.only(
          shape: CircleBorderMix(),
          color: Colors.blue,
        );

        expect(mix1, isNot(equals(mix2)));
      });
    });
  });

  // DecorationMix cross-type tests
  group('DecorationMix cross-type tests', () {
    // Base DecorationMix factory tests
    group('DecorationMix factory tests', () {
      test('value factory with BoxDecoration', () {
        const decoration = BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        );
        final mix = DecorationMix.value(decoration);

        expect(mix, isA<BoxDecorationMix>());
        expect((mix as BoxDecorationMix).color, resolvesTo(Colors.red));
      });

      test('value factory with ShapeDecoration', () {
        const decoration = ShapeDecoration(
          color: Colors.blue,
          shape: CircleBorder(),
        );
        final mix = DecorationMix.value(decoration);

        expect(mix, isA<ShapeDecorationMix>());
        expect((mix as ShapeDecorationMix).color, resolvesTo(Colors.blue));
      });

      test('maybeValue factory', () {
        const decoration = BoxDecoration(color: Colors.red);
        final mix = DecorationMix.maybeValue(decoration);

        expect(mix, isNotNull);
        expect(mix, isA<BoxDecorationMix>());

        final nullDto = DecorationMix.maybeValue(null);
        expect(nullDto, isNull);
      });
    });

    // Basic merge tests
    group('merge tests', () {
      test('merge BoxDecorationMix with BoxDecorationMix', () {
        final mix1 = BoxDecorationMix.only(
          color: Colors.red,
          shape: BoxShape.rectangle,
        );
        final mix2 = BoxDecorationMix.only(
          gradient: LinearGradientMix.only(
            colors: const [Colors.blue, Colors.green],
          ),
        );

        final merged = dto1.merge(mix2);

        expect(merged.color, resolvesTo(Colors.red));
        expect(merged, resolvesTo(isA<BoxDecoration>()));
      });

      test('merge with null values', () {
        final mix = BoxDecorationMix.only(color: Colors.red);

        expect(mix.merge(null), same(mix));
      });
    });
  });
}
