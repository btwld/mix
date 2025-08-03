import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/decoration_merge.dart';
import 'package:mix/src/properties/painting/border_mix.dart';
import 'package:mix/src/properties/painting/border_radius_mix.dart';
import 'package:mix/src/properties/painting/decoration_mix.dart';
import 'package:mix/src/properties/painting/gradient_mix.dart';
import 'package:mix/src/properties/painting/shadow_mix.dart';
import 'package:mix/src/properties/painting/shape_border_mix.dart';

void main() {
  group('DecorationMerger', () {
    group('tryMerge', () {
      test('returns null when both decorations are null', () {
        final result = DecorationMerger().tryMerge(null, null);
        expect(result, isNull);
      });

      test('returns first decoration when second is null', () {
        final box = BoxDecorationMix(color: Colors.red);
        final result = DecorationMerger().tryMerge(box, null);
        expect(result, equals(box));
      });

      test('returns second decoration when first is null', () {
        final shape = ShapeDecorationMix(color: Colors.blue);
        final result = DecorationMerger().tryMerge(null, shape);
        expect(result, equals(shape));
      });

      test('merges same type decorations using standard merge', () {
        final box1 = BoxDecorationMix(color: Colors.red);
        final box2 = BoxDecorationMix(
          gradient: LinearGradientMix(colors: [Colors.white, Colors.black]),
        );

        final result =
            DecorationMerger().tryMerge(box1, box2) as BoxDecorationMix;

        expect(result.runtimeType, equals(BoxDecorationMix));
        expect(result.$color?.$value, equals(Colors.red));
        expect(result.$gradient?.value, isA<LinearGradientMix>());
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

          final result = DecorationMerger().tryMerge(box, shape);

          expect(result.runtimeType, equals(BoxDecorationMix));
          final boxResult = result as BoxDecorationMix;

          // Second argument takes precedence
          expect(boxResult.$color?.$value, equals(Colors.blue));
          expect(boxResult.$gradient?.value, isA<LinearGradientMix>());

          // Box-specific properties preserved
          expect(
            boxResult.$border?.value,
            equals(BorderMix.all(BorderSideMix(color: Colors.black, width: 2))),
          );
          expect(
            boxResult.$borderRadius?.value,
            equals(BorderRadiusGeometryMix.circular(8)),
          );
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

          final result = DecorationMerger().tryMerge(box, shape);

          expect(result.runtimeType, equals(ShapeDecorationMix));
          final shapeResult = result as ShapeDecorationMix;

          // Second argument takes precedence
          expect(shapeResult.$color?.$value, equals(Colors.red));
          expect(shapeResult.$shape?.value, isA<CircleBorderMix>());
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

          final result = DecorationMerger().tryMerge(box, shape);

          expect(result.runtimeType, equals(ShapeDecorationMix));
          final shapeResult = result as ShapeDecorationMix;

          // Second argument takes precedence
          expect(shapeResult.$color?.$value, equals(Colors.red));
          expect(shapeResult.$gradient?.value, isA<RadialGradientMix>());
          expect(shapeResult.$shape?.value, isA<RoundedRectangleBorderMix>());
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

          final result = DecorationMerger().tryMerge(shape, box);

          expect(result.runtimeType, equals(ShapeDecorationMix));
          final shapeResult = result as ShapeDecorationMix;

          // Second argument takes precedence
          expect(shapeResult.$color?.$value, equals(Colors.red));
          expect(shapeResult.$gradient?.value, isA<LinearGradientMix>());

          // Shape-specific properties preserved
          expect(shapeResult.$shape?.value, isA<CircleBorderMix>());
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

          final result = DecorationMerger().tryMerge(shape, box);

          expect(result.runtimeType, equals(ShapeDecorationMix));
          final shapeResult = result as ShapeDecorationMix;

          // Second argument takes precedence
          expect(shapeResult.$color?.$value, equals(Colors.red));
          expect(shapeResult.$shape?.value, isA<RoundedRectangleBorderMix>());
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
          DecorationMerger().tryMerge(shape, boxWithBorder).runtimeType,
          equals(ShapeDecorationMix),
        );

        // Test borderRadius property
        final boxWithBorderRadius = BoxDecorationMix(
          borderRadius: BorderRadiusGeometryMix.circular(8),
        );
        expect(
          DecorationMerger().tryMerge(shape, boxWithBorderRadius).runtimeType,
          equals(ShapeDecorationMix),
        );

        // Test shape property
        final boxWithShape = BoxDecorationMix(shape: BoxShape.circle);
        expect(
          DecorationMerger().tryMerge(shape, boxWithShape).runtimeType,
          equals(ShapeDecorationMix),
        );

        // Test backgroundBlendMode property
        final boxWithBlendMode = BoxDecorationMix(
          backgroundBlendMode: BlendMode.multiply,
        );
        expect(
          DecorationMerger().tryMerge(shape, boxWithBlendMode).runtimeType,
          equals(ShapeDecorationMix),
        );
      });

      test('correctly identifies ShapeDecorationMix-specific properties', () {
        final box = BoxDecorationMix(color: Colors.red);

        // ShapeDecorationMix without shape - should preserve BoxDecorationMix
        final shapeWithoutShape = ShapeDecorationMix(color: Colors.blue);
        expect(
          DecorationMerger().tryMerge(box, shapeWithoutShape).runtimeType,
          equals(BoxDecorationMix),
        );

        // ShapeDecorationMix with shape - should convert to ShapeDecorationMix
        final shapeWithShape = ShapeDecorationMix(
          color: Colors.blue,
          shape: CircleBorderMix(),
        );
        expect(
          DecorationMerger().tryMerge(box, shapeWithShape).runtimeType,
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
          () => DecorationMerger().tryMerge(shape, validBox),
          returnsNormally,
        );

        final result = DecorationMerger().tryMerge(shape, validBox);
        expect(result.runtimeType, equals(ShapeDecorationMix));
      });
    });

    group('Edge cases', () {
      test('handles empty decorations', () {
        final emptyBox = BoxDecorationMix();
        final emptyShape = ShapeDecorationMix();

        final result = DecorationMerger().tryMerge(emptyBox, emptyShape);
        expect(
          result.runtimeType,
          equals(BoxDecorationMix),
        ); // Should preserve original type
      });

      test('handles decorations with only shadows/boxShadow', () {
        final boxWithShadows = BoxDecorationMix(
          boxShadow: [BoxShadowMix(color: Colors.black26, blurRadius: 4)],
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
          boxWithShadows,
          shapeWithShadows,
        );
        expect(result.runtimeType, equals(BoxDecorationMix));

        final boxResult = result as BoxDecorationMix;
        expect(boxResult.$boxShadow?.length, equals(1));
        expect(
          (boxResult.$boxShadow?.first.value as BoxShadowMix).$color?.$value,
          equals(Colors.red.withValues(alpha: 0.26)),
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
          boxWithNulls,
          shapeWithNulls,
        );
        expect(result.runtimeType, equals(BoxDecorationMix));

        final boxResult = result as BoxDecorationMix;
        expect(
          boxResult.$color?.$value,
          equals(Colors.red),
        ); // First has color, second doesn't
        expect(
          boxResult.$gradient?.value,
          isA<LinearGradientMix>(),
        ); // Second takes precedence
      });
    });

    group('Property preservation', () {
      test('preserves all common properties during merge', () {
        final box = BoxDecorationMix(
          color: Colors.red,
          gradient: LinearGradientMix(colors: [Colors.white, Colors.black]),
          boxShadow: [BoxShadowMix(color: Colors.black26, blurRadius: 4)],
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

        final result = DecorationMerger().tryMerge(box, shape);
        final boxResult = result as BoxDecorationMix;

        // Second argument takes precedence
        expect(boxResult.$color?.$value, equals(Colors.blue));
        expect(boxResult.$gradient?.value, isA<LinearGradientMix>());
        expect(
          (boxResult.$boxShadow?.first.value as BoxShadowMix).$color?.$value,
          equals(Colors.red.withValues(alpha: 0.26)),
        );
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

        final result = DecorationMerger().tryMerge(box, shape);
        final shapeResult = result as ShapeDecorationMix;

        // Second argument takes precedence
        expect(shapeResult.$color?.$value, equals(Colors.blue));
        expect(shapeResult.$shape?.value, isA<RoundedRectangleBorderMix>());
      });
    });
  });
}
