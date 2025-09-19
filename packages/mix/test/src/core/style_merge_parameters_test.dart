import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Style Merge Parameters', () {
    group('BoxMix merge', () {
      test('merges orderOfModifiers correctly', () {
        final first = BoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: WidgetModifierConfig.orderOfModifiers([
            OpacityModifier,
            PaddingModifier,
          ]),
        );
        final second = BoxStyler(
          constraints: BoxConstraintsMix.height(200.0),
          modifier: WidgetModifierConfig.orderOfModifiers([
            ClipOvalModifier,
            TransformModifier,
          ]),
        );
        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          ClipOvalModifier,
          TransformModifier,
        ]);
      });

      test('preserves first orderOfModifiers when second is empty', () {
        final first = BoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: WidgetModifierConfig.orderOfModifiers([
            OpacityModifier,
            PaddingModifier,
          ]),
        );
        final second = BoxStyler(constraints: BoxConstraintsMix.height(200.0));

        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          OpacityModifier,
          PaddingModifier,
        ]);
      });

      test('merges animation correctly', () {
        const firstAnimation = CurveAnimationConfig(
          duration: Duration(milliseconds: 100),
          curve: Curves.easeIn,
        );
        const secondAnimation = CurveAnimationConfig(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );

        final first = BoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
          animation: firstAnimation,
        );
        final second = BoxStyler(
          constraints: BoxConstraintsMix.height(200.0),
          animation: secondAnimation,
        );

        final merged = first.merge(second);

        expect(merged.$animation, secondAnimation);
      });

      test('preserves first animation when second is null', () {
        const firstAnimation = CurveAnimationConfig(
          duration: Duration(milliseconds: 100),
          curve: Curves.easeIn,
        );

        final first = BoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
          animation: firstAnimation,
        );
        final second = BoxStyler(constraints: BoxConstraintsMix.height(200.0));

        final merged = first.merge(second);

        expect(merged.$animation, firstAnimation);
      });

      test('merges modifiers correctly', () {
        final firstModifiers = [OpacityModifierMix(opacity: 0.5)];
        final secondModifiers = [
          PaddingModifierMix(padding: EdgeInsetsMix.all(10)),
        ];

        final first = BoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: WidgetModifierConfig(modifiers: firstModifiers),
        );
        final second = BoxStyler(
          constraints: BoxConstraintsMix.height(200.0),
          modifier: WidgetModifierConfig(modifiers: secondModifiers),
        );

        final merged = first.merge(second);

        expect(merged.$modifier, isNotNull);
        expect(merged.$modifier!.$modifiers!.length, 2);
        expect(merged.$modifier!.$modifiers![0], isA<OpacityModifierMix>());
        expect(merged.$modifier!.$modifiers![1], isA<PaddingModifierMix>());
      });

      test('merges variants correctly', () {
        final firstVariants = [
          VariantStyle(
            const NamedVariant('primary'),
            BoxStyler().color(Colors.blue),
          ),
        ];
        final secondVariants = [
          VariantStyle(
            const NamedVariant('secondary'),
            BoxStyler().color(Colors.red),
          ),
        ];

        final first = BoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
          variants: firstVariants,
        );
        final second = BoxStyler(
          constraints: BoxConstraintsMix.height(200.0),
          variants: secondVariants,
        );

        final merged = first.merge(second);

        expect(merged.$variants, isNotNull);
        expect(merged.$variants!.length, 2);
        expect(merged.$variants![0].variant, const NamedVariant('primary'));
        expect(merged.$variants![1].variant, const NamedVariant('secondary'));
      });

      test('handles null merge correctly', () {
        final first = BoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: WidgetModifierConfig.orderOfModifiers(const [OpacityModifier]),
        );

        final merged = first.merge(null);

        expect(merged, equals(first));
      });
    });

    group('TextStyling merge', () {
      test('merges orderOfModifiers correctly', () {
        final first = TextStyler(
          maxLines: 2,
          modifier: WidgetModifierConfig.orderOfModifiers(const [
            OpacityModifier,
            PaddingModifier,
          ]),
        );
        final second = TextStyler(
          overflow: TextOverflow.ellipsis,
          modifier: WidgetModifierConfig.orderOfModifiers(const [
            ClipOvalModifier,
            TransformModifier,
          ]),
        );
        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          ClipOvalModifier,
          TransformModifier,
        ]);
      });
    });

    group('IconStyle merge', () {
      test('merges orderOfModifiers correctly', () {
        final first = IconStyler(
          size: 24.0,
          modifier: WidgetModifierConfig.orderOfModifiers(const [
            OpacityModifier,
            PaddingModifier,
          ]),
        );
        final second = IconStyler(
          color: Colors.red,
          modifier: WidgetModifierConfig.orderOfModifiers(const [
            ClipOvalModifier,
            TransformModifier,
          ]),
        );
        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          ClipOvalModifier,
          TransformModifier,
        ]);
      });
    });

    group('FlexStyle merge', () {
      test('merges orderOfModifiers correctly', () {
        final first = FlexStyler(
          direction: Axis.horizontal,
          modifier: WidgetModifierConfig.orderOfModifiers(const [
            OpacityModifier,
            PaddingModifier,
          ]),
        );
        final second = FlexStyler(
          spacing: 8.0,
          modifier: WidgetModifierConfig.orderOfModifiers(const [
            ClipOvalModifier,
            TransformModifier,
          ]),
        );
        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          ClipOvalModifier,
          TransformModifier,
        ]);
      });
    });

    group('ImageStyle merge', () {
      test('merges orderOfModifiers correctly', () {
        final first = ImageStyler(
          width: 100.0,
          modifier: WidgetModifierConfig.orderOfModifiers(const [
            OpacityModifier,
            PaddingModifier,
          ]),
        );
        final second = ImageStyler(
          height: 200.0,
          modifier: WidgetModifierConfig.orderOfModifiers(const [
            ClipOvalModifier,
            TransformModifier,
          ]),
        );
        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          ClipOvalModifier,
          TransformModifier,
        ]);
      });
    });

    group('StackStyle merge', () {
      test('merges orderOfModifiers correctly', () {
        final first = StackStyler(
          alignment: Alignment.center,
          modifier: WidgetModifierConfig.orderOfModifiers(const [
            OpacityModifier,
            PaddingModifier,
          ]),
        );
        final second = StackStyler(
          fit: StackFit.expand,
          modifier: WidgetModifierConfig.orderOfModifiers(const [
            ClipOvalModifier,
            TransformModifier,
          ]),
        );
        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          ClipOvalModifier,
          TransformModifier,
        ]);
      });
    });

    group('FlexBoxStyle merge', () {
      test('merges orderOfModifiers correctly', () {
        final first = FlexBoxStyler(
          constraints: BoxConstraintsMix.width(100),
          modifier: WidgetModifierConfig.orderOfModifiers(const [
            OpacityModifier,
            PaddingModifier,
          ]),
        );
        final second = FlexBoxStyler(
          spacing: 8.0,
          modifier: WidgetModifierConfig.orderOfModifiers(const [
            ClipOvalModifier,
            TransformModifier,
          ]),
        );
        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          ClipOvalModifier,
          TransformModifier,
        ]);
      });
    });

    group('StackBoxStyle merge', () {
      test('merges orderOfModifiers correctly', () {
        final first = StackBoxStyler(
          constraints: BoxConstraintsMix.width(100),
          modifier: WidgetModifierConfig.orderOfModifiers(const [
            OpacityModifier,
            PaddingModifier,
          ]),
        );
        final second = StackBoxStyler(
          stackAlignment: Alignment.center,
          modifier: WidgetModifierConfig.orderOfModifiers(const [
            ClipOvalModifier,
            TransformModifier,
          ]),
        );
        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          ClipOvalModifier,
          TransformModifier,
        ]);
      });
    });

    group('Complex merge scenarios', () {
      test('chained merges preserve final values', () {
        final first = BoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: WidgetModifierConfig.orderOfModifiers(const [OpacityModifier]),
        );
        final second = BoxStyler(
          constraints: BoxConstraintsMix.height(200.0),
          modifier: WidgetModifierConfig.orderOfModifiers(const [PaddingModifier]),
        );
        final third = BoxStyler(
          decoration: DecorationMix.color(Colors.blue),
          modifier: WidgetModifierConfig.orderOfModifiers(const [ClipOvalModifier]),
        );

        final merged = first.merge(second).merge(third);

        expect(merged.$modifier?.$orderOfModifiers, [ClipOvalModifier]);
        expect(merged.$decoration, isNotNull);
      });

      test('merges with same modifier types correctly', () {
        final firstOpacity = OpacityModifierMix(opacity: 0.3);
        final secondOpacity = OpacityModifierMix(opacity: 0.7);

        final first = BoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: WidgetModifierConfig(modifiers: [firstOpacity]),
        );
        final second = BoxStyler(
          constraints: BoxConstraintsMix.height(200.0),
          modifier: WidgetModifierConfig(modifiers: [secondOpacity]),
        );

        final merged = first.merge(second);

        expect(merged.$modifier, isNotNull);
        expect(merged.$modifier!.$modifiers!.length, 1);
        expect(merged.$modifier!.$modifiers![0], isA<OpacityModifierMix>());

        final mergedOpacity =
            merged.$modifier!.$modifiers![0] as OpacityModifierMix;
        expect(mergedOpacity.opacity, resolvesTo(0.7));
      });

      test('merges with same variant types correctly', () {
        const variant = NamedVariant('primary');
        final firstStyle = BoxStyler().width(100.0);
        final secondStyle = BoxStyler().height(200.0);

        final first = BoxStyler(
          decoration: DecorationMix.color(Colors.red),
          variants: [VariantStyle(variant, firstStyle)],
        );
        final second = BoxStyler(
          padding: EdgeInsetsMix.all(10),
          variants: [VariantStyle(variant, secondStyle)],
        );

        final merged = first.merge(second);

        expect(merged.$variants, isNotNull);
        expect(merged.$variants!.length, 1);
        expect(merged.$variants![0].variant, variant);

        final mergedVariantStyle = merged.$variants![0].value as BoxStyler;
        final context = MockBuildContext();
        final spec = mergedVariantStyle.resolve(context).spec;
        expect(spec.constraints?.minWidth, 100.0);
        expect(spec.constraints?.minHeight, 200.0);
      });

      test('empty orderOfModifiers list behavior', () {
        final first = BoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: WidgetModifierConfig.orderOfModifiers(const [OpacityModifier]),
        );
        final second = BoxStyler(
          constraints: BoxConstraintsMix.height(200.0),
          modifier: WidgetModifierConfig.orderOfModifiers(const []),
        );

        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [OpacityModifier]);
      });

      test('null vs empty list handling for modifiers', () {
        final first = BoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: WidgetModifierConfig(
            modifiers: [OpacityModifierMix(opacity: 0.5)],
          ),
        );
        final second = BoxStyler(
          constraints: BoxConstraintsMix.height(200.0),
        ); // null modifiers

        final merged = first.merge(second);

        expect(merged.$modifier, isNotNull);
        expect(merged.$modifier!.$modifiers!.length, 1);
        expect(merged.$modifier!.$modifiers![0], isA<OpacityModifierMix>());
      });

      test('null vs empty list handling for variants', () {
        final first = BoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
          variants: [
            VariantStyle(
              const NamedVariant('primary'),
              BoxStyler().color(Colors.blue),
            ),
          ],
        );
        final second = BoxStyler(
          constraints: BoxConstraintsMix.height(200.0),
        ); // null variants

        final merged = first.merge(second);

        expect(merged.$variants, isNotNull);
        expect(merged.$variants!.length, 1);
        expect(merged.$variants![0].variant, const NamedVariant('primary'));
      });
    });

    group('Edge cases', () {
      test('merge with self returns same instance', () {
        final style = BoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: WidgetModifierConfig.orderOfModifiers(const [OpacityModifier]),
        );

        final merged = style.merge(style);

        // Merging with self should return a new instance (not the same reference) with identical values to ensure immutability.
        expect(merged, isNot(same(style)));
        expect(
          merged.$modifier?.$orderOfModifiers,
          style.$modifier?.$orderOfModifiers,
        );
      });

      test('all parameters null in both styles', () {
        final first = BoxStyler();
        final second = BoxStyler();

        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, isNull);
        expect(merged.$animation, isNull);
        expect(merged.$modifier, isNull);
        expect(merged.$variants, isNull);
      });

      test('mixed null and non-null parameters', () {
        final first = BoxStyler(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: WidgetModifierConfig.orderOfModifiers(const [OpacityModifier]),
          animation: null,
        );
        final second = BoxStyler(
          constraints: BoxConstraintsMix.height(200.0),
          modifier: WidgetModifierConfig.orderOfModifiers(const []),
          animation: const CurveAnimationConfig(
            duration: Duration(milliseconds: 100),
            curve: Curves.linear,
          ),
        );

        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [OpacityModifier]);
        expect(merged.$animation, isNotNull);
      });
    });
  });
}
