import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('SizedBoxWidgetModifier', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        const modifier = SizedBoxWidgetModifier();

        expect(modifier.width, isNull);
        expect(modifier.height, isNull);
      });

      test('assigns all parameters correctly', () {
        const width = 100.0;
        const height = 100.0;
        const modifier = SizedBoxWidgetModifier(width: width, height: height);

        expect(modifier.width, width);
        expect(modifier.height, height);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated values', () {
        const original = SizedBoxWidgetModifier(width: 100.0, height: 100.0);

        final updated = original.copyWith(width: 200.0, height: 150.0);

        expect(updated.width, 200.0);
        expect(updated.height, 150.0);
        expect(updated, isNot(same(original)));
      });

      test('preserves original values when parameters are null', () {
        const original = SizedBoxWidgetModifier(width: 100.0, height: 100.0);

        final updated = original.copyWith();

        expect(updated.width, original.width);
        expect(updated.height, original.height);
        expect(updated, isNot(same(original)));
      });

      test('allows partial updates', () {
        const original = SizedBoxWidgetModifier(width: 100.0, height: 100.0);

        final updatedWidth = original.copyWith(width: 200.0);
        expect(updatedWidth.width, 200.0);
        expect(updatedWidth.height, original.height);

        final updatedHeight = original.copyWith(height: 200.0);
        expect(updatedHeight.width, original.width);
        expect(updatedHeight.height, 200.0);
      });
    });

    group('lerp', () {
      test('interpolates width correctly', () {
        const start = SizedBoxWidgetModifier(width: 100.0);
        const end = SizedBoxWidgetModifier(width: 200.0);
        final result = start.lerp(end, 0.5);

        expect(result.width, 150.0);
      });

      test('interpolates height correctly', () {
        const start = SizedBoxWidgetModifier(height: 100.0);
        const end = SizedBoxWidgetModifier(height: 200.0);
        final result = start.lerp(end, 0.5);

        expect(result.height, 150.0);
      });

      test('interpolates all properties together', () {
        const start = SizedBoxWidgetModifier(width: 100.0, height: 100.0);
        const end = SizedBoxWidgetModifier(width: 200.0, height: 200.0);
        final result = start.lerp(end, 0.25);

        expect(result.width, 125.0);
        expect(result.height, 125.0);
      });

      test('handles null other parameter', () {
        const start = SizedBoxWidgetModifier(width: 100.0, height: 100.0);
        final result = start.lerp(null, 0.5);

        expect(result, same(start));
      });

      test('handles null values in properties', () {
        const start = SizedBoxWidgetModifier(width: 100.0);
        const end = SizedBoxWidgetModifier(height: 200.0);
        final result = start.lerp(end, 0.5);

        expect(result.width, 50.0); // 100.0 to 0.0 at t=0.5
        expect(result.height, 100.0); // 0.0 to 200.0 at t=0.5
      });

      test('handles extreme t values', () {
        const start = SizedBoxWidgetModifier(width: 100.0, height: 100.0);
        const end = SizedBoxWidgetModifier(width: 200.0, height: 200.0);

        final result0 = start.lerp(end, 0.0);
        expect(result0.width, 100.0);
        expect(result0.height, 100.0);

        final result1 = start.lerp(end, 1.0);
        expect(result1.width, 200.0);
        expect(result1.height, 200.0);
      });
    });

    group('equality and hashCode', () {
      test('equal when all properties match', () {
        const modifier1 = SizedBoxWidgetModifier(width: 100.0, height: 100.0);
        const modifier2 = SizedBoxWidgetModifier(width: 100.0, height: 100.0);

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });

      test('not equal when width differs', () {
        const modifier1 = SizedBoxWidgetModifier(width: 100.0);
        const modifier2 = SizedBoxWidgetModifier(width: 200.0);

        expect(modifier1, isNot(equals(modifier2)));
      });

      test('not equal when height differs', () {
        const modifier1 = SizedBoxWidgetModifier(height: 100.0);
        const modifier2 = SizedBoxWidgetModifier(height: 200.0);

        expect(modifier1, isNot(equals(modifier2)));
      });

      test('equal when both have all null values', () {
        const modifier1 = SizedBoxWidgetModifier();
        const modifier2 = SizedBoxWidgetModifier();

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });
    });

    group('props', () {
      test('contains all properties', () {
        const modifier = SizedBoxWidgetModifier(width: 100.0, height: 200.0);

        expect(modifier.props, [100.0, 200.0]);
      });

      test('contains null values', () {
        const modifier = SizedBoxWidgetModifier();

        expect(modifier.props, [null, null]);
      });
    });

    group('build', () {
      testWidgets('creates SizedBox widget with default values', (
        WidgetTester tester,
      ) async {
        const modifier = SizedBoxWidgetModifier();
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.width, isNull);
        expect(sizedBox.height, isNull);
        expect(sizedBox.child, same(child));
      });

      testWidgets('creates SizedBox widget with custom dimensions', (
        WidgetTester tester,
      ) async {
        const modifier = SizedBoxWidgetModifier(width: 100.0, height: 200.0);
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.width, 100.0);
        expect(sizedBox.height, 200.0);
        expect(sizedBox.child, same(child));
      });
    });
  });

  group('SizedBoxWidgetModifierMix', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        final attribute = SizedBoxWidgetModifierMix();

        expect(attribute.width, isNull);
        expect(attribute.height, isNull);
      });

      test('creates with provided Prop values', () {
        final width = Prop.value(100.0);
        final height = Prop.value(200.0);
        final attribute = SizedBoxWidgetModifierMix.create(
          width: width,
          height: height,
        );

        expect(attribute.width, same(width));
        expect(attribute.height, same(height));
      });
    });

    group('only constructor', () {
      test('creates Prop values from direct values', () {
        final attribute = SizedBoxWidgetModifierMix(
          width: 100.0,
          height: 200.0,
        );

        expect(attribute.width!, resolvesTo(100.0));
        expect(attribute.height!, resolvesTo(200.0));
      });

      test('handles null values correctly', () {
        final attribute = SizedBoxWidgetModifierMix();

        expect(attribute.width, isNull);
        expect(attribute.height, isNull);
      });

      test('handles partial values', () {
        final attribute1 = SizedBoxWidgetModifierMix(width: 100.0);
        expect(attribute1.width!, resolvesTo(100.0));
        expect(attribute1.height, isNull);

        final attribute2 = SizedBoxWidgetModifierMix(height: 200.0);
        expect(attribute2.width, isNull);
        expect(attribute2.height!, resolvesTo(200.0));
      });
    });

    group('resolve', () {
      test('resolves to SizedBoxWidgetModifier with resolved values', () {
        final attribute = SizedBoxWidgetModifierMix(
          width: 100.0,
          height: 200.0,
        );

        const expectedModifier = SizedBoxWidgetModifier(width: 100.0, height: 200.0);

        expect(attribute, resolvesTo(expectedModifier));
      });

      test('resolves with null values', () {
        final attribute = SizedBoxWidgetModifierMix();

        const expectedModifier = SizedBoxWidgetModifier();

        expect(attribute, resolvesTo(expectedModifier));
      });
    });

    group('merge', () {
      test('merges with other SizedBoxWidgetModifierMix', () {
        final attribute1 = SizedBoxWidgetModifierMix(
          width: 100.0,
          height: 100.0,
        );
        final attribute2 = SizedBoxWidgetModifierMix(
          width: 200.0,
          height: 200.0,
        );

        final merged = attribute1.merge(attribute2);

        expect(merged.width!, resolvesTo(200.0)); // overridden
        expect(merged.height!, resolvesTo(200.0)); // overridden
      });

      test('returns original when other is null', () {
        final attribute = SizedBoxWidgetModifierMix(width: 100.0);

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });

      test('merges with null values', () {
        final attribute1 = SizedBoxWidgetModifierMix();
        final attribute2 = SizedBoxWidgetModifierMix(
          width: 100.0,
          height: 200.0,
        );

        final merged = attribute1.merge(attribute2);

        expect(merged.width!, resolvesTo(100.0));
        expect(merged.height!, resolvesTo(200.0));
      });
    });

    group('equality and props', () {
      test('equal when all Prop values match', () {
        final attribute1 = SizedBoxWidgetModifierMix(
          width: 100.0,
          height: 200.0,
        );
        final attribute2 = SizedBoxWidgetModifierMix(
          width: 100.0,
          height: 200.0,
        );

        expect(attribute1, equals(attribute2));
      });

      test('not equal when values differ', () {
        final attribute1 = SizedBoxWidgetModifierMix(width: 100.0);
        final attribute2 = SizedBoxWidgetModifierMix(width: 200.0);

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('props contains all Prop values', () {
        final attribute = SizedBoxWidgetModifierMix(
          width: 100.0,
          height: 200.0,
        );

        final props = attribute.props;
        expect(props.length, 2);
        expect(props[0], attribute.width);
        expect(props[1], attribute.height);
      });
    });
  });

  group('Integration tests', () {
    testWidgets('SizedBoxWidgetModifierMix resolves and builds correctly', (
      WidgetTester tester,
    ) async {
      final attribute = SizedBoxWidgetModifierMix(width: 150.0, height: 250.0);

      final modifier = attribute.resolve(MockBuildContext());
      const child = SizedBox(width: 100, height: 100);

      await tester.pumpWidget(modifier.build(child));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, 150.0);
      expect(sizedBox.height, 250.0);
      expect(sizedBox.child, same(child));
    });

    test('Complex merge scenario preserves and overrides correctly', () {
      final base = SizedBoxWidgetModifierMix(width: 100.0, height: 100.0);

      final override1 = SizedBoxWidgetModifierMix(width: 200.0);

      final override2 = SizedBoxWidgetModifierMix(height: 300.0);

      final result = base.merge(override1).merge(override2);

      expect(result.width!, resolvesTo(200.0));
      expect(result.height!, resolvesTo(300.0));
    });

    test('Lerp produces expected intermediate values', () {
      const start = SizedBoxWidgetModifier(width: 100.0, height: 100.0);
      const end = SizedBoxWidgetModifier(width: 200.0, height: 200.0);

      final quarter = start.lerp(end, 0.25);
      final half = start.lerp(end, 0.5);
      final threeQuarter = start.lerp(end, 0.75);

      expect(quarter.width, 125.0);
      expect(quarter.height, 125.0);

      expect(half.width, 150.0);
      expect(half.height, 150.0);

      expect(threeQuarter.width, 175.0);
      expect(threeQuarter.height, 175.0);
    });
  });
}
