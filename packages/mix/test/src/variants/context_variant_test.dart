import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('ContextVariant', () {
    test(
        'call method should return a VariantAttribute with provided attributes',
        () {
      const variant = _MockContextVariant();
      const attribute1 = MockDoubleScalarAttribute(1.0);
      const attribute2 = MockIntScalarAttribute(2);

      final result = variant(attribute1, attribute2);

      expect(result, isA<VariantAttribute>());
      expect(result.variant, equals(variant));
      expect(result.value.styles.length, equals(2));
      expect(result.value.styles.containsType(attribute1), isTrue);
      expect(result.value.styles.containsType(attribute2), isTrue);
    });

    test('call method should ignore null attributes', () {
      const variant = _MockContextVariant();
      const attribute1 = MockDoubleScalarAttribute(1.0);

      final result = variant(attribute1, null);

      expect(result.value.styles.length, equals(1));
      expect(result.value.styles.containsType(attribute1), isTrue);
    });

    test('priority should return VariantPriority.normal by default', () {
      const variant = _MockContextVariant();

      expect(variant.priority, equals(VariantPriority.normal));
    });

    test('mergeKey should return the runtime type as a string', () {
      const variant = _MockContextVariant();

      expect(variant.mergeKey, equals('_MockContextVariant'));
    });

    test('props should return a list containing the priority', () {
      const variant = _MockContextVariant();

      expect(variant.props, equals([VariantPriority.normal]));
    });
  });

  group('WidgetContextVariant', () {
    test('priority should return VariantPriority.highest', () {
      const variant = _MockWidgetContextVariant<int>(5);

      expect(variant.priority, equals(VariantPriority.highest));
    });

    test('event method should return a ContextVariantBuilder', () {
      const variant = _MockWidgetContextVariant<int>(4);
      final style = Style();

      final result = variant.event((_) => style);

      expect(result, isA<ContextVariantBuilder>());
      expect(result.variant, equals(variant));
      expect(result.fn(MockBuildContext()), equals(style));
    });
  });

  group('MediaQueryContextVariant', () {
    test('priority should return VariantPriority.normal', () {
      const variant = MockMediaQueryContextVariant();

      expect(variant.priority, equals(VariantPriority.normal));
    });
  });

  group('ContextVariantBuilder', () {
    test(
        'merge method should return a new ContextVariantBuilder with merged functions',
        () {
      const variant = _MockContextVariant();
      final style1 = Style();
      final style2 = Style();
      final builder1 = ContextVariantBuilder((_) => style1, variant);
      final builder2 = ContextVariantBuilder((_) => style2, variant);

      final result = builder1.merge(builder2);

      expect(result, isA<ContextVariantBuilder>());
      expect(result.variant, equals(variant));
      expect(result.fn(MockBuildContext()), equals(style1.merge(style2)));
    });

    test('props should return a list containing the variant', () {
      const variant = _MockContextVariant();
      final builder = ContextVariantBuilder((_) => Style(), variant);

      expect(builder.props, equals([variant]));
    });

    test('build method should return a Style with the result of the function',
        () {
      const variant = _MockContextVariant();
      final style = Style();
      final builder = ContextVariantBuilder((_) => style, variant);

      final result = builder.build(MockBuildContext());

      expect(result, isA<Style>());
      expect(result, equals(style));
    });
  });
}

class _MockContextVariant extends ContextVariant {
  const _MockContextVariant();

  @override
  bool when(BuildContext context) => true;
}

class _MockWidgetContextVariant<T> extends MixWidgetStateVariant<T> {
  final T value;
  const _MockWidgetContextVariant(this.value);

  @override
  bool when(BuildContext context) => true;

  @override
  T builder(BuildContext context) => value;
}

class MockMediaQueryContextVariant extends MediaQueryContextVariant {
  const MockMediaQueryContextVariant();

  @override
  bool when(BuildContext context) => true;
}
