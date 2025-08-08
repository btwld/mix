import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('AlignModifier', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        const modifier = AlignModifier();

        expect(modifier.alignment, isNull);
        expect(modifier.widthFactor, isNull);
        expect(modifier.heightFactor, isNull);
      });

      test('assigns all parameters correctly', () {
        const alignment = Alignment.topLeft;
        const widthFactor = 0.8;
        const heightFactor = 0.6;
        const modifier = AlignModifier(
          alignment: alignment,
          widthFactor: widthFactor,
          heightFactor: heightFactor,
        );

        expect(modifier.alignment, alignment);
        expect(modifier.widthFactor, widthFactor);
        expect(modifier.heightFactor, heightFactor);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated values', () {
        const original = AlignModifier(
          alignment: Alignment.center,
          widthFactor: 1.0,
          heightFactor: 1.0,
        );

        final updated = original.copyWith(
          alignment: Alignment.topLeft,
          widthFactor: 0.5,
          heightFactor: 0.8,
        );

        expect(updated.alignment, Alignment.topLeft);
        expect(updated.widthFactor, 0.5);
        expect(updated.heightFactor, 0.8);
        expect(updated, isNot(same(original)));
      });

      test('preserves original values when parameters are null', () {
        const original = AlignModifier(
          alignment: Alignment.center,
          widthFactor: 1.0,
          heightFactor: 1.0,
        );

        final updated = original.copyWith();

        expect(updated.alignment, original.alignment);
        expect(updated.widthFactor, original.widthFactor);
        expect(updated.heightFactor, original.heightFactor);
        expect(updated, isNot(same(original)));
      });

      test('allows partial updates', () {
        const original = AlignModifier(
          alignment: Alignment.center,
          widthFactor: 1.0,
          heightFactor: 1.0,
        );

        final updatedAlignment = original.copyWith(
          alignment: Alignment.topLeft,
        );
        expect(updatedAlignment.alignment, Alignment.topLeft);
        expect(updatedAlignment.widthFactor, original.widthFactor);
        expect(updatedAlignment.heightFactor, original.heightFactor);

        final updatedWidth = original.copyWith(widthFactor: 0.5);
        expect(updatedWidth.alignment, original.alignment);
        expect(updatedWidth.widthFactor, 0.5);
        expect(updatedWidth.heightFactor, original.heightFactor);

        final updatedHeight = original.copyWith(heightFactor: 0.8);
        expect(updatedHeight.alignment, original.alignment);
        expect(updatedHeight.widthFactor, original.widthFactor);
        expect(updatedHeight.heightFactor, 0.8);
      });
    });

    group('lerp', () {
      test('interpolates alignment correctly', () {
        const start = AlignModifier(alignment: Alignment.topLeft);
        const end = AlignModifier(alignment: Alignment.bottomRight);
        final result = start.lerp(end, 0.5);

        expect(result.alignment, const Alignment(0.0, 0.0)); // Center point
      });

      test('interpolates widthFactor correctly', () {
        const start = AlignModifier(widthFactor: 0.2);
        const end = AlignModifier(widthFactor: 0.8);
        final result = start.lerp(end, 0.5);

        expect(result.widthFactor, 0.5);
      });

      test('interpolates heightFactor correctly', () {
        const start = AlignModifier(heightFactor: 0.1);
        const end = AlignModifier(heightFactor: 0.9);
        final result = start.lerp(end, 0.5);

        expect(result.heightFactor, 0.5);
      });

      test('interpolates all properties together', () {
        const start = AlignModifier(
          alignment: Alignment.topLeft,
          widthFactor: 0.0,
          heightFactor: 0.0,
        );
        const end = AlignModifier(
          alignment: Alignment.bottomRight,
          widthFactor: 1.0,
          heightFactor: 1.0,
        );
        final result = start.lerp(end, 0.25);

        expect(result.alignment, const Alignment(-0.5, -0.5));
        expect(result.widthFactor, 0.25);
        expect(result.heightFactor, 0.25);
      });

      test('handles null other parameter', () {
        const start = AlignModifier(
          alignment: Alignment.center,
          widthFactor: 0.5,
          heightFactor: 0.5,
        );
        final result = start.lerp(null, 0.5);

        expect(result, same(start));
      });

      test('handles null values in properties', () {
        const start = AlignModifier(alignment: Alignment.center);
        const end = AlignModifier(widthFactor: 1.0);
        final result = start.lerp(end, 0.5);

        expect(result.alignment, Alignment.center);
        expect(result.widthFactor, 0.5); // 0.0 to 1.0 at t=0.5
        expect(result.heightFactor, isNull);
      });

      test('handles extreme t values', () {
        const start = AlignModifier(alignment: Alignment.topLeft);
        const end = AlignModifier(alignment: Alignment.bottomRight);

        final result0 = start.lerp(end, 0.0);
        expect(result0.alignment, Alignment.topLeft);

        final result1 = start.lerp(end, 1.0);
        expect(result1.alignment, Alignment.bottomRight);
      });
    });

    group('equality and hashCode', () {
      test('equal when all properties match', () {
        const modifier1 = AlignModifier(
          alignment: Alignment.center,
          widthFactor: 0.5,
          heightFactor: 0.8,
        );
        const modifier2 = AlignModifier(
          alignment: Alignment.center,
          widthFactor: 0.5,
          heightFactor: 0.8,
        );

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });

      test('not equal when alignment differs', () {
        const modifier1 = AlignModifier(alignment: Alignment.center);
        const modifier2 = AlignModifier(alignment: Alignment.topLeft);

        expect(modifier1, isNot(equals(modifier2)));
      });

      test('not equal when widthFactor differs', () {
        const modifier1 = AlignModifier(widthFactor: 0.5);
        const modifier2 = AlignModifier(widthFactor: 0.8);

        expect(modifier1, isNot(equals(modifier2)));
      });

      test('not equal when heightFactor differs', () {
        const modifier1 = AlignModifier(heightFactor: 0.5);
        const modifier2 = AlignModifier(heightFactor: 0.8);

        expect(modifier1, isNot(equals(modifier2)));
      });

      test('equal when both have all null values', () {
        const modifier1 = AlignModifier();
        const modifier2 = AlignModifier();

        expect(modifier1, equals(modifier2));
      });
    });

    group('props', () {
      test('contains all properties', () {
        const modifier = AlignModifier(
          alignment: Alignment.center,
          widthFactor: 0.5,
          heightFactor: 0.8,
        );

        expect(modifier.props, [Alignment.center, 0.5, 0.8]);
      });

      test('contains null values', () {
        const modifier = AlignModifier();

        expect(modifier.props, [null, null, null]);
      });
    });

    group('build', () {
      testWidgets('creates Align widget with default center alignment', (
        WidgetTester tester,
      ) async {
        const modifier = AlignModifier();
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final align = tester.widget<Align>(find.byType(Align));
        expect(align.alignment, Alignment.center);
        expect(align.widthFactor, isNull);
        expect(align.heightFactor, isNull);
        expect(align.child, same(child));
      });

      testWidgets('creates Align widget with custom alignment', (
        WidgetTester tester,
      ) async {
        const modifier = AlignModifier(alignment: Alignment.topRight);
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final align = tester.widget<Align>(find.byType(Align));
        expect(align.alignment, Alignment.topRight);
        expect(align.child, same(child));
      });

      testWidgets('creates Align widget with all parameters', (
        WidgetTester tester,
      ) async {
        const modifier = AlignModifier(
          alignment: Alignment.bottomLeft,
          widthFactor: 0.6,
          heightFactor: 0.4,
        );
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final align = tester.widget<Align>(find.byType(Align));
        expect(align.alignment, Alignment.bottomLeft);
        expect(align.widthFactor, 0.6);
        expect(align.heightFactor, 0.4);
        expect(align.child, same(child));
      });
    });
  });

  group('AlignModifierMix', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        final attribute = AlignModifierMix();

        expect(attribute.alignment, isNull);
        expect(attribute.widthFactor, isNull);
        expect(attribute.heightFactor, isNull);
      });

      test('creates with provided Prop values', () {
        final alignment = Prop.value<AlignmentGeometry>(Alignment.center);
        final widthFactor = Prop.value(0.5);
        final heightFactor = Prop.value(0.8);
        final attribute = AlignModifierMix.create(
          alignment: alignment,
          widthFactor: widthFactor,
          heightFactor: heightFactor,
        );

        expect(attribute.alignment, same(alignment));
        expect(attribute.widthFactor, same(widthFactor));
        expect(attribute.heightFactor, same(heightFactor));
      });
    });

    group('only constructor', () {
      test('creates Prop values from direct values', () {
        final attribute = AlignModifierMix(
          alignment: Alignment.topLeft,
          widthFactor: 0.3,
          heightFactor: 0.7,
        );

        expect(attribute.alignment!, resolvesTo(Alignment.topLeft));
        expect(attribute.widthFactor!, resolvesTo(0.3));
        expect(attribute.heightFactor!, resolvesTo(0.7));
      });

      test('handles null values correctly', () {
        final attribute = AlignModifierMix();

        expect(attribute.alignment, isNull);
        expect(attribute.widthFactor, isNull);
        expect(attribute.heightFactor, isNull);
      });

      test('handles partial values', () {
        final attribute1 = AlignModifierMix(alignment: Alignment.center);
        expectProp(attribute1.alignment, Alignment.center);
        expect(attribute1.widthFactor, isNull);
        expect(attribute1.heightFactor, isNull);

        final attribute2 = AlignModifierMix(widthFactor: 0.5);
        expect(attribute2.alignment, isNull);
        expect(attribute2.widthFactor!, resolvesTo(0.5));
        expect(attribute2.heightFactor, isNull);
      });
    });

    group('resolve', () {
      test('resolves to AlignModifier with resolved values', () {
        final attribute = AlignModifierMix(
          alignment: Alignment.topRight,
          widthFactor: 0.4,
          heightFactor: 0.6,
        );

        const expectedModifier = AlignModifier(
          alignment: Alignment.topRight,
          widthFactor: 0.4,
          heightFactor: 0.6,
        );

        expect(attribute, resolvesTo(expectedModifier));
      });

      test('resolves with null values', () {
        final attribute = AlignModifierMix();

        const expectedModifier = AlignModifier();

        expect(attribute, resolvesTo(expectedModifier));
      });
    });

    group('merge', () {
      test('merges with other AlignModifierMix', () {
        final attribute1 = AlignModifierMix(
          alignment: Alignment.center,
          widthFactor: 0.5,
        );
        final attribute2 = AlignModifierMix(
          alignment: Alignment.topLeft,
          heightFactor: 0.8,
        );

        final merged = attribute1.merge(attribute2);

        expect(merged.alignment!, resolvesTo(Alignment.topLeft)); // overridden
        expect(merged.widthFactor!, resolvesTo(0.5)); // preserved
        expect(merged.heightFactor!, resolvesTo(0.8)); // added
      });

      test('returns original when other is null', () {
        final attribute = AlignModifierMix(alignment: Alignment.center);

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });

      test('merges with null values', () {
        final attribute1 = AlignModifierMix();
        final attribute2 = AlignModifierMix(
          alignment: Alignment.bottomRight,
        );

        final merged = attribute1.merge(attribute2);

        expectProp(merged.alignment, Alignment.bottomRight);
        expect(merged.widthFactor, isNull);
        expect(merged.heightFactor, isNull);
      });
    });

    group('equality and props', () {
      test('equal when all Prop values match', () {
        final attribute1 = AlignModifierMix(
          alignment: Alignment.center,
          widthFactor: 0.5,
          heightFactor: 0.8,
        );
        final attribute2 = AlignModifierMix(
          alignment: Alignment.center,
          widthFactor: 0.5,
          heightFactor: 0.8,
        );

        expect(attribute1, equals(attribute2));
      });

      test('not equal when values differ', () {
        final attribute1 = AlignModifierMix(alignment: Alignment.center);
        final attribute2 = AlignModifierMix(alignment: Alignment.topLeft);

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('props contains all Prop values', () {
        final attribute = AlignModifierMix(
          alignment: Alignment.center,
          widthFactor: 0.5,
          heightFactor: 0.8,
        );

        final props = attribute.props;
        expect(props.length, 3);
        expect(props[0], attribute.alignment);
        expect(props[1], attribute.widthFactor);
        expect(props[2], attribute.heightFactor);
      });
    });
  });

  group('Integration tests', () {
    testWidgets('AlignModifierMix resolves and builds correctly', (
      WidgetTester tester,
    ) async {
      final attribute = AlignModifierMix(
        alignment: Alignment.topRight,
        widthFactor: 0.7,
        heightFactor: 0.9,
      );

      final modifier = attribute.resolve(MockBuildContext());
      const child = SizedBox(width: 100, height: 100);

      await tester.pumpWidget(modifier.build(child));

      final align = tester.widget<Align>(find.byType(Align));
      expect(align.alignment, Alignment.topRight);
      expect(align.widthFactor, 0.7);
      expect(align.heightFactor, 0.9);
      expect(align.child, same(child));
    });

    test('Complex merge scenario preserves and overrides correctly', () {
      final base = AlignModifierMix(
        alignment: Alignment.center,
        widthFactor: 0.5,
        heightFactor: 0.5,
      );

      final override1 = AlignModifierMix(
        alignment: Alignment.topLeft,
        widthFactor: 0.8,
      );

      final override2 = AlignModifierMix(heightFactor: 0.9);

      final result = base.merge(override1).merge(override2);

      expectProp(result.alignment, Alignment.topLeft);
      expectProp(result.widthFactor, 0.8);
      expectProp(result.heightFactor, 0.9);
    });

    test('Lerp produces expected intermediate values', () {
      const start = AlignModifier(
        alignment: Alignment.topLeft,
        widthFactor: 0.0,
        heightFactor: 0.0,
      );
      const end = AlignModifier(
        alignment: Alignment.bottomRight,
        widthFactor: 1.0,
        heightFactor: 1.0,
      );

      final quarter = start.lerp(end, 0.25);
      final half = start.lerp(end, 0.5);
      final threeQuarter = start.lerp(end, 0.75);

      expect(quarter.alignment, const Alignment(-0.5, -0.5));
      expect(quarter.widthFactor, 0.25);
      expect(quarter.heightFactor, 0.25);

      expect(half.alignment, const Alignment(0.0, 0.0));
      expect(half.widthFactor, 0.5);
      expect(half.heightFactor, 0.5);

      expect(threeQuarter.alignment, const Alignment(0.5, 0.5));
      expect(threeQuarter.widthFactor, 0.75);
      expect(threeQuarter.heightFactor, 0.75);
    });
  });
}
