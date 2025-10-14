import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/decoration_merge.dart';
import 'package:mix/src/properties/painting/border_mix.dart';
import 'package:mix/src/properties/painting/border_radius_mix.dart';
import 'package:mix/src/properties/painting/decoration_mix.dart';
import 'package:mix/src/properties/painting/gradient_mix.dart';
import 'package:mix/src/properties/painting/shadow_mix.dart';
import 'package:mix/src/properties/painting/shape_border_mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('DecorationMerger', () {
    late BuildContext context;

    setUp(() {
      context = MockBuildContext();
    });
    group('tryMerge', () {
      test('returns null when both decorations are null', () {
        final result = DecorationMerger().tryMerge(context, null, null);
        expect(result, isNull);
      });

      test('returns first decoration when second is null', () {
        final box = BoxDecorationMix(color: Colors.red);
        final result = DecorationMerger().tryMerge(context, box, null);
        expect(result, equals(box));
      });

      test('returns second decoration when first is null', () {
        final shape = ShapeDecorationMix(color: Colors.blue);
        final result = DecorationMerger().tryMerge(context, null, shape);
        expect(result, equals(shape));
      });

      test('merges same type decorations using standard merge', () {
        final box1 = BoxDecorationMix(color: Colors.red);
        final box2 = BoxDecorationMix(
          gradient: LinearGradientMix(colors: [Colors.white, Colors.black]),
        );

        final result =
            DecorationMerger().tryMerge(context, box1, box2)
                as BoxDecorationMix;

        expect(result.runtimeType, equals(BoxDecorationMix));
        expect(result.$color, resolvesTo(Colors.red));
        expect(result.$gradient, isNotNull);
      });
    });

    group('Cross-type merging: BoxDecorationMix + ShapeDecorationMix', () {
      test(
        'preserves BoxDecorationMix when ShapeDecorationMix has only common properties',
        () {
          final box = BoxDecorationMix(
            color: Colors.red,
            border: BorderMix.all(BorderSideMix(color: Colors.black, width: 2)),
            borderRadius: BorderRadiusGeometryMix.circular(8),
          );
          final shape = ShapeDecorationMix(
            color: Colors.blue,
            gradient: LinearGradientMix(colors: [Colors.white, Colors.black]),
          );

          final result = DecorationMerger().tryMerge(context, box, shape);

          expect(result.runtimeType, equals(BoxDecorationMix));
          final boxResult = result as BoxDecorationMix;

          // Second argument takes precedence
          expect(boxResult.$color, resolvesTo(Colors.blue));
          expect(boxResult.$gradient, isNotNull);

          // Box-specific properties preserved
          expect(boxResult.$border, isNotNull);
          expect(boxResult.$borderRadius, isNotNull);
        },
      );

      test(
        'converts to ShapeDecorationMix when ShapeDecorationMix has shape properties',
        () {
          final box = BoxDecorationMix(color: Colors.blue);
          final shape = ShapeDecorationMix(
            color: Colors.red,
            shape: CircleBorderMix(
              side: BorderSideMix(color: Colors.green, width: 3),
            ),
          );

          final result = DecorationMerger().tryMerge(context, box, shape);

          expect(result.runtimeType, equals(ShapeDecorationMix));
          final shapeResult = result as ShapeDecorationMix;

          // Second argument takes precedence
          expect(shapeResult.$color, resolvesTo(Colors.red));
          expect(shapeResult.$shape, isNotNull);
        },
      );

      test(
        'handles complex BoxDecorationMix with shape-specific ShapeDecorationMix',
        () {
          final box = BoxDecorationMix(
            color: Colors.blue,
            border: BorderMix.all(
              BorderSideMix(color: Colors.yellow, width: 1),
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadiusGeometryMix.circular(4),
          );
          final shape = ShapeDecorationMix(
            color: Colors.red,
            gradient: RadialGradientMix(colors: [Colors.purple, Colors.orange]),
            shape: RoundedRectangleBorderMix(
              borderRadius: BorderRadiusGeometryMix.circular(12),
              side: BorderSideMix(color: Colors.pink, width: 2),
            ),
          );

          final result = DecorationMerger().tryMerge(context, box, shape);

          expect(result.runtimeType, equals(ShapeDecorationMix));
          final shapeResult = result as ShapeDecorationMix;

          // Second argument takes precedence
          expect(shapeResult.$color, resolvesTo(Colors.red));
          expect(shapeResult.$gradient, isNotNull);
          expect(shapeResult.$shape, isNotNull);
        },
      );
    });

    group('Cross-type merging: ShapeDecorationMix + BoxDecorationMix', () {
      test(
        'preserves ShapeDecorationMix when BoxDecorationMix has only common properties',
        () {
          final shape = ShapeDecorationMix(
            shape: CircleBorderMix(
              side: BorderSideMix(color: Colors.blue, width: 2),
            ),
            color: Colors.green,
          );
          final box = BoxDecorationMix(
            color: Colors.red,
            gradient: LinearGradientMix(colors: [Colors.cyan, Colors.pink]),
          );

          final result = DecorationMerger().tryMerge(context, shape, box);

          expect(result.runtimeType, equals(ShapeDecorationMix));
          final shapeResult = result as ShapeDecorationMix;

          // Second argument takes precedence
          expect(shapeResult.$color, resolvesTo(Colors.red));
          expect(shapeResult.$gradient, isNotNull);

          // Shape-specific properties preserved
          expect(shapeResult.$shape, isNotNull);
        },
      );

      test(
        'converts to ShapeDecorationMix when BoxDecorationMix has box-specific properties',
        () {
          final shape = ShapeDecorationMix(color: Colors.blue);
          final box = BoxDecorationMix(
            color: Colors.red,
            border: BorderMix.all(BorderSideMix(color: Colors.black, width: 2)),
            borderRadius: BorderRadiusGeometryMix.circular(8),
            shape: BoxShape.rectangle,
          );

          final result = DecorationMerger().tryMerge(context, shape, box);

          expect(result.runtimeType, equals(ShapeDecorationMix));
          final shapeResult = result as ShapeDecorationMix;

          // Second argument takes precedence
          expect(shapeResult.$color, resolvesTo(Colors.red));
          expect(shapeResult.$shape, isNotNull);
        },
      );
    });

    group('Property handling', () {
      test('correctly identifies BoxDecorationMix-specific properties', () {
        final shape = ShapeDecorationMix(color: Colors.blue);

        // Test border property
        final boxWithBorder = BoxDecorationMix(
          border: BorderMix.all(BorderSideMix(color: Colors.red, width: 1)),
        );
        expect(
          DecorationMerger()
              .tryMerge(context, shape, boxWithBorder)
              .runtimeType,
          equals(ShapeDecorationMix),
        );

        // Test borderRadius property
        final boxWithBorderRadius = BoxDecorationMix(
          borderRadius: BorderRadiusGeometryMix.circular(8),
        );
        expect(
          DecorationMerger()
              .tryMerge(context, shape, boxWithBorderRadius)
              .runtimeType,
          equals(ShapeDecorationMix),
        );

        // Test shape property
        final boxWithShape = BoxDecorationMix(shape: BoxShape.circle);
        expect(
          DecorationMerger().tryMerge(context, shape, boxWithShape).runtimeType,
          equals(ShapeDecorationMix),
        );

        // Test backgroundBlendMode property
        final boxWithBlendMode = BoxDecorationMix(
          backgroundBlendMode: BlendMode.multiply,
        );
        expect(
          DecorationMerger()
              .tryMerge(context, shape, boxWithBlendMode)
              .runtimeType,
          equals(ShapeDecorationMix),
        );
      });

      test('correctly identifies ShapeDecorationMix-specific properties', () {
        final box = BoxDecorationMix(color: Colors.red);

        // ShapeDecorationMix without shape - should preserve BoxDecorationMix
        final shapeWithoutShape = ShapeDecorationMix(color: Colors.blue);
        expect(
          DecorationMerger()
              .tryMerge(context, box, shapeWithoutShape)
              .runtimeType,
          equals(BoxDecorationMix),
        );

        // ShapeDecorationMix with shape - should convert to ShapeDecorationMix
        final shapeWithShape = ShapeDecorationMix(
          color: Colors.blue,
          shape: CircleBorderMix(),
        );
        expect(
          DecorationMerger().tryMerge(context, box, shapeWithShape).runtimeType,
          equals(ShapeDecorationMix),
        );
      });

      test('allows valid uniform border conversions', () {
        final shape = ShapeDecorationMix(color: Colors.blue);
        final validBox = BoxDecorationMix(
          shape: BoxShape.circle,
          border: BorderMix.all(
            BorderSideMix(color: Colors.red, width: 2),
          ), // Uniform border
        );

        expect(
          () => DecorationMerger().tryMerge(context, shape, validBox),
          returnsNormally,
        );

        final result = DecorationMerger().tryMerge(context, shape, validBox);
        expect(result.runtimeType, equals(ShapeDecorationMix));
      });
    });

    group('Edge cases', () {
      test('handles empty decorations', () {
        final emptyBox = BoxDecorationMix();
        final emptyShape = ShapeDecorationMix();

        final result = DecorationMerger().tryMerge(
          context,
          emptyBox,
          emptyShape,
        );
        expect(
          result.runtimeType,
          equals(BoxDecorationMix),
        ); // Should preserve original type
      });

      test('handles decorations with only shadows/boxShadow', () {
        final boxWithShadows = BoxDecorationMix(
          boxShadow: BoxShadowListMix([
            BoxShadowMix(color: Colors.black26, blurRadius: 4),
          ]),
        );
        final shapeWithShadows = ShapeDecorationMix(
          shadows: [
            BoxShadowMix(
              color: Colors.red.withValues(alpha: 0.26),
              blurRadius: 8,
            ),
          ],
        );

        final result = DecorationMerger().tryMerge(
          context,
          boxWithShadows,
          shapeWithShadows,
        );
        expect(result.runtimeType, equals(BoxDecorationMix));

        final boxResult = result as BoxDecorationMix;
        expect(boxResult.$boxShadow, isNotNull);
        expect(
          boxResult.$boxShadow!,
          resolvesTo(hasLength(1), context: context),
        ); // Second argument takes precedence
      });

      test('handles null properties correctly', () {
        final boxWithNulls = BoxDecorationMix(
          color: Colors.red,
          border: null,
          gradient: null,
        );
        final shapeWithNulls = ShapeDecorationMix(
          color: null,
          shape: null,
          gradient: LinearGradientMix(colors: [Colors.white, Colors.black]),
        );

        final result = DecorationMerger().tryMerge(
          context,
          boxWithNulls,
          shapeWithNulls,
        );
        expect(result.runtimeType, equals(BoxDecorationMix));

        final boxResult = result as BoxDecorationMix;
        expect(
          boxResult.$color,
          resolvesTo(Colors.red),
        ); // First has color, second doesn't
        expect(boxResult.$gradient, isNotNull); // Second takes precedence
      });
    });

    group('Property preservation', () {
      test('preserves all common properties during merge', () {
        final box = BoxDecorationMix(
          color: Colors.red,
          gradient: LinearGradientMix(colors: [Colors.white, Colors.black]),
          boxShadow: BoxShadowListMix([
            BoxShadowMix(color: Colors.black26, blurRadius: 4),
          ]),
        );
        final shape = ShapeDecorationMix(
          color: Colors.blue,
          gradient: LinearGradientMix(colors: [Colors.yellow, Colors.orange]),
          shadows: [
            BoxShadowMix(
              color: Colors.red.withValues(alpha: 0.26),
              blurRadius: 8,
            ),
          ],
        );

        final result = DecorationMerger().tryMerge(context, box, shape);
        final boxResult = result as BoxDecorationMix;

        // Second argument takes precedence
        expect(boxResult.$color, resolvesTo(Colors.blue));
        expect(boxResult.$gradient, isNotNull);
        expect(boxResult.$boxShadow, isNotNull);
      });

      test('preserves type-specific properties during conversion', () {
        final box = BoxDecorationMix(
          color: Colors.red,
          border: BorderMix.all(BorderSideMix(color: Colors.black, width: 2)),
          borderRadius: BorderRadiusGeometryMix.circular(8),
          shape: BoxShape.rectangle,
        );
        final shape = ShapeDecorationMix(
          color: Colors.blue,
          shape: RoundedRectangleBorderMix(
            borderRadius: BorderRadiusGeometryMix.circular(12),
            side: BorderSideMix(color: Colors.red, width: 3),
          ),
        );

        final result = DecorationMerger().tryMerge(context, box, shape);
        final shapeResult = result as ShapeDecorationMix;

        // Second argument takes precedence
        expect(shapeResult.$color, resolvesTo(Colors.blue));
        expect(shapeResult.$shape, isNotNull);
      });
    });
  });
}
