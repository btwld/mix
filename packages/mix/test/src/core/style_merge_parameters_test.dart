import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Style Merge Parameters', () {
    group('BoxMix merge', () {
      test('merges orderOfModifiers correctly', () {
        final first = BoxStyle(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig.orderOfModifiers([
            OpacityModifier,
            PaddingModifier,
          ]),
        );
        final second = BoxStyle(
          constraints: BoxConstraintsMix.height(200.0),
          modifier: ModifierConfig.orderOfModifiers([
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
        final first = BoxStyle(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig.orderOfModifiers([
            OpacityModifier,
            PaddingModifier,
          ]),
        );
        final second = BoxStyle(constraints: BoxConstraintsMix.height(200.0));

        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          OpacityModifier,
          PaddingModifier,
        ]);
      });

      test('merges inherit correctly', () {
        final first = BoxStyle(
          constraints: BoxConstraintsMix.width(100.0),
          inherit: true,
        );
        final second = BoxStyle(
          constraints: BoxConstraintsMix.height(200.0),
          inherit: false,
        );

        final merged = first.merge(second);

        expect(merged.$inherit, false);
      });

      test('preserves first inherit when second is null', () {
        final first = BoxStyle(
          constraints: BoxConstraintsMix.width(100.0),
          inherit: true,
        );
        final second = BoxStyle(constraints: BoxConstraintsMix.height(200.0));

        final merged = first.merge(second);

        expect(merged.$inherit, true);
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

        final first = BoxStyle(
          constraints: BoxConstraintsMix.width(100.0),
          animation: firstAnimation,
        );
        final second = BoxStyle(
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

        final first = BoxStyle(
          constraints: BoxConstraintsMix.width(100.0),
          animation: firstAnimation,
        );
        final second = BoxStyle(constraints: BoxConstraintsMix.height(200.0));

        final merged = first.merge(second);

        expect(merged.$animation, firstAnimation);
      });

      test('merges modifiers correctly', () {
        final firstModifiers = [OpacityModifierMix(opacity: 0.5)];
        final secondModifiers = [
          PaddingModifierMix(padding: EdgeInsetsMix.all(10)),
        ];

        final first = BoxStyle(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig(modifiers: firstModifiers),
        );
        final second = BoxStyle(
          constraints: BoxConstraintsMix.height(200.0),
          modifier: ModifierConfig(modifiers: secondModifiers),
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
            BoxStyle().color(Colors.blue),
          ),
        ];
        final secondVariants = [
          VariantStyle(
            const NamedVariant('secondary'),
            BoxStyle().color(Colors.red),
          ),
        ];

        final first = BoxStyle(
          constraints: BoxConstraintsMix.width(100.0),
          variants: firstVariants,
        );
        final second = BoxStyle(
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
        final first = BoxStyle(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig.orderOfModifiers(const [OpacityModifier]),
          inherit: true,
        );

        final merged = first.merge(null);

        expect(merged, same(first));
      });
    });

    group('TextStyling merge', () {
      test('merges orderOfModifiers correctly', () {
        final first = TextStyling(
          maxLines: 2,
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityModifier,
            PaddingModifier,
          ]),
        );
        final second = TextStyling(
          overflow: TextOverflow.ellipsis,
          modifier: ModifierConfig.orderOfModifiers(const [
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

      test('merges inherit correctly', () {
        final first = TextStyling(maxLines: 2, inherit: true);
        final second = TextStyling(
          overflow: TextOverflow.ellipsis,
          inherit: false,
        );

        final merged = first.merge(second);

        expect(merged.$inherit, false);
      });
    });

    group('', () {
      test('merges orderOfModifiers correctly', () {
        final first = IconStyle(
          size: 24.0,
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityModifier,
            PaddingModifier,
          ]),
        );
        final second = IconStyle(
          color: Colors.red,
          modifier: ModifierConfig.orderOfModifiers(const [
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

      test('merges inherit correctly', () {
        final first = IconStyle(size: 24.0, inherit: true);
        final second = IconStyle(color: Colors.red, inherit: false);

        final merged = first.merge(second);

        expect(merged.$inherit, false);
      });
    });

    group('', () {
      test('merges orderOfModifiers correctly', () {
        final first = FlexStyle(
          direction: Axis.horizontal,
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityModifier,
            PaddingModifier,
          ]),
        );
        final second = FlexStyle(
          gap: 8.0,
          modifier: ModifierConfig.orderOfModifiers(const [
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

      test('merges inherit correctly', () {
        final first = FlexStyle(direction: Axis.horizontal, inherit: true);
        final second = FlexStyle(gap: 8.0, inherit: false);

        final merged = first.merge(second);

        expect(merged.$inherit, false);
      });
    });

    group('', () {
      test('merges orderOfModifiers correctly', () {
        final first = ImageStyle(
          width: 100.0,
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityModifier,
            PaddingModifier,
          ]),
        );
        final second = ImageStyle(
          height: 200.0,
          modifier: ModifierConfig.orderOfModifiers(const [
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

      test('merges inherit correctly', () {
        final first = ImageStyle(width: 100.0, inherit: true);
        final second = ImageStyle(height: 200.0, inherit: false);

        final merged = first.merge(second);

        expect(merged.$inherit, false);
      });
    });

    group('', () {
      test('merges orderOfModifiers correctly', () {
        final first = StackStyle(
          alignment: Alignment.center,
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityModifier,
            PaddingModifier,
          ]),
        );
        final second = StackStyle(
          fit: StackFit.expand,
          modifier: ModifierConfig.orderOfModifiers(const [
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

      test('merges inherit correctly', () {
        final first = StackStyle(alignment: Alignment.center, inherit: true);
        final second = StackStyle(fit: StackFit.expand, inherit: false);

        final merged = first.merge(second);

        expect(merged.$inherit, false);
      });
    });

    group('', () {
      test('merges orderOfModifiers correctly', () {
        final first = FlexBoxStyle(
          constraints: BoxConstraintsMix.width(100),
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityModifier,
            PaddingModifier,
          ]),
        );
        final second = FlexBoxStyle(
          spacing: 8.0,
          modifier: ModifierConfig.orderOfModifiers(const [
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

      test('merges inherit correctly', () {
        final first = FlexBoxStyle(
          constraints: BoxConstraintsMix.width(100),
          inherit: true,
        );
        final second = FlexBoxStyle(
          spacing: 8.0,
          inherit: false,
        );

        final merged = first.merge(second);

        expect(merged.$inherit, false);
      });
    });

    group('', () {
      test('merges orderOfModifiers correctly', () {
        final first = StackBoxStyle(
          box: BoxMix().width(100),
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityModifier,
            PaddingModifier,
          ]),
        );
        final second = StackBoxStyle(
          stack: StackMix.alignment(Alignment.center),
          modifier: ModifierConfig.orderOfModifiers(const [
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

      test('merges inherit correctly', () {
        final first = StackBoxStyle(box: BoxMix().width(100), inherit: true);
        final second = StackBoxStyle(
          stack: StackMix.alignment(Alignment.center),
          inherit: false,
        );

        final merged = first.merge(second);

        expect(merged.$inherit, false);
      });
    });

    group('Complex merge scenarios', () {
      test('chained merges preserve final values', () {
        final first = BoxStyle(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig.orderOfModifiers(const [OpacityModifier]),
          inherit: true,
        );
        final second = BoxStyle(
          constraints: BoxConstraintsMix.height(200.0),
          modifier: ModifierConfig.orderOfModifiers(const [PaddingModifier]),
          inherit: false,
        );
        final third = BoxStyle(
          decoration: DecorationMix.color(Colors.blue),
          modifier: ModifierConfig.orderOfModifiers(const [ClipOvalModifier]),
          inherit: true,
        );

        final merged = first.merge(second).merge(third);

        expect(merged.$modifier?.$orderOfModifiers, [ClipOvalModifier]);
        expect(merged.$inherit, true);
        expect(merged.$decoration, isNotNull);
      });

      test('merges with same modifier types correctly', () {
        final firstOpacity = OpacityModifierMix(opacity: 0.3);
        final secondOpacity = OpacityModifierMix(opacity: 0.7);

        final first = BoxStyle(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig(modifiers: [firstOpacity]),
        );
        final second = BoxStyle(
          constraints: BoxConstraintsMix.height(200.0),
          modifier: ModifierConfig(modifiers: [secondOpacity]),
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
        final firstStyle = BoxStyle().width(100.0);
        final secondStyle = BoxStyle().height(200.0);

        final first = BoxStyle(
          decoration: DecorationMix.color(Colors.red),
          variants: [VariantStyle(variant, firstStyle)],
        );
        final second = BoxStyle(
          padding: EdgeInsetsMix.all(10),
          variants: [VariantStyle(variant, secondStyle)],
        );

        final merged = first.merge(second);

        expect(merged.$variants, isNotNull);
        expect(merged.$variants!.length, 1);
        expect(merged.$variants![0].variant, variant);

        final mergedVariantStyle = merged.$variants![0].value as BoxStyle;
        final context = MockBuildContext();
        final spec = mergedVariantStyle.resolve(context);
        expect(spec.constraints?.minWidth, 100.0);
        expect(spec.constraints?.minHeight, 200.0);
      });

      test('empty orderOfModifiers list behavior', () {
        final first = BoxStyle(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig.orderOfModifiers(const [OpacityModifier]),
        );
        final second = BoxStyle(
          constraints: BoxConstraintsMix.height(200.0),
          modifier: ModifierConfig.orderOfModifiers(const []),
        );

        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [OpacityModifier]);
      });

      test('null vs empty list handling for modifiers', () {
        final first = BoxStyle(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig(
            modifiers: [OpacityModifierMix(opacity: 0.5)],
          ),
        );
        final second = BoxStyle(
          constraints: BoxConstraintsMix.height(200.0),
        ); // null modifiers

        final merged = first.merge(second);

        expect(merged.$modifier, isNotNull);
        expect(merged.$modifier!.$modifiers!.length, 1);
        expect(merged.$modifier!.$modifiers![0], isA<OpacityModifierMix>());
      });

      test('null vs empty list handling for variants', () {
        final first = BoxStyle(
          constraints: BoxConstraintsMix.width(100.0),
          variants: [
            VariantStyle(
              const NamedVariant('primary'),
              BoxStyle().color(Colors.blue),
            ),
          ],
        );
        final second = BoxStyle(
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
        final style = BoxStyle(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig.orderOfModifiers(const [OpacityModifier]),
          inherit: true,
        );

        final merged = style.merge(style);

        // Merging with self should return a new instance (not the same reference) with identical values to ensure immutability.
        expect(merged, isNot(same(style)));
        expect(
          merged.$modifier?.$orderOfModifiers,
          style.$modifier?.$orderOfModifiers,
        );
        expect(merged.$inherit, style.$inherit);
      });

      test('all parameters null in both styles', () {
        final first = BoxStyle();
        final second = BoxStyle();

        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, isNull);
        expect(merged.$inherit, isNull);
        expect(merged.$animation, isNull);
        expect(merged.$modifier, isNull);
        expect(merged.$variants, isNull);
      });

      test('mixed null and non-null parameters', () {
        final first = BoxStyle(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig.orderOfModifiers(const [OpacityModifier]),
          inherit: null,
          animation: null,
        );
        final second = BoxStyle(
          constraints: BoxConstraintsMix.height(200.0),
          modifier: ModifierConfig.orderOfModifiers(const []),
          inherit: true,
          animation: const CurveAnimationConfig(
            duration: Duration(milliseconds: 100),
            curve: Curves.linear,
          ),
        );

        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [OpacityModifier]);
        expect(merged.$inherit, true);
        expect(merged.$animation, isNotNull);
      });
    });
  });
}
