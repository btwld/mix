import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Style Merge Parameters', () {
    group('BoxMix merge', () {
      test('merges orderOfModifiers correctly', () {
        final first = BoxMix(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig.orderOfModifiers([
            OpacityWidgetModifier,
            PaddingWidgetModifier,
          ]),
        );
        final second = BoxMix(
          constraints: BoxConstraintsMix.height(200.0),
          modifier: ModifierConfig.orderOfModifiers([
            ClipOvalWidgetModifier,
            TransformWidgetModifier,
          ]),
        );
        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          ClipOvalWidgetModifier,
          TransformWidgetModifier,
        ]);
      });

      test('preserves first orderOfModifiers when second is empty', () {
        final first = BoxMix(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig.orderOfModifiers([
            OpacityWidgetModifier,
            PaddingWidgetModifier,
          ]),
        );
        final second = BoxMix(constraints: BoxConstraintsMix.height(200.0));

        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          OpacityWidgetModifier,
          PaddingWidgetModifier,
        ]);
      });

      test('merges inherit correctly', () {
        final first = BoxMix(
          constraints: BoxConstraintsMix.width(100.0),
          inherit: true,
        );
        final second = BoxMix(
          constraints: BoxConstraintsMix.height(200.0),
          inherit: false,
        );

        final merged = first.merge(second);

        expect(merged.$inherit, false);
      });

      test('preserves first inherit when second is null', () {
        final first = BoxMix(
          constraints: BoxConstraintsMix.width(100.0),
          inherit: true,
        );
        final second = BoxMix(constraints: BoxConstraintsMix.height(200.0));

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

        final first = BoxMix(
          constraints: BoxConstraintsMix.width(100.0),
          animation: firstAnimation,
        );
        final second = BoxMix(
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

        final first = BoxMix(
          constraints: BoxConstraintsMix.width(100.0),
          animation: firstAnimation,
        );
        final second = BoxMix(constraints: BoxConstraintsMix.height(200.0));

        final merged = first.merge(second);

        expect(merged.$animation, firstAnimation);
      });

      test('merges modifiers correctly', () {
        final firstModifiers = [OpacityWidgetModifierMix(opacity: 0.5)];
        final secondModifiers = [
          PaddingWidgetModifierMix(padding: EdgeInsetsMix.all(10)),
        ];

        final first = BoxMix(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig(modifiers: firstModifiers),
        );
        final second = BoxMix(
          constraints: BoxConstraintsMix.height(200.0),
          modifier: ModifierConfig(modifiers: secondModifiers),
        );

        final merged = first.merge(second);

        expect(merged.$modifier, isNotNull);
        expect(merged.$modifier!.$modifiers!.length, 2);
        expect(
          merged.$modifier!.$modifiers![0],
          isA<OpacityWidgetModifierMix>(),
        );
        expect(
          merged.$modifier!.$modifiers![1],
          isA<PaddingWidgetModifierMix>(),
        );
      });

      test('merges variants correctly', () {
        final firstVariants = [
          VariantStyle(
            const NamedVariant('primary'),
            BoxMix.color(Colors.blue),
          ),
        ];
        final secondVariants = [
          VariantStyle(
            const NamedVariant('secondary'),
            BoxMix.color(Colors.red),
          ),
        ];

        final first = BoxMix(
          constraints: BoxConstraintsMix.width(100.0),
          variants: firstVariants,
        );
        final second = BoxMix(
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
        final first = BoxMix(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityWidgetModifier,
          ]),
          inherit: true,
        );

        final merged = first.merge(null);

        expect(merged, same(first));
      });
    });

    group('TextMix merge', () {
      test('merges orderOfModifiers correctly', () {
        final first = TextMix(
          maxLines: 2,
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityWidgetModifier,
            PaddingWidgetModifier,
          ]),
        );
        final second = TextMix(
          overflow: TextOverflow.ellipsis,
          modifier: ModifierConfig.orderOfModifiers(const [
            ClipOvalWidgetModifier,
            TransformWidgetModifier,
          ]),
        );
        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          ClipOvalWidgetModifier,
          TransformWidgetModifier,
        ]);
      });

      test('merges inherit correctly', () {
        final first = TextMix(maxLines: 2, inherit: true);
        final second = TextMix(overflow: TextOverflow.ellipsis, inherit: false);

        final merged = first.merge(second);

        expect(merged.$inherit, false);
      });
    });

    group('IconMix merge', () {
      test('merges orderOfModifiers correctly', () {
        final first = IconMix(
          size: 24.0,
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityWidgetModifier,
            PaddingWidgetModifier,
          ]),
        );
        final second = IconMix(
          color: Colors.red,
          modifier: ModifierConfig.orderOfModifiers(const [
            ClipOvalWidgetModifier,
            TransformWidgetModifier,
          ]),
        );
        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          ClipOvalWidgetModifier,
          TransformWidgetModifier,
        ]);
      });

      test('merges inherit correctly', () {
        final first = IconMix(size: 24.0, inherit: true);
        final second = IconMix(color: Colors.red, inherit: false);

        final merged = first.merge(second);

        expect(merged.$inherit, false);
      });
    });

    group('FlexMix merge', () {
      test('merges orderOfModifiers correctly', () {
        final first = FlexMix(
          direction: Axis.horizontal,
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityWidgetModifier,
            PaddingWidgetModifier,
          ]),
        );
        final second = FlexMix(
          gap: 8.0,
          modifier: ModifierConfig.orderOfModifiers(const [
            ClipOvalWidgetModifier,
            TransformWidgetModifier,
          ]),
        );
        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          ClipOvalWidgetModifier,
          TransformWidgetModifier,
        ]);
      });

      test('merges inherit correctly', () {
        final first = FlexMix(direction: Axis.horizontal, inherit: true);
        final second = FlexMix(gap: 8.0, inherit: false);

        final merged = first.merge(second);

        expect(merged.$inherit, false);
      });
    });

    group('ImageMix merge', () {
      test('merges orderOfModifiers correctly', () {
        final first = ImageMix(
          width: 100.0,
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityWidgetModifier,
            PaddingWidgetModifier,
          ]),
        );
        final second = ImageMix(
          height: 200.0,
          modifier: ModifierConfig.orderOfModifiers(const [
            ClipOvalWidgetModifier,
            TransformWidgetModifier,
          ]),
        );
        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          ClipOvalWidgetModifier,
          TransformWidgetModifier,
        ]);
      });

      test('merges inherit correctly', () {
        final first = ImageMix(width: 100.0, inherit: true);
        final second = ImageMix(height: 200.0, inherit: false);

        final merged = first.merge(second);

        expect(merged.$inherit, false);
      });
    });

    group('StackMix merge', () {
      test('merges orderOfModifiers correctly', () {
        final first = StackMix(
          alignment: Alignment.center,
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityWidgetModifier,
            PaddingWidgetModifier,
          ]),
        );
        final second = StackMix(
          fit: StackFit.expand,
          modifier: ModifierConfig.orderOfModifiers(const [
            ClipOvalWidgetModifier,
            TransformWidgetModifier,
          ]),
        );
        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          ClipOvalWidgetModifier,
          TransformWidgetModifier,
        ]);
      });

      test('merges inherit correctly', () {
        final first = StackMix(alignment: Alignment.center, inherit: true);
        final second = StackMix(fit: StackFit.expand, inherit: false);

        final merged = first.merge(second);

        expect(merged.$inherit, false);
      });
    });

    group('FlexBoxMix merge', () {
      test('merges orderOfModifiers correctly', () {
        final first = FlexBoxMix(
          box: BoxMix.width(100),
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityWidgetModifier,
            PaddingWidgetModifier,
          ]),
        );
        final second = FlexBoxMix(
          flex: FlexMix.gap(8.0),
          modifier: ModifierConfig.orderOfModifiers(const [
            ClipOvalWidgetModifier,
            TransformWidgetModifier,
          ]),
        );
        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          ClipOvalWidgetModifier,
          TransformWidgetModifier,
        ]);
      });

      test('merges inherit correctly', () {
        final first = FlexBoxMix(box: BoxMix.width(100), inherit: true);
        final second = FlexBoxMix(flex: FlexMix.gap(8.0), inherit: false);

        final merged = first.merge(second);

        expect(merged.$inherit, false);
      });
    });

    group('StackBoxMix merge', () {
      test('merges orderOfModifiers correctly', () {
        final first = StackBoxMix(
          box: BoxMix.width(100),
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityWidgetModifier,
            PaddingWidgetModifier,
          ]),
        );
        final second = StackBoxMix(
          stack: StackMix.alignment(Alignment.center),
          modifier: ModifierConfig.orderOfModifiers(const [
            ClipOvalWidgetModifier,
            TransformWidgetModifier,
          ]),
        );
        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [
          ClipOvalWidgetModifier,
          TransformWidgetModifier,
        ]);
      });

      test('merges inherit correctly', () {
        final first = StackBoxMix(box: BoxMix.width(100), inherit: true);
        final second = StackBoxMix(
          stack: StackMix.alignment(Alignment.center),
          inherit: false,
        );

        final merged = first.merge(second);

        expect(merged.$inherit, false);
      });
    });

    group('Complex merge scenarios', () {
      test('chained merges preserve final values', () {
        final first = BoxMix(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityWidgetModifier,
          ]),
          inherit: true,
        );
        final second = BoxMix(
          constraints: BoxConstraintsMix.height(200.0),
          modifier: ModifierConfig.orderOfModifiers(const [
            PaddingWidgetModifier,
          ]),
          inherit: false,
        );
        final third = BoxMix(
          decoration: DecorationMix.color(Colors.blue),
          modifier: ModifierConfig.orderOfModifiers(const [
            ClipOvalWidgetModifier,
          ]),
          inherit: true,
        );

        final merged = first.merge(second).merge(third);

        expect(merged.$modifier?.$orderOfModifiers, [ClipOvalWidgetModifier]);
        expect(merged.$inherit, true);
        expect(merged.$decoration, isNotNull);
      });

      test('merges with same modifier types correctly', () {
        final firstOpacity = OpacityWidgetModifierMix(opacity: 0.3);
        final secondOpacity = OpacityWidgetModifierMix(opacity: 0.7);

        final first = BoxMix(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig(modifiers: [firstOpacity]),
        );
        final second = BoxMix(
          constraints: BoxConstraintsMix.height(200.0),
          modifier: ModifierConfig(modifiers: [secondOpacity]),
        );

        final merged = first.merge(second);

        expect(merged.$modifier, isNotNull);
        expect(merged.$modifier!.$modifiers!.length, 1);
        expect(
          merged.$modifier!.$modifiers![0],
          isA<OpacityWidgetModifierMix>(),
        );

        final mergedOpacity =
            merged.$modifier!.$modifiers![0] as OpacityWidgetModifierMix;
        expect(mergedOpacity.opacity, resolvesTo(0.7));
      });

      test('merges with same variant types correctly', () {
        const variant = NamedVariant('primary');
        final firstStyle = BoxMix.width(100.0);
        final secondStyle = BoxMix.height(200.0);

        final first = BoxMix(
          decoration: DecorationMix.color(Colors.red),
          variants: [VariantStyle(variant, firstStyle)],
        );
        final second = BoxMix(
          padding: EdgeInsetsMix.all(10),
          variants: [VariantStyle(variant, secondStyle)],
        );

        final merged = first.merge(second);

        expect(merged.$variants, isNotNull);
        expect(merged.$variants!.length, 1);
        expect(merged.$variants![0].variant, variant);

        final mergedVariantStyle = merged.$variants![0].value as BoxMix;
        final context = MockBuildContext();
        final spec = mergedVariantStyle.resolve(context);
        expect(spec.constraints?.minWidth, 100.0);
        expect(spec.constraints?.minHeight, 200.0);
      });

      test('empty orderOfModifiers list behavior', () {
        final first = BoxMix(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityWidgetModifier,
          ]),
        );
        final second = BoxMix(
          constraints: BoxConstraintsMix.height(200.0),
          modifier: ModifierConfig.orderOfModifiers(const []),
        );

        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [OpacityWidgetModifier]);
      });

      test('null vs empty list handling for modifiers', () {
        final first = BoxMix(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig(
            modifiers: [OpacityWidgetModifierMix(opacity: 0.5)],
          ),
        );
        final second = BoxMix(
          constraints: BoxConstraintsMix.height(200.0),
        ); // null modifiers

        final merged = first.merge(second);

        expect(merged.$modifier, isNotNull);
        expect(merged.$modifier!.$modifiers!.length, 1);
        expect(
          merged.$modifier!.$modifiers![0],
          isA<OpacityWidgetModifierMix>(),
        );
      });

      test('null vs empty list handling for variants', () {
        final first = BoxMix(
          constraints: BoxConstraintsMix.width(100.0),
          variants: [
            VariantStyle(
              const NamedVariant('primary'),
              BoxMix.color(Colors.blue),
            ),
          ],
        );
        final second = BoxMix(
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
        final style = BoxMix(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityWidgetModifier,
          ]),
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
        final first = BoxMix();
        final second = BoxMix();

        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, isNull);
        expect(merged.$inherit, isNull);
        expect(merged.$animation, isNull);
        expect(merged.$modifier, isNull);
        expect(merged.$variants, isNull);
      });

      test('mixed null and non-null parameters', () {
        final first = BoxMix(
          constraints: BoxConstraintsMix.width(100.0),
          modifier: ModifierConfig.orderOfModifiers(const [
            OpacityWidgetModifier,
          ]),
          inherit: null,
          animation: null,
        );
        final second = BoxMix(
          constraints: BoxConstraintsMix.height(200.0),
          modifier: ModifierConfig.orderOfModifiers(const []),
          inherit: true,
          animation: const CurveAnimationConfig(
            duration: Duration(milliseconds: 100),
            curve: Curves.linear,
          ),
        );

        final merged = first.merge(second);

        expect(merged.$modifier?.$orderOfModifiers, [OpacityWidgetModifier]);
        expect(merged.$inherit, true);
        expect(merged.$animation, isNotNull);
      });
    });
  });
}
