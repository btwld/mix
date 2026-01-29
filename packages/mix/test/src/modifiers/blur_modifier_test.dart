import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('BlurModifier', () {
    group('Constructor', () {
      test('assigns default sigma of 0.0', () {
        const modifier = BlurModifier();

        expect(modifier.sigma, 0.0);
      });

      test('assigns sigma correctly', () {
        const sigma = 5.0;
        const modifier = BlurModifier(sigma);

        expect(modifier.sigma, sigma);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated sigma', () {
        const original = BlurModifier(5.0);
        final updated = original.copyWith(sigma: 8.0);

        expect(updated.sigma, 8.0);
        expect(updated, isNot(same(original)));
      });

      test('preserves original sigma when parameter is null', () {
        const original = BlurModifier(5.0);
        final updated = original.copyWith();

        expect(updated.sigma, 5.0);
        expect(updated, isNot(same(original)));
      });
    });

    group('lerp', () {
      test('interpolates sigma correctly', () {
        const start = BlurModifier(0.0);
        const end = BlurModifier(10.0);
        final result = start.lerp(end, 0.5);

        expect(result.sigma, 5.0);
      });

      test('handles null other parameter', () {
        const start = BlurModifier(5.0);
        final result = start.lerp(null, 0.5);

        expect(result, same(start));
      });

      test('handles extreme t values', () {
        const start = BlurModifier(0.0);
        const end = BlurModifier(10.0);

        final result0 = start.lerp(end, 0.0);
        expect(result0.sigma, 0.0);

        final result1 = start.lerp(end, 1.0);
        expect(result1.sigma, 10.0);
      });
    });

    group('equality and hashCode', () {
      test('equal when sigma values match', () {
        const modifier1 = BlurModifier(5.0);
        const modifier2 = BlurModifier(5.0);

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });

      test('not equal when sigma differs', () {
        const modifier1 = BlurModifier(5.0);
        const modifier2 = BlurModifier(8.0);

        expect(modifier1, isNot(equals(modifier2)));
      });
    });

    group('props', () {
      test('contains sigma value', () {
        const modifier = BlurModifier(5.0);

        expect(modifier.props, [5.0]);
      });
    });

    group('build', () {
      testWidgets('returns child unchanged when sigma is 0.0', (
        WidgetTester tester,
      ) async {
        const modifier = BlurModifier(0.0);
        const child = SizedBox(width: 50, height: 50);

        final result = modifier.build(child);

        expect(result, same(child));
      });

      testWidgets('creates ImageFiltered widget when sigma > 0', (
        WidgetTester tester,
      ) async {
        const sigma = 5.0;
        const modifier = BlurModifier(sigma);
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final imageFiltered =
            tester.widget<ImageFiltered>(find.byType(ImageFiltered));
        expect(imageFiltered.child, same(child));

        // Verify the blur is applied (ImageFiltered with blur filter)
        expect(find.byType(ImageFiltered), findsOneWidget);
      });
    });
  });

  group('BlurModifierMix', () {
    group('Constructor', () {
      test('creates with null sigma by default', () {
        final attribute = BlurModifierMix();

        expect(attribute.sigma, isNull);
      });

      test('creates with provided Prop sigma value', () {
        final sigma = Prop.value(5.0);
        final attribute = BlurModifierMix.create(sigma: sigma);

        expect(attribute.sigma, same(sigma));
      });
    });

    group('only constructor', () {
      test('creates Prop value from direct sigma', () {
        final attribute = BlurModifierMix(sigma: 7.0);

        expect(attribute.sigma!, resolvesTo(7.0));
      });

      test('handles null sigma correctly', () {
        final attribute = BlurModifierMix();

        expect(attribute.sigma, isNull);
      });
    });

    group('resolve', () {
      test('resolves to BlurModifier with resolved sigma', () {
        final attribute = BlurModifierMix(sigma: 7.0);

        const expectedModifier = BlurModifier(7.0);

        expect(attribute, resolvesTo(expectedModifier));
      });

      test('resolves with null sigma to default', () {
        final attribute = BlurModifierMix();

        const expectedModifier = BlurModifier(0.0);

        expect(attribute, resolvesTo(expectedModifier));
      });
    });

    group('merge', () {
      test('merges with other BlurModifierMix', () {
        final attribute1 = BlurModifierMix(sigma: 5.0);
        final attribute2 = BlurModifierMix(sigma: 8.0);

        final merged = attribute1.merge(attribute2);

        expect(merged.sigma!, resolvesTo(8.0));
      });

      test('returns original when other is null', () {
        final attribute = BlurModifierMix(sigma: 5.0);

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });

      test('merges with null sigma', () {
        final attribute1 = BlurModifierMix();
        final attribute2 = BlurModifierMix(sigma: 7.0);

        final merged = attribute1.merge(attribute2);

        expect(merged.sigma!, resolvesTo(7.0));
      });
    });

    group('equality and props', () {
      test('equal when sigma values match', () {
        final attribute1 = BlurModifierMix(sigma: 5.0);
        final attribute2 = BlurModifierMix(sigma: 5.0);

        expect(attribute1, equals(attribute2));
      });

      test('not equal when sigma differs', () {
        final attribute1 = BlurModifierMix(sigma: 5.0);
        final attribute2 = BlurModifierMix(sigma: 8.0);

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('props contains Prop sigma value', () {
        final attribute = BlurModifierMix(sigma: 5.0);

        final props = attribute.props;
        expect(props.length, 1);
        expect(props[0], attribute.sigma);
      });
    });
  });

  group('Integration tests', () {
    testWidgets('BlurModifierMix resolves and builds correctly', (
      WidgetTester tester,
    ) async {
      final attribute = BlurModifierMix(sigma: 3.0);

      final modifier = attribute.resolve(MockBuildContext());
      const child = SizedBox(width: 100, height: 100);

      await tester.pumpWidget(modifier.build(child));

      expect(find.byType(ImageFiltered), findsOneWidget);
      final imageFiltered =
          tester.widget<ImageFiltered>(find.byType(ImageFiltered));
      expect(imageFiltered.child, same(child));
    });

    test('Complex merge scenario preserves and overrides correctly', () {
      final base = BlurModifierMix(sigma: 5.0);
      final override1 = BlurModifierMix(sigma: 8.0);
      final override2 = BlurModifierMix(sigma: 2.0);

      final result = base.merge(override1).merge(override2);

      expect(result.sigma!, resolvesTo(2.0));
    });

    test('Lerp produces expected intermediate values', () {
      const start = BlurModifier(0.0);
      const end = BlurModifier(10.0);

      final quarter = start.lerp(end, 0.25);
      final half = start.lerp(end, 0.5);
      final threeQuarter = start.lerp(end, 0.75);

      expect(quarter.sigma, 2.5);
      expect(half.sigma, 5.0);
      expect(threeQuarter.sigma, 7.5);
    });
  });
}
