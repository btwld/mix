import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('ContextVariantBuilder', () {
    test('merge should return the same object if other is null', () {
      const variant = _MockContextVariant();
      fn(BuildContext context) => Style();
      final builder = ContextVariantBuilder(fn, variant);

      final mergedBuilder = builder.merge(null);

      expect(mergedBuilder, same(builder));
    });

    test('merge should throw ArgumentError if variant is not the same', () {
      const variant1 = _MockContextVariant();
      const variant2 = _MockContextVariant2();
      fn1(BuildContext context) => Style();
      fn2(BuildContext context) => Style();
      final builder1 = ContextVariantBuilder(fn1, variant1);
      final builder2 = ContextVariantBuilder(fn2, variant2);

      expect(() => builder1.merge(builder2), throwsArgumentError);
    });

    test(
        'merge should return a new ContextVariantBuilder with merged functions',
        () {
      const variant = _MockContextVariant();
      fn1(BuildContext context) => Style(const MockIntScalarAttribute(1));
      fn2(BuildContext context) => Style(const MockDoubleScalarAttribute(2.0));
      final builder1 = ContextVariantBuilder(fn1, variant);
      final builder2 = ContextVariantBuilder(fn2, variant);

      final mergedBuilder = builder1.merge(builder2);

      expect(mergedBuilder, isNot(same(builder1)));
      expect(mergedBuilder, isNot(same(builder2)));
      expect(mergedBuilder.variant, equals(variant));
      expect(
          mergedBuilder.fn(MockBuildContext()),
          equals(Style(const MockIntScalarAttribute(1),
              const MockDoubleScalarAttribute(2.0))));
    });

    test(
        'mergeKey should return a string containing runtimeType and variant mergeKey',
        () {
      const variant = _MockContextVariant();
      fn(BuildContext context) => Style();
      final builder = ContextVariantBuilder(fn, variant);

      final mergeKey = builder.mergeKey;

      expect(mergeKey, equals('ContextVariantBuilder.${variant.mergeKey}'));
    });

    test('props should return a list containing the variant', () {
      const variant = _MockContextVariant();
      fn(BuildContext context) => Style();
      final builder = ContextVariantBuilder(fn, variant);

      final props = builder.props;

      expect(props, isList);
      expect(props, contains(variant));
    });

    test('build should return a Style with the result of fn', () {
      const variant = _MockContextVariant();
      final style = Style(const MockIntScalarAttribute(1));
      fn(BuildContext context) => style;
      final builder = ContextVariantBuilder(fn, variant);

      final builtStyle = builder.build(MockBuildContext());

      expect(builtStyle, isA<Style>());
      expect(builtStyle, equals(style));
    });
  });
}

class _MockContextVariant extends ContextVariant {
  const _MockContextVariant();

  @override
  final priority = VariantPriority.normal;

  @override
  Object get mergeKey => 'MockContextVariant';

  @override
  bool when(BuildContext context) => true;
}

class _MockContextVariant2 extends ContextVariant {
  const _MockContextVariant2();

  @override
  final priority = VariantPriority.normal;

  @override
  Object get mergeKey => 'MockContextVariant2';

  @override
  bool when(BuildContext context) => true;
}
