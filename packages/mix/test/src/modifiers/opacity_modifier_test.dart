import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('OpacityWidgetModifier', () {
    group('Constructor', () {
      test('assigns opacity correctly', () {
        const opacity = 0.5;
        const modifier = OpacityWidgetModifier(opacity);

        expect(modifier.opacity, opacity);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated opacity', () {
        const original = OpacityWidgetModifier(0.5);
        final updated = original.copyWith(opacity: 0.8);

        expect(updated.opacity, 0.8);
        expect(updated, isNot(same(original)));
      });

      test('preserves original opacity when parameter is null', () {
        const original = OpacityWidgetModifier(0.5);
        final updated = original.copyWith();

        expect(updated.opacity, 0.5);
        expect(updated, isNot(same(original)));
      });
    });

    group('lerp', () {
      test('interpolates opacity correctly', () {
        const start = OpacityWidgetModifier(0.0);
        const end = OpacityWidgetModifier(1.0);
        final result = start.lerp(end, 0.5);

        expect(result.opacity, 0.5);
      });

      test('handles null other parameter', () {
        const start = OpacityWidgetModifier(0.5);
        final result = start.lerp(null, 0.5);

        expect(result, same(start));
      });

      test('handles extreme t values', () {
        const start = OpacityWidgetModifier(0.0);
        const end = OpacityWidgetModifier(1.0);

        final result0 = start.lerp(end, 0.0);
        expect(result0.opacity, 0.0);

        final result1 = start.lerp(end, 1.0);
        expect(result1.opacity, 1.0);
      });
    });

    group('equality and hashCode', () {
      test('equal when opacity values match', () {
        const modifier1 = OpacityWidgetModifier(0.5);
        const modifier2 = OpacityWidgetModifier(0.5);

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });

      test('not equal when opacity differs', () {
        const modifier1 = OpacityWidgetModifier(0.5);
        const modifier2 = OpacityWidgetModifier(0.8);

        expect(modifier1, isNot(equals(modifier2)));
      });
    });

    group('props', () {
      test('contains opacity value', () {
        const modifier = OpacityWidgetModifier(0.5);

        expect(modifier.props, [0.5]);
      });
    });

    group('build', () {
      testWidgets('creates Opacity widget with correct opacity', (
        WidgetTester tester,
      ) async {
        const opacity = 0.5;
        const modifier = OpacityWidgetModifier(opacity);
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
        expect(opacityWidget.opacity, opacity);
        expect(opacityWidget.child, same(child));
      });
    });
  });

  group('OpacityWidgetModifierMix', () {
    group('Constructor', () {
      test('creates with null opacity by default', () {
        final attribute = OpacityWidgetModifierMix();

        expect(attribute.opacity, isNull);
      });

      test('creates with provided Prop opacity value', () {
        final opacity = Prop.value(0.5);
        final attribute = OpacityWidgetModifierMix.create(opacity: opacity);

        expect(attribute.opacity, same(opacity));
      });
    });

    group('only constructor', () {
      test('creates Prop value from direct opacity', () {
        final attribute = OpacityWidgetModifierMix(opacity: 0.7);

        expect(attribute.opacity!, resolvesTo(0.7));
      });

      test('handles null opacity correctly', () {
        final attribute = OpacityWidgetModifierMix();

        expect(attribute.opacity, isNull);
      });
    });

    group('resolve', () {
      test('resolves to OpacityWidgetModifier with resolved opacity', () {
        final attribute = OpacityWidgetModifierMix(opacity: 0.7);

        const expectedModifier = OpacityWidgetModifier(0.7);

        expect(attribute, resolvesTo(expectedModifier));
      });

      test('resolves with null opacity', () {
        final attribute = OpacityWidgetModifierMix();

        const expectedModifier = OpacityWidgetModifier(
          1.0,
        ); // OpacityWidgetModifier defaults to 1.0

        expect(attribute, resolvesTo(expectedModifier));
      });
    });

    group('merge', () {
      test('merges with other OpacityWidgetModifierMix', () {
        final attribute1 = OpacityWidgetModifierMix(opacity: 0.5);
        final attribute2 = OpacityWidgetModifierMix(opacity: 0.8);

        final merged = attribute1.merge(attribute2);

        expect(merged.opacity!, resolvesTo(0.8)); // overridden
      });

      test('returns original when other is null', () {
        final attribute = OpacityWidgetModifierMix(opacity: 0.5);

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });

      test('merges with null opacity', () {
        final attribute1 = OpacityWidgetModifierMix();
        final attribute2 = OpacityWidgetModifierMix(opacity: 0.7);

        final merged = attribute1.merge(attribute2);

        expect(merged.opacity!, resolvesTo(0.7));
      });
    });

    group('equality and props', () {
      test('equal when opacity values match', () {
        final attribute1 = OpacityWidgetModifierMix(opacity: 0.5);
        final attribute2 = OpacityWidgetModifierMix(opacity: 0.5);

        expect(attribute1, equals(attribute2));
      });

      test('not equal when opacity differs', () {
        final attribute1 = OpacityWidgetModifierMix(opacity: 0.5);
        final attribute2 = OpacityWidgetModifierMix(opacity: 0.8);

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('props contains Prop opacity value', () {
        final attribute = OpacityWidgetModifierMix(opacity: 0.5);

        final props = attribute.props;
        expect(props.length, 1);
        expect(props[0], attribute.opacity);
      });
    });
  });

  group('Integration tests', () {
    testWidgets('OpacityWidgetModifierMix resolves and builds correctly', (
      WidgetTester tester,
    ) async {
      final attribute = OpacityWidgetModifierMix(opacity: 0.3);

      final modifier = attribute.resolve(MockBuildContext());
      const child = SizedBox(width: 100, height: 100);

      await tester.pumpWidget(modifier.build(child));

      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, 0.3);
      expect(opacity.child, same(child));
    });

    test('Complex merge scenario preserves and overrides correctly', () {
      final base = OpacityWidgetModifierMix(opacity: 0.5);
      final override1 = OpacityWidgetModifierMix(opacity: 0.8);
      final override2 = OpacityWidgetModifierMix(opacity: 0.2);

      final result = base.merge(override1).merge(override2);

      expect(result.opacity!, resolvesTo(0.2));
    });

    test('Lerp produces expected intermediate values', () {
      const start = OpacityWidgetModifier(0.0);
      const end = OpacityWidgetModifier(1.0);

      final quarter = start.lerp(end, 0.25);
      final half = start.lerp(end, 0.5);
      final threeQuarter = start.lerp(end, 0.75);

      expect(quarter.opacity, 0.25);
      expect(half.opacity, 0.5);
      expect(threeQuarter.opacity, 0.75);
    });
  });
}
