import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('VariantSpecAttribute', () {
    group('Constructor', () {
      test('creates VariantSpecAttribute with variant and style', () {
        const variant = NamedVariant('primary');
        final style = BoxStyler().width(100.0);
        final variantAttr = VariantStyle(variant, style);

        expect(variantAttr.variant, variant);
        expect(variantAttr.value, style);
        expect(variantAttr.mergeKey, 'primary');
      });

      test('creates VariantSpecAttribute with ContextVariant', () {
        final variant = ContextVariant.widgetState(WidgetState.hovered);
        final style = BoxStyler().height(200.0);
        final variantAttr = VariantStyle(variant, style);

        expect(variantAttr.variant, variant);
        expect(variantAttr.value, style);
        expect(variantAttr.mergeKey, 'widget_state_hovered');
      });

      test('creates VariantSpecAttribute with ContextVariant', () {
        final variant = ContextVariant.widgetState(WidgetState.hovered);
        final style = BoxStyler().width(150.0);
        final variantAttr = VariantStyle(variant, style);

        expect(variantAttr.variant, variant);
        expect(variantAttr.value, style);
        expect(variantAttr.mergeKey, 'widget_state_hovered');
      });
    });

    group('matches method', () {
      test('matches when variant is in the provided list', () {
        const variant = NamedVariant('primary');
        final style = BoxStyler().width(100.0);
        final variantAttr = VariantStyle(variant, style);

        const variants = [NamedVariant('primary'), NamedVariant('secondary')];
        expect(variantAttr.matches(variants), isTrue);
      });

      test('does not match when variant is not in the provided list', () {
        const variant = NamedVariant('tertiary');
        final style = BoxStyler().width(100.0);
        final variantAttr = VariantStyle(variant, style);

        const variants = [NamedVariant('primary'), NamedVariant('secondary')];
        expect(variantAttr.matches(variants), isFalse);
      });

      test('matches empty list returns false', () {
        const variant = NamedVariant('primary');
        final style = BoxStyler().width(100.0);
        final variantAttr = VariantStyle(variant, style);

        expect(variantAttr.matches([]), isFalse);
      });

      test('matches with ContextVariant', () {
        final variant = ContextVariant('test', (context) => true);
        final style = BoxStyler().width(100.0);
        final variantAttr = VariantStyle(variant, style);

        // The exact variant must be in the list to match
        final variants = [variant];
        expect(variantAttr.matches(variants), isTrue);

        // Different variants don't match
        const otherVariants = [NamedVariant('primary')];
        expect(variantAttr.matches(otherVariants), isFalse);
      });
    });

    group('removeVariants method', () {
      test('returns null when removing the only variant', () {
        const variant = NamedVariant('primary');
        final style = BoxStyler().width(100.0);
        final variantAttr = VariantStyle(variant, style);

        const variantsToRemove = [NamedVariant('primary')];
        final result = variantAttr.removeVariants(variantsToRemove);

        expect(result, isNull);
      });

      test('returns same instance when variant not in removal list', () {
        const variant = NamedVariant('primary');
        final style = BoxStyler().width(100.0);
        final variantAttr = VariantStyle(variant, style);

        const variantsToRemove = [NamedVariant('secondary')];
        final result = variantAttr.removeVariants(variantsToRemove);

        expect(result, same(variantAttr));
      });

      test('handles variant removal correctly', () {
        const variant = NamedVariant('primary');
        final style = BoxStyler().width(100.0);
        final variantAttr = VariantStyle(variant, style);

        const variantsToRemove = [NamedVariant('primary')];
        final result = variantAttr.removeVariants(variantsToRemove);

        expect(result, isNull);
      });

      test('returns attribute when variant not in removal list', () {
        const variant = NamedVariant('primary');
        final style = BoxStyler().width(100.0);
        final variantAttr = VariantStyle(variant, style);

        const variantsToRemove = [NamedVariant('secondary')];
        final result = variantAttr.removeVariants(variantsToRemove);

        expect(result, isNotNull);
        expect(result!.variant, variant);
      });

      test('returns null when variant is removed', () {
        const variant = NamedVariant('primary');
        final style = BoxStyler().width(100.0);
        final variantAttr = VariantStyle(variant, style);

        const variantsToRemove = [NamedVariant('primary')];
        final result = variantAttr.removeVariants(variantsToRemove);

        expect(result, isNull);
      });

      test('preserves context variant when removal doesnt match', () {
        final variant = ContextVariant('test', (context) => true);
        final style = BoxStyler().width(100.0);
        final variantAttr = VariantStyle(variant, style);

        const variantsToRemove = [NamedVariant('other')];
        final result = variantAttr.removeVariants(variantsToRemove);

        expect(result, isNotNull);
        expect(result!.variant, same(variant));
      });
    });

    group('merge method', () {
      test('merges styles when variants match', () {
        const variant = NamedVariant('primary');
        final style1 = BoxStyler().width(100.0);
        final style2 = BoxStyler().height(200.0);

        final variantAttr1 = VariantStyle(variant, style1);
        final variantAttr2 = VariantStyle(variant, style2);

        final merged = variantAttr1.merge(variantAttr2);

        expect(merged.variant, variant);
        final mergedBox = merged.value as BoxStyler;
        final context = MockBuildContext();
        final constraints = mergedBox.resolve(context).constraints;
        expect(constraints?.minWidth, 100.0);
        expect(constraints?.maxWidth, 100.0);
        expect(constraints?.minHeight, 200.0);
        expect(constraints?.maxHeight, 200.0);
      });

      test('returns this when variants do not match', () {
        const variant1 = NamedVariant('primary');
        const variant2 = NamedVariant('secondary');
        final style1 = BoxStyler().width(100.0);
        final style2 = BoxStyler().height(200.0);

        final variantAttr1 = VariantStyle(variant1, style1);
        final variantAttr2 = VariantStyle(variant2, style2);

        final merged = variantAttr1.merge(variantAttr2);

        expect(merged, same(variantAttr1));
        final mergedBox = merged.value as BoxStyler;
        final context = MockBuildContext();
        final constraints = mergedBox.resolve(context).constraints;
        expect(constraints?.minWidth, 100.0);
        expect(constraints?.maxWidth, 100.0);
        expect(constraints?.minHeight, 0.0);
        expect(constraints?.maxHeight, double.infinity);
      });

      test('returns this when other is null', () {
        const variant = NamedVariant('primary');
        final style = BoxStyler().width(100.0);
        final variantAttr = VariantStyle(variant, style);

        final merged = variantAttr.merge(null);

        expect(merged, same(variantAttr));
      });

      test('merges with overlapping properties - other takes precedence', () {
        const variant = NamedVariant('primary');
        final style1 = BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: 100.0,
            maxWidth: 100.0,
            minHeight: 150.0,
            maxHeight: 150.0,
          ),
        );
        final style2 = BoxStyler().width(200.0);

        final variantAttr1 = VariantStyle(variant, style1);
        final variantAttr2 = VariantStyle(variant, style2);

        final merged = variantAttr1.merge(variantAttr2);

        expect(merged.variant, variant);
        final mergedBox = merged.value as BoxStyler;
        final context = MockBuildContext();
        final constraints = mergedBox.resolve(context).constraints;
        expect(constraints?.minWidth, 200.0); // other overrides
        expect(constraints?.maxWidth, 200.0); // other overrides
        expect(constraints?.minHeight, 150.0); // from first
        expect(constraints?.maxHeight, 150.0); // from first
      });
    });

    group('Equality', () {
      test('equal VariantSpecAttributes have same hashCode', () {
        const variant = NamedVariant('primary');
        final style = BoxStyler().width(100.0);

        final variantAttr1 = VariantStyle(variant, style);
        final variantAttr2 = VariantStyle(variant, style);

        expect(variantAttr1, equals(variantAttr2));
        expect(variantAttr1.hashCode, equals(variantAttr2.hashCode));
      });

      test('different variants are not equal', () {
        const variant1 = NamedVariant('primary');
        const variant2 = NamedVariant('secondary');
        final style = BoxStyler().width(100.0);

        final variantAttr1 = VariantStyle(variant1, style);
        final variantAttr2 = VariantStyle(variant2, style);

        expect(variantAttr1, isNot(equals(variantAttr2)));
      });

      test('different styles are not equal', () {
        const variant = NamedVariant('primary');
        final style1 = BoxStyler().width(100.0);
        final style2 = BoxStyler().width(200.0);

        final variantAttr1 = VariantStyle(variant, style1);
        final variantAttr2 = VariantStyle(variant, style2);

        expect(variantAttr1, isNot(equals(variantAttr2)));
      });

      test('identical instances are equal', () {
        const variant = NamedVariant('primary');
        final style = BoxStyler().width(100.0);
        final variantAttr = VariantStyle(variant, style);

        expect(variantAttr, equals(variantAttr));
        expect(identical(variantAttr, variantAttr), isTrue);
      });
    });

    group('mergeKey property', () {
      test('uses variant key as merge key', () {
        const variant = NamedVariant('primary');
        final style = BoxStyler().width(100.0);
        final variantAttr = VariantStyle(variant, style);

        expect(variantAttr.mergeKey, 'primary');
      });

      test('uses ContextVariant key as merge key', () {
        final variant = ContextVariant.widgetState(WidgetState.hovered);
        final style = BoxStyler().width(100.0);
        final variantAttr = VariantStyle(variant, style);

        expect(variantAttr.mergeKey, 'widget_state_hovered');
      });

      test('uses variant key as merge key', () {
        const variant = NamedVariant('primary');
        final style = BoxStyler().width(100.0);
        final variantAttr = VariantStyle(variant, style);

        expect(variantAttr.mergeKey, 'primary');
      });
    });

    group('Different SpecAttribute Types', () {
      test('works with TextSpecAttribute', () {
        const variant = NamedVariant('large');
        final textStyle = TextStyler(textAlign: TextAlign.center, maxLines: 2);
        final variantAttr = VariantStyle(variant, textStyle);

        expect(variantAttr.variant, variant);
        expect(variantAttr.value, textStyle);
        final textAttr = variantAttr.value as TextStyler;
        expect(textAttr.$textAlign, resolvesTo(TextAlign.center));
        expect(textAttr.$maxLines, resolvesTo(2));
      });

      test('', () {
        const variant = NamedVariant('avatar');
        final imageStyle = ImageStyler(
          width: 50.0,
          height: 50.0,
          fit: BoxFit.cover,
        );
        final variantAttr = VariantStyle(variant, imageStyle);

        expect(variantAttr.variant, variant);
        expect(variantAttr.value, imageStyle);
        final imageAttr = variantAttr.value as ImageStyler;
        expect(imageAttr.$width, resolvesTo(50.0));
        expect(imageAttr.$height, resolvesTo(50.0));
        expect(imageAttr.$fit, resolvesTo(BoxFit.cover));
      });
    });

    group('Complex Scenarios', () {
      test('complex variant combinations', () {
        final variant1 = ContextVariant.widgetState(WidgetState.hovered);
        final variant2 = ContextVariant.brightness(Brightness.dark);

        final style = BoxStyler().width(100.0);
        final variantAttr1 = VariantStyle(variant1, style);
        final variantAttr2 = VariantStyle(variant2, style);

        expect(variantAttr1.variant, variant1);
        expect(variantAttr2.variant, variant2);
        expect(variantAttr1.value, style);
        expect(variantAttr2.value, style);
      });

      test('removing variants from different variant types', () {
        final variant = ContextVariant.widgetState(WidgetState.hovered);
        final style = BoxStyler().width(100.0);
        final variantAttr = VariantStyle(variant, style);

        // Try to remove a NamedVariant - should not affect ContextVariant
        const variantsToRemove = [NamedVariant('primary')];
        final result = variantAttr.removeVariants(variantsToRemove);

        expect(result, isNotNull);
        expect(result!.variant, same(variant));
      });
    });
  });
}
