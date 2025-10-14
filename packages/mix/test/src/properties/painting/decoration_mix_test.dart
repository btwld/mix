import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BoxDecorationMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final boxDecorationMix = BoxDecorationMix(
          color: Colors.blue,
          shape: BoxShape.circle,
          backgroundBlendMode: BlendMode.multiply,
          border: BorderMix.all(BorderSideMix(color: Colors.red, width: 2.0)),
          borderRadius: BorderRadiusMix(topLeft: const Radius.circular(8.0)),
          boxShadow: BoxShadowListMix([BoxShadowMix(color: Colors.black, blurRadius: 5.0)]),
        );

        expect(boxDecorationMix.$color, resolvesTo(Colors.blue));
        expect(boxDecorationMix.$shape, resolvesTo(BoxShape.circle));
        expect(
          boxDecorationMix.$backgroundBlendMode,
          resolvesTo(BlendMode.multiply),
        );
        expect(boxDecorationMix.$border, isA<Prop<BoxBorder>>());
        expect(
          boxDecorationMix.$borderRadius,
          isA<Prop<BorderRadiusGeometry>>(),
        );
        expect(boxDecorationMix.$boxShadow, resolvesTo(hasLength(1)));
      });

      test('named constructors work correctly', () {
        final borderMix = BorderMix.all(
          BorderSideMix(color: Colors.red, width: 2.0),
        );
        final borderDecorationMix = BoxDecorationMix.border(borderMix);

        expect(borderDecorationMix.$border, isA<Prop<BoxBorder>>());
        expect(borderDecorationMix.$color, isNull);

        final colorDecorationMix = DecorationMix.color(Colors.green);
        expect(colorDecorationMix.$color, resolvesTo(Colors.green));
        expect(colorDecorationMix.$border, isNull);

        final shapeDecorationMix = BoxDecorationMix.shape(BoxShape.circle);
        expect(shapeDecorationMix.$shape, resolvesTo(BoxShape.circle));
      });

      test('value constructor extracts all properties from BoxDecoration', () {
        const boxDecoration = BoxDecoration(
          color: Colors.red,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border(
            top: BorderSide(color: Colors.blue, width: 2.0),
            right: BorderSide(color: Colors.green, width: 1.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(2.0, 2.0),
              blurRadius: 5.0,
              spreadRadius: 1.0,
            ),
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1.0, 1.0),
              blurRadius: 3.0,
            ),
          ],
          gradient: LinearGradient(
            colors: [Colors.white, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          backgroundBlendMode: BlendMode.multiply,
        );

        final boxDecorationMix = BoxDecorationMix.value(boxDecoration);

        expect(boxDecorationMix.$color, resolvesTo(Colors.red));
        expect(boxDecorationMix.$shape, resolvesTo(BoxShape.rectangle));
        expect(
          boxDecorationMix.$backgroundBlendMode,
          resolvesTo(BlendMode.multiply),
        );

        // Test border extraction
        expect(boxDecorationMix.$border, isNotNull);
        // BoxDecorationMix.value() creates a BorderMix, which is wrapped as MixSource
        final borderMixSource =
            boxDecorationMix.$border!.sources[0] as MixSource<BoxBorder>;
        final borderMix = borderMixSource.mix;
        // Resolve the BorderMix to get the actual Border
        final border = borderMix.resolve(MockBuildContext()) as Border;
        expect(border.top.color, Colors.blue);
        expect(border.top.width, 2.0);
        expect(border.right.color, Colors.green);
        expect(border.right.width, 1.0);

        // Test borderRadius extraction
        expect(boxDecorationMix.$borderRadius, isNotNull);
        // BorderRadiusGeometryMix.maybeValue() creates a Mix
        final borderRadiusMixSource =
            boxDecorationMix.$borderRadius!.sources[0]
                as MixSource<BorderRadiusGeometry>;
        final borderRadiusMix = borderRadiusMixSource.mix;
        final borderRadius =
            borderRadiusMix.resolve(MockBuildContext()) as BorderRadius;
        expect(borderRadius.topLeft, const Radius.circular(8.0));

        // Test boxShadow extraction
        expect(boxDecorationMix.$boxShadow, resolvesTo(hasLength(2)));

        // Test gradient extraction
        expect(boxDecorationMix.$gradient, isNotNull);
        final gradientMixSource =
            boxDecorationMix.$gradient!.sources[0] as MixSource<Gradient>;
        final gradientMix = gradientMixSource.mix;
        final gradient =
            gradientMix.resolve(MockBuildContext()) as LinearGradient;
        expect(gradient.colors, [Colors.white, Colors.black]);
        expect(gradient.begin, Alignment.topLeft);
        expect(gradient.end, Alignment.bottomRight);
      });

      test('maybeValue returns null for null input', () {
        final result = BoxDecorationMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns BoxDecorationMix for non-null input', () {
        const boxDecoration = BoxDecoration(color: Colors.blue);
        final result = BoxDecorationMix.maybeValue(boxDecoration);

        expect(result, isNotNull);
        expect(result!.$color, resolvesTo(Colors.blue));
      });
    });

    group('resolve', () {
      test('resolves to BoxDecoration with correct properties', () {
        final boxDecorationMix = BoxDecorationMix(
          color: Colors.blue,
          shape: BoxShape.circle,
          border: BorderMix.all(BorderSideMix(color: Colors.red, width: 2.0)),
        );

        // For complex objects with nested properties, test specific properties after resolution
        // as per testing guide
        final context = MockBuildContext();
        final resolved = boxDecorationMix.resolve(context);
        expect(resolved, isA<BoxDecoration>());
        expect(resolved.color, Colors.blue);
        expect(resolved.shape, BoxShape.circle);
        expect(resolved.border, isA<Border>());
        expect(resolved.border!.top.color, Colors.red);
        expect(resolved.border!.top.width, 2.0);
      });

      test('resolves with complex properties', () {
        final boxDecorationMix = BoxDecorationMix(
          borderRadius: BorderRadiusMix(topLeft: const Radius.circular(8.0)),
          boxShadow: BoxShadowListMix([
            BoxShadowMix(color: Colors.black, blurRadius: 5.0),
            BoxShadowMix(color: Colors.grey, blurRadius: 10.0),
          ]),
        );

        final resolved = boxDecorationMix.resolve(MockBuildContext());
        expect(resolved, isA<BoxDecoration>());
        expect(resolved.borderRadius, isA<BorderRadius>());
        expect(resolved.boxShadow, hasLength(2));
        expect(resolved.boxShadow![0].color, Colors.black);
        expect(resolved.boxShadow![1].color, Colors.grey);
      });
    });

    group('merge', () {
      test('returns equivalent instance when other is null', () {
        final boxDecorationMix = BoxDecorationMix(color: Colors.blue);
        final merged = boxDecorationMix.merge(null);

        expect(identical(merged, boxDecorationMix), isFalse);
        expect(merged, equals(boxDecorationMix));
      });

      test('merges properties correctly', () {
        final first = BoxDecorationMix(
          color: Colors.blue,
          shape: BoxShape.rectangle,
        );

        final second = BoxDecorationMix(
          color: Colors.red,
          backgroundBlendMode: BlendMode.multiply,
        );

        final merged = first.merge(second);

        expect(merged.$color, resolvesTo(Colors.red));
        expect(merged.$shape, resolvesTo(BoxShape.rectangle));
        expect(merged.$backgroundBlendMode, resolvesTo(BlendMode.multiply));
      });

      test('merges list properties correctly', () {
        final first = BoxDecorationMix(
          boxShadow: BoxShadowListMix([BoxShadowMix(color: Colors.black, blurRadius: 5.0)]),
        );

        final second = BoxDecorationMix(
          boxShadow: BoxShadowListMix([BoxShadowMix(color: Colors.grey, blurRadius: 10.0)]),
        );

        final merged = first.merge(second);

        expect(merged.$boxShadow, resolvesTo(hasLength(1)));
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final boxDecorationMix1 = BoxDecorationMix(
          color: Colors.blue,
          shape: BoxShape.circle,
        );

        final boxDecorationMix2 = BoxDecorationMix(
          color: Colors.blue,
          shape: BoxShape.circle,
        );

        expect(boxDecorationMix1, boxDecorationMix2);
        expect(boxDecorationMix1.hashCode, boxDecorationMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final boxDecorationMix1 = BoxDecorationMix(color: Colors.blue);
        final boxDecorationMix2 = BoxDecorationMix(color: Colors.red);

        expect(boxDecorationMix1, isNot(boxDecorationMix2));
      });
    });
  });

  group('ShapeDecorationMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final shapeDecorationMix = ShapeDecorationMix(
          color: Colors.green,
          shape: CircleBorderMix(),
          shadows: [BoxShadowMix(color: Colors.black, blurRadius: 5.0)],
        );

        expect(shapeDecorationMix.$color, resolvesTo(Colors.green));
        expect(shapeDecorationMix.$shape, isA<Prop<ShapeBorder>>());
        expect(shapeDecorationMix.$shadows, resolvesTo(hasLength(1)));
      });

      test('value constructor extracts all properties from ShapeDecoration', () {
        // Note: ShapeDecoration can't have both color and gradient, so we use gradient only
        final shapeDecoration = ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Colors.blue, width: 2.0),
          ),
          gradient: RadialGradient(
            colors: [Colors.red, Colors.yellow],
            center: Alignment.center,
            radius: 0.5,
          ),
          shadows: [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(3.0, 3.0),
              blurRadius: 6.0,
              spreadRadius: 2.0,
            ),
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1.0, 1.0),
              blurRadius: 2.0,
            ),
          ],
          image: DecorationImage(
            image: NetworkImage('https://example.com/image.png'),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        );

        final shapeDecorationMix = ShapeDecorationMix.value(shapeDecoration);

        // Color should be null since we're using gradient
        expect(shapeDecorationMix.$color, isNull);

        // Test shape extraction
        expect(shapeDecorationMix.$shape, isNotNull);
        // ShapeDecorationMix.value() creates a ShapeBorderMix, which is wrapped as MixSource
        final shapeMixSource =
            shapeDecorationMix.$shape!.sources[0] as MixSource<ShapeBorder>;
        final shapeMix = shapeMixSource.mix;
        // Resolve the ShapeBorderMix to get the actual ShapeBorder
        final shape =
            shapeMix.resolve(MockBuildContext()) as RoundedRectangleBorder;
        expect(shape.borderRadius, BorderRadius.circular(10.0));
        expect(shape.side.color, Colors.blue);
        expect(shape.side.width, 2.0);

        // Test gradient extraction
        expect(shapeDecorationMix.$gradient, isNotNull);
        // GradientMix.maybeValue() creates a GradientMix, which is wrapped as MixSource
        final gradientMixSource =
            shapeDecorationMix.$gradient!.sources[0] as MixSource<Gradient>;
        final gradientMix = gradientMixSource.mix;
        // Resolve the GradientMix to get the actual Gradient
        final gradient =
            gradientMix.resolve(MockBuildContext()) as RadialGradient;
        expect(gradient.colors, [Colors.red, Colors.yellow]);
        expect(gradient.center, Alignment.center);
        expect(gradient.radius, 0.5);

        // Test shadows extraction
        expect(shapeDecorationMix.$shadows, resolvesTo(hasLength(2)));

        // Test image extraction
        expect(shapeDecorationMix.$image, isNotNull);
        // DecorationImageMix.maybeValue() creates a Mix
        final imageMixSource =
            shapeDecorationMix.$image!.sources[0] as MixSource<DecorationImage>;
        final imageMix = imageMixSource.mix;
        final decorationImage = imageMix.resolve(MockBuildContext());
        expect(decorationImage.image, isA<NetworkImage>());
        expect(decorationImage.fit, BoxFit.cover);
        expect(decorationImage.alignment, Alignment.topCenter);
      });

      test('maybeValue returns null for null input', () {
        final result = ShapeDecorationMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns ShapeDecorationMix for non-null input', () {
        const shapeDecoration = ShapeDecoration(
          color: Colors.orange,
          shape: CircleBorder(),
        );
        final result = ShapeDecorationMix.maybeValue(shapeDecoration);

        expect(result, isNotNull);
        expect(result!.$color, resolvesTo(Colors.orange));
      });
    });

    group('resolve', () {
      test('resolves to ShapeDecoration with correct properties', () {
        final shapeDecorationMix = ShapeDecorationMix(
          color: Colors.green,
          shape: CircleBorderMix(),
        );

        const expectedDecoration = ShapeDecoration(
          color: Colors.green,
          shape: CircleBorder(),
        );

        expect(shapeDecorationMix, resolvesTo(expectedDecoration));
      });
    });

    group('merge', () {
      test('returns equivalent instance when other is null', () {
        final shapeDecorationMix = ShapeDecorationMix(color: Colors.green);
        final merged = shapeDecorationMix.merge(null);

        expect(identical(merged, shapeDecorationMix), isFalse);
        expect(merged, equals(shapeDecorationMix));
      });

      test('merges properties correctly', () {
        final first = ShapeDecorationMix(
          color: Colors.green,
          shape: CircleBorderMix(),
        );

        final second = ShapeDecorationMix(color: Colors.purple);

        final merged = first.merge(second);

        expect(merged.$color, resolvesTo(Colors.purple));
        expect(merged.$shape, isA<Prop<ShapeBorder>>());
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final shapeDecorationMix1 = ShapeDecorationMix(color: Colors.green);

        final shapeDecorationMix2 = ShapeDecorationMix(color: Colors.green);

        expect(shapeDecorationMix1, shapeDecorationMix2);
        expect(shapeDecorationMix1.hashCode, shapeDecorationMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final shapeDecorationMix1 = ShapeDecorationMix(color: Colors.green);
        final shapeDecorationMix2 = ShapeDecorationMix(color: Colors.purple);

        expect(shapeDecorationMix1, isNot(shapeDecorationMix2));
      });
    });
  });
}
