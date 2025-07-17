import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('VariantPriority', () {
    test('enum values have correct numeric values', () {
      expect(VariantPriority.normal.value, 0);
      expect(VariantPriority.high.value, 1);
    });

    test('NamedVariant has normal priority through VariantAttribute', () {
      const variant = NamedVariant('test');
      const attribute = VariantAttribute(variant, MockIntScalarAttribute(1));

    });

    test('ContextVariant has normal priority by default', () {
      final variant = MockContextVariant();
      final attribute = VariantAttribute(variant, MockIntScalarAttribute(1));

    });

    test('WidgetStateVariant has normal priority', () {
      final variant = ContextVariant.widgetState(WidgetState.hovered);
      final attribute = VariantAttribute(variant, MockIntScalarAttribute(1));

    });

    test('Custom high priority ContextVariant has high priority', () {
      final variant = MockHighPriorityContextVariant();
      final attribute = VariantAttribute(variant, MockIntScalarAttribute(1));

    });

    test('MultiVariant gets high priority if any variant has high priority', () {
      final highPriorityVariant = MockHighPriorityContextVariant();
      const normalVariant = NamedVariant('normal');
      final multiVariant = MultiVariant.and([normalVariant, highPriorityVariant]);
      final attribute = VariantAttribute(multiVariant, MockIntScalarAttribute(1));

    });

    test('MultiVariant gets normal priority if all variants have normal priority', () {
      const variant1 = NamedVariant('variant1');
      final variant2 = MockContextVariant();
      final multiVariant = MultiVariant.and([variant1, variant2]);
      final attribute = VariantAttribute(multiVariant, MockIntScalarAttribute(1));

    });

    test('MultiVariant priority works with OR operation', () {
      final highPriorityVariant = MockHighPriorityContextVariant();
      const normalVariant = NamedVariant('normal');
      final multiVariant = MultiVariant.or([normalVariant, highPriorityVariant]);
      final attribute = VariantAttribute(multiVariant, MockIntScalarAttribute(1));

    });

    test('VariantPriority comparison works correctly', () {
      expect(VariantPriority.normal.value < VariantPriority.high.value, isTrue);
      expect(VariantPriority.high.value > VariantPriority.normal.value, isTrue);
    });
  });
}