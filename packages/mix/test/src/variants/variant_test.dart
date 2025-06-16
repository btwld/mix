import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Variant', () {
    testWidgets(
      'should set attributes when variant matches, otherwise null',
      (WidgetTester tester) async {
        final style = Style(
          $icon.color.black(),
          _foo($box.height(10), $box.width(10)),
        );

        await tester.pumpMaterialApp(
          Row(
            children: [
              _buildDefaultTestCase(style, [_foo]),
              _buildTestCaseToVerifyIfNull(style, [_bar]),
            ],
          ),
        );
      },
    );
  });

  group('MultiVariant', () {
    test('remove should remove the correct variants', () {
      const variant1 = Variant('variant1');
      const variant2 = Variant('variant2');
      const variant3 = Variant('variant3');
      final multiVariant =
          MultiVariant.and(const [variant1, variant2, variant3]);

      final result = multiVariant.remove([variant1, variant2]);

      expect(result, isA<Variant>());
      expect((result as Variant).name, variant3.name);
    });

    test('matches should correctly match variants', () {
      const variant1 = Variant('variant1');
      const variant2 = Variant('variant2');
      const variant3 = Variant('variant3');
      final multiAndVariant = MultiVariant.and(const [variant1, variant2]);

      final multiOrVariant = MultiVariant.or(const [variant1, variant2]);

      expect(multiAndVariant.matches([variant1, variant2, variant3]), isTrue);
      expect(multiAndVariant.matches([variant1]), isFalse);
      expect(multiOrVariant.matches([variant1, variant2, variant3]), isTrue);
      expect(multiOrVariant.matches([variant1]), isTrue);
    });

    test('when should correctly match context variants', () {
      const variant1 = MockContextVariantCondition(true);
      const variant2 = MockContextVariantCondition(false);
      final multiAndVariant = MultiVariant.and(const [variant1, variant2]);
      final multiOrVariant = MultiVariant.or(const [variant1, variant2]);

      expect(multiAndVariant.when(MockBuildContext()), isFalse);
      expect(multiOrVariant.when(MockBuildContext()), isTrue);
    });

    test('MultiVariant.and should correctly create a MultiVariant', () {
      const variant1 = Variant('variant1');
      const variant2 = Variant('variant2');
      final multiVariant = MultiVariant.and(const [variant1, variant2]);

      expect(multiVariant.variants, containsAll([variant1, variant2]));
      expect(multiVariant.operatorType, MultiVariantOperator.and);
    });

    test('MultiVariant.or should correctly create a MultiVariant', () {
      const variant1 = Variant('variant1');
      const variant2 = Variant('variant2');
      final multiVariant = MultiVariant.or(const [variant1, variant2]);

      expect(multiVariant.variants, containsAll([variant1, variant2]));
      expect(multiVariant.operatorType, MultiVariantOperator.or);
    });

    group('when', () {
      test(
          'MultiVariant.or with 2 PressableStateVariant (false & false) should return true',
          () {
        const variant1 = MockContextVariantCondition(false);
        const variant2 = MockContextVariantCondition(false);
        final multiVariant = MultiVariant.or(const [variant1, variant2]);

        final expectValue = multiVariant.when(MockBuildContext());

        expect(expectValue, isFalse);
        expect(multiVariant.operatorType, MultiVariantOperator.or);
      });

      test(
          'MultiVariant.or with 2 PressableStateVariant (false & true) should return true',
          () {
        const variant1 = MockContextVariantCondition(false);
        const variant2 = MockContextVariantCondition(true);
        final multiVariant = MultiVariant.or(const [variant1, variant2]);

        final expectValue = multiVariant.when(MockBuildContext());

        expect(expectValue, isTrue);
        expect(multiVariant.operatorType, MultiVariantOperator.or);
      });

      test(
          'MultiVariant.or with 2 PressableStateVariant (true & true) should return true',
          () {
        const variant1 = MockContextVariantCondition(true);
        const variant2 = MockContextVariantCondition(true);
        final multiVariant = MultiVariant.or(const [variant1, variant2]);

        final expectValue = multiVariant.when(MockBuildContext());

        expect(expectValue, isTrue);
        expect(multiVariant.operatorType, MultiVariantOperator.or);
      });

      test(
          'MultiVariant.and with 2 ContextVariant (false & false) should return false',
          () {
        const variant1 = MockContextVariantCondition(false);
        const variant2 = MockContextVariantCondition(false);
        final multiVariant = MultiVariant.and(const [variant1, variant2]);

        final expectValue = multiVariant.when(MockBuildContext());

        expect(expectValue, isFalse);
        expect(multiVariant.operatorType, MultiVariantOperator.and);
      });

      test(
          'MultiVariant.and with 2 ContextVariant (false & true) should return false',
          () {
        const variant1 = MockContextVariantCondition(false);
        const variant2 = MockContextVariantCondition(true);
        final multiVariant = MultiVariant.and(const [variant1, variant2]);

        final expectValue = multiVariant.when(MockBuildContext());

        expect(expectValue, isFalse);
        expect(multiVariant.operatorType, MultiVariantOperator.and);
      });

      test(
          'MultiVariant.and with 2 ContextVariant (true & true) should return true',
          () {
        const variant1 = MockContextVariantCondition(true);
        const variant2 = MockContextVariantCondition(true);
        final multiVariant = MultiVariant.and(const [variant1, variant2]);

        final expectValue = multiVariant.when(MockBuildContext());

        expect(expectValue, isTrue);
        expect(multiVariant.operatorType, MultiVariantOperator.and);
      });

      test('Mv.or(v1, Mv.or(v2,v3)) with 3 ContextVariant', () {
        void testCase({
          required bool v1,
          required bool v2,
          required bool v3,
          required Matcher expected,
        }) {
          _testWhenWithThreeVariants(
            v1: v1,
            v2: v2,
            v3: v3,
            condition: (v1, v2, v3) {
              return MultiVariant.or([
                v1,
                MultiVariant.or([v2, v3]),
              ]);
            },
            expectedValue: expected,
          );
        }

        testCase(v1: true, v2: true, v3: true, expected: isTrue);
        testCase(v1: true, v2: true, v3: false, expected: isTrue);
        testCase(v1: true, v2: false, v3: true, expected: isTrue);
        testCase(v1: true, v2: false, v3: false, expected: isTrue);
        testCase(v1: false, v2: true, v3: true, expected: isTrue);
        testCase(v1: false, v2: true, v3: false, expected: isTrue);
        testCase(v1: false, v2: false, v3: true, expected: isTrue);
        testCase(v1: false, v2: false, v3: false, expected: isFalse);
      });

      test('Mv.and(v1, Mv.and(v2,v3)) with 3 ContextVariant', () {
        void testCase({
          required bool v1,
          required bool v2,
          required bool v3,
          required Matcher expected,
        }) {
          _testWhenWithThreeVariants(
            v1: v1,
            v2: v2,
            v3: v3,
            condition: (v1, v2, v3) {
              return MultiVariant.and([
                v1,
                MultiVariant.and([v2, v3]),
              ]);
            },
            expectedValue: expected,
          );
        }

        testCase(v1: true, v2: true, v3: true, expected: isTrue);
        testCase(v1: true, v2: true, v3: false, expected: isFalse);
        testCase(v1: true, v2: false, v3: true, expected: isFalse);
        testCase(v1: true, v2: false, v3: false, expected: isFalse);
        testCase(v1: false, v2: true, v3: true, expected: isFalse);
        testCase(v1: false, v2: true, v3: false, expected: isFalse);
        testCase(v1: false, v2: false, v3: true, expected: isFalse);
        testCase(v1: false, v2: false, v3: false, expected: isFalse);
      });

      test('Mv.or(v1, Mv.and(v2,v3)) with 3 ContextVariant', () {
        void testCase({
          required bool v1,
          required bool v2,
          required bool v3,
          required Matcher expected,
        }) {
          _testWhenWithThreeVariants(
            v1: v1,
            v2: v2,
            v3: v3,
            condition: (v1, v2, v3) {
              return MultiVariant.or([
                v1,
                MultiVariant.and([v2, v3]),
              ]);
            },
            expectedValue: expected,
          );
        }

        testCase(v1: true, v2: true, v3: true, expected: isTrue);
        testCase(v1: true, v2: true, v3: false, expected: isTrue);
        testCase(v1: true, v2: false, v3: true, expected: isTrue);
        testCase(v1: true, v2: false, v3: false, expected: isTrue);
        testCase(v1: false, v2: true, v3: true, expected: isTrue);
        testCase(v1: false, v2: true, v3: false, expected: isFalse);
        testCase(v1: false, v2: false, v3: true, expected: isFalse);
        testCase(v1: false, v2: false, v3: false, expected: isFalse);
      });

      test('Mv.and(v1, Mv.or(v2,v3)) with 3 ContextVariant', () {
        void testCase({
          required bool v1,
          required bool v2,
          required bool v3,
          required Matcher expected,
        }) {
          _testWhenWithThreeVariants(
            v1: v1,
            v2: v2,
            v3: v3,
            condition: (v1, v2, v3) {
              return MultiVariant.and([
                v1,
                MultiVariant.or([v2, v3]),
              ]);
            },
            expectedValue: expected,
          );
        }

        testCase(v1: true, v2: true, v3: true, expected: isTrue);
        testCase(v1: true, v2: true, v3: false, expected: isTrue);
        testCase(v1: true, v2: false, v3: true, expected: isTrue);
        testCase(v1: true, v2: false, v3: false, expected: isFalse);
        testCase(v1: false, v2: true, v3: true, expected: isFalse);
        testCase(v1: false, v2: true, v3: false, expected: isFalse);
        testCase(v1: false, v2: false, v3: true, expected: isFalse);
        testCase(v1: false, v2: false, v3: false, expected: isFalse);
      });
    });

    test('mergeKey should correctly represent the MultiVariant', () {
      const variant1 = Variant('variant1');
      const variant2 = Variant('variant2');
      final multiAndVariant = MultiVariant.and(const [variant1, variant2]);
      final multiOrVariant = MultiVariant.or(const [variant1, variant2]);

      expect(multiAndVariant.mergeKey.toString(),
          contains('MultiVariant.MultiVariantOperator.and'));
      expect(multiAndVariant.mergeKey.toString(), contains('variant1'));
      expect(multiAndVariant.mergeKey.toString(), contains('variant2'));

      expect(multiOrVariant.mergeKey.toString(),
          contains('MultiVariant.MultiVariantOperator.or'));
      expect(multiOrVariant.mergeKey.toString(), contains('variant1'));
      expect(multiOrVariant.mergeKey.toString(), contains('variant2'));
    });

    test('priority should return the highest priority of context variants', () {
      const variant1 = MockContextVariant(VariantPriority.low);
      const variant2 = MockContextVariant(VariantPriority.high);
      const variant3 = MockContextVariant(VariantPriority.normal);
      final multiVariant =
          MultiVariant.and(const [variant1, variant2, variant3]);

      expect(multiVariant.priority, VariantPriority.high);
    });

    test(
        'priority should return normal priority if no context variants are present',
        () {
      const variant1 = Variant('variant1');
      const variant2 = Variant('variant2');
      final multiVariant = MultiVariant.and(const [variant1, variant2]);

      expect(multiVariant.priority, VariantPriority.normal);
    });
  });
}

typedef _ConditionBuilder = MultiVariant Function(
  IVariant v1,
  IVariant v2,
  IVariant v3,
);

void _testWhenWithThreeVariants({
  required bool v1,
  required bool v2,
  required bool v3,
  required _ConditionBuilder condition,
  required Matcher expectedValue,
}) {
  final variant1 = MockContextVariantCondition(v1);
  final variant2 = MockContextVariantCondition(v2);
  final variant3 = MockContextVariantCondition(v3);

  final multiVariant = condition(variant1, variant2, variant3);

  final expectValue = multiVariant.when(MockBuildContext());

  expect(expectValue, expectedValue);
}

Widget _buildDefaultTestCase(Style style, List<Variant> variants) {
  return Builder(
    builder: (context) {
      final mixData = MixContext.create(context, style.applyVariants(variants));

      final box = BoxSpec.from(mixData);
      final icon = IconSpec.from(mixData);

      expect(box.height, 10);
      expect(box.width, 10);
      expect(icon.color, Colors.black);

      return const SizedBox();
    },
  );
}

Widget _buildTestCaseToVerifyIfNull(Style style, List<Variant> variants) {
  return Builder(
    builder: (context) {
      final mixData = MixContext.create(context, style.applyVariants(variants));

      final box = BoxSpec.from(mixData);
      final icon = IconSpec.from(mixData);

      expect(box.height, null);
      expect(box.width, null);
      expect(icon.color, Colors.black);

      return const SizedBox();
    },
  );
}

const _foo = Variant('foo');
const _bar = Variant('bar');
