import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Variant', () {
    testWidgets('should set attributes when variant matches, otherwise null',
        (WidgetTester tester) async {
      final style = Style(
        icon.color.black(),
        _foo(
          box.height(10),
          box.width(10),
        ),
      );

      await tester.pumpMaterialApp(
        Row(
          children: [
            _buildDefaultTestCase(style, [_foo]),
            _buildTestCaseToVerifyIfNull(style, [_bar]),
          ],
        ),
      );
    });
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
      expect((result).name, variant3.name);
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
      final variant1 = ContextVariant('variant1', (context) => true);
      final variant2 = ContextVariant('variant2', (context) => false);
      final multiAndVariant = MultiVariant.and([variant1, variant2]);
      final multiOrVariant = MultiVariant.or([variant1, variant2]);

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
  });
}

Widget _buildDefaultTestCase(Style style, List<Variant> variants) {
  return Builder(
    builder: (context) {
      final mixData = MixData.create(context, style.variantList(variants));

      final box = BoxSpec.of(mixData);
      final icon = IconSpec.of(mixData);

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
      final mixData = MixData.create(context, style.variantList(variants));

      final box = BoxSpec.of(mixData);
      final icon = IconSpec.of(mixData);

      expect(box.height, null);
      expect(box.width, null);
      expect(icon.color, Colors.black);

      return const SizedBox();
    },
  );
}

const _foo = Variant('foo');
const _bar = Variant('bar');
