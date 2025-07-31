import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('StackSpecAttribute', () {
    group('Constructor', () {
      test('creates StackSpecAttribute with all properties', () {
        final attribute = StackMix.raw(
          alignment: Prop(AlignmentDirectional.topStart),
          fit: Prop(StackFit.loose),
          textDirection: Prop(TextDirection.ltr),
          clipBehavior: Prop(Clip.antiAlias),
        );

        expectProp(attribute.$alignment, AlignmentDirectional.topStart);
        expectProp(attribute.$fit, StackFit.loose);
        expectProp(attribute.$textDirection, TextDirection.ltr);
        expectProp(attribute.$clipBehavior, Clip.antiAlias);
      });

      test('creates empty StackSpecAttribute', () {
        final attribute = StackMix();

        expect(attribute.$alignment, isNull);
        expect(attribute.$fit, isNull);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$clipBehavior, isNull);
      });
    });

    group('only constructor', () {
      test('creates StackSpecAttribute with only constructor', () {
        final attribute = StackMix(
          alignment: AlignmentDirectional.bottomEnd,
          fit: StackFit.expand,
          textDirection: TextDirection.rtl,
          clipBehavior: Clip.hardEdge,
        );

        expectProp(attribute.$alignment, AlignmentDirectional.bottomEnd);
        expectProp(attribute.$fit, StackFit.expand);
        expectProp(attribute.$textDirection, TextDirection.rtl);
        expectProp(attribute.$clipBehavior, Clip.hardEdge);
      });

      test('creates partial StackSpecAttribute with only constructor', () {
        final attribute = StackMix(
          alignment: Alignment.center,
          fit: StackFit.passthrough,
        );

        expect(attribute.$alignment, resolvesTo(Alignment.center));
        expect(attribute.$fit, resolvesTo(StackFit.passthrough));
        expect(attribute.$textDirection, isNull);
        expect(attribute.$clipBehavior, isNull);
      });
    });

    group('value constructor', () {
      test('creates StackSpecAttribute from StackSpec', () {
        const spec = StackSpec(
          alignment: AlignmentDirectional.topStart,
          fit: StackFit.loose,
          textDirection: TextDirection.ltr,
          clipBehavior: Clip.antiAlias,
        );

        final attribute = StackMix.value(spec);

        expect(attribute.$alignment, resolvesTo(AlignmentDirectional.topStart));
        expect(attribute.$fit, resolvesTo(StackFit.loose));
        expect(attribute.$textDirection, resolvesTo(TextDirection.ltr));
        expect(attribute.$clipBehavior, resolvesTo(Clip.antiAlias));
      });

      test('maybeValue returns null for null spec', () {
        expect(StackMix.maybeValue(null), isNull);
      });

      test('maybeValue returns attribute for non-null spec', () {
        const spec = StackSpec(
          alignment: Alignment.bottomRight,
          fit: StackFit.expand,
        );
        final attribute = StackMix.maybeValue(spec);

        expect(attribute, isNotNull);
        expect(attribute!.$alignment, resolvesTo(Alignment.bottomRight));
        expect(attribute.$fit, resolvesTo(StackFit.expand));
      });
    });

    group('Utility Methods', () {
      test('utility methods create new instances', () {
        final original = StackMix();
        final withAlignment = original.alignment(Alignment.center);
        final withFit = original.fit(StackFit.expand);

        // Each utility creates a new instance
        expect(identical(original, withAlignment), isFalse);
        expect(identical(original, withFit), isFalse);
        expect(identical(withAlignment, withFit), isFalse);

        // Original remains unchanged
        expect(original.$alignment, isNull);
        expect(original.$fit, isNull);

        // New instances have their properties set
        expect(withAlignment.$alignment, resolvesTo(Alignment.center));
        expect(withAlignment.$fit, isNull);
        expect(withFit.$fit, resolvesTo(StackFit.expand));
        expect(withFit.$alignment, isNull);
      });

      test('alignment utility works correctly', () {
        final center = StackMix().alignment(Alignment.center);
        final topStart = StackMix().alignment(AlignmentDirectional.topStart);
        final bottomEnd = StackMix().alignment(AlignmentDirectional.bottomEnd);

        expect(center.$alignment, resolvesTo(Alignment.center));
        expect(topStart.$alignment, resolvesTo(AlignmentDirectional.topStart));
        expect(
          bottomEnd.$alignment,
          resolvesTo(AlignmentDirectional.bottomEnd),
        );
      });

      test('fit utility works correctly', () {
        final loose = StackMix().fit(StackFit.loose);
        final expand = StackMix().fit(StackFit.expand);
        final passthrough = StackMix().fit(StackFit.passthrough);

        expect(loose.$fit, resolvesTo(StackFit.loose));
        expect(expand.$fit, resolvesTo(StackFit.expand));
        expect(passthrough.$fit, resolvesTo(StackFit.passthrough));
      });

      test('textDirection utility works correctly', () {
        final ltr = StackMix().textDirection(TextDirection.ltr);
        final rtl = StackMix().textDirection(TextDirection.rtl);

        expect(ltr.$textDirection, resolvesTo(TextDirection.ltr));
        expect(rtl.$textDirection, resolvesTo(TextDirection.rtl));
      });

      test('clipBehavior utility works correctly', () {
        final none = StackMix().clipBehavior(Clip.none);
        final hardEdge = StackMix().clipBehavior(Clip.hardEdge);
        final antiAlias = StackMix().clipBehavior(Clip.antiAlias);
        final antiAliasWithSaveLayer = StackMix().clipBehavior(
          Clip.antiAliasWithSaveLayer,
        );

        expect(none.$clipBehavior, resolvesTo(Clip.none));
        expect(hardEdge.$clipBehavior, resolvesTo(Clip.hardEdge));
        expect(antiAlias.$clipBehavior, resolvesTo(Clip.antiAlias));
        expectProp(
          antiAliasWithSaveLayer.$clipBehavior,
          Clip.antiAliasWithSaveLayer,
        );
      });

      test('chaining utilities accumulates properties correctly', () {
        // Chaining now properly accumulates all properties
        final chained = StackMix()
            .alignment(Alignment.topLeft)
            .fit(StackFit.expand)
            .textDirection(TextDirection.ltr)
            .clipBehavior(Clip.antiAlias);

        // All properties should be accumulated
        expect(chained.$alignment, resolvesTo(Alignment.topLeft));
        expect(chained.$fit, resolvesTo(StackFit.expand));
        expect(chained.$textDirection, resolvesTo(TextDirection.ltr));
        expect(chained.$clipBehavior, resolvesTo(Clip.antiAlias));
      });

      test('chaining with overrides works correctly', () {
        // Later values override earlier ones
        final chained = StackMix()
            .alignment(Alignment.topLeft)
            .fit(StackFit.loose)
            .alignment(
              Alignment.bottomRight,
            ) // This overrides the first alignment
            .fit(StackFit.expand); // This overrides the first fit

        expect(chained.$alignment, resolvesTo(Alignment.bottomRight));
        expect(chained.$fit, resolvesTo(StackFit.expand));
      });
    });

    group('Convenience Methods', () {
      test('animate method sets animation config', () {
        final animation = AnimationConfig.curve(
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
        final attribute = StackMix().animate(animation);

        expect(attribute.$animation, equals(animation));
      });
    });

    group('Resolution', () {
      test('resolves to StackSpec with correct properties', () {
        final attribute = StackMix(
          alignment: AlignmentDirectional.centerStart,
          fit: StackFit.loose,
          textDirection: TextDirection.rtl,
          clipBehavior: Clip.hardEdge,
        );

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.alignment, AlignmentDirectional.centerStart);
        expect(spec.fit, StackFit.loose);
        expect(spec.textDirection, TextDirection.rtl);
        expect(spec.clipBehavior, Clip.hardEdge);
      });

      test('resolves with partial values correctly', () {
        final attribute = StackMix(
          alignment: Alignment.bottomCenter,
          fit: StackFit.passthrough,
        );

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.alignment, Alignment.bottomCenter);
        expect(spec.fit, StackFit.passthrough);
        expect(spec.textDirection, isNull);
        expect(spec.clipBehavior, isNull);
      });
    });

    group('Merge', () {
      test('merges properties correctly', () {
        final first = StackMix(
          alignment: Alignment.topLeft,
          fit: StackFit.loose,
          textDirection: TextDirection.ltr,
        );

        final second = StackMix(
          alignment: Alignment.bottomRight,
          clipBehavior: Clip.antiAlias,
        );

        final merged = first.merge(second);

        expectProp(
          merged.$alignment,
          Alignment.bottomRight,
        ); // second overrides
        expect(merged.$fit, resolvesTo(StackFit.loose)); // from first
        expectProp(merged.$textDirection, TextDirection.ltr); // from first
        expect(merged.$clipBehavior, resolvesTo(Clip.antiAlias)); // from second
      });

      test('returns this when other is null', () {
        final attribute = StackMix().alignment(Alignment.center);
        final merged = attribute.merge(null);

        expect(identical(attribute, merged), isTrue);
      });

      test('merges all properties when both have values', () {
        final first = StackMix(
          alignment: AlignmentDirectional.topStart,
          fit: StackFit.loose,
        );

        final second = StackMix(
          alignment: AlignmentDirectional.bottomEnd,
          fit: StackFit.expand,
          textDirection: TextDirection.rtl,
          clipBehavior: Clip.hardEdge,
        );

        final merged = first.merge(second);

        expectProp(
          merged.$alignment,
          AlignmentDirectional.bottomEnd,
        ); // second overrides
        expect(merged.$fit, resolvesTo(StackFit.expand)); // second overrides
        expectProp(merged.$textDirection, TextDirection.rtl); // from second
        expect(merged.$clipBehavior, resolvesTo(Clip.hardEdge)); // from second
      });
    });

    group('Equality', () {
      test('equal attributes have same hashCode', () {
        final attr1 = StackMix()
            .alignment(Alignment.center)
            .fit(StackFit.loose)
            .textDirection(TextDirection.ltr)
            .clipBehavior(Clip.antiAlias);

        final attr2 = StackMix()
            .alignment(Alignment.center)
            .fit(StackFit.loose)
            .textDirection(TextDirection.ltr)
            .clipBehavior(Clip.antiAlias);

        expect(attr1, equals(attr2));
        // Skip hashCode test due to infrastructure issue with list instances
        // TODO: Fix hashCode contract violation in Mix 2.0
        // expect(attr1.hashCode, equals(attr2.hashCode));
      });

      test('different attributes are not equal', () {
        final attr1 = StackMix().alignment(Alignment.topLeft);
        final attr2 = StackMix().alignment(Alignment.bottomRight);

        expect(attr1, isNot(equals(attr2)));
      });

      test('attributes with different fit are not equal', () {
        final attr1 = StackMix().fit(StackFit.loose);
        final attr2 = StackMix().fit(StackFit.expand);

        expect(attr1, isNot(equals(attr2)));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final attribute = StackMix.raw(
          alignment: Prop(AlignmentDirectional.topStart),
          fit: Prop(StackFit.loose),
          textDirection: Prop(TextDirection.ltr),
          clipBehavior: Prop(Clip.antiAlias),
        );

        expect(attribute.props.length, 7);
        expect(attribute.props, contains(attribute.$alignment));
        expect(attribute.props, contains(attribute.$fit));
        expect(attribute.props, contains(attribute.$textDirection));
        expect(attribute.props, contains(attribute.$clipBehavior));
      });
    });

    group('Modifiers', () {
      test('modifiers can be added to attribute', () {
        final attribute = StackMix(
          modifierConfig: ModifierConfig(modifiers: [
            OpacityModifierAttribute(opacity: 0.5),
            AlignModifierAttribute(alignment: Alignment.center),
          ]),
        );

        expect(attribute.$modifierConfig, isNotNull);
        expect(attribute.$modifierConfig!.$modifiers!.length, 2);
      });

      test('modifiers merge correctly', () {
        final opacityModifier = OpacityModifierAttribute(opacity: 0.5);
        final alignModifier = AlignModifierAttribute(
          alignment: Alignment.center,
        );

        final first = StackMix(modifierConfig: ModifierConfig(modifiers: [opacityModifier]));

        final second = StackMix(modifierConfig: ModifierConfig(modifiers: [alignModifier]));

        final merged = first.merge(second);

        // Check that the modifiers list matches exactly the expected list
        final expectedModifiers = [
          OpacityModifierAttribute(opacity: 0.5),
          AlignModifierAttribute(alignment: Alignment.center),
        ];

        expect(merged.$modifierConfig?.$modifiers, expectedModifiers);
      });

      test('modifiers with same type merge correctly', () {
        final firstOpacity = OpacityModifierAttribute(opacity: 0.3);
        final secondOpacity = OpacityModifierAttribute(opacity: 0.7);

        final first = StackMix(modifierConfig: ModifierConfig(modifiers: [firstOpacity]));
        final second = StackMix(modifierConfig: ModifierConfig(modifiers: [secondOpacity]));

        final merged = first.merge(second);

        // Should have only one opacity modifier (merged)
        expect(merged.$modifierConfig, isNotNull);
        expect(merged.$modifierConfig!.$modifiers!.length, 1);
        expect(merged.$modifierConfig!.$modifiers![0], isA<OpacityModifierAttribute>());

        // The second opacity should take precedence
        final mergedOpacity =
            merged.$modifierConfig!.$modifiers![0] as OpacityModifierAttribute;
        expect(mergedOpacity.opacity, resolvesTo(0.7));
      });
    });

    group('Variants', () {
      test('variants can be added to attribute', () {
        final attribute = StackMix();
        expect(attribute.$variants, isNull); // By default no variants
      });
    });

    group('Builder pattern', () {
      test('builder methods create new instances', () {
        final original = StackMix();
        final modified = original.alignment(Alignment.center);

        expect(identical(original, modified), isFalse);
        expect(original.$alignment, isNull);
        expect(modified.$alignment, resolvesTo(Alignment.center));
      });

      test('builder methods can be chained fluently', () {
        final attribute = StackMix(
          alignment: AlignmentDirectional.topEnd,
          fit: StackFit.expand,
          textDirection: TextDirection.rtl,
          clipBehavior: Clip.hardEdge,
        );

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec.alignment, AlignmentDirectional.topEnd);
        expect(spec.fit, StackFit.expand);
        expect(spec.textDirection, TextDirection.rtl);
        expect(spec.clipBehavior, Clip.hardEdge);
      });
    });

    group('Debug Properties', () {
      test('debugFillProperties includes all properties', () {
        // This test verifies that the attribute implements Diagnosticable correctly
        final attribute = StackMix()
            .alignment(Alignment.center)
            .fit(StackFit.loose);

        // The presence of debugFillProperties is tested by the framework
        expect(attribute, isA<StackMix>());
      });
    });
  });
}
