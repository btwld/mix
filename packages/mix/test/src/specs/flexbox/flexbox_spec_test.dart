import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';
import 'package:mix/src/specs/flexbox/flexbox_spec.dart';

void main() {
  group('FlexBoxSpecAttribute', () {
    group('Constructor', () {
      test('creates FlexBoxSpecAttribute with all properties', () {
        final boxAttr = BoxSpecAttribute(
          alignment: Prop(Alignment.center),
          padding: MixProp(EdgeInsetsMix.only(
            top: 10.0,
            bottom: 20.0,
          )),
        );

        final flexAttr = FlexSpecAttribute(
          direction: Prop(Axis.horizontal),
          mainAxisAlignment: Prop(MainAxisAlignment.center),
          crossAxisAlignment: Prop(CrossAxisAlignment.start),
        );

        final attribute = FlexBoxSpecAttribute(
          box: boxAttr,
          flex: flexAttr,
        );

        // Verify properties are set
        expect(attribute.$box, equals(boxAttr));
        expect(attribute.$flex, equals(flexAttr));
      });

      test('creates empty FlexBoxSpecAttribute', () {
        const attribute = FlexBoxSpecAttribute();

        // Verify all properties are null in default state
        expect(attribute.$box, isNull);
        expect(attribute.$flex, isNull);
      });

      test('value constructor creates FlexBoxSpecAttribute from FlexBoxSpec', () {
        const spec = FlexBoxSpec(
          box: BoxSpec(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.0),
          ),
          flex: FlexSpec(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        );

        final attribute = FlexBoxSpecAttribute.value(spec);

        expect(attribute.$box, isNotNull);
        expect(attribute.$flex, isNotNull);
      });

      test('maybeValue returns null for null spec', () {
        expect(FlexBoxSpecAttribute.maybeValue(null), isNull);
      });

      test('maybeValue returns attribute for non-null spec', () {
        const spec = FlexBoxSpec(
          box: BoxSpec(alignment: Alignment.center),
          flex: FlexSpec(direction: Axis.vertical),
        );

        final attribute = FlexBoxSpecAttribute.maybeValue(spec);

        expect(attribute, isNotNull);
        expect(attribute!.$box, isNotNull);
        expect(attribute.$flex, isNotNull);
      });
    });

    group('Utility Methods', () {
      test('utility methods create new instances', () {
        final utility = FlexBoxSpecUtility();
        final original = const FlexBoxSpecAttribute();
        final withBox = utility.build(FlexBoxSpecAttribute(box: BoxSpecAttribute()));
        final withFlex = utility.build(FlexBoxSpecAttribute(flex: FlexSpecAttribute()));

        // Each utility creates a new instance
        expect(identical(original, withBox.attribute), isFalse);
        expect(identical(original, withFlex.attribute), isFalse);
        expect(identical(withBox.attribute, withFlex.attribute), isFalse);

        // New instances have their properties set
        expect(withBox.attribute.$box, isNotNull);
        expect(withFlex.attribute.$flex, isNotNull);
      });

      test('utility provides access to nested box utilities', () {
        final utility = FlexBoxSpecUtility();

        // Test that box utilities are accessible
        expect(utility.alignment, isNotNull);
        expect(utility.padding, isNotNull);
        expect(utility.margin, isNotNull);
        expect(utility.constraints, isNotNull);
        expect(utility.decoration, isNotNull);
        expect(utility.color, isNotNull);
        expect(utility.border, isNotNull);
        expect(utility.borderRadius, isNotNull);
        expect(utility.width, isNotNull);
        expect(utility.height, isNotNull);
      });

      test('utility provides access to flex utilities', () {
        final utility = FlexBoxSpecUtility();

        // Test that flex utilities are accessible
        expect(utility.flex, isNotNull);
      });
    });

    group('Resolution', () {
      test('resolves to FlexBoxSpec with correct properties', () {
        final attribute = FlexBoxSpecAttribute(
          box: BoxSpecAttribute(
            alignment: Prop(Alignment.center),
            padding: MixProp(EdgeInsetsMix.only(
              top: 10.0,
              bottom: 20.0,
            )),
          ),
          flex: FlexSpecAttribute(
            direction: Prop(Axis.horizontal),
            mainAxisAlignment: Prop(MainAxisAlignment.center),
          ),
        );

        final context = MockBuildContext();
        final resolved = attribute.resolve(context);

        expect(resolved, isNotNull);
        expect(resolved.box.alignment, Alignment.center);
        expect(resolved.box.padding, const EdgeInsets.only(
          top: 10.0,
          bottom: 20.0,
        ));
        expect(resolved.flex.direction, Axis.horizontal);
        expect(resolved.flex.mainAxisAlignment, MainAxisAlignment.center);
      });

      test('resolves complex nested properties correctly', () {
        final attribute = FlexBoxSpecAttribute(
          box: BoxSpecAttribute(
            decoration: MixProp(BoxDecorationMix(
              color: Prop(Colors.red),
              border: MixProp(BoxBorderMix.all(BorderSideMix.only(
                color: Colors.blue,
                width: 2.0,
              ))),
              borderRadius: MixProp(BorderRadiusMix.only(
                topLeft: const Radius.circular(8.0),
                topRight: const Radius.circular(8.0),
              )),
            )),
          ),
          flex: FlexSpecAttribute(
            gap: Prop(10.0),
            mainAxisAlignment: Prop(MainAxisAlignment.spaceBetween),
          ),
        );

        final context = MockBuildContext();
        final resolved = attribute.resolve(context);

        expect(resolved, isNotNull);
        final decoration = resolved.box.decoration as BoxDecoration?;
        expect(decoration?.color, Colors.red);
        expect(decoration?.border, isNotNull);
        expect(decoration?.borderRadius, isNotNull);
        expect(resolved.flex.gap, 10.0);
        expect(resolved.flex.mainAxisAlignment, MainAxisAlignment.spaceBetween);
      });
    });

    group('Merge', () {
      test('merges properties correctly', () {
        final first = FlexBoxSpecAttribute(
          box: BoxSpecAttribute(
            alignment: Prop(Alignment.center),
            padding: MixProp(EdgeInsetsMix.all(10.0)),
          ),
          flex: FlexSpecAttribute(
            direction: Prop(Axis.horizontal),
          ),
        );

        final second = FlexBoxSpecAttribute(
          box: BoxSpecAttribute(
            alignment: Prop(Alignment.topLeft), // This should override
            margin: MixProp(EdgeInsetsMix.all(20.0)), // This should be added
          ),
          flex: FlexSpecAttribute(
            mainAxisAlignment: Prop(MainAxisAlignment.center), // This should be added
          ),
        );

        final merged = first.merge(second);

        // Resolve to check merged values
        final context = MockBuildContext();
        final resolved = merged.resolve(context);

        expect(resolved.box.alignment, Alignment.topLeft); // second overrides first
        expect(resolved.box.padding, const EdgeInsets.all(10.0)); // from first
        expect(resolved.box.margin, const EdgeInsets.all(20.0)); // from second
        expect(resolved.flex.direction, Axis.horizontal); // from first
        expect(resolved.flex.mainAxisAlignment, MainAxisAlignment.center); // from second
      });

      test('returns this when other is null', () {
        final attribute = FlexBoxSpecAttribute(
          box: BoxSpecAttribute(
            alignment: Prop(Alignment.center),
          ),
        );

        final merged = attribute.merge(null);

        expect(identical(attribute, merged), isTrue);
      });

      test('merges nested box and flex attributes correctly', () {
        final first = FlexBoxSpecAttribute(
          box: BoxSpecAttribute(
            decoration: MixProp(
              BoxDecorationMix.only(color: Colors.red),
            ),
          ),
        );

        final second = FlexBoxSpecAttribute(
          box: BoxSpecAttribute(
            decoration: MixProp(
              BoxDecorationMix(
                border: MixProp(BoxBorderMix.all(BorderSideMix.only(color: Colors.blue))),
              ),
            ),
          ),
        );

        final merged = first.merge(second);

        // Resolve to check merged decoration
        final context = MockBuildContext();
        final resolved = merged.resolve(context);
        final decoration = resolved.box.decoration as BoxDecoration?;

        expect(decoration?.color, Colors.red); // from first
        expect(decoration?.border, isNotNull); // from second
      });
    });

    group('Equality', () {
      test('equal attributes have same hashCode', () {
        final attr1 = FlexBoxSpecAttribute(
          box: BoxSpecAttribute(
            alignment: Prop(Alignment.center),
          ),
          flex: FlexSpecAttribute(
            direction: Prop(Axis.horizontal),
          ),
        );

        final attr2 = FlexBoxSpecAttribute(
          box: BoxSpecAttribute(
            alignment: Prop(Alignment.center),
          ),
          flex: FlexSpecAttribute(
            direction: Prop(Axis.horizontal),
          ),
        );

        expect(attr1, equals(attr2));
        expect(attr1.hashCode, equals(attr2.hashCode));
      });

      test('different attributes are not equal', () {
        final attr1 = FlexBoxSpecAttribute(
          box: BoxSpecAttribute(
            alignment: Prop(Alignment.center),
          ),
        );

        final attr2 = FlexBoxSpecAttribute(
          box: BoxSpecAttribute(
            alignment: Prop(Alignment.topLeft),
          ),
        );

        expect(attr1, isNot(equals(attr2)));
      });

      test('attributes with different nested properties are not equal', () {
        final attr1 = FlexBoxSpecAttribute(
          flex: FlexSpecAttribute(
            direction: Prop(Axis.horizontal),
          ),
        );

        final attr2 = FlexBoxSpecAttribute(
          flex: FlexSpecAttribute(
            direction: Prop(Axis.vertical),
          ),
        );

        expect(attr1, isNot(equals(attr2)));
      });
    });

    group('Modifiers', () {
      test('modifiers can be added to attribute', () {
        final attribute = FlexBoxSpecAttribute(
          modifiers: [
            OpacityModifierAttribute(opacity: Prop(0.5)),
            TransformModifierAttribute.only(
              transform: Matrix4.identity(),
              alignment: Alignment.center,
            ),
          ],
        );

        expect(attribute.$modifiers, isNotNull);
        expect(attribute.$modifiers!.length, 2);
      });

      test('modifiers are merged correctly', () {
        final first = FlexBoxSpecAttribute(
          modifiers: [OpacityModifierAttribute(opacity: Prop(0.5))],
        );

        final second = FlexBoxSpecAttribute(
          modifiers: [TransformModifierAttribute.only(transform: Matrix4.identity())],
        );

        final merged = first.merge(second);

        // Modifiers are combined when merging
        expect(merged.$modifiers, isNotNull);
        expect(merged.$modifiers!.length, 2);
      });
    });

    group('Animation', () {
      test('animation config can be added to attribute', () {
        const attribute = FlexBoxSpecAttribute();
        expect(attribute.$animation, isNull); // By default no animation

        final withAnimation = FlexBoxSpecAttribute(
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
        const attribute = FlexBoxSpecAttribute();
        expect(attribute.$variants, isNull); // By default no variants

        final variant = ContextVariant('test', (context) => true);
        final withVariants = FlexBoxSpecAttribute(
          variants: [
            VariantStyleAttribute(
              variant,
              FlexBoxSpecAttribute(
                box: BoxSpecAttribute(
                  decoration: MixProp(
                    BoxDecorationMix.only(color: Colors.green),
                  ),
                ),
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
        final boxOnly = FlexBoxSpecAttribute(
          box: BoxSpecAttribute(
            alignment: Prop(Alignment.center),
          ),
        );

        final flexOnly = FlexBoxSpecAttribute(
          flex: FlexSpecAttribute(
            direction: Prop(Axis.horizontal),
          ),
        );

        expect(boxOnly.$box, isNotNull);
        expect(boxOnly.$flex, isNull);

        expect(flexOnly.$box, isNull);
        expect(flexOnly.$flex, isNotNull);
      });

      test('partial updates preserve other attribute', () {
        final initial = FlexBoxSpecAttribute(
          box: BoxSpecAttribute(
            alignment: Prop(Alignment.center),
          ),
          flex: FlexSpecAttribute(
            direction: Prop(Axis.horizontal),
          ),
        );

        final updateBox = FlexBoxSpecAttribute(
          box: BoxSpecAttribute(
            padding: MixProp(EdgeInsetsMix.all(10.0)),
          ),
        );

        final merged = initial.merge(updateBox);

        // Check that flex is preserved and box is updated
        final context = MockBuildContext();
        final resolved = merged.resolve(context);

        expect(resolved.flex.direction, Axis.horizontal); // preserved
        expect(resolved.box.padding, const EdgeInsets.all(10.0)); // updated
        expect(resolved.box.alignment, Alignment.center); // preserved from initial box
      });
    });

    group('Edge Cases', () {
      test('handles empty merge correctly', () {
        const empty1 = FlexBoxSpecAttribute();
        const empty2 = FlexBoxSpecAttribute();

        final merged = empty1.merge(empty2);

        expect(merged.$box, isNull);
        expect(merged.$flex, isNull);
      });

      test('handles resolution with all null properties', () {
        const attribute = FlexBoxSpecAttribute();

        final context = MockBuildContext();
        final resolved = attribute.resolve(context);

        expect(resolved, isNotNull);
        expect(resolved.box, const BoxSpec());
        expect(resolved.flex, const FlexSpec());
      });

      test('handles complex nested chaining', () {
        final utility = FlexBoxSpecUtility();
        
        // Build complex nested structure using utilities
        final complex = utility.build(
          FlexBoxSpecAttribute(
            box: BoxSpecAttribute()
              .alignment(Alignment.center)
              .padding.all(10.0)
              .margin.horizontal(20.0)
              .color(Colors.red)
              .border.all(BorderSideMix.only(width: 2.0))
              .borderRadius.all(const Radius.circular(8.0)),
            flex: FlexSpecAttribute()
              .direction(Axis.horizontal)
              .mainAxisAlignment(MainAxisAlignment.spaceBetween)
              .gap(10.0),
          ),
        );

        final context = MockBuildContext();
        final resolved = complex.attribute.resolve(context);

        // Verify all properties are resolved correctly
        expect(resolved.box.alignment, Alignment.center);
        expect(resolved.box.padding, const EdgeInsets.all(10.0));
        expect(resolved.box.margin, const EdgeInsets.symmetric(horizontal: 20.0));
        expect((resolved.box.decoration as BoxDecoration?)?.color, Colors.red);
        expect(resolved.flex.direction, Axis.horizontal);
        expect(resolved.flex.mainAxisAlignment, MainAxisAlignment.spaceBetween);
        expect(resolved.flex.gap, 10.0);
      });
    });
  });

  group('FlexBoxSpec', () {
    test('creates FlexBoxSpec with default values', () {
      const spec = FlexBoxSpec();

      expect(spec.box, const BoxSpec());
      expect(spec.flex, const FlexSpec());
    });

    test('creates FlexBoxSpec with custom values', () {
      const boxSpec = BoxSpec(alignment: Alignment.center);
      const flexSpec = FlexSpec(direction: Axis.vertical);
      const spec = FlexBoxSpec(box: boxSpec, flex: flexSpec);

      expect(spec.box, boxSpec);
      expect(spec.flex, flexSpec);
    });

    test('copyWith creates new instance with updated values', () {
      const original = FlexBoxSpec(
        box: BoxSpec(alignment: Alignment.center),
        flex: FlexSpec(direction: Axis.horizontal),
      );

      final updated = original.copyWith(
        box: const BoxSpec(alignment: Alignment.topLeft),
      );

      expect(updated.box.alignment, Alignment.topLeft);
      expect(updated.flex.direction, Axis.horizontal); // unchanged
      expect(identical(original, updated), isFalse);
    });

    test('lerp interpolates between two FlexBoxSpec instances', () {
      const spec1 = FlexBoxSpec(
        box: BoxSpec(
          padding: EdgeInsets.all(10.0),
        ),
        flex: FlexSpec(
          gap: 10.0,
        ),
      );

      const spec2 = FlexBoxSpec(
        box: BoxSpec(
          padding: EdgeInsets.all(20.0),
        ),
        flex: FlexSpec(
          gap: 20.0,
        ),
      );

      final interpolated = spec1.lerp(spec2, 0.5);

      expect(interpolated.box.padding, const EdgeInsets.all(15.0));
      expect(interpolated.flex.gap, 15.0);
    });

    test('lerp returns this when other is null', () {
      const spec = FlexBoxSpec(
        box: BoxSpec(alignment: Alignment.center),
      );

      final result = spec.lerp(null, 0.5);

      expect(identical(spec, result), isTrue);
    });

    test('equality and hashCode', () {
      const spec1 = FlexBoxSpec(
        box: BoxSpec(alignment: Alignment.center),
        flex: FlexSpec(direction: Axis.horizontal),
      );

      const spec2 = FlexBoxSpec(
        box: BoxSpec(alignment: Alignment.center),
        flex: FlexSpec(direction: Axis.horizontal),
      );

      const spec3 = FlexBoxSpec(
        box: BoxSpec(alignment: Alignment.topLeft),
        flex: FlexSpec(direction: Axis.horizontal),
      );

      expect(spec1, equals(spec2));
      expect(spec1.hashCode, equals(spec2.hashCode));
      expect(spec1, isNot(equals(spec3)));
    });
  });
}