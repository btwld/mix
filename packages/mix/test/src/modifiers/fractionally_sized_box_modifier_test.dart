import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('FractionallySizedBoxWidgetModifier', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        const modifier = FractionallySizedBoxWidgetModifier();

        expect(modifier.widthFactor, isNull);
        expect(modifier.heightFactor, isNull);
        expect(modifier.alignment, isNull);
      });

      test('assigns all parameters correctly', () {
        const widthFactor = 0.8;
        const heightFactor = 0.6;
        const alignment = Alignment.topLeft;
        const modifier = FractionallySizedBoxWidgetModifier(
          widthFactor: widthFactor,
          heightFactor: heightFactor,
          alignment: alignment,
        );

        expect(modifier.widthFactor, widthFactor);
        expect(modifier.heightFactor, heightFactor);
        expect(modifier.alignment, alignment);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated values', () {
        const original = FractionallySizedBoxWidgetModifier(
          widthFactor: 0.5,
          heightFactor: 0.7,
          alignment: Alignment.center,
        );

        final updated = original.copyWith(
          widthFactor: 0.9,
          heightFactor: 0.3,
          alignment: Alignment.topRight,
        );

        expect(updated.widthFactor, 0.9);
        expect(updated.heightFactor, 0.3);
        expect(updated.alignment, Alignment.topRight);
        expect(updated, isNot(same(original)));
      });

      test('preserves original values when parameters are null', () {
        const original = FractionallySizedBoxWidgetModifier(
          widthFactor: 0.5,
          heightFactor: 0.7,
          alignment: Alignment.center,
        );

        final updated = original.copyWith();

        expect(updated.widthFactor, original.widthFactor);
        expect(updated.heightFactor, original.heightFactor);
        expect(updated.alignment, original.alignment);
        expect(updated, isNot(same(original)));
      });

      test('allows partial updates', () {
        const original = FractionallySizedBoxWidgetModifier(
          widthFactor: 0.5,
          heightFactor: 0.7,
          alignment: Alignment.center,
        );

        final updatedWidth = original.copyWith(widthFactor: 0.2);
        expect(updatedWidth.widthFactor, 0.2);
        expect(updatedWidth.heightFactor, original.heightFactor);
        expect(updatedWidth.alignment, original.alignment);

        final updatedHeight = original.copyWith(heightFactor: 0.9);
        expect(updatedHeight.widthFactor, original.widthFactor);
        expect(updatedHeight.heightFactor, 0.9);
        expect(updatedHeight.alignment, original.alignment);

        final updatedAlignment = original.copyWith(
          alignment: Alignment.bottomLeft,
        );
        expect(updatedAlignment.widthFactor, original.widthFactor);
        expect(updatedAlignment.heightFactor, original.heightFactor);
        expect(updatedAlignment.alignment, Alignment.bottomLeft);
      });
    });

    group('lerp', () {
      test('interpolates widthFactor correctly', () {
        const start = FractionallySizedBoxWidgetModifier(widthFactor: 0.2);
        const end = FractionallySizedBoxWidgetModifier(widthFactor: 0.8);
        final result = start.lerp(end, 0.5);

        expect(result.widthFactor, 0.5);
      });

      test('interpolates heightFactor correctly', () {
        const start = FractionallySizedBoxWidgetModifier(heightFactor: 0.1);
        const end = FractionallySizedBoxWidgetModifier(heightFactor: 0.9);
        final result = start.lerp(end, 0.5);

        expect(result.heightFactor, 0.5);
      });

      test('interpolates alignment correctly', () {
        const start = FractionallySizedBoxWidgetModifier(
          alignment: Alignment.topLeft,
        );
        const end = FractionallySizedBoxWidgetModifier(
          alignment: Alignment.bottomRight,
        );
        final result = start.lerp(end, 0.5);

        expect(result.alignment, const Alignment(0.0, 0.0)); // Center
      });

      test('interpolates all properties together', () {
        const start = FractionallySizedBoxWidgetModifier(
          widthFactor: 0.0,
          heightFactor: 0.0,
          alignment: Alignment.topLeft,
        );
        const end = FractionallySizedBoxWidgetModifier(
          widthFactor: 1.0,
          heightFactor: 1.0,
          alignment: Alignment.bottomRight,
        );
        final result = start.lerp(end, 0.25);

        expect(result.widthFactor, 0.25);
        expect(result.heightFactor, 0.25);
        expect(result.alignment, const Alignment(-0.5, -0.5));
      });

      test('handles null other parameter', () {
        const start = FractionallySizedBoxWidgetModifier(
          widthFactor: 0.5,
          heightFactor: 0.5,
          alignment: Alignment.center,
        );
        final result = start.lerp(null, 0.5);

        expect(result, same(start));
      });

      test('handles null values in properties', () {
        const start = FractionallySizedBoxWidgetModifier(widthFactor: 0.5);
        const end = FractionallySizedBoxWidgetModifier(heightFactor: 0.5);
        final result = start.lerp(end, 0.5);

        expect(result.widthFactor, 0.25); // 0.5 to null (0) at t=0.5
        expect(result.heightFactor, 0.25); // null (0) to 0.5 at t=0.5
        expect(result.alignment, isNull);
      });

      test('handles extreme t values', () {
        const start = FractionallySizedBoxWidgetModifier(
          widthFactor: 0.2,
          alignment: Alignment.topLeft,
        );
        const end = FractionallySizedBoxWidgetModifier(
          widthFactor: 0.8,
          alignment: Alignment.bottomRight,
        );

        final result0 = start.lerp(end, 0.0);
        expect(result0.widthFactor, 0.2);
        expect(result0.alignment, Alignment.topLeft);

        final result1 = start.lerp(end, 1.0);
        expect(result1.widthFactor, 0.8);
        expect(result1.alignment, Alignment.bottomRight);
      });
    });

    group('equality and hashCode', () {
      test('equal when all properties match', () {
        const modifier1 = FractionallySizedBoxWidgetModifier(
          widthFactor: 0.5,
          heightFactor: 0.8,
          alignment: Alignment.center,
        );
        const modifier2 = FractionallySizedBoxWidgetModifier(
          widthFactor: 0.5,
          heightFactor: 0.8,
          alignment: Alignment.center,
        );

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });

      test('not equal when widthFactor differs', () {
        const modifier1 = FractionallySizedBoxWidgetModifier(
          widthFactor: 0.5,
        );
        const modifier2 = FractionallySizedBoxWidgetModifier(
          widthFactor: 0.8,
        );

        expect(modifier1, isNot(equals(modifier2)));
        // Hash codes might be equal due to hash collisions, so we only test inequality
        expect(modifier1 == modifier2, isFalse);
      });

      test('not equal when heightFactor differs', () {
        const modifier1 = FractionallySizedBoxWidgetModifier(
          heightFactor: 0.5,
        );
        const modifier2 = FractionallySizedBoxWidgetModifier(
          heightFactor: 0.8,
        );

        expect(modifier1, isNot(equals(modifier2)));
        // Hash codes might be equal due to hash collisions, so we only test inequality
        expect(modifier1 == modifier2, isFalse);
      });

      test('not equal when alignment differs', () {
        const modifier1 = FractionallySizedBoxWidgetModifier(
          alignment: Alignment.center,
        );
        const modifier2 = FractionallySizedBoxWidgetModifier(
          alignment: Alignment.topLeft,
        );

        expect(modifier1, isNot(equals(modifier2)));
        // Hash codes might be equal due to hash collisions, so we only test inequality
        expect(modifier1 == modifier2, isFalse);
      });

      test('equal when both have all null values', () {
        const modifier1 = FractionallySizedBoxWidgetModifier();
        const modifier2 = FractionallySizedBoxWidgetModifier();

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });
    });

    group('props', () {
      test('contains all properties', () {
        const modifier = FractionallySizedBoxWidgetModifier(
          widthFactor: 0.5,
          heightFactor: 0.8,
          alignment: Alignment.center,
        );

        expect(modifier.props, [0.5, 0.8, Alignment.center]);
      });

      test('contains null values', () {
        const modifier = FractionallySizedBoxWidgetModifier();

        expect(modifier.props, [null, null, null]);
      });
    });

    group('build', () {
      testWidgets(
        'creates FractionallySizedBox widget with default center alignment',
        (WidgetTester tester) async {
          const modifier = FractionallySizedBoxWidgetModifier();
          const child = SizedBox(width: 50, height: 50);

          await tester.pumpWidget(modifier.build(child));

          final box = tester.widget<FractionallySizedBox>(
            find.byType(FractionallySizedBox),
          );
          expect(box.alignment, Alignment.center);
          expect(box.widthFactor, isNull);
          expect(box.heightFactor, isNull);
          expect(box.child, same(child));
        },
      );

      testWidgets('creates FractionallySizedBox widget with custom values', (
        WidgetTester tester,
      ) async {
        const modifier = FractionallySizedBoxWidgetModifier(
          widthFactor: 0.7,
          heightFactor: 0.9,
          alignment: Alignment.topRight,
        );
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final box = tester.widget<FractionallySizedBox>(
          find.byType(FractionallySizedBox),
        );
        expect(box.widthFactor, 0.7);
        expect(box.heightFactor, 0.9);
        expect(box.alignment, Alignment.topRight);
        expect(box.child, same(child));
      });
    });
  });

  group('FractionallySizedBoxWidgetModifierMix', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        final attribute = FractionallySizedBoxWidgetModifierMix();

        expect(attribute.widthFactor, isNull);
        expect(attribute.heightFactor, isNull);
        expect(attribute.alignment, isNull);
      });

      test('creates with provided Prop values', () {
        final widthFactor = Prop.value(0.5);
        final heightFactor = Prop.value(0.8);
        final alignment = Prop.value<AlignmentGeometry>(Alignment.center);
        final attribute = FractionallySizedBoxWidgetModifierMix.create(
          widthFactor: widthFactor,
          heightFactor: heightFactor,
          alignment: alignment,
        );

        expect(attribute.widthFactor, same(widthFactor));
        expect(attribute.heightFactor, same(heightFactor));
        expect(attribute.alignment, same(alignment));
      });
    });

    group('only constructor', () {
      test('creates Prop values from direct values', () {
        final attribute = FractionallySizedBoxWidgetModifierMix(
          widthFactor: 0.3,
          heightFactor: 0.7,
          alignment: Alignment.topLeft,
        );

        expectProp(attribute.widthFactor, 0.3);
        expectProp(attribute.heightFactor, 0.7);
        expectProp(attribute.alignment, Alignment.topLeft);
      });

      test('handles null values correctly', () {
        final attribute = FractionallySizedBoxWidgetModifierMix();

        expect(attribute.widthFactor, isNull);
        expect(attribute.heightFactor, isNull);
        expect(attribute.alignment, isNull);
      });

      test('handles partial values', () {
        final attribute1 = FractionallySizedBoxWidgetModifierMix(
          widthFactor: 0.5,
        );
        expectProp(attribute1.widthFactor, 0.5);
        expect(attribute1.heightFactor, isNull);
        expect(attribute1.alignment, isNull);

        final attribute2 = FractionallySizedBoxWidgetModifierMix(
          heightFactor: 0.7,
        );
        expect(attribute2.widthFactor, isNull);
        expectProp(attribute2.heightFactor, 0.7);
        expect(attribute2.alignment, isNull);

        final attribute3 = FractionallySizedBoxWidgetModifierMix(
          alignment: Alignment.bottomRight,
        );
        expect(attribute3.widthFactor, isNull);
        expect(attribute3.heightFactor, isNull);
        expectProp(attribute3.alignment, Alignment.bottomRight);
      });
    });

    group('resolve', () {
      test(
        'resolves to FractionallySizedBoxWidgetModifier with resolved values',
        () {
          final attribute = FractionallySizedBoxWidgetModifierMix(
            widthFactor: 0.4,
            heightFactor: 0.6,
            alignment: Alignment.topRight,
          );

          const expectedModifier = FractionallySizedBoxWidgetModifier(
            widthFactor: 0.4,
            heightFactor: 0.6,
            alignment: Alignment.topRight,
          );
          expect(attribute, resolvesTo(expectedModifier));
        },
      );

      test('resolves with null values', () {
        final attribute = FractionallySizedBoxWidgetModifierMix();

        const expectedModifier = FractionallySizedBoxWidgetModifier();
        expect(attribute, resolvesTo(expectedModifier));
      });
    });

    group('merge', () {
      test('merges with other FractionallySizedBoxWidgetModifierMix', () {
        final attribute1 = FractionallySizedBoxWidgetModifierMix(
          widthFactor: 0.5,
          heightFactor: 0.5,
        );
        final attribute2 = FractionallySizedBoxWidgetModifierMix(
          widthFactor: 0.8,
          alignment: Alignment.topLeft,
        );

        final merged = attribute1.merge(attribute2);

        expectProp(merged.widthFactor, 0.8); // overridden
        expectProp(merged.heightFactor, 0.5); // preserved
        expectProp(merged.alignment, Alignment.topLeft); // added
      });

      test('returns original when other is null', () {
        final attribute = FractionallySizedBoxWidgetModifierMix(
          widthFactor: 0.5,
        );

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });

      test('merges with null values', () {
        final attribute1 = FractionallySizedBoxWidgetModifierMix();
        final attribute2 = FractionallySizedBoxWidgetModifierMix(
          alignment: Alignment.bottomRight,
        );

        final merged = attribute1.merge(attribute2);

        expect(merged.widthFactor, isNull);
        expect(merged.heightFactor, isNull);
        expectProp(merged.alignment, Alignment.bottomRight);
      });
    });

    group('equality and props', () {
      test('equal when all Prop values match', () {
        final attribute1 = FractionallySizedBoxWidgetModifierMix(
          widthFactor: 0.5,
          heightFactor: 0.8,
          alignment: Alignment.center,
        );
        final attribute2 = FractionallySizedBoxWidgetModifierMix(
          widthFactor: 0.5,
          heightFactor: 0.8,
          alignment: Alignment.center,
        );

        expect(attribute1, equals(attribute2));
      });

      test('not equal when values differ', () {
        final attribute1 = FractionallySizedBoxWidgetModifierMix(
          widthFactor: 0.5,
        );
        final attribute2 = FractionallySizedBoxWidgetModifierMix(
          widthFactor: 0.8,
        );

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('props contains all Prop values', () {
        final attribute = FractionallySizedBoxWidgetModifierMix(
          widthFactor: 0.5,
          heightFactor: 0.8,
          alignment: Alignment.center,
        );

        final props = attribute.props;
        expect(props.length, 3);
        expect(props[0], attribute.widthFactor);
        expect(props[1], attribute.heightFactor);
        expect(props[2], attribute.alignment);
      });
    });
  });

  group('FractionallySizedBoxWidgetModifierUtility', () {
    late FractionallySizedBoxWidgetModifierUtility<
      MockStyle<FractionallySizedBoxWidgetModifierMix>
    >
    utility;

    setUp(() {
      utility = FractionallySizedBoxWidgetModifierUtility(
        (attribute) => MockStyle(attribute),
      );
    });

    test('call() creates attribute with specified values', () {
      final result = utility.call(
        widthFactor: 0.5,
        heightFactor: 0.8,
        alignment: Alignment.topLeft,
      );
      final attribute = result.value;

      expectProp(attribute.widthFactor, 0.5);
      expectProp(attribute.heightFactor, 0.8);
      expectProp(attribute.alignment, Alignment.topLeft);
    });

    test('call() handles null values', () {
      final result = utility.call();
      final attribute = result.value;

      expect(attribute.widthFactor, isNull);
      expect(attribute.heightFactor, isNull);
      expect(attribute.alignment, isNull);
    });

    test('call() handles partial values', () {
      final result1 = utility.call(widthFactor: 0.7);
      final attribute1 = result1.value;

      expectProp(attribute1.widthFactor, 0.7);
      expect(attribute1.heightFactor, isNull);
      expect(attribute1.alignment, isNull);

      final result2 = utility.call(
        heightFactor: 0.3,
        alignment: Alignment.center,
      );
      final attribute2 = result2.value;

      expect(attribute2.widthFactor, isNull);
      expectProp(attribute2.heightFactor, 0.3);
      expectProp(attribute2.alignment, Alignment.center);
    });
  });

  group('Integration tests', () {
    testWidgets(
      'FractionallySizedBoxWidgetModifierMix resolves and builds correctly',
      (WidgetTester tester) async {
        final attribute = FractionallySizedBoxWidgetModifierMix(
          widthFactor: 0.7,
          heightFactor: 0.9,
          alignment: Alignment.bottomCenter,
        );

        const expectedModifier = FractionallySizedBoxWidgetModifier(
          widthFactor: 0.7,
          heightFactor: 0.9,
          alignment: Alignment.bottomCenter,
        );
        expect(attribute, resolvesTo(expectedModifier));

        final modifier = attribute.resolve(MockBuildContext());
        const child = SizedBox(width: 100, height: 100);

        await tester.pumpWidget(modifier.build(child));

        final box = tester.widget<FractionallySizedBox>(
          find.byType(FractionallySizedBox),
        );
        expect(box.widthFactor, 0.7);
        expect(box.heightFactor, 0.9);
        expect(box.alignment, Alignment.bottomCenter);
        expect(box.child, same(child));
      },
    );

    test('Complex merge scenario preserves and overrides correctly', () {
      final base = FractionallySizedBoxWidgetModifierMix(
        widthFactor: 0.5,
        heightFactor: 0.5,
        alignment: Alignment.center,
      );

      final override1 = FractionallySizedBoxWidgetModifierMix(
        widthFactor: 0.8,
        heightFactor: 0.8,
      );

      final override2 = FractionallySizedBoxWidgetModifierMix(
        alignment: Alignment.topLeft,
      );

      final result = base.merge(override1).merge(override2);

      expectProp(result.widthFactor, 0.8);
      expectProp(result.heightFactor, 0.8);
      expectProp(result.alignment, Alignment.topLeft);
    });

    test('Lerp produces expected intermediate values', () {
      const start = FractionallySizedBoxWidgetModifier(
        widthFactor: 0.0,
        heightFactor: 0.0,
        alignment: Alignment.topLeft,
      );
      const end = FractionallySizedBoxWidgetModifier(
        widthFactor: 1.0,
        heightFactor: 1.0,
        alignment: Alignment.bottomRight,
      );

      final quarter = start.lerp(end, 0.25);
      final half = start.lerp(end, 0.5);
      final threeQuarter = start.lerp(end, 0.75);

      expect(quarter.widthFactor, 0.25);
      expect(quarter.heightFactor, 0.25);
      expect(quarter.alignment, const Alignment(-0.5, -0.5));

      expect(half.widthFactor, 0.5);
      expect(half.heightFactor, 0.5);
      expect(half.alignment, const Alignment(0.0, 0.0));

      expect(threeQuarter.widthFactor, 0.75);
      expect(threeQuarter.heightFactor, 0.75);
      expect(threeQuarter.alignment, const Alignment(0.5, 0.5));
    });
  });
}
