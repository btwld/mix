import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('VariantAttribute', () {
    const variant = NamedVariant('custom_variant');
    const style = MockIntScalarAttribute(8);

    test('Constructor assigns correct properties', () {
      const variantAttribute = VariantSpecAttribute(variant, style);

      expect(variantAttribute.variant, variant);
      expect(variantAttribute.value, style);
    });

    test('mergeKey returns variant key', () {
      const variantAttribute = VariantSpecAttribute(variant, style);

      expect(variantAttribute.mergeKey, variant.key);
    });

    test('merge() returns correct instance', () {
      const variantAttribute = VariantSpecAttribute(variant, style);

      const otherStyle = MockIntScalarAttribute(10);
      const otherAttribute = VariantSpecAttribute(variant, otherStyle);

      final result = variantAttribute.merge(otherAttribute);

      expect(result, isA<VariantSpecAttribute>());
      expect(result.variant, variant);
      expect(result.value, style.merge(otherStyle));
    });

    test('merge() throws ArgumentError when variants differ', () {
      const variantAttribute = VariantSpecAttribute(variant, style);
      const otherVariant = NamedVariant('other_variant');
      const otherAttribute = VariantSpecAttribute(otherVariant, style);

      expect(() => variantAttribute.merge(otherAttribute), throwsArgumentError);
    });

    test('matches() returns true when variant matches', () {
      const variantAttribute = VariantSpecAttribute(variant, style);

      expect(variantAttribute.matches([variant]), isTrue);
    });

    test('matches() returns false when variant does not match', () {
      const variantAttribute = VariantSpecAttribute(variant, style);
      const otherVariant = NamedVariant('other_variant');

      expect(variantAttribute.matches([otherVariant]), isFalse);
    });

    test('removeVariants() returns null when variant is removed', () {
      const variantAttribute = VariantSpecAttribute(variant, style);

      final result = variantAttribute.removeVariants([variant]);

      expect(result, isNull);
    });

    test('removeVariants() returns self when variant is not removed', () {
      const variantAttribute = VariantSpecAttribute(variant, style);
      const otherVariant = NamedVariant('other_variant');

      final result = variantAttribute.removeVariants([otherVariant]);

      expect(result, variantAttribute);
    });

    test('removeVariants() handles MultiVariant correctly', () {
      const variant1 = NamedVariant('variant1');
      const variant2 = NamedVariant('variant2');
      final multiVariant = MultiVariant.and(const [variant1, variant2]);
      final variantAttribute = VariantSpecAttribute(multiVariant, style);

      // Remove one variant - should return new VariantAttribute with remaining variant
      final result = variantAttribute.removeVariants([variant1]);

      expect(result, isNotNull);
      expect(result!.variant, variant2);
      expect(result.value, style);
    });

    test(
      'removeVariants() returns null when all variants in MultiVariant are removed',
      () {
        const variant1 = NamedVariant('variant1');
        const variant2 = NamedVariant('variant2');
        final multiVariant = MultiVariant.and(const [variant1, variant2]);
        final variantAttribute = VariantSpecAttribute(multiVariant, style);

        final result = variantAttribute.removeVariants([variant1, variant2]);

        expect(result, isNull);
      },
    );

    test('priority returns normal for NamedVariant', () {
      const variantAttribute = VariantSpecAttribute(variant, style);
    });

    test('priority returns normal for ContextVariant', () {
      final contextVariant = MockContextVariant();
      final variantAttribute = VariantSpecAttribute(contextVariant, style);
    });

    test('priority returns high for WidgetStateVariant', () {
      final widgetStateVariant = ContextVariant.widgetState(
        WidgetState.hovered,
      );
      final variantAttribute = VariantSpecAttribute(widgetStateVariant, style);
    });

    test('priority returns high for custom high priority ContextVariant', () {
      final highPriorityVariant = MockHighPriorityContextVariant();
      final variantAttribute = VariantSpecAttribute(highPriorityVariant, style);
    });

    test(
      'priority returns high for MultiVariant with high priority variant',
      () {
        final highPriorityVariant = MockHighPriorityContextVariant();
        const normalVariant = NamedVariant('normal');
        final multiVariant = MultiVariant.and([
          normalVariant,
          highPriorityVariant,
        ]);
        final variantAttribute = VariantSpecAttribute(multiVariant, style);
      },
    );

    test(
      'priority returns normal for MultiVariant with only normal priority variants',
      () {
        const variant1 = NamedVariant('variant1');
        const variant2 = NamedVariant('variant2');
        final multiVariant = MultiVariant.and(const [variant1, variant2]);
        final variantAttribute = VariantSpecAttribute(multiVariant, style);
      },
    );

    test('props returns correct list of properties', () {
      const variantAttribute = VariantSpecAttribute(variant, style);

      expect(variantAttribute.props, [variant, style]);
    });
  });
}
