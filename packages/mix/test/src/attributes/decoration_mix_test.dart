import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
import '../../helpers/testing_utils.dart';

void main() {
  group('BoxDecorationMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final boxDecorationMix = BoxDecorationMix.only(
          color: Colors.blue,
          shape: BoxShape.circle,
          backgroundBlendMode: BlendMode.multiply,
          border: BorderMix.all(
            BorderSideMix.only(color: Colors.red, width: 2.0),
          ),
          borderRadius: BorderRadiusMix.only(
            topLeft: const Radius.circular(8.0),
          ),
          boxShadow: [BoxShadowMix.only(color: Colors.black, blurRadius: 5.0)],
        );

        expect(boxDecorationMix.color, isProp(Colors.blue));
        expect(boxDecorationMix.shape, isProp(BoxShape.circle));
        expect(
          boxDecorationMix.backgroundBlendMode,
          isProp(BlendMode.multiply),
        );
        expect(boxDecorationMix.border, isA<MixProp<BoxBorder>>());
        expect(
          boxDecorationMix.borderRadius,
          isA<MixProp<BorderRadiusGeometry>>(),
        );
        expect(boxDecorationMix.boxShadow, hasLength(1));
        expect(boxDecorationMix.boxShadow![0], isA<MixProp<BoxShadow>>());
      });

      test('named constructors work correctly', () {
        final borderMix = BorderMix.all(
          BorderSideMix.only(color: Colors.red, width: 2.0),
        );
        final borderDecorationMix = BoxDecorationMix.border(borderMix);

        expect(borderDecorationMix.border, isA<MixProp<BoxBorder>>());
        expect(borderDecorationMix.color, isNull);

        final colorDecorationMix = BoxDecorationMix.color(Colors.green);
        expect(colorDecorationMix.color, isProp(Colors.green));
        expect(colorDecorationMix.border, isNull);

        final shapeDecorationMix = BoxDecorationMix.shape(BoxShape.circle);
        expect(shapeDecorationMix.shape, isProp(BoxShape.circle));
      });

      test('value constructor extracts properties from BoxDecoration', () {
        final boxDecoration = BoxDecoration(
          color: Colors.red,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
        );

        final boxDecorationMix = BoxDecorationMix.value(boxDecoration);

        expect(boxDecorationMix.color, isProp(Colors.red));
        expect(boxDecorationMix.shape, isProp(BoxShape.rectangle));
        expect(
          boxDecorationMix.borderRadius,
          isA<MixProp<BorderRadiusGeometry>>(),
        );
      });

      test('maybeValue returns null for null input', () {
        final result = BoxDecorationMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns BoxDecorationMix for non-null input', () {
        const boxDecoration = BoxDecoration(color: Colors.blue);
        final result = BoxDecorationMix.maybeValue(boxDecoration);

        expect(result, isNotNull);
        expect(result!.color, isProp(Colors.blue));
      });
    });

    group('resolve', () {
      test('resolves to BoxDecoration with correct properties', () {
        final boxDecorationMix = BoxDecorationMix.only(
          color: Colors.blue,
          shape: BoxShape.circle,
          border: BorderMix.all(
            BorderSideMix.only(color: Colors.red, width: 2.0),
          ),
        );

        final context = MockBuildContext();
        final resolved = boxDecorationMix.resolve(context);

        expect(resolved.color, Colors.blue);
        expect(resolved.shape, BoxShape.circle);
        expect(resolved.border, isA<Border>());
      });

      test('resolves with complex properties', () {
        final boxDecorationMix = BoxDecorationMix.only(
          borderRadius: BorderRadiusMix.only(
            topLeft: const Radius.circular(8.0),
          ),
          boxShadow: [
            BoxShadowMix.only(color: Colors.black, blurRadius: 5.0),
            BoxShadowMix.only(color: Colors.grey, blurRadius: 10.0),
          ],
        );

        final context = MockBuildContext();
        final resolved = boxDecorationMix.resolve(context);

        expect(resolved.borderRadius, isA<BorderRadius>());
        expect(resolved.boxShadow, hasLength(2));
        expect(resolved.boxShadow![0].color, Colors.black);
        expect(resolved.boxShadow![1].color, Colors.grey);
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final boxDecorationMix = BoxDecorationMix.only(color: Colors.blue);
        final merged = boxDecorationMix.merge(null);

        expect(merged, same(boxDecorationMix));
      });

      test('merges properties correctly', () {
        final first = BoxDecorationMix.only(
          color: Colors.blue,
          shape: BoxShape.rectangle,
        );

        final second = BoxDecorationMix.only(
          color: Colors.red,
          backgroundBlendMode: BlendMode.multiply,
        );

        final merged = first.merge(second) as BoxDecorationMix;

        expect(merged.color, isProp(Colors.red));
        expect(merged.shape, isProp(BoxShape.rectangle));
        expect(merged.backgroundBlendMode, isProp(BlendMode.multiply));
      });

      test('merges list properties correctly', () {
        final first = BoxDecorationMix.only(
          boxShadow: [BoxShadowMix.only(color: Colors.black, blurRadius: 5.0)],
        );

        final second = BoxDecorationMix.only(
          boxShadow: [BoxShadowMix.only(color: Colors.grey, blurRadius: 10.0)],
        );

        final merged = first.merge(second);

        expect(merged.boxShadow, hasLength(2));
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final boxDecorationMix1 = BoxDecorationMix.only(
          color: Colors.blue,
          shape: BoxShape.circle,
        );

        final boxDecorationMix2 = BoxDecorationMix.only(
          color: Colors.blue,
          shape: BoxShape.circle,
        );

        expect(boxDecorationMix1, boxDecorationMix2);
        expect(boxDecorationMix1.hashCode, boxDecorationMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final boxDecorationMix1 = BoxDecorationMix.only(color: Colors.blue);
        final boxDecorationMix2 = BoxDecorationMix.only(color: Colors.red);

        expect(boxDecorationMix1, isNot(boxDecorationMix2));
      });
    });
  });

  group('ShapeDecorationMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final shapeDecorationMix = ShapeDecorationMix.only(
          color: Colors.green,
          shape: CircleBorderMix.only(),
          shadows: [BoxShadowMix.only(color: Colors.black, blurRadius: 5.0)],
        );

        expect(shapeDecorationMix.color, isProp(Colors.green));
        expect(shapeDecorationMix.shape, isA<MixProp<ShapeBorder>>());
        expect(shapeDecorationMix.shadows, hasLength(1));
      });

      test('value constructor extracts properties from ShapeDecoration', () {
        const shapeDecoration = ShapeDecoration(
          color: Colors.purple,
          shape: CircleBorder(),
        );

        final shapeDecorationMix = ShapeDecorationMix.value(shapeDecoration);

        expect(shapeDecorationMix.color, isProp(Colors.purple));
        expect(shapeDecorationMix.shape, isA<MixProp<ShapeBorder>>());
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
        expect(result!.color, isProp(Colors.orange));
      });
    });

    group('resolve', () {
      test('resolves to ShapeDecoration with correct properties', () {
        final shapeDecorationMix = ShapeDecorationMix.only(
          color: Colors.green,
          shape: CircleBorderMix.only(),
        );

        final context = MockBuildContext();
        final resolved = shapeDecorationMix.resolve(context);

        expect(resolved.color, Colors.green);
        expect(resolved.shape, isA<CircleBorder>());
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final shapeDecorationMix = ShapeDecorationMix.only(color: Colors.green);
        final merged = shapeDecorationMix.merge(null);

        expect(merged, same(shapeDecorationMix));
      });

      test('merges properties correctly', () {
        final first = ShapeDecorationMix.only(
          color: Colors.green,
          shape: CircleBorderMix.only(),
        );

        final second = ShapeDecorationMix.only(color: Colors.purple);

        final merged = first.merge(second) as ShapeDecorationMix;

        expect(merged.color, isProp(Colors.purple));
        expect(merged.shape, isA<MixProp<ShapeBorder>>());
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final shapeDecorationMix1 = ShapeDecorationMix.only(
          color: Colors.green,
        );

        final shapeDecorationMix2 = ShapeDecorationMix.only(
          color: Colors.green,
        );

        expect(shapeDecorationMix1, shapeDecorationMix2);
        expect(shapeDecorationMix1.hashCode, shapeDecorationMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final shapeDecorationMix1 = ShapeDecorationMix.only(
          color: Colors.green,
        );
        final shapeDecorationMix2 = ShapeDecorationMix.only(
          color: Colors.purple,
        );

        expect(shapeDecorationMix1, isNot(shapeDecorationMix2));
      });
    });
  });
}
