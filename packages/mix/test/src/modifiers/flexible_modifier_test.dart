import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('FlexibleModifier', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        const modifier = FlexibleModifier();

        expect(modifier.flex, isNull);
        expect(modifier.fit, isNull);
      });

      test('assigns all parameters correctly', () {
        const flex = 2;
        const fit = FlexFit.tight;
        const modifier = FlexibleModifier(flex: flex, fit: fit);

        expect(modifier.flex, flex);
        expect(modifier.fit, fit);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated values', () {
        const original = FlexibleModifier(flex: 1, fit: FlexFit.loose);

        final updated = original.copyWith(flex: 3, fit: FlexFit.tight);

        expect(updated.flex, 3);
        expect(updated.fit, FlexFit.tight);
        expect(updated, isNot(same(original)));
      });

      test('preserves original values when parameters are null', () {
        const original = FlexibleModifier(flex: 2, fit: FlexFit.tight);

        final updated = original.copyWith();

        expect(updated.flex, original.flex);
        expect(updated.fit, original.fit);
        expect(updated, isNot(same(original)));
      });

      test('allows partial updates', () {
        const original = FlexibleModifier(flex: 1, fit: FlexFit.loose);

        final updatedFlex = original.copyWith(flex: 4);
        expect(updatedFlex.flex, 4);
        expect(updatedFlex.fit, original.fit);

        final updatedFit = original.copyWith(fit: FlexFit.tight);
        expect(updatedFit.flex, original.flex);
        expect(updatedFit.fit, FlexFit.tight);
      });
    });

    group('lerp', () {
      test('interpolates flex using lerpDouble + round', () {
        const start = FlexibleModifier(flex: 1);
        const end = FlexibleModifier(flex: 3);

        // MixOps.lerp for int: lerpDouble(a, b, t).round()
        expect(start.lerp(end, 0.0).flex, 1);
        expect(start.lerp(end, 0.25).flex, 2); // 1 + 0.25 * 2 = 1.5 → 2
        expect(start.lerp(end, 0.5).flex, 2); // 1 + 0.5 * 2 = 2.0 → 2
        expect(start.lerp(end, 1.0).flex, 3);
      });

      test('uses step function for fit', () {
        const start = FlexibleModifier(fit: FlexFit.loose);
        const end = FlexibleModifier(fit: FlexFit.tight);

        expect(start.lerp(end, 0.0).fit, FlexFit.loose);
        expect(start.lerp(end, 0.49).fit, FlexFit.loose);
        expect(start.lerp(end, 0.5).fit, FlexFit.tight);
        expect(start.lerp(end, 1.0).fit, FlexFit.tight);
      });

      test('interpolates all properties together', () {
        const start = FlexibleModifier(flex: 1, fit: FlexFit.loose);
        const end = FlexibleModifier(flex: 5, fit: FlexFit.tight);

        final result = start.lerp(end, 0.3);
        expect(result.flex, 2); // lerpDouble(1, 5, 0.3).round() = 2.2 → 2
        expect(result.fit, FlexFit.loose);

        final result2 = start.lerp(end, 0.7);
        expect(result2.flex, 4); // lerpDouble(1, 5, 0.7).round() = 3.8 → 4
        expect(result2.fit, FlexFit.tight);
      });

      test('handles null other parameter', () {
        const start = FlexibleModifier(flex: 2, fit: FlexFit.tight);
        final result = start.lerp(null, 0.5);

        expect(result, same(start));
      });

      test('handles null values in properties', () {
        const start = FlexibleModifier(flex: 1);
        const end = FlexibleModifier(fit: FlexFit.tight);
        final result = start.lerp(end, 0.5);

        // MixOps.lerp(1, null, 0.5): lerpDouble treats null as 0
        // lerpDouble(1, 0, 0.5) = 0.5, round() = 1
        expect(result.flex, 1);
        expect(result.fit, FlexFit.tight);
      });
    });

    group('equality and hashCode', () {
      test('equal when all properties match', () {
        const modifier1 = FlexibleModifier(flex: 2, fit: FlexFit.tight);
        const modifier2 = FlexibleModifier(flex: 2, fit: FlexFit.tight);

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });

      test('not equal when flex differs', () {
        const modifier1 = FlexibleModifier(flex: 1);
        const modifier2 = FlexibleModifier(flex: 2);

        expect(modifier1, isNot(equals(modifier2)));
      });

      test('not equal when fit differs', () {
        const modifier1 = FlexibleModifier(fit: FlexFit.loose);
        const modifier2 = FlexibleModifier(fit: FlexFit.tight);

        expect(modifier1, isNot(equals(modifier2)));
      });

      test('equal when both have all null values', () {
        const modifier1 = FlexibleModifier();
        const modifier2 = FlexibleModifier();

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });
    });

    group('props', () {
      test('contains all properties', () {
        const modifier = FlexibleModifier(flex: 3, fit: FlexFit.tight);

        expect(modifier.props, [FlexFit.tight, 3]);
      });

      test('contains null values', () {
        const modifier = FlexibleModifier();

        expect(modifier.props, [null, null]);
      });
    });

    group('build', () {
      testWidgets('creates Flexible widget with default values', (
        WidgetTester tester,
      ) async {
        const modifier = FlexibleModifier();
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(children: [modifier.build(child)]),
          ),
        );

        final flexible = tester.widget<Flexible>(find.byType(Flexible));
        expect(flexible.flex, 1); // default flex
        expect(flexible.fit, FlexFit.loose); // default fit
        expect(flexible.child, same(child));
      });

      testWidgets('creates Flexible widget with custom values', (
        WidgetTester tester,
      ) async {
        const modifier = FlexibleModifier(flex: 3, fit: FlexFit.tight);
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(children: [modifier.build(child)]),
          ),
        );

        final flexible = tester.widget<Flexible>(find.byType(Flexible));
        expect(flexible.flex, 3);
        expect(flexible.fit, FlexFit.tight);
        expect(flexible.child, same(child));
      });
    });
  });

  group('FlexibleModifierMix', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        final attribute = FlexibleModifierMix();

        expect(attribute.flex, isNull);
        expect(attribute.fit, isNull);
      });

      test('creates with provided Prop values', () {
        final flex = Prop.value(2);
        final fit = Prop.value(FlexFit.tight);
        final attribute = FlexibleModifierMix.create(flex: flex, fit: fit);

        expect(attribute.flex, same(flex));
        expect(attribute.fit, same(fit));
      });
    });

    group('only constructor', () {
      test('creates Prop values from direct values', () {
        final attribute = FlexibleModifierMix(flex: 3, fit: FlexFit.loose);

        expect(attribute.flex, resolvesTo(3));
        expect(attribute.fit, resolvesTo(FlexFit.loose));
      });

      test('handles null values correctly', () {
        final attribute = FlexibleModifierMix();

        expect(attribute.flex, isNull);
        expect(attribute.fit, isNull);
      });

      test('handles partial values', () {
        final attribute1 = FlexibleModifierMix(flex: 2);
        expect(attribute1.flex, resolvesTo(2));
        expect(attribute1.fit, isNull);

        final attribute2 = FlexibleModifierMix(fit: FlexFit.tight);
        expect(attribute2.flex, isNull);
        expect(attribute2.fit, resolvesTo(FlexFit.tight));
      });
    });

    group('resolve', () {
      test('resolves to FlexibleModifier with resolved values', () {
        final attribute = FlexibleModifierMix(flex: 4, fit: FlexFit.tight);

        expect(
          attribute,
          resolvesTo(const FlexibleModifier(flex: 4, fit: FlexFit.tight)),
        );
      });

      test('resolves with null values', () {
        final attribute = FlexibleModifierMix();

        expect(attribute, resolvesTo(const FlexibleModifier()));
      });
    });

    group('merge', () {
      test('merges with other FlexibleModifierMix', () {
        final attribute1 = FlexibleModifierMix(flex: 1, fit: FlexFit.loose);
        final attribute2 = FlexibleModifierMix(flex: 3, fit: FlexFit.tight);

        final merged = attribute1.merge(attribute2);

        expect(merged.flex, resolvesTo(3)); // overridden
        expect(merged.fit, resolvesTo(FlexFit.tight)); // overridden
      });

      test('returns original when other is null', () {
        final attribute = FlexibleModifierMix(flex: 2);

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });

      test('merges with null values', () {
        final attribute1 = FlexibleModifierMix();
        final attribute2 = FlexibleModifierMix(fit: FlexFit.tight);

        final merged = attribute1.merge(attribute2);

        expect(merged.flex, isNull);
        expect(merged.fit, resolvesTo(FlexFit.tight));
      });
    });

    group('equality and props', () {
      test('equal when all Prop values match', () {
        final attribute1 = FlexibleModifierMix(flex: 2, fit: FlexFit.tight);
        final attribute2 = FlexibleModifierMix(flex: 2, fit: FlexFit.tight);

        expect(attribute1, equals(attribute2));
      });

      test('not equal when values differ', () {
        final attribute1 = FlexibleModifierMix(flex: 1);
        final attribute2 = FlexibleModifierMix(flex: 2);

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('props contains all Prop values', () {
        final attribute = FlexibleModifierMix(flex: 3, fit: FlexFit.tight);

        final props = attribute.props;
        expect(props.length, 2);
        expect(props[0], attribute.fit);
        expect(props[1], attribute.flex);
      });
    });
  });

  group('Integration tests', () {
    testWidgets('FlexibleModifierMix resolves and builds correctly', (
      WidgetTester tester,
    ) async {
      final attribute = FlexibleModifierMix(flex: 2, fit: FlexFit.tight);

      expect(
        attribute,
        resolvesTo(const FlexibleModifier(flex: 2, fit: FlexFit.tight)),
      );

      final modifier = attribute.resolve(MockBuildContext());
      const child = SizedBox(width: 100, height: 100);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(children: [modifier.build(child)]),
        ),
      );

      final flexible = tester.widget<Flexible>(find.byType(Flexible));
      expect(flexible.flex, 2);
      expect(flexible.fit, FlexFit.tight);
      expect(flexible.child, same(child));
    });

    test('Complex merge scenario preserves and overrides correctly', () {
      final base = FlexibleModifierMix(flex: 1, fit: FlexFit.loose);

      final override1 = FlexibleModifierMix(flex: 3);

      final override2 = FlexibleModifierMix(fit: FlexFit.tight);

      final result = base.merge(override1).merge(override2);

      expect(result.flex, resolvesTo(3));
      expect(result.fit, resolvesTo(FlexFit.tight));
    });

    test('Lerp interpolates flex and snaps fit', () {
      const start = FlexibleModifier(flex: 1, fit: FlexFit.loose);
      const end = FlexibleModifier(flex: 5, fit: FlexFit.tight);

      final quarter = start.lerp(end, 0.25);
      final half = start.lerp(end, 0.5);
      final threeQuarter = start.lerp(end, 0.75);

      // flex: lerpDouble(1, 5, t).round()
      expect(quarter.flex, 2); // 1 + 1.0 = 2.0 → 2
      expect(quarter.fit, FlexFit.loose);

      expect(half.flex, 3); // 1 + 2.0 = 3.0 → 3
      expect(half.fit, FlexFit.tight);

      expect(threeQuarter.flex, 4); // 1 + 3.0 = 4.0 → 4
      expect(threeQuarter.fit, FlexFit.tight);
    });
  });
}
