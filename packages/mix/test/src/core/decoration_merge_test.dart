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
        final result = DecorationMerger.tryMerge(null, null);
        expect(result, isNull);
      });

      test('returns first decoration when second is null', () {
        final box = BoxDecorationMix(color: Colors.red);
        final result = DecorationMerger.tryMerge(box, null);
        expect(result, equals(box));
      });

      test('returns second decoration when first is null', () {
        final shape = ShapeDecorationMix(color: Colors.blue);
        final result = DecorationMerger.tryMerge(null, shape);
        expect(result, equals(shape));
      });

      test('merges same type decorations using standard merge', () {
        final box1 = BoxDecorationMix(color: Colors.red);
        final box2 = BoxDecorationMix(
          gradient: LinearGradientMix(colors: [Colors.white, Colors.black]),
        );

        final result =
            DecorationMerger.tryMerge(box1, box2) as BoxDecorationMix;

        expect(result.runtimeType, equals(BoxDecorationMix));
        expect(result.$color?.value, equals(Colors.red));
        expect(result.$gradient?.value, isA<LinearGradientMix>());
      });
    });

    group('Target Type Determination - BoxDecorationMix + ShapeDecorationMix', () {
      test(
        'preserves BoxDecorationMix when ShapeDecorationMix has only common properties',
        () {
          final box = BoxDecorationMix(
            border: BorderMix.all(BorderSideMix(color: Colors.black, width: 2)),
            borderRadius: BorderRadiusGeometryMix.circular(8),
          );
          final shape = ShapeDecorationMix(
            color: Colors.red,
            gradient: LinearGradientMix(colors: [Colors.white, Colors.black]),
          );

          final result = DecorationMerger.tryMerge(box, shape);

          expect(result.runtimeType, equals(BoxDecorationMix));
          final boxResult = result as BoxDecorationMix;
          expect(boxResult.$color?.value, equals(Colors.red));

          // Check graident values matchesd the second
          expect(
            boxResult.$gradient?.value,
            equals(LinearGradientMix(colors: [Colors.white, Colors.black])),
          );
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

          final result = DecorationMerger.tryMerge(box, shape);

          expect(result.runtimeType, equals(ShapeDecorationMix));
          final shapeResult = result as ShapeDecorationMix;
          expect(
            shapeResult.$color?.value,
            equals(Colors.blue),
          ); // Box color takes precedence in merge
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
            gradient: RadialGradientMix(colors: [Colors.purple, Colors.orange]),
            shape: RoundedRectangleBorderMix(
              borderRadius: BorderRadiusGeometryMix.circular(12),
              side: BorderSideMix(color: Colors.pink, width: 2),
            ),
          );

          final result = DecorationMerger.tryMerge(box, shape);

          expect(result.runtimeType, equals(ShapeDecorationMix));
          final shapeResult = result as ShapeDecorationMix;
          expect(shapeResult.$gradient?.value, isA<RadialGradientMix>());
          expect(shapeResult.$shape?.value, isA<RoundedRectangleBorderMix>());
        },
      );
    });

    group('Target Type Determination - ShapeDecorationMix + BoxDecorationMix', () {
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

          final result = DecorationMerger.tryMerge(shape, box);

          expect(result.runtimeType, equals(ShapeDecorationMix));
          final shapeResult = result as ShapeDecorationMix;
          expect(shapeResult.$color?.value, equals(Colors.red));
          expect(shapeResult.$gradient?.value, isA<LinearGradientMix>());
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

          final result = DecorationMerger.tryMerge(shape, box);

          expect(result.runtimeType, equals(ShapeDecorationMix));
          final shapeResult = result as ShapeDecorationMix;
          expect(shapeResult.$color?.value, equals(Colors.red));
          expect(shapeResult.$shape?.value, isA<RoundedRectangleBorderMix>());
        },
      );
    });

    group('Property-Specific Detection', () {
      test('correctly identifies BoxDecorationMix-specific properties', () {
        // Test each box-specific property individually
        final boxWithBorder = BoxDecorationMix(
          border: BorderMix.all(BorderSideMix(color: Colors.red, width: 1)),
        );
        final boxWithBorderRadius = BoxDecorationMix(
          borderRadius: BorderRadiusGeometryMix.circular(8),
        );
        final boxWithShape = BoxDecorationMix(shape: BoxShape.circle);
        final boxWithBlendMode = BoxDecorationMix(
          backgroundBlendMode: BlendMode.multiply,
        );

        final shape = ShapeDecorationMix(color: Colors.blue);

        // Each should convert to accommodate box-specific properties
        expect(
          DecorationMerger.tryMerge(shape, boxWithBorder).runtimeType,
          equals(ShapeDecorationMix),
        );
        expect(
          DecorationMerger.tryMerge(shape, boxWithBorderRadius).runtimeType,
          equals(ShapeDecorationMix),
        );
        expect(
          DecorationMerger.tryMerge(shape, boxWithShape).runtimeType,
          equals(ShapeDecorationMix),
        );

        // backgroundBlendMode should throw error due to validation
        expect(
          () => DecorationMerger.tryMerge(shape, boxWithBlendMode),
          throwsArgumentError,
        );
      });

      test('correctly identifies ShapeDecorationMix-specific properties', () {
        final box = BoxDecorationMix(color: Colors.red);

        // ShapeDecorationMix without shape - should preserve BoxDecorationMix
        final shapeWithoutShape = ShapeDecorationMix(color: Colors.blue);
        expect(
          DecorationMerger.tryMerge(box, shapeWithoutShape).runtimeType,
          equals(BoxDecorationMix),
        );

        // ShapeDecorationMix with shape - should convert to ShapeDecorationMix
        final shapeWithShape = ShapeDecorationMix(
          color: Colors.blue,
          shape: CircleBorderMix(),
        );
        expect(
          DecorationMerger.tryMerge(box, shapeWithShape).runtimeType,
          equals(ShapeDecorationMix),
        );
      });

      test('handles complex combinations of properties', () {
        final complexBox = BoxDecorationMix(
          color: Colors.red,
          border: BorderMix.all(BorderSideMix(color: Colors.black, width: 2)),
          borderRadius: BorderRadiusGeometryMix.circular(8),
          gradient: LinearGradientMix(colors: [Colors.white, Colors.grey]),
          boxShadow: [BoxShadowMix(color: Colors.black26, blurRadius: 4)],
        );

        final complexShape = ShapeDecorationMix(
          color: Colors.blue,
          shape: RoundedRectangleBorderMix(
            borderRadius: BorderRadiusGeometryMix.circular(12),
          ),
          gradient: LinearGradientMix(
            colors: [Colors.yellow, Colors.orange],
          ), // Same type to allow merging
          shadows: [
            BoxShadowMix(color: Colors.red.withOpacity(0.26), blurRadius: 8),
          ],
        );

        final result = DecorationMerger.tryMerge(complexBox, complexShape);
        expect(result.runtimeType, equals(ShapeDecorationMix));

        final shapeResult = result as ShapeDecorationMix;
        expect(
          shapeResult.$color?.value,
          equals(Colors.red),
        ); // Box's original color takes precedence
        expect(shapeResult.$gradient?.value, isA<LinearGradientMix>());
        expect(shapeResult.$shape?.value, isA<RoundedRectangleBorderMix>());
        expect(shapeResult.shadows?.length, equals(1));
      });
    });

    group('Validation Logic', () {
      test('throws error when BoxDecorationMix has backgroundBlendMode', () {
        final shape = ShapeDecorationMix(color: Colors.blue);
        final boxWithBlendMode = BoxDecorationMix(
          color: Colors.red,
          backgroundBlendMode: BlendMode.multiply,
        );

        expect(
          () => DecorationMerger.tryMerge(shape, boxWithBlendMode),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('backgroundBlendMode'),
            ),
          ),
        );
      });

      test(
        'throws error when BoxDecorationMix has circle shape with non-uniform border',
        () {
          final shape = ShapeDecorationMix(color: Colors.blue);
          final boxWithNonUniformCircle = BoxDecorationMix(
            shape: BoxShape.circle,
            border: BorderMix(
              top: BorderSideMix(color: Colors.red, width: 2),
              bottom: BorderSideMix(
                color: Colors.blue,
                width: 3,
              ), // Different width
            ),
          );

          expect(
            () => DecorationMerger.tryMerge(shape, boxWithNonUniformCircle),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                contains('circle shape'),
              ),
            ),
          );
        },
      );

      test(
        'throws error when BoxDecorationMix has borderRadius with non-uniform border',
        () {
          final shape = ShapeDecorationMix(color: Colors.blue);
          final boxWithNonUniformRadius = BoxDecorationMix(
            borderRadius: BorderRadiusGeometryMix.circular(8),
            border: BorderMix(
              left: BorderSideMix(color: Colors.red, width: 2),
              right: BorderSideMix(
                color: Colors.red,
                width: 4,
              ), // Different width
            ),
          );

          expect(
            () => DecorationMerger.tryMerge(shape, boxWithNonUniformRadius),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                contains('borderRadius'),
              ),
            ),
          );
        },
      );

      test('allows valid uniform border conversions', () {
        final shape = ShapeDecorationMix(color: Colors.blue);
        final validBox = BoxDecorationMix(
          shape: BoxShape.circle,
          border: BorderMix.all(
            BorderSideMix(color: Colors.red, width: 2),
          ), // Uniform
        );

        expect(
          () => DecorationMerger.tryMerge(shape, validBox),
          returnsNormally,
        );

        final result = DecorationMerger.tryMerge(shape, validBox);
        expect(result.runtimeType, equals(ShapeDecorationMix));
      });
    });

    group('canMerge', () {
      test('returns true when either decoration is null', () {
        final box = BoxDecorationMix(color: Colors.red);
        expect(DecorationMerger.needsAccumulation(null, box), isTrue);
        expect(DecorationMerger.needsAccumulation(box, null), isTrue);
        expect(DecorationMerger.needsAccumulation(null, null), isTrue);
      });

      test('returns true for same type decorations', () {
        final box1 = BoxDecorationMix(color: Colors.red);
        final box2 = BoxDecorationMix(color: Colors.blue);
        expect(DecorationMerger.needsAccumulation(box1, box2), isTrue);

        final shape1 = ShapeDecorationMix(color: Colors.red);
        final shape2 = ShapeDecorationMix(color: Colors.blue);
        expect(DecorationMerger.needsAccumulation(shape1, shape2), isTrue);
      });

      test('returns true for BoxDecorationMix + ShapeDecorationMix', () {
        final box = BoxDecorationMix(color: Colors.red);
        final shape = ShapeDecorationMix(color: Colors.blue);
        expect(DecorationMerger.needsAccumulation(box, shape), isTrue);
      });

      test(
        'returns true for ShapeDecorationMix + mergeable BoxDecorationMix',
        () {
          final shape = ShapeDecorationMix(color: Colors.blue);
          final mergeableBox = BoxDecorationMix(
            color: Colors.red,
            border: BorderMix.all(BorderSideMix(color: Colors.black, width: 2)),
          );
          expect(
            DecorationMerger.needsAccumulation(shape, mergeableBox),
            isTrue,
          );
        },
      );

      test(
        'returns false for ShapeDecorationMix + non-mergeable BoxDecorationMix',
        () {
          final shape = ShapeDecorationMix(color: Colors.blue);
          final nonMergeableBox = BoxDecorationMix(
            backgroundBlendMode:
                BlendMode.multiply, // This makes it non-mergeable
          );
          expect(
            DecorationMerger.needsAccumulation(shape, nonMergeableBox),
            isFalse,
          );
        },
      );
    });

    group('Edge Cases', () {
      test('handles empty decorations', () {
        final emptyBox = BoxDecorationMix();
        final emptyShape = ShapeDecorationMix();

        final result = DecorationMerger.tryMerge(emptyBox, emptyShape);
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
            BoxShadowMix(color: Colors.red.withOpacity(0.26), blurRadius: 8),
          ],
        );

        final result = DecorationMerger.tryMerge(
          boxWithShadows,
          shapeWithShadows,
        );
        expect(result.runtimeType, equals(BoxDecorationMix));

        final boxResult = result as BoxDecorationMix;
        expect(boxResult.$boxShadow?.length, equals(1));
        expect(
          (boxResult.$boxShadow?.first.value as BoxShadowMix).$color?.value,
          equals(Colors.red.withOpacity(0.26)),
        ); // Shape shadows take precedence
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

        final result = DecorationMerger.tryMerge(boxWithNulls, shapeWithNulls);
        expect(result.runtimeType, equals(BoxDecorationMix));

        final boxResult = result as BoxDecorationMix;
        expect(boxResult.$color?.value, equals(Colors.red));
        expect(boxResult.$gradient?.value, isA<LinearGradientMix>());
      });
    });

    group('Property Preservation', () {
      test('preserves all common properties during merge', () {
        final box = BoxDecorationMix(
          color: Colors.red,
          gradient: LinearGradientMix(colors: [Colors.white, Colors.black]),
          boxShadow: [BoxShadowMix(color: Colors.black26, blurRadius: 4)],
        );
        final shape = ShapeDecorationMix(
          color: Colors.blue,
          gradient: LinearGradientMix(
            colors: [Colors.yellow, Colors.orange],
          ), // Same type as box
          shadows: [
            BoxShadowMix(color: Colors.red.withOpacity(0.26), blurRadius: 8),
          ],
        );

        final result = DecorationMerger.tryMerge(box, shape);
        final boxResult = result as BoxDecorationMix;

        // Should merge properties correctly
        expect(
          boxResult.$color?.value,
          equals(Colors.blue),
        ); // Shape takes precedence
        expect(
          boxResult.$gradient?.value,
          isA<LinearGradientMix>(),
        ); // Shape takes precedence
        expect(
          (boxResult.$boxShadow?.first.value as BoxShadowMix).$color?.value,
          equals(Colors.red.withOpacity(0.26)),
        ); // Shape takes precedence
      });

      test('preserves type-specific properties during conversion', () {
        final box = BoxDecorationMix(
          border: BorderMix.all(BorderSideMix(color: Colors.black, width: 2)),
          borderRadius: BorderRadiusGeometryMix.circular(8),
          shape: BoxShape.rectangle,
        );
        final shape = ShapeDecorationMix(
          shape: RoundedRectangleBorderMix(
            borderRadius: BorderRadiusGeometryMix.circular(12),
            side: BorderSideMix(color: Colors.red, width: 3),
          ),
        );

        final result = DecorationMerger.tryMerge(box, shape);
        final shapeResult = result as ShapeDecorationMix;

        // Should convert box properties and merge with shape, using compatible shape types
        expect(
          shapeResult.$shape?.value,
          isA<RoundedRectangleBorderMix>(),
        ); // Shape takes precedence
      });
    });
  });
}
