import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('RotatedBoxModifier', () {
    group('Constructor', () {
      test('creates with zero quarter turns by default', () {
        const modifier = RotatedBoxModifier();

        expect(modifier.quarterTurns, 0);
      });

      test('creates with specified quarter turns', () {
        const modifier = RotatedBoxModifier(2);

        expect(modifier.quarterTurns, 2);
      });

      test('creates with null quarter turns defaults to zero', () {
        const modifier = RotatedBoxModifier(null);

        expect(modifier.quarterTurns, 0);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated quarter turns', () {
        const original = RotatedBoxModifier(1);
        final updated = original.copyWith(quarterTurns: 3);

        expect(updated.quarterTurns, 3);
        expect(updated, isNot(same(original)));
      });

      test('preserves original value when parameter is null', () {
        const original = RotatedBoxModifier(2);
        final updated = original.copyWith();

        expect(updated.quarterTurns, original.quarterTurns);
        expect(updated, isNot(same(original)));
      });
    });

    group('lerp', () {
      test('interpolates quarter turns correctly', () {
        const start = RotatedBoxModifier(0);
        const end = RotatedBoxModifier(4);
        final result = start.lerp(end, 0.5);

        expect(result.quarterTurns, 2);
      });

      test('handles decimal interpolation with rounding', () {
        const start = RotatedBoxModifier(1);
        const end = RotatedBoxModifier(2);

        final result25 = start.lerp(end, 0.25);
        expect(result25.quarterTurns, 1); // rounds down

        final result75 = start.lerp(end, 0.75);
        expect(result75.quarterTurns, 2); // rounds up
      });

      test('handles null other parameter', () {
        const start = RotatedBoxModifier(2);
        final result = start.lerp(null, 0.5);

        expect(result, same(start));
      });

      test('handles extreme t values', () {
        const start = RotatedBoxModifier(1);
        const end = RotatedBoxModifier(3);

        final result0 = start.lerp(end, 0.0);
        expect(result0.quarterTurns, 1);

        final result1 = start.lerp(end, 1.0);
        expect(result1.quarterTurns, 3);
      });
    });

    group('equality and hashCode', () {
      test('equal when quarter turns match', () {
        const modifier1 = RotatedBoxModifier(2);
        const modifier2 = RotatedBoxModifier(2);

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });

      test('not equal when quarter turns differ', () {
        const modifier1 = RotatedBoxModifier(1);
        const modifier2 = RotatedBoxModifier(3);

        expect(modifier1, isNot(equals(modifier2)));
        // Hash codes might be equal due to hash collisions, so we only test inequality
        expect(modifier1 == modifier2, isFalse);
      });

      test('equal when both have default zero turns', () {
        const modifier1 = RotatedBoxModifier();
        const modifier2 = RotatedBoxModifier(0);

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });
    });

    group('props', () {
      test('contains quarter turns', () {
        const modifier = RotatedBoxModifier(3);

        expect(modifier.props, [3]);
      });
    });

    group('build', () {
      testWidgets('creates RotatedBox widget with specified quarter turns', (
        WidgetTester tester,
      ) async {
        const modifier = RotatedBoxModifier(2);
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final rotatedBox = tester.widget<RotatedBox>(find.byType(RotatedBox));
        expect(rotatedBox.quarterTurns, 2);
        expect(rotatedBox.child, same(child));
      });

      testWidgets('creates RotatedBox widget with zero turns by default', (
        WidgetTester tester,
      ) async {
        const modifier = RotatedBoxModifier();
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final rotatedBox = tester.widget<RotatedBox>(find.byType(RotatedBox));
        expect(rotatedBox.quarterTurns, 0);
        expect(rotatedBox.child, same(child));
      });
    });
  });

  group('RotatedBoxModifierAttribute', () {
    group('Constructor', () {
      test('creates with null quarter turns by default', () {
        const attribute = RotatedBoxModifierAttribute();

        expect(attribute.quarterTurns, isNull);
      });

      test('creates with provided Prop quarter turns', () {
        final quarterTurns = Prop<int>(2);
        final attribute = RotatedBoxModifierAttribute(
          quarterTurns: quarterTurns,
        );

        expect(attribute.quarterTurns, same(quarterTurns));
      });
    });

    group('only constructor', () {
      test('creates Prop from int value', () {
        final attribute = RotatedBoxModifierAttribute.only(quarterTurns: 3);

        expect(attribute.quarterTurns, isNotNull);
        expectProp(attribute.quarterTurns, 3);
      });

      test('handles null quarter turns', () {
        final attribute = RotatedBoxModifierAttribute.only();

        expect(attribute.quarterTurns, isNull);
      });
    });

    group('resolve', () {
      test('resolves to RotatedBoxModifier with resolved quarter turns', () {
        final attribute = RotatedBoxModifierAttribute.only(quarterTurns: 1);

        expect(attribute, resolvesTo(const RotatedBoxModifier(1)));
      });

      test('resolves with null quarter turns to zero', () {
        const attribute = RotatedBoxModifierAttribute();

        expect(attribute, resolvesTo(const RotatedBoxModifier(0)));
      });
    });

    group('merge', () {
      test('merges with other RotatedBoxModifierAttribute', () {
        final attribute1 = RotatedBoxModifierAttribute.only(quarterTurns: 1);
        final attribute2 = RotatedBoxModifierAttribute.only(quarterTurns: 3);

        final merged = attribute1.merge(attribute2);

        expectProp(merged.quarterTurns, 3); // Prop<int> uses replacement
      });

      test('returns original when other is null', () {
        final attribute = RotatedBoxModifierAttribute.only(quarterTurns: 2);

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });

      test('merges with null quarter turns', () {
        const attribute1 = RotatedBoxModifierAttribute();
        final attribute2 = RotatedBoxModifierAttribute.only(quarterTurns: 1);

        final merged = attribute1.merge(attribute2);

        expect(merged.quarterTurns!, resolvesTo(1));
      });
    });

    group('equality and props', () {
      test('equal when quarter turns match', () {
        final attribute1 = RotatedBoxModifierAttribute.only(quarterTurns: 2);
        final attribute2 = RotatedBoxModifierAttribute.only(quarterTurns: 2);

        expect(attribute1, equals(attribute2));
      });

      test('not equal when quarter turns differ', () {
        final attribute1 = RotatedBoxModifierAttribute.only(quarterTurns: 1);
        final attribute2 = RotatedBoxModifierAttribute.only(quarterTurns: 3);

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('props contains quarter turns', () {
        final attribute = RotatedBoxModifierAttribute.only(quarterTurns: 2);

        final props = attribute.props;
        expect(props.length, 1);
        expect(props[0], attribute.quarterTurns);
      });
    });
  });

  group('RotatedBoxModifierUtility', () {
    late RotatedBoxModifierUtility<
      UtilityTestAttribute<RotatedBoxModifierAttribute>
    >
    utility;

    setUp(() {
      utility = RotatedBoxModifierUtility(
        (attribute) => UtilityTestAttribute(attribute),
      );
    });

    test('call() creates attribute with specified quarter turns', () {
      final result = utility.call(3);
      final attribute = result.value;

      expect(attribute.quarterTurns, isNotNull);
      expect(attribute.quarterTurns!, resolvesTo(3));
    });

    test('d90() creates attribute with 1 quarter turn', () {
      final result = utility.d90();
      final attribute = result.value;

      expect(attribute.quarterTurns!, resolvesTo(1));

      // Verify it creates 90-degree rotation
      expect(attribute, resolvesTo(const RotatedBoxModifier(1)));
    });

    test('d180() creates attribute with 2 quarter turns', () {
      final result = utility.d180();
      final attribute = result.value;

      expect(attribute.quarterTurns!, resolvesTo(2));

      // Verify it creates 180-degree rotation
      expect(attribute, resolvesTo(const RotatedBoxModifier(2)));
    });

    test('d270() creates attribute with 3 quarter turns', () {
      final result = utility.d270();
      final attribute = result.value;

      expect(attribute.quarterTurns!, resolvesTo(3));

      // Verify it creates 270-degree rotation
      expect(attribute, resolvesTo(const RotatedBoxModifier(3)));
    });

    test('utility methods are convenience for call()', () {
      final d90Result = utility.d90();
      final call1Result = utility.call(1);

      expect(
        d90Result.value.quarterTurns!,
        resolvesTo(call1Result.value.quarterTurns!.value),
      );

      final d180Result = utility.d180();
      final call2Result = utility.call(2);

      expect(
        d180Result.value.quarterTurns!,
        resolvesTo(call2Result.value.quarterTurns!.value),
      );

      final d270Result = utility.d270();
      final call3Result = utility.call(3);

      expect(
        d270Result.value.quarterTurns!,
        resolvesTo(call3Result.value.quarterTurns!.value),
      );
    });
  });

  group('Integration tests', () {
    testWidgets('RotatedBoxModifierAttribute resolves and builds correctly', (
      WidgetTester tester,
    ) async {
      final attribute = RotatedBoxModifierAttribute.only(quarterTurns: 2);

      expect(attribute, resolvesTo(const RotatedBoxModifier(2)));

      final modifier = attribute.resolve(MockBuildContext());
      const child = SizedBox(width: 100, height: 50);

      await tester.pumpWidget(Center(child: modifier.build(child)));

      final rotatedBox = tester.widget<RotatedBox>(find.byType(RotatedBox));
      expect(rotatedBox.quarterTurns, 2);
      expect(rotatedBox.child, same(child));

      // Verify the widget is actually rotated 180 degrees
      final size = tester.getSize(find.byType(RotatedBox));
      expect(size.width, 100); // Width and height are preserved
      expect(size.height, 50);
    });

    test('Complex merge scenario preserves and overrides correctly', () {
      final base = RotatedBoxModifierAttribute.only(quarterTurns: 0);

      final override1 = RotatedBoxModifierAttribute.only(quarterTurns: 1);

      final override2 = RotatedBoxModifierAttribute.only(quarterTurns: 3);

      final result = base.merge(override1).merge(override2);

      expect(result.quarterTurns!, resolvesTo(3));
    });

    test('Lerp produces expected intermediate values', () {
      const start = RotatedBoxModifier(0);
      const end = RotatedBoxModifier(4);

      final quarter = start.lerp(end, 0.25);
      final half = start.lerp(end, 0.5);
      final threeQuarter = start.lerp(end, 0.75);

      expect(quarter.quarterTurns, 1);
      expect(half.quarterTurns, 2);
      expect(threeQuarter.quarterTurns, 3);
    });

    testWidgets('Rotation actually rotates the child widget', (
      WidgetTester tester,
    ) async {
      // Test each rotation angle
      for (final turns in [0, 1, 2, 3]) {
        await tester.pumpWidget(
          Center(
            child: RotatedBoxModifier(turns).build(
              Container(width: 100, height: 50, color: const Color(0xFF00FF00)),
            ),
          ),
        );

        final rotatedBox = tester.widget<RotatedBox>(find.byType(RotatedBox));
        expect(rotatedBox.quarterTurns, turns);

        // For 90 and 270 degree rotations, width and height are swapped
        final size = tester.getSize(find.byType(RotatedBox));
        if (turns == 1 || turns == 3) {
          expect(size.width, 50);
          expect(size.height, 100);
        } else {
          expect(size.width, 100);
          expect(size.height, 50);
        }
      }
    });
  });
}
