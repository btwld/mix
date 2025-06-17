import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  // StyleVariantAttribute
  group('VariantAttribute', () {
    const variant = Variant('custom_variant');
    final style = Style(const MockIntScalarAttribute(8));
    test('Constructor assigns correct properties', () {
      final variantAttribute = VariantAttribute(variant, style);

      expect(variantAttribute.variant, variant);
      expect(variantAttribute.value, style);
    });

    // mergeKey
    test('mergeKey returns correct instance', () {
      final variantAttribute = VariantAttribute(variant, style);

      expect(variantAttribute.mergeKey, variant.mergeKey);
    });

    // merge()
    test('merge() returns correct instance', () {
      final variantAttribute = VariantAttribute(variant, style);

      final otherStyle = Style(const MockIntScalarAttribute(10));
      final otherAttribute = VariantAttribute(variant, otherStyle);

      final result = variantAttribute.merge(otherAttribute);

      expect(result, isA<VariantAttribute>());
      expect(result.variant, variant);
      expect(result.value, style.merge(otherStyle));
    });
  });

  // StyleVariantAttribute
  group('StyleVariantAttribute', () {
    const variant = MockContextVariantCondition(
      true,
      priority: VariantPriority.high,
    );

    final style = Style(const MockIntScalarAttribute(8));
    test('Constructor assigns correct properties', () {
      final variantAttribute = VariantAttribute(variant, style);

      expect(variantAttribute.variant, variant);
      expect(variantAttribute.value, style);
    });

    // mergeKey
    test('mergeKey returns correct instance', () {
      final variantAttribute = VariantAttribute(variant, style);

      expect(variantAttribute.mergeKey, variant.mergeKey);
    });

    // merge()
    test('merge() returns correct instance', () {
      final variantAttribute = VariantAttribute(variant, style);

      final otherStyle = Style(const MockIntScalarAttribute(10));
      final otherAttribute = VariantAttribute(variant, otherStyle);

      final result = variantAttribute.merge(otherAttribute);

      expect(result, isA<VariantAttribute>());
      expect(result.variant, variant);
      expect(result.value, style.merge(otherStyle));
    });

    // when()
    test('when() returns correct instance', () {
      final variantAttribute = VariantAttribute(variant, style);

      final result = variantAttribute.variant.when(MockBuildContext());

      expect(result, isTrue);
    });
  });

  group('StyleVariantAttribute', () {
    const variant = Variant('custom_variant');
    final style = Style(const MockIntScalarAttribute(8));

    test('matches() returns true when variant matches', () {
      final variantAttribute = VariantAttribute(variant, style);

      expect(variantAttribute.matches([variant]), isTrue);
    });

    test('matches() returns false when variant does not match', () {
      final variantAttribute = VariantAttribute(variant, style);
      const otherVariant = Variant('other_variant');

      expect(variantAttribute.matches([otherVariant]), isFalse);
    });
  });

// MultiVariantAttribute
  group('MultiVariantAttribute', () {
    const variant1 = Variant('variant1');
    const variant2 = Variant('variant2');
    final multiVariant = MultiVariant(
      const [variant1, variant2],
      type: MultiVariantOperator.or,
    );
    final style = Style(const MockIntScalarAttribute(8));

    test('remove() returns correct instance when removing a variant', () {
      final multiVariantAttribute = VariantAttribute(multiVariant, style);

      final result = multiVariantAttribute.removeVariants([variant1]);

      expect(result, isA<VariantAttribute>());
      expect(result?.variant, variant2);
      expect(result?.value, style);
    });

    test('remove() returns correct instance when removing all variants', () {
      final multiVariant = MultiVariant.or(const [variant1, variant2]);
      final multiVariantAttribute = multiVariant(style);

      final attribute =
          multiVariantAttribute.removeVariants([variant1, variant2]);

      expect(
        attribute,
        isNull,
      );
    });

    test('merge() returns correct instance', () {
      final multiVariantAttribute = VariantAttribute(multiVariant, style);

      final otherStyle = Style(const MockIntScalarAttribute(10));
      final otherAttribute = VariantAttribute(multiVariant, otherStyle);

      final result = multiVariantAttribute.merge(otherAttribute);

      expect(result, isA<VariantAttribute>());
      expect(result.variant, multiVariant);
      expect(result.value, style.merge(otherStyle));
    });
  });
}

// StyleVariantAttribute
