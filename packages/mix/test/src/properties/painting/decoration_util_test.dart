import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('DecorationUtility', () {
    late DecorationUtility<MockStyle<DecorationMix>> util;

    setUp(() {
      util = DecorationUtility<MockStyle<DecorationMix>>(
        (mix) => MockStyle(mix),
      );
    });

    test('has box property', () {
      expect(util.box, isA<BoxDecorationUtility>());
    });

    test('has shape property', () {
      expect(util.shape, isA<ShapeDecorationUtility>());
    });

    test('as method accepts Decoration', () {
      const decoration = BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      );
      final result = util.as(decoration);

      expect(result.value, isA<DecorationMix>());
      final resolved = result.value.resolve(MockBuildContext());

      expect(resolved, decoration);
    });
  });

  group('BoxDecorationUtility', () {
    late BoxDecorationUtility<MockStyle<BoxDecorationMix>> util;

    setUp(() {
      util = BoxDecorationUtility<MockStyle<BoxDecorationMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has border utility', () {
        expect(util.border, isA<BorderUtility>());
      });

      test('has borderDirectional utility', () {
        expect(util.borderDirectional, isA<BorderDirectionalUtility>());
      });

      test('has borderRadius utility', () {
        expect(util.borderRadius, isA<BorderRadiusUtility>());
      });

      test('has borderRadiusDirectional utility', () {
        expect(
          util.borderRadiusDirectional,
          isA<BorderRadiusDirectionalUtility>(),
        );
      });

      test('has shape utility', () {
        expect(util.shape, isA<MixUtility>());
      });

      test('has backgroundBlendMode utility', () {
        expect(util.backgroundBlendMode, isA<MixUtility>());
      });

      test('has color utility', () {
        expect(util.color, isA<ColorUtility>());
      });

      test('has gradient utility', () {
        expect(util.gradient, isA<GradientUtility>());
      });

      test('has image utility', () {
        expect(util.image, isA<DecorationImageUtility>());
      });

      test('has boxShadows utility', () {
        expect(util.boxShadows, isA<MixUtility>());
      });

      test('has boxShadow utility', () {
        expect(util.boxShadow, isA<BoxShadowUtility>());
      });

      test('has elevation utility', () {
        expect(util.elevation, isA<MixUtility>());
      });
    });

    group('property setters', () {
      test('color sets decoration color', () {
        final result = util.color(Colors.blue);

        final decoration = result.value.resolve(MockBuildContext());

        expect(decoration, const BoxDecoration(color: Colors.blue));
      });

      test('shape sets decoration shape', () {
        final result = util.shape(BoxShape.circle);

        final decoration = result.value.resolve(MockBuildContext());

        expect(decoration, const BoxDecoration(shape: BoxShape.circle));
      });

      test('backgroundBlendMode sets blend mode', () {
        final result = util.only(
          color: Colors.blue,
          backgroundBlendMode: BlendMode.multiply,
        );

        final decoration = result.value.resolve(MockBuildContext());

        expect(
          decoration,
          const BoxDecoration(
            color: Colors.blue,
            backgroundBlendMode: BlendMode.multiply,
          ),
        );
      });
    });

    group('border utilities', () {
      test('border.all sets all border sides', () {
        final result = util.border.all(width: 2.0, color: Colors.red);

        final decoration = result.value.resolve(MockBuildContext());

        expect(
          decoration,
          BoxDecoration(border: Border.all(width: 2.0, color: Colors.red)),
        );
      });

      test('borderRadius.circular sets circular radius', () {
        final result = util.borderRadius.circular(10.0);

        final decoration = result.value.resolve(MockBuildContext());

        expect(
          decoration,
          const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        );
      });
    });

    group('gradient utilities', () {
      test('gradient.linear creates linear gradient', () {
        final result = util.gradient.linear(
          colors: [Colors.red, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

        final decoration = result.value.resolve(MockBuildContext());

        expect(
          decoration,
          const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      });

      test('gradient.radial creates radial gradient', () {
        final result = util.gradient.radial(
          colors: [Colors.red, Colors.blue],
          center: Alignment.center,
          radius: 0.5,
        );

        final decoration = result.value.resolve(MockBuildContext());

        expect(
          decoration,
          const BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.red, Colors.blue],
              center: Alignment.center,
              radius: 0.5,
            ),
          ),
        );
      });
    });

    group('shadow utilities', () {
      test('boxShadow sets single shadow', () {
        final result = util.boxShadow(
          color: Colors.black,
          offset: const Offset(2, 2),
          blurRadius: 4.0,
        );

        final decoration = result.value.resolve(MockBuildContext());

        expect(
          decoration,
          const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(2, 2),
                blurRadius: 4.0,
              ),
            ],
          ),
        );
      });

      test('boxShadows sets multiple shadows', () {
        final shadows = [
          BoxShadow(
            color: Colors.black,
            offset: const Offset(2, 2),
            blurRadius: 4.0,
            spreadRadius: 0.0,
          ),
          BoxShadow(
            color: Colors.grey,
            offset: const Offset(4, 4),
            blurRadius: 8.0,
            spreadRadius: 0.0,
          ),
        ];
        final result = util.boxShadows(shadows);

        final decoration = result.value.resolve(MockBuildContext());

        expect(
          decoration,
          const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(2, 2),
                blurRadius: 4.0,
              ),
              BoxShadow(
                color: Colors.grey,
                offset: Offset(4, 4),
                blurRadius: 8.0,
              ),
            ],
          ),
        );
      });

      test('elevation sets elevation shadow', () {
        final result = util.elevation(ElevationShadow.three);

        final decoration = result.value.resolve(MockBuildContext());

        expect(decoration, isA<BoxDecoration>());
        expect(decoration.boxShadow, isNotNull);
        expect(decoration.boxShadow!.length, greaterThan(0));
      });
    });

    group('only method', () {
      test('sets multiple properties at once', () {
        final result = util.only(
          color: Colors.red,
          shape: BoxShape.circle,
          gradient: LinearGradientMix(colors: [Colors.red, Colors.blue]),
        );

        final decoration = result.value.resolve(MockBuildContext());

        expect(
          decoration,
          const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
          ),
        );
      });
    });

    group('call method', () {
      test('accepts Flutter decoration properties', () {
        final result = util(
          color: Colors.blue,
          border: Border.all(width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            const BoxShadow(
              color: Colors.black,
              offset: Offset(2, 2),
              blurRadius: 4.0,
            ),
          ],
        );

        final decoration = result.value.resolve(MockBuildContext());

        expect(
          decoration,
          BoxDecoration(
            color: Colors.blue,
            border: Border.all(width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(2, 2),
                blurRadius: 4.0,
              ),
            ],
          ),
        );
      });
    });

    group('as method', () {
      test('accepts BoxDecoration', () {
        const decoration = BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(2, 2),
              blurRadius: 4.0,
            ),
          ],
        );
        final result = util.as(decoration);

        expect(
          result.value,
          BoxDecorationMix(
            color: Colors.red,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadowMix(
                color: Colors.black,
                offset: const Offset(2, 2),
                blurRadius: 4.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
        );
      });
    });
  });

  group('ShapeDecorationUtility', () {
    late ShapeDecorationUtility<MockStyle<ShapeDecorationMix>> util;

    setUp(() {
      util = ShapeDecorationUtility<MockStyle<ShapeDecorationMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has shape utility', () {
        expect(util.shape, isA<ShapeBorderUtility>());
      });

      test('has color utility', () {
        expect(util.color, isA<ColorUtility>());
      });

      test('has image utility', () {
        expect(util.image, isA<DecorationImageUtility>());
      });

      test('has gradient utility', () {
        expect(util.gradient, isA<GradientUtility>());
      });

      test('has shadows utility', () {
        expect(util.shadows, isA<MixUtility>());
      });
    });

    group('property setters', () {
      test('color sets decoration color', () {
        final result = util.color(Colors.green);

        final decoration = result.value.resolve(MockBuildContext());

        expect(
          decoration,
          const ShapeDecoration(
            shape: RoundedRectangleBorder(),
            color: Colors.green,
          ),
        );
      });

      test('shape.circle sets circle shape', () {
        final result = util.shape.circle();

        final decoration = result.value.resolve(MockBuildContext());

        expect(decoration, const ShapeDecoration(shape: CircleBorder()));
      });

      test('gradient.linear sets linear gradient', () {
        final result = util.gradient.linear(colors: [Colors.red, Colors.blue]);

        final decoration = result.value.resolve(MockBuildContext());

        expect(
          decoration,
          const ShapeDecoration(
            shape: RoundedRectangleBorder(),
            gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
          ),
        );
      });
    });

    group('only method', () {
      test('sets multiple properties at once', () {
        final result = util.only(
          color: Colors.purple,
          shape: ShapeBorderMix.value(const CircleBorder()),
          shadows: [
            BoxShadowMix(
              color: Colors.black,
              offset: const Offset(2, 2),
              blurRadius: 4.0,
              spreadRadius: 0.0,
            ),
          ],
        );

        final decoration = result.value.resolve(MockBuildContext());

        expect(
          decoration,
          const ShapeDecoration(
            shape: CircleBorder(),
            color: Colors.purple,
            shadows: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(2, 2),
                blurRadius: 4.0,
              ),
            ],
          ),
        );
      });
    });

    group('call method', () {
      test('accepts Flutter decoration properties', () {
        final result = util(
          shape: const CircleBorder(),
          gradient: const RadialGradient(colors: [Colors.red, Colors.yellow]),
        );

        final decoration = result.value.resolve(MockBuildContext());

        expect(
          decoration,
          const ShapeDecoration(
            shape: CircleBorder(),
            gradient: RadialGradient(colors: [Colors.red, Colors.yellow]),
          ),
        );
      });
    });

    group('as method', () {
      test('accepts ShapeDecoration', () {
        const decoration = ShapeDecoration(
          shape: CircleBorder(),
          color: Colors.red,
          shadows: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(2, 2),
              blurRadius: 4.0,
            ),
          ],
        );
        final result = util.as(decoration);

        expect(
          result.value,
          ShapeDecorationMix(
            shape: ShapeBorderMix.value(const CircleBorder()),
            color: Colors.red,
            shadows: [
              BoxShadowMix(
                color: Colors.black,
                offset: const Offset(2, 2),
                blurRadius: 4.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
        );
      });
    });
  });
}
