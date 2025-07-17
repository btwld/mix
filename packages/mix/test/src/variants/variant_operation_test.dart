import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

const _foo = NamedVariant('foo');
const _bar = NamedVariant('bar');
const _fooBar = NamedVariant('fooBar');

void main() {
  group('VariantOperation', () {
    test('should add variant with & operator', () {
      const variant = NamedVariant('test');
      const otherVariant = NamedVariant('other');
      final result = otherVariant & variant;
      expect(result.variants, contains(variant));
      expect(result.variants, contains(otherVariant));
    });

    test('should add variant with | operator', () {
      const variant = NamedVariant('test');
      const otherVariant = NamedVariant('other');
      final result = otherVariant | variant;
      expect(result.variants, contains(variant));
      expect(result.variants, contains(otherVariant));
    });
  });

  group('Operator `or`', () {
    testWidgets('should set the same icon color for 2 different variants', (
      WidgetTester tester,
    ) async {
      final style = Style((_foo | _bar)($icon.color.black()));

      await tester.pumpMaterialApp(
        Row(
          children: [
            _buildDefaultTestCase(style, [_foo]),
            _buildDefaultTestCase(style, [_bar]),
            _buildDefaultTestCase(style, [_foo, _bar]),
            _buildDefaultTestCase(style, [_foo, _fooBar]),
            _buildDefaultTestCase(style, [_bar, _fooBar]),
            _buildTestCaseToVerifyIfNull(style, [_fooBar]),
          ],
        ),
      );
    });

    testWidgets('should set the same icon color for 3 different variants', (
      WidgetTester tester,
    ) async {
      final style = Style((_foo | _bar | _fooBar)($icon.color.black()));

      await tester.pumpMaterialApp(
        Row(
          children: [
            _buildDefaultTestCase(style, [_foo]),
            _buildDefaultTestCase(style, [_bar]),
            _buildDefaultTestCase(style, [_fooBar]),
            _buildDefaultTestCase(style, [_foo, _bar]),
            _buildDefaultTestCase(style, [_foo, _fooBar]),
            _buildDefaultTestCase(style, [_bar, _fooBar]),
            _buildDefaultTestCase(style, [_bar, _foo, _fooBar]),
          ],
        ),
      );
    });
  });

  group('Operator `and`', () {
    testWidgets(
      'should set the icon color when 2 different variants are needed',
      (WidgetTester tester) async {
        final style = Style((_foo & _bar)($icon.color.black()));

        await tester.pumpMaterialApp(
          Row(
            children: [
              _buildDefaultTestCase(style, [_foo, _bar]),
              _buildTestCaseToVerifyIfNull(style, [_fooBar]),
              _buildTestCaseToVerifyIfNull(style, [_foo, _fooBar]),
              _buildTestCaseToVerifyIfNull(style, [_bar, _fooBar]),
              _buildDefaultTestCase(style, [_foo, _bar, _fooBar]),
            ],
          ),
        );
      },
    );

    testWidgets(
      'should set the icon color when 3 different variants are needed',
      (WidgetTester tester) async {
        final style = Style((_foo & _bar & _fooBar)($icon.color.black()));

        await tester.pumpMaterialApp(
          Row(
            children: [
              _buildDefaultTestCase(style, [_foo, _bar, _fooBar]),
              _buildTestCaseToVerifyIfNull(style, [_bar]),
              _buildTestCaseToVerifyIfNull(style, [_foo]),
              _buildTestCaseToVerifyIfNull(style, [_fooBar]),
              _buildTestCaseToVerifyIfNull(style, [_bar, _foo]),
              _buildTestCaseToVerifyIfNull(style, [_foo, _fooBar]),
              _buildTestCaseToVerifyIfNull(style, [_bar, _fooBar]),
            ],
          ),
        );
      },
    );
  });

  group('Operators `and` and `or` in the same expression', () {
    testWidgets(
      'should follow the order of operations and set the icon color when all conditions are met, case with | first',
      (WidgetTester tester) async {
        final style = Style(((_foo | _bar) & _fooBar)($icon.color.black()));

        await tester.pumpMaterialApp(
          Row(
            children: [
              // _buildDefaultTestCase(style, [_foo, _fooBar]),
              // _buildDefaultTestCase(style, [_bar, _fooBar]),
              // _buildDefaultTestCase(style, [_foo, _bar, _fooBar]),
              // _buildTestCaseToVerifyIfNull(style, [_foo]),
              // _buildTestCaseToVerifyIfNull(style, [_bar]),
              _buildTestCaseToVerifyIfNull(style, [_fooBar]),
            ],
          ),
        );
      },
    );

    testWidgets(
      'should follow the order of operations and set the icon color when all conditions are met, case with & first',
      (WidgetTester tester) async {
        final style = Style((_foo & _bar | _fooBar)($icon.color.black()));

        await tester.pumpMaterialApp(
          Row(
            children: [
              _buildDefaultTestCase(style, [_foo, _bar, _fooBar]),
              _buildDefaultTestCase(style, [_foo, _bar]),
              _buildDefaultTestCase(style, [_foo, _fooBar]),
              _buildDefaultTestCase(style, [_bar, _fooBar]),
              _buildDefaultTestCase(style, [_fooBar]),
              _buildTestCaseToVerifyIfNull(style, [_foo]),
              _buildTestCaseToVerifyIfNull(style, [_bar]),
            ],
          ),
        );
      },
    );
  });
}

Widget _buildDefaultTestCase(Style style, List<Variant> variants) {
  return Builder(
    builder: (context) {
      final mixData = MixContext.create(context, style.applyVariants(variants));
      final icon = IconSpec.from(mixData);

      expect(icon.color, Colors.black);

      return const SizedBox();
    },
  );
}

Widget _buildTestCaseToVerifyIfNull(Style style, List<Variant> variants) {
  return Builder(
    builder: (context) {
      final mixData = MixContext.create(context, style.applyVariants(variants));
      final icon = IconSpec.from(mixData);

      expect(icon.color, null, reason: '$variants');

      return const SizedBox();
    },
  );
}
