import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexBoxSpecAttribute', () {
    group('Constructor', () {
      test('creates FlexBoxSpecAttribute with all properties', () {
        final containerAttr = ContainerSpecMix(
          alignment: Alignment.center,
          padding: EdgeInsetsMix(top: 10.0, bottom: 20.0),
        );

        final flexAttr = FlexPropertiesMix(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
        );

        final attribute = FlexBoxMix(container: containerAttr, flex: flexAttr);

        // Verify properties are set
        expect(attribute.$container!.sources[0], isA<MixSource<Object?>>());
        expect(attribute.$flex!.sources[0], isA<MixSource<Object?>>());
      });

      test('creates empty FlexBoxSpecAttribute', () {
        final attribute = FlexBoxMix();

        // Verify all properties are null in default state
        expect(attribute.$container, isNull);
        expect(attribute.$flex, isNull);
      });

      test(
        'value constructor creates FlexBoxSpecAttribute from FlexBoxSpec',
        () {
          const spec = FlexBoxSpec(
            container: ContainerSpec(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16.0),
            ),
            flex: FlexProperties(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          );

          final attribute = FlexBoxMix.value(spec);

          expect(attribute.$container, isNotNull);
          expect(attribute.$flex, isNotNull);
        },
      );

      test('maybeValue returns null for null spec', () {
        expect(FlexBoxMix.maybeValue(null), isNull);
      });

      test('maybeValue returns attribute for non-null spec', () {
        const spec = FlexBoxSpec(
          container: ContainerSpec(alignment: Alignment.center),
          flex: FlexProperties(direction: Axis.vertical),
        );

        final attribute = FlexBoxMix.maybeValue(spec);

        expect(attribute, isNotNull);
        expect(attribute!.$container, isNotNull);
        expect(attribute.$flex, isNotNull);
      });
    });

    group('Resolution', () {
      test('resolves to FlexBoxSpec with correct properties', () {
        final attribute = FlexBoxMix(
          container: ContainerSpecMix(
            alignment: Alignment.center,
            padding: EdgeInsetsMix(top: 10.0, bottom: 20.0),
          ),
          flex: FlexPropertiesMix(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        );

        final context = MockBuildContext();
        final resolved = attribute.resolve(context);

        expect(resolved, isNotNull);
        expect(resolved.container?.alignment, Alignment.center);
        expect(
          resolved.container?.padding,
          const EdgeInsets.only(top: 10.0, bottom: 20.0),
        );
        expect(resolved.flex?.direction, Axis.horizontal);
        expect(resolved.flex?.mainAxisAlignment, MainAxisAlignment.center);
      });

      test('resolves complex nested properties correctly', () {
        final attribute = FlexBoxMix(
          container: ContainerSpecMix(
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
          ),

          flex: FlexPropertiesMix(
            spacing: 10.0,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        );

        final context = MockBuildContext();
        final resolved = attribute.resolve(context);

        expect(resolved, isNotNull);
        final decoration = resolved.container?.decoration as BoxDecoration?;
        expect(decoration?.color, Colors.red);
        expect(decoration?.border, isNotNull);
        expect(decoration?.borderRadius, isNotNull);
        expect(resolved.flex?.spacing, 10.0);
        expect(resolved.flex?.mainAxisAlignment, MainAxisAlignment.spaceBetween);
      });
    });

    group('Merge', () {
      test('merges properties correctly', () {
        final first = FlexBoxMix(
          container: ContainerSpecMix(
            alignment: Alignment.center,
            padding: EdgeInsetsMix.all(10.0),
          ),
          flex: FlexPropertiesMix(direction: Axis.horizontal),
        );

        final second = FlexBoxMix(
          container: ContainerSpecMix(
            alignment: Alignment.topLeft, // This should override
            margin: EdgeInsetsMix.all(20.0), // This should be added
          ),
          flex: FlexPropertiesMix(
            mainAxisAlignment: MainAxisAlignment.center,
          ), // This should be added
        );

        final merged = first.merge(second);

        // Resolve to check merged values
        final context = MockBuildContext();
        final resolved = merged.resolve(context);

        expect(
          resolved.container?.alignment,
          Alignment.topLeft,
        ); // second overrides first
        expect(resolved.container?.padding, const EdgeInsets.all(10.0)); // from first
        expect(resolved.container?.margin, const EdgeInsets.all(20.0)); // from second
        expect(resolved.flex?.direction, Axis.horizontal); // from first
        expect(
          resolved.flex?.mainAxisAlignment,
          MainAxisAlignment.center,
        ); // from second
      });

      test('returns this when other is null', () {
        final attribute = FlexBoxMix(container: ContainerSpecMix(alignment: Alignment.center));

        final merged = attribute.merge(null);

        expect(identical(attribute, merged), isTrue);
      });

      test('merges nested box and flex attributes correctly', () {
        final first = FlexBoxMix(
          container: ContainerSpecMix(decoration: BoxDecorationMix(color: Colors.red)),
        );

        final second = FlexBoxMix(
          container: ContainerSpecMix(
            decoration: BoxDecorationMix(
              border: BoxBorderMix.all(BorderSideMix(color: Colors.blue)),
            ),
          ),
        );

        final merged = first.merge(second);

        // Resolve to check merged decoration
        final context = MockBuildContext();
        final resolved = merged.resolve(context);
        final decoration = resolved.container?.decoration as BoxDecoration?;

        expect(decoration?.color, Colors.red); // from first
        expect(decoration?.border, isNotNull); // from second
      });
    });

    group('Equality', () {
      test('equal attributes have same hashCode', () {
        final attr1 = FlexBoxMix(
          container: ContainerSpecMix(alignment: Alignment.center),
          flex: FlexPropertiesMix(direction: Axis.horizontal),
        );

        final attr2 = FlexBoxMix(
          container: ContainerSpecMix(alignment: Alignment.center),
          flex: FlexPropertiesMix(direction: Axis.horizontal),
        );

        expect(attr1, equals(attr2));
        expect(attr1.hashCode, equals(attr2.hashCode));
      });

      test('different attributes are not equal', () {
        final attr1 = FlexBoxMix(container: ContainerSpecMix(alignment: Alignment.center));

        final attr2 = FlexBoxMix(container: ContainerSpecMix(alignment: Alignment.topLeft));

        expect(attr1, isNot(equals(attr2)));
      });

      test('attributes with different nested properties are not equal', () {
        final attr1 = FlexBoxMix(flex: FlexPropertiesMix(direction: Axis.horizontal));

        final attr2 = FlexBoxMix(flex: FlexPropertiesMix(direction: Axis.vertical));

        expect(attr1, isNot(equals(attr2)));
      });
    });

    group('Modifiers', () {
      test('modifiers can be added to attribute', () {
        final attribute = FlexBoxMix(
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
        final first = FlexBoxMix(
          modifier: ModifierConfig(
            modifiers: [OpacityModifierMix(opacity: 0.5)],
          ),
        );

        final second = FlexBoxMix(
          modifier: ModifierConfig(
            modifiers: [
              TransformModifierMix(transform: Matrix4.identity()),
            ],
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
        final attribute = FlexBoxMix();
        expect(attribute.$animation, isNull); // By default no animation

        final withAnimation = FlexBoxMix(
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
        final attribute = FlexBoxMix();
        expect(attribute.$variants, isNull); // By default no variants

        final variant = ContextVariant('test', (context) => true);
        final withVariants = FlexBoxMix(
          variants: [
            VariantStyle(
              variant,
              FlexBoxMix(
                container: ContainerSpecMix(decoration: BoxDecorationMix(color: Colors.green)),
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
        final boxOnly = FlexBoxMix(container: ContainerSpecMix(alignment: Alignment.center));

        final flexOnly = FlexBoxMix(flex: FlexPropertiesMix(direction: Axis.horizontal));

        expect(boxOnly.$container, isNotNull);
        expect(boxOnly.$flex, isNull);

        expect(flexOnly.$container, isNull);
        expect(flexOnly.$flex, isNotNull);
      });

      test('partial updates preserve other attribute', () {
        final initial = FlexBoxMix(
          container: ContainerSpecMix(alignment: Alignment.center),
          flex: FlexPropertiesMix(direction: Axis.horizontal),
        );

        final updateBox = FlexBoxMix(
          container: ContainerSpecMix(padding: EdgeInsetsMix.all(10.0)),
        );

        final merged = initial.merge(updateBox);

        // Check that flex is preserved and box is updated
        final context = MockBuildContext();
        final resolved = merged.resolve(context);

        expect(resolved.flex?.direction, Axis.horizontal); // preserved
        expect(resolved.container?.padding, const EdgeInsets.all(10.0)); // updated
        expect(
          resolved.container?.alignment,
          Alignment.center,
        ); // preserved from initial container
      });
    });

    group('Edge Cases', () {
      test('handles empty merge correctly', () {
        final empty1 = FlexBoxMix();
        final empty2 = FlexBoxMix();

        final merged = empty1.merge(empty2);

        expect(merged.$container, isNull);
        expect(merged.$flex, isNull);
      });

      test('handles resolution with all null properties', () {
        final attribute = FlexBoxMix();

        final context = MockBuildContext();
        final resolved = attribute.resolve(context);

        expect(resolved, isNotNull);
        expect(resolved.container, null);
        expect(resolved.flex, null);
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

        // Verify all properties are resolved correctly
        expect(resolved.container?.alignment, Alignment.center);
        expect(resolved.container?.padding, const EdgeInsets.all(10.0));
        expect(
          resolved.container?.margin,
          const EdgeInsets.symmetric(horizontal: 20.0),
        );
        expect((resolved.container?.decoration as BoxDecoration?)?.color, Colors.red);
        expect(resolved.flex?.direction, Axis.horizontal);
        expect(resolved.flex?.mainAxisAlignment, MainAxisAlignment.spaceBetween);
        expect(resolved.flex?.spacing, 10.0);
      });
    });
  });

  group('FlexBoxSpec', () {
    test('creates FlexBoxSpec with default values', () {
      final spec = FlexBoxSpec();

      expect(spec.container, null);
      expect(spec.flex, null);
    });

    test('creates FlexBoxSpec with custom values', () {
      const boxSpec = ContainerSpec(alignment: Alignment.center);
      const flexSpec = FlexProperties(direction: Axis.vertical);
      const spec = FlexBoxSpec(container: boxSpec, flex: flexSpec);

      expect(spec.container, boxSpec);
      expect(spec.flex, flexSpec);
    });

    test('copyWith creates new instance with updated values', () {
      const original = FlexBoxSpec(
        container: ContainerSpec(alignment: Alignment.center),
        flex: FlexProperties(direction: Axis.horizontal),
      );

      final updated = original.copyWith(
        container: const ContainerSpec(alignment: Alignment.topLeft),
      );

      expect(updated.container?.alignment, Alignment.topLeft);
      expect(updated.flex?.direction, Axis.horizontal); // unchanged
      expect(identical(original, updated), isFalse);
    });

    test('lerp interpolates between two FlexBoxSpec instances', () {
      const spec1 = FlexBoxSpec(
        container: ContainerSpec(padding: EdgeInsets.all(10.0)),
        flex: FlexProperties(spacing: 10.0),
      );

      const spec2 = FlexBoxSpec(
        container: ContainerSpec(padding: EdgeInsets.all(20.0)),
        flex: FlexProperties(spacing: 20.0),
      );

      final interpolated = spec1.lerp(spec2, 0.5);

      expect(interpolated.container?.padding, const EdgeInsets.all(15.0));
      expect(interpolated.flex?.spacing, 15.0);
    });

    test('lerp returns this when other is null', () {
      const spec = FlexBoxSpec(container: ContainerSpec(alignment: Alignment.center));

      final result = spec.lerp(null, 0.5);

      expect(result, equals(spec));
    });

    test('equality and hashCode', () {
      const spec1 = FlexBoxSpec(
        container: ContainerSpec(alignment: Alignment.center),
        flex: FlexProperties(direction: Axis.horizontal),
      );

      const spec2 = FlexBoxSpec(
        container: ContainerSpec(alignment: Alignment.center),
        flex: FlexProperties(direction: Axis.horizontal),
      );

      const spec3 = FlexBoxSpec(
        container: ContainerSpec(alignment: Alignment.topLeft),
        flex: FlexProperties(direction: Axis.horizontal),
      );

      expect(spec1, equals(spec2));
      expect(spec1.hashCode, equals(spec2.hashCode));
      expect(spec1, isNot(equals(spec3)));
    });
  });
}
