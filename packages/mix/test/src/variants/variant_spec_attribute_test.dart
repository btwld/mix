import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('VariantSpecAttribute', () {
    group('Constructor', () {
      test('creates VariantSpecAttribute with variant and style', () {
        const variant = NamedVariant('primary');
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(variant, style);

        expect(variantAttr.variant, variant);
        expect(variantAttr.value, style);
        expect(variantAttr.mergeKey, 'primary');
      });

      test('creates VariantSpecAttribute with ContextVariant', () {
        final variant = ContextVariant.widgetState(WidgetState.hovered);
        final style = BoxSpecAttribute.only(height: 200.0);
        final variantAttr = VariantSpecAttribute(variant, style);

        expect(variantAttr.variant, variant);
        expect(variantAttr.value, style);
        expect(variantAttr.mergeKey, 'widget_state_hovered');
      });

      test('creates VariantSpecAttribute with MultiVariant', () {
        final variant = MultiVariant.and([
          NamedVariant('primary'),
          ContextVariant.widgetState(WidgetState.hovered),
        ]);
        final style = BoxSpecAttribute.only(width: 150.0);
        final variantAttr = VariantSpecAttribute(variant, style);

        expect(variantAttr.variant, variant);
        expect(variantAttr.value, style);
        expect(variantAttr.mergeKey, isA<String>());
      });
    });

    group('matches method', () {
      test('matches when variant is in the provided list', () {
        const variant = NamedVariant('primary');
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(variant, style);

        const variants = [NamedVariant('primary'), NamedVariant('secondary')];
        expect(variantAttr.matches(variants), isTrue);
      });

      test('does not match when variant is not in the provided list', () {
        const variant = NamedVariant('tertiary');
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(variant, style);

        const variants = [NamedVariant('primary'), NamedVariant('secondary')];
        expect(variantAttr.matches(variants), isFalse);
      });

      test('matches empty list returns false', () {
        const variant = NamedVariant('primary');
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(variant, style);

        expect(variantAttr.matches([]), isFalse);
      });

      test('matches with MultiVariant', () {
        final variant = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(variant, style);

        // The exact MultiVariant must be in the list to match
        final variants = [variant];
        expect(variantAttr.matches(variants), isTrue);
        
        // Individual components don't match
        const individualVariants = [NamedVariant('primary')];
        expect(variantAttr.matches(individualVariants), isFalse);
      });
    });

    group('removeVariants method', () {
      test('returns null when removing the only variant', () {
        const variant = NamedVariant('primary');
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(variant, style);

        const variantsToRemove = [NamedVariant('primary')];
        final result = variantAttr.removeVariants(variantsToRemove);

        expect(result, isNull);
      });

      test('returns same instance when variant not in removal list', () {
        const variant = NamedVariant('primary');
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(variant, style);

        const variantsToRemove = [NamedVariant('secondary')];
        final result = variantAttr.removeVariants(variantsToRemove);

        expect(result, same(variantAttr));
      });

      test('handles MultiVariant removal correctly', () {
        final variant = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('large'),
          NamedVariant('outlined'),
        ]);
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(variant, style);

        const variantsToRemove = [NamedVariant('large')];
        final result = variantAttr.removeVariants(variantsToRemove);

        expect(result, isNotNull);
        expect(result!.variant, isA<MultiVariant>());
        
        final remainingMultiVariant = result.variant as MultiVariant;
        expect(remainingMultiVariant.variants.length, 2);
        expect(remainingMultiVariant.variants, contains(NamedVariant('primary')));
        expect(remainingMultiVariant.variants, contains(const NamedVariant('outlined')));
        expect(remainingMultiVariant.variants, isNot(contains(NamedVariant('large'))));
      });

      test('returns single variant when MultiVariant reduced to one', () {
        final variant = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(variant, style);

        const variantsToRemove = [NamedVariant('large')];
        final result = variantAttr.removeVariants(variantsToRemove);

        expect(result, isNotNull);
        expect(result!.variant, NamedVariant('primary'));
        expect(result.variant, isNot(isA<MultiVariant>()));
      });

      test('returns null when all variants removed from MultiVariant', () {
        final variant = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(variant, style);

        const variantsToRemove = [NamedVariant('primary'), NamedVariant('large')];
        final result = variantAttr.removeVariants(variantsToRemove);

        expect(result, isNull);
      });

      test('preserves MultiVariant operator type', () {
        final orVariant = MultiVariant.or(const [
          NamedVariant('primary'),
          NamedVariant('large'),
          NamedVariant('outlined'),
        ]);
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(orVariant, style);

        const variantsToRemove = [NamedVariant('large')];
        final result = variantAttr.removeVariants(variantsToRemove);

        expect(result, isNotNull);
        expect(result!.variant, isA<MultiVariant>());
        
        final remainingMultiVariant = result.variant as MultiVariant;
        expect(remainingMultiVariant.operatorType, MultiVariantOperator.or);
      });
    });

    group('merge method', () {
      test('merges styles when variants match', () {
        const variant = NamedVariant('primary');
        final style1 = BoxSpecAttribute.only(width: 100.0);
        final style2 = BoxSpecAttribute.only(height: 200.0);
        
        final variantAttr1 = VariantSpecAttribute(variant, style1);
        final variantAttr2 = VariantSpecAttribute(variant, style2);

        final merged = variantAttr1.merge(variantAttr2);

        expect(merged.variant, variant);
        final mergedBox = merged.value as BoxSpecAttribute;
        expect(mergedBox.$width, expectPropResolves(100.0));
        expect(mergedBox.$height, expectPropResolves(200.0));
      });

      test('returns this when variants do not match', () {
        const variant1 = NamedVariant('primary');
        const variant2 = NamedVariant('secondary');
        final style1 = BoxSpecAttribute.only(width: 100.0);
        final style2 = BoxSpecAttribute.only(height: 200.0);
        
        final variantAttr1 = VariantSpecAttribute(variant1, style1);
        final variantAttr2 = VariantSpecAttribute(variant2, style2);

        final merged = variantAttr1.merge(variantAttr2);

        expect(merged, same(variantAttr1));
        final mergedBox = merged.value as BoxSpecAttribute;
        expect(mergedBox.$width, expectPropResolves(100.0));
        expect(mergedBox.$height, isNull);
      });

      test('returns this when other is null', () {
        const variant = NamedVariant('primary');
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(variant, style);

        final merged = variantAttr.merge(null);

        expect(merged, same(variantAttr));
      });

      test('merges with overlapping properties - other takes precedence', () {
        const variant = NamedVariant('primary');
        final style1 = BoxSpecAttribute.only(width: 100.0, height: 150.0);
        final style2 = BoxSpecAttribute.only(width: 200.0);
        
        final variantAttr1 = VariantSpecAttribute(variant, style1);
        final variantAttr2 = VariantSpecAttribute(variant, style2);

        final merged = variantAttr1.merge(variantAttr2);

        expect(merged.variant, variant);
        final mergedBox = merged.value as BoxSpecAttribute;
        expect(mergedBox.$width, expectPropResolves(200.0)); // other overrides
        expect(mergedBox.$height, expectPropResolves(150.0)); // from first
      });
    });

    group('Equality', () {
      test('equal VariantSpecAttributes have same hashCode', () {
        const variant = NamedVariant('primary');
        final style = BoxSpecAttribute.only(width: 100.0);
        
        final variantAttr1 = VariantSpecAttribute(variant, style);
        final variantAttr2 = VariantSpecAttribute(variant, style);

        expect(variantAttr1, equals(variantAttr2));
        expect(variantAttr1.hashCode, equals(variantAttr2.hashCode));
      });

      test('different variants are not equal', () {
        const variant1 = NamedVariant('primary');
        const variant2 = NamedVariant('secondary');
        final style = BoxSpecAttribute.only(width: 100.0);
        
        final variantAttr1 = VariantSpecAttribute(variant1, style);
        final variantAttr2 = VariantSpecAttribute(variant2, style);

        expect(variantAttr1, isNot(equals(variantAttr2)));
      });

      test('different styles are not equal', () {
        const variant = NamedVariant('primary');
        final style1 = BoxSpecAttribute.only(width: 100.0);
        final style2 = BoxSpecAttribute.only(width: 200.0);
        
        final variantAttr1 = VariantSpecAttribute(variant, style1);
        final variantAttr2 = VariantSpecAttribute(variant, style2);

        expect(variantAttr1, isNot(equals(variantAttr2)));
      });

      test('identical instances are equal', () {
        const variant = NamedVariant('primary');
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(variant, style);

        expect(variantAttr, equals(variantAttr));
        expect(identical(variantAttr, variantAttr), isTrue);
      });
    });

    group('mergeKey property', () {
      test('uses variant key as merge key', () {
        const variant = NamedVariant('primary');
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(variant, style);

        expect(variantAttr.mergeKey, 'primary');
      });

      test('uses ContextVariant key as merge key', () {
        final variant = ContextVariant.widgetState(WidgetState.hovered);
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(variant, style);

        expect(variantAttr.mergeKey, 'widget_state_hovered');
      });

      test('uses MultiVariant key as merge key', () {
        final variant = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(variant, style);

        expect(variantAttr.mergeKey, isA<String>());
        expect(variantAttr.mergeKey, contains('MultiVariant'));
      });
    });

    group('Different SpecAttribute Types', () {
      test('works with TextSpecAttribute', () {
        const variant = NamedVariant('large');
        final textStyle = TextSpecAttribute.only(
          textAlign: TextAlign.center,
          maxLines: 2,
        );
        final variantAttr = VariantSpecAttribute(variant, textStyle);

        expect(variantAttr.variant, variant);
        expect(variantAttr.value, textStyle);
        final textAttr = variantAttr.value as TextSpecAttribute;
        expect(textAttr.$textAlign, expectPropResolves(TextAlign.center));
        expect(textAttr.$maxLines, expectPropResolves(2));
      });

      test('works with ImageSpecAttribute', () {
        const variant = NamedVariant('avatar');
        final imageStyle = ImageSpecAttribute.only(
          width: 50.0,
          height: 50.0,
          fit: BoxFit.cover,
        );
        final variantAttr = VariantSpecAttribute(variant, imageStyle);

        expect(variantAttr.variant, variant);
        expect(variantAttr.value, imageStyle);
        final imageAttr = variantAttr.value as ImageSpecAttribute;
        expect(imageAttr.$width, expectPropResolves(50.0));
        expect(imageAttr.$height, expectPropResolves(50.0));
        expect(imageAttr.$fit, expectPropResolves(BoxFit.cover));
      });
    });

    group('Complex Scenarios', () {
      test('nested MultiVariant operations', () {
        final variant1 = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);
        
        final variant2 = MultiVariant.or([
          variant1,
          const NamedVariant('secondary'),
        ]);
        
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(variant2, style);

        expect(variantAttr.variant, variant2);
        expect(variantAttr.value, style);
      });

      test('removing variants from complex nested structure', () {
        final innerAnd = MultiVariant.and(const [
          NamedVariant('primary'),
          NamedVariant('large'),
        ]);
        
        final outerOr = MultiVariant.or([
          innerAnd,
          const NamedVariant('secondary'),
        ]);
        
        final style = BoxSpecAttribute.only(width: 100.0);
        final variantAttr = VariantSpecAttribute(outerOr, style);

        const variantsToRemove = [NamedVariant('primary')];
        final result = variantAttr.removeVariants(variantsToRemove);

        expect(result, isNotNull);
        // The nested structure should be handled appropriately
        expect(result!.variant, isA<MultiVariant>());
      });
    });
  });
}