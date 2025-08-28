import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexWidgetSpecUtility', () {
    group('Constructor', () {
      test('', () {
        final containerAttr = BoxStyle(
          alignment: Alignment.center,
          padding: EdgeInsetsMix(top: 10.0, bottom: 20.0),
        );

        final flexAttr = FlexStyle(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
        );

        final attribute = FlexBoxStyle.create(box: Prop.maybeMix(containerAttr), flex: Prop.maybeMix(flexAttr));

        // Verify properties are set
        expect(attribute.$box!.sources[0], isA<MixSource<Object?>>());
        expect(attribute.$flex!.sources[0], isA<MixSource<Object?>>());
      });

      test('', () {
        final attribute = FlexBoxStyle();

        // Verify empty FlexBoxStyle creates empty box and flex specs
        expect(attribute.$box, isNotNull);
        expect(attribute.$flex, isNotNull);
      });

    });

    group('Resolution', () {
      test('', () {
        final attribute = FlexBoxStyle(
          alignment: Alignment.center,
          padding: EdgeInsetsMix(top: 10.0, bottom: 20.0),
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
        );

        final context = MockBuildContext();
        final resolved = attribute.resolve(context);

        expect(resolved, isNotNull);
        expect(resolved.spec.box?.spec.alignment, Alignment.center);
        expect(
          resolved.spec.box?.spec.padding,
          const EdgeInsets.only(top: 10.0, bottom: 20.0),
        );
        expect(resolved.spec.flex?.spec.direction, Axis.horizontal);
        expect(resolved.spec.flex?.spec.mainAxisAlignment, MainAxisAlignment.center);
      });

      test('resolves complex nested properties correctly', () {
        final attribute = FlexBoxStyle(
          decoration: BoxDecorationMix(
            color: Colors.red,
            border: BoxBorderMix.all(
              BorderSideMix(color: Colors.blue, width: 2.0),
            ),
            borderRadius: BorderRadiusMix(
              topLeft: const Radius.circular(8.0),
              topRight: const Radius.circular(8.0),
            ),
          ),
          spacing: 10.0,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        );

        final context = MockBuildContext();
        final resolved = attribute.resolve(context);

        expect(resolved, isNotNull);
        final decoration = resolved.spec.box?.spec.decoration as BoxDecoration?;
        expect(decoration?.color, Colors.red);
        expect(decoration?.border, isNotNull);
        expect(decoration?.borderRadius, isNotNull);
        expect(resolved.spec.flex?.spec.spacing, 10.0);
        expect(
          resolved.spec.flex?.spec.mainAxisAlignment,
          MainAxisAlignment.spaceBetween,
        );
      });
    });

    group('Merge', () {
      test('merges properties correctly', () {
        final first = FlexBoxStyle(
          alignment: Alignment.center,
          padding: EdgeInsetsMix.all(10.0),
          direction: Axis.horizontal,
        );

        final second = FlexBoxStyle(
          alignment: Alignment.topLeft, // This should override
          margin: EdgeInsetsMix.all(20.0), // This should be added
          mainAxisAlignment: MainAxisAlignment.center, // This should be added
        );

        final merged = first.merge(second);

        // Resolve to check merged values
        final context = MockBuildContext();
        final resolved = merged.resolve(context);
        final boxSpec = resolved.spec.box?.spec;

        expect(
          boxSpec?.alignment,
          Alignment.topLeft,
        ); // second overrides first
        expect(
          boxSpec?.padding,
          const EdgeInsets.all(10.0),
        ); // from first
        expect(
          boxSpec?.margin,
          const EdgeInsets.all(20.0),
        ); // from second
        expect(resolved.spec.flex?.spec.direction, Axis.horizontal); // from first
        expect(
          resolved.spec.flex?.spec.mainAxisAlignment,
          MainAxisAlignment.center,
        ); // from second
      });

      test('returns this when other is null', () {
        final attribute = FlexBoxStyle(
          alignment: Alignment.center,
        );

        final merged = attribute.merge(null);

        expect(identical(attribute, merged), isTrue);
      });

      test('merges nested box and flex attributes correctly', () {
        final first = FlexBoxStyle(
          decoration: BoxDecorationMix(color: Colors.red),
        );

        final second = FlexBoxStyle(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: Colors.blue)),
          ),
        );

        final merged = first.merge(second);

        // Resolve to check merged decoration
        final context = MockBuildContext();
        final resolved = merged.resolve(context);
        final decoration = resolved.spec.box?.spec.decoration as BoxDecoration?;

        expect(decoration?.color, Colors.red); // from first
        expect(decoration?.border, isNotNull); // from second
      });
    });

    group('Equality', () {
      test('equal attributes have same hashCode', () {
        final attr1 = FlexBoxStyle(
          alignment: Alignment.center,
          direction: Axis.horizontal,
        );

        final attr2 = FlexBoxStyle(
          alignment: Alignment.center,
          direction: Axis.horizontal,
        );

        expect(attr1, equals(attr2));
        expect(attr1.hashCode, equals(attr2.hashCode));
      });

      test('different attributes are not equal', () {
        final attr1 = FlexBoxStyle(alignment: Alignment.center);

        final attr2 = FlexBoxStyle(alignment: Alignment.topLeft);

        expect(attr1, isNot(equals(attr2)));
      });

      test('attributes with different nested properties are not equal', () {
        final attr1 = FlexBoxStyle(direction: Axis.horizontal);

        final attr2 = FlexBoxStyle(direction: Axis.vertical);

        expect(attr1, isNot(equals(attr2)));
      });
    });

    group('Modifiers', () {
      test('modifiers can be added to attribute', () {
        final attribute = FlexBoxStyle(
          modifier: ModifierConfig(
            modifiers: [
              OpacityModifierMix(opacity: 0.5),
              TransformModifierMix(
                transform: Matrix4.identity(),
                alignment: Alignment.center,
              ),
            ],
          ),
        );

        expect(attribute.$modifier, isNotNull);
        expect(attribute.$modifier!.$modifiers!.length, 2);
      });

      test('modifiers are merged correctly', () {
        final first = FlexBoxStyle(
          modifier: ModifierConfig(
            modifiers: [OpacityModifierMix(opacity: 0.5)],
          ),
        );

        final second = FlexBoxStyle(
          modifier: ModifierConfig(
            modifiers: [TransformModifierMix(transform: Matrix4.identity())],
          ),
        );

        final merged = first.merge(second);

        // Modifiers are combined when merging
        expect(merged.$modifier, isNotNull);
        expect(merged.$modifier!.$modifiers!.length, 2);
      });
    });

    group('Animation', () {
      test('animation config can be added to attribute', () {
        final attribute = FlexBoxStyle();
        expect(attribute.$animation, isNull); // By default no animation

        final withAnimation = FlexBoxStyle(
          animation: CurveAnimationConfig(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          ),
        );

        expect(withAnimation.$animation, isNotNull);
      });
    });

    group('Variants', () {
      test('variants functionality exists', () {
        final attribute = FlexBoxStyle();
        expect(attribute.$variants, isNull); // By default no variants

        final variant = ContextVariant('test', (context) => true);
        final withVariants = FlexBoxStyle(
          variants: [
            VariantStyle(
              variant,
              FlexBoxStyle(
                decoration: BoxDecorationMix(color: Colors.green),
              ),
            ),
          ],
        );

        expect(withVariants.$variants, isNotNull);
        expect(withVariants.$variants!.length, 1);
      });
    });

    group('Composite Behavior', () {
      test('box and flex attributes work independently', () {
        final boxOnly = FlexBoxStyle(alignment: Alignment.center);

        final flexOnly = FlexBoxStyle(
          direction: Axis.horizontal,
        );

        expect(boxOnly.$box, isNotNull);
        expect(boxOnly.$flex, isNotNull); // Now creates empty flex even for box-only

        expect(flexOnly.$box, isNotNull); // Now creates empty box even for flex-only
        expect(flexOnly.$flex, isNotNull);
      });

      test('partial updates preserve other attribute', () {
        final initial = FlexBoxStyle(
          alignment: Alignment.center,
          direction: Axis.horizontal,
        );

        final updateBox = FlexBoxStyle(
          padding: EdgeInsetsMix.all(10.0),
        );

        final merged = initial.merge(updateBox);

        // Check that flex is preserved and box is updated
        final context = MockBuildContext();
        final resolved = merged.resolve(context);

        expect(resolved.spec.flex?.spec.direction, Axis.horizontal); // preserved
        expect(
          resolved.spec.box?.spec.padding,
          const EdgeInsets.all(10.0),
        ); // updated
        final boxSpec = resolved.spec.box?.spec;
        expect(
          boxSpec?.alignment,
          Alignment.center,
        ); // preserved from initial container
      });
    });

    group('Edge Cases', () {
      test('handles empty merge correctly', () {
        final empty1 = FlexBoxStyle();
        final empty2 = FlexBoxStyle();

        final merged = empty1.merge(empty2);

        expect(merged.$box, isNotNull); // Empty FlexBoxStyle creates empty specs
        expect(merged.$flex, isNotNull);
      });

      test('handles resolution with all null properties', () {
        final attribute = FlexBoxStyle();

        final context = MockBuildContext();
        final resolved = attribute.resolve(context);

        expect(resolved, isNotNull);
        expect(resolved.spec.box, isNotNull); // Empty FlexBoxStyle resolves to empty BoxSpec
        expect(resolved.spec.flex, isNotNull); // Empty FlexBoxStyle resolves to empty FlexSpec
      });

      test('handles complex nested chaining', () {
        final utility = FlexBoxSpecUtility();

        // Build complex nested structure using mutable utilities
        utility.alignment(Alignment.center);
        utility.padding.all(10.0);
        utility.margin.horizontal(20.0);
        utility.color.red();
        utility.direction(Axis.horizontal);
        utility.mainAxisAlignment(MainAxisAlignment.spaceBetween);
        utility.spacing(10.0);

        final context = MockBuildContext();
        final resolved = utility.resolve(context);
        final boxSpec = resolved.spec.box?.spec;

        // Verify all properties are resolved correctly
        expect(boxSpec?.alignment, Alignment.center);
        expect(boxSpec?.padding, const EdgeInsets.all(10.0));
        expect(
          boxSpec?.margin,
          const EdgeInsets.symmetric(horizontal: 20.0),
        );
        expect(
          (boxSpec?.decoration as BoxDecoration?)?.color,
          Colors.red,
        );
        expect(resolved.spec.flex?.spec.direction, Axis.horizontal);
        expect(
          resolved.spec.flex?.spec.mainAxisAlignment,
          MainAxisAlignment.spaceBetween,
        );
        expect(resolved.spec.flex?.spec.spacing, 10.0);
      });
    });
  });

  group('FlexWidgetSpecUtility', () {
    test('', () {
      final spec = FlexBoxSpec();

      expect(spec.box, null);
      expect(spec.flex, null);
    });

    test('', () {
      const boxSpec = BoxSpec(alignment: Alignment.center);
      const flexSpec = FlexSpec(direction: Axis.vertical);
      final boxWidgetSpec = WidgetSpec(spec: boxSpec);
      final flexWidgetSpec = WidgetSpec(spec: flexSpec);
      final spec = FlexBoxSpec(box: boxWidgetSpec, flex: flexWidgetSpec);

      expect(spec.box?.spec, boxSpec);
      expect(spec.flex?.spec, flexSpec);
    });

    test('copyWith creates new instance with updated values', () {
      final original = FlexBoxSpec(
        box: WidgetSpec(spec: BoxSpec(alignment: Alignment.center)),
        flex: WidgetSpec(spec: FlexSpec(direction: Axis.horizontal)),
      );

      final updated = original.copyWith(
        box: WidgetSpec(spec: BoxSpec(alignment: Alignment.topLeft)),
      );

      expect(updated.box?.spec.alignment, Alignment.topLeft);
      expect(updated.flex?.spec.direction, Axis.horizontal);
      expect(identical(original, updated), isFalse);
    });

    test('', () {
      final spec1 = FlexBoxSpec(
        box: WidgetSpec(spec: BoxSpec(padding: EdgeInsets.all(10.0))),
        flex: WidgetSpec(spec: FlexSpec(spacing: 10.0)),
      );

      final spec2 = FlexBoxSpec(
        box: WidgetSpec(spec: BoxSpec(padding: EdgeInsets.all(20.0))),
        flex: WidgetSpec(spec: FlexSpec(spacing: 20.0)),
      );

      final interpolated = spec1.lerp(spec2, 0.5);
      final boxSpec = interpolated.box?.spec;
      final flexSpec = interpolated.flex?.spec;

      expect(boxSpec?.padding, const EdgeInsets.all(15.0));
      expect(flexSpec?.spacing, 15.0);
    });

    test('lerp interpolates properly when other is null', () {
      final spec = FlexBoxSpec(box: WidgetSpec(spec: BoxSpec(alignment: Alignment.center)));

      final result = spec.lerp(null, 0.5);
      final boxSpec = result.box?.spec;

      // Properties should interpolate according to their lerp behavior
      expect(
        boxSpec?.alignment,
        Alignment.lerp(Alignment.center, null, 0.5),
      );
    });

    test('equality and hashCode', () {
      final spec1 = FlexBoxSpec(
        box: WidgetSpec(spec: BoxSpec(alignment: Alignment.center)),
        flex: WidgetSpec(spec: FlexSpec(direction: Axis.horizontal)),
      );

      final spec2 = FlexBoxSpec(
        box: WidgetSpec(spec: BoxSpec(alignment: Alignment.center)),
        flex: WidgetSpec(spec: FlexSpec(direction: Axis.horizontal)),
      );

      final spec3 = FlexBoxSpec(
        box: WidgetSpec(spec: BoxSpec(alignment: Alignment.topLeft)),
        flex: WidgetSpec(spec: FlexSpec(direction: Axis.horizontal)),
      );

      expect(spec1, equals(spec2));
      expect(spec1.hashCode, equals(spec2.hashCode));
      expect(spec1, isNot(equals(spec3)));
    });
  });
}
