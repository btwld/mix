import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('AlignWidgetDecorator', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        const decorator = AlignWidgetDecorator();

        expect(decorator.alignment, isNull);
        expect(decorator.widthFactor, isNull);
        expect(decorator.heightFactor, isNull);
      });

      test('assigns all parameters correctly', () {
        const alignment = Alignment.topLeft;
        const widthFactor = 0.8;
        const heightFactor = 0.6;
        const decorator = AlignWidgetDecorator(
          alignment: alignment,
          widthFactor: widthFactor,
          heightFactor: heightFactor,
        );

        expect(decorator.alignment, alignment);
        expect(decorator.widthFactor, widthFactor);
        expect(decorator.heightFactor, heightFactor);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated values', () {
        const original = AlignWidgetDecorator(
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
        const original = AlignWidgetDecorator(
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
        const original = AlignWidgetDecorator(
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
        const start = AlignWidgetDecorator(alignment: Alignment.topLeft);
        const end = AlignWidgetDecorator(alignment: Alignment.bottomRight);
        final result = start.lerp(end, 0.5);

        expect(result.alignment, const Alignment(0.0, 0.0)); // Center point
      });

      test('interpolates widthFactor correctly', () {
        const start = AlignWidgetDecorator(widthFactor: 0.2);
        const end = AlignWidgetDecorator(widthFactor: 0.8);
        final result = start.lerp(end, 0.5);

        expect(result.widthFactor, 0.5);
      });

      test('interpolates heightFactor correctly', () {
        const start = AlignWidgetDecorator(heightFactor: 0.1);
        const end = AlignWidgetDecorator(heightFactor: 0.9);
        final result = start.lerp(end, 0.5);

        expect(result.heightFactor, 0.5);
      });

      test('interpolates all properties together', () {
        const start = AlignWidgetDecorator(
          alignment: Alignment.topLeft,
          widthFactor: 0.0,
          heightFactor: 0.0,
        );
        const end = AlignWidgetDecorator(
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
        const start = AlignWidgetDecorator(
          alignment: Alignment.center,
          widthFactor: 0.5,
          heightFactor: 0.5,
        );
        final result = start.lerp(null, 0.5);

        expect(result, same(start));
      });

      test('handles null values in properties', () {
        const start = AlignWidgetDecorator(alignment: Alignment.center);
        const end = AlignWidgetDecorator(widthFactor: 1.0);
        final result = start.lerp(end, 0.5);

        expect(result.alignment, Alignment.center);
        expect(result.widthFactor, 0.5); // 0.0 to 1.0 at t=0.5
        expect(result.heightFactor, isNull);
      });

      test('handles extreme t values', () {
        const start = AlignWidgetDecorator(alignment: Alignment.topLeft);
        const end = AlignWidgetDecorator(alignment: Alignment.bottomRight);

        final result0 = start.lerp(end, 0.0);
        expect(result0.alignment, Alignment.topLeft);

        final result1 = start.lerp(end, 1.0);
        expect(result1.alignment, Alignment.bottomRight);
      });
    });

    group('equality and hashCode', () {
      test('equal when all properties match', () {
        const decorator1 = AlignWidgetDecorator(
          alignment: Alignment.center,
          widthFactor: 0.5,
          heightFactor: 0.8,
        );
        const decorator2 = AlignWidgetDecorator(
          alignment: Alignment.center,
          widthFactor: 0.5,
          heightFactor: 0.8,
        );

        expect(decorator1, equals(decorator2));
        expect(decorator1.hashCode, equals(decorator2.hashCode));
      });

      test('not equal when alignment differs', () {
        const decorator1 = AlignWidgetDecorator(alignment: Alignment.center);
        const decorator2 = AlignWidgetDecorator(alignment: Alignment.topLeft);

        expect(decorator1, isNot(equals(decorator2)));
      });

      test('not equal when widthFactor differs', () {
        const decorator1 = AlignWidgetDecorator(widthFactor: 0.5);
        const decorator2 = AlignWidgetDecorator(widthFactor: 0.8);

        expect(decorator1, isNot(equals(decorator2)));
      });

      test('not equal when heightFactor differs', () {
        const decorator1 = AlignWidgetDecorator(heightFactor: 0.5);
        const decorator2 = AlignWidgetDecorator(heightFactor: 0.8);

        expect(decorator1, isNot(equals(decorator2)));
      });

      test('equal when both have all null values', () {
        const decorator1 = AlignWidgetDecorator();
        const decorator2 = AlignWidgetDecorator();

        expect(decorator1, equals(decorator2));
      });
    });

    group('props', () {
      test('contains all properties', () {
        const decorator = AlignWidgetDecorator(
          alignment: Alignment.center,
          widthFactor: 0.5,
          heightFactor: 0.8,
        );

        expect(decorator.props, [Alignment.center, 0.5, 0.8]);
      });

      test('contains null values', () {
        const decorator = AlignWidgetDecorator();

        expect(decorator.props, [null, null, null]);
      });
    });

    group('build', () {
      testWidgets('creates Align widget with default center alignment', (
        WidgetTester tester,
      ) async {
        const decorator = AlignWidgetDecorator();
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(decorator.build(child));

        final align = tester.widget<Align>(find.byType(Align));
        expect(align.alignment, Alignment.center);
        expect(align.widthFactor, isNull);
        expect(align.heightFactor, isNull);
        expect(align.child, same(child));
      });

      testWidgets('creates Align widget with custom alignment', (
        WidgetTester tester,
      ) async {
        const decorator = AlignWidgetDecorator(alignment: Alignment.topRight);
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(decorator.build(child));

        final align = tester.widget<Align>(find.byType(Align));
        expect(align.alignment, Alignment.topRight);
        expect(align.child, same(child));
      });

      testWidgets('creates Align widget with all parameters', (
        WidgetTester tester,
      ) async {
        const decorator = AlignWidgetDecorator(
          alignment: Alignment.bottomLeft,
          widthFactor: 0.6,
          heightFactor: 0.4,
        );
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(decorator.build(child));

        final align = tester.widget<Align>(find.byType(Align));
        expect(align.alignment, Alignment.bottomLeft);
        expect(align.widthFactor, 0.6);
        expect(align.heightFactor, 0.4);
        expect(align.child, same(child));
      });
    });
  });

  group('AlignWidgetDecoratorMix', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        final attribute = AlignWidgetDecoratorMix();

        expect(attribute.alignment, isNull);
        expect(attribute.widthFactor, isNull);
        expect(attribute.heightFactor, isNull);
      });

      test('creates with provided Prop values', () {
        final alignment = Prop.value<AlignmentGeometry>(Alignment.center);
        final widthFactor = Prop.value(0.5);
        final heightFactor = Prop.value(0.8);
        final attribute = AlignWidgetDecoratorMix.create(
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
        final attribute = AlignWidgetDecoratorMix(
          alignment: Alignment.topLeft,
          widthFactor: 0.3,
          heightFactor: 0.7,
        );

        expect(attribute.alignment!, resolvesTo(Alignment.topLeft));
        expect(attribute.widthFactor!, resolvesTo(0.3));
        expect(attribute.heightFactor!, resolvesTo(0.7));
      });

      test('handles null values correctly', () {
        final attribute = AlignWidgetDecoratorMix();

        expect(attribute.alignment, isNull);
        expect(attribute.widthFactor, isNull);
        expect(attribute.heightFactor, isNull);
      });

      test('handles partial values', () {
        final attribute1 = AlignWidgetDecoratorMix(alignment: Alignment.center);
        expectProp(attribute1.alignment, Alignment.center);
        expect(attribute1.widthFactor, isNull);
        expect(attribute1.heightFactor, isNull);

        final attribute2 = AlignWidgetDecoratorMix(widthFactor: 0.5);
        expect(attribute2.alignment, isNull);
        expect(attribute2.widthFactor!, resolvesTo(0.5));
        expect(attribute2.heightFactor, isNull);
      });
    });

    group('resolve', () {
      test('resolves to AlignWidgetDecorator with resolved values', () {
        final attribute = AlignWidgetDecoratorMix(
          alignment: Alignment.topRight,
          widthFactor: 0.4,
          heightFactor: 0.6,
        );

        const expectedDecorator = AlignWidgetDecorator(
          alignment: Alignment.topRight,
          widthFactor: 0.4,
          heightFactor: 0.6,
        );

        expect(attribute, resolvesTo(expectedDecorator));
      });

      test('resolves with null values', () {
        final attribute = AlignWidgetDecoratorMix();

        const expectedDecorator = AlignWidgetDecorator();

        expect(attribute, resolvesTo(expectedDecorator));
      });
    });

    group('merge', () {
      test('merges with other AlignWidgetDecoratorMix', () {
        final attribute1 = AlignWidgetDecoratorMix(
          alignment: Alignment.center,
          widthFactor: 0.5,
        );
        final attribute2 = AlignWidgetDecoratorMix(
          alignment: Alignment.topLeft,
          heightFactor: 0.8,
        );

        final merged = attribute1.merge(attribute2);

        expect(merged.alignment!, resolvesTo(Alignment.topLeft)); // overridden
        expect(merged.widthFactor!, resolvesTo(0.5)); // preserved
        expect(merged.heightFactor!, resolvesTo(0.8)); // added
      });

      test('returns original when other is null', () {
        final attribute = AlignWidgetDecoratorMix(alignment: Alignment.center);

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });

      test('merges with null values', () {
        final attribute1 = AlignWidgetDecoratorMix();
        final attribute2 = AlignWidgetDecoratorMix(
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
        final attribute1 = AlignWidgetDecoratorMix(
          alignment: Alignment.center,
          widthFactor: 0.5,
          heightFactor: 0.8,
        );
        final attribute2 = AlignWidgetDecoratorMix(
          alignment: Alignment.center,
          widthFactor: 0.5,
          heightFactor: 0.8,
        );

        expect(attribute1, equals(attribute2));
      });

      test('not equal when values differ', () {
        final attribute1 = AlignWidgetDecoratorMix(alignment: Alignment.center);
        final attribute2 = AlignWidgetDecoratorMix(alignment: Alignment.topLeft);

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('props contains all Prop values', () {
        final attribute = AlignWidgetDecoratorMix(
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
    testWidgets('AlignWidgetDecoratorMix resolves and builds correctly', (
      WidgetTester tester,
    ) async {
      final attribute = AlignWidgetDecoratorMix(
        alignment: Alignment.topRight,
        widthFactor: 0.7,
        heightFactor: 0.9,
      );

      final decorator = attribute.resolve(MockBuildContext());
      const child = SizedBox(width: 100, height: 100);

      await tester.pumpWidget(decorator.build(child));

      final align = tester.widget<Align>(find.byType(Align));
      expect(align.alignment, Alignment.topRight);
      expect(align.widthFactor, 0.7);
      expect(align.heightFactor, 0.9);
      expect(align.child, same(child));
    });

    test('Complex merge scenario preserves and overrides correctly', () {
      final base = AlignWidgetDecoratorMix(
        alignment: Alignment.center,
        widthFactor: 0.5,
        heightFactor: 0.5,
      );

      final override1 = AlignWidgetDecoratorMix(
        alignment: Alignment.topLeft,
        widthFactor: 0.8,
      );

      final override2 = AlignWidgetDecoratorMix(heightFactor: 0.9);

      final result = base.merge(override1).merge(override2);

      expectProp(result.alignment, Alignment.topLeft);
      expectProp(result.widthFactor, 0.8);
      expectProp(result.heightFactor, 0.9);
    });

    test('Lerp produces expected intermediate values', () {
      const start = AlignWidgetDecorator(
        alignment: Alignment.topLeft,
        widthFactor: 0.0,
        heightFactor: 0.0,
      );
      const end = AlignWidgetDecorator(
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
