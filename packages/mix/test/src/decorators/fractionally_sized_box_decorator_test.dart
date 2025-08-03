import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('FractionallySizedBoxWidgetDecorator', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        const decorator = FractionallySizedBoxWidgetDecorator();

        expect(decorator.widthFactor, isNull);
        expect(decorator.heightFactor, isNull);
        expect(decorator.alignment, isNull);
      });

      test('assigns all parameters correctly', () {
        const widthFactor = 0.8;
        const heightFactor = 0.6;
        const alignment = Alignment.topLeft;
        const decorator = FractionallySizedBoxWidgetDecorator(
          widthFactor: widthFactor,
          heightFactor: heightFactor,
          alignment: alignment,
        );

        expect(decorator.widthFactor, widthFactor);
        expect(decorator.heightFactor, heightFactor);
        expect(decorator.alignment, alignment);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated values', () {
        const original = FractionallySizedBoxWidgetDecorator(
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
        const original = FractionallySizedBoxWidgetDecorator(
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
        const original = FractionallySizedBoxWidgetDecorator(
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
        const start = FractionallySizedBoxWidgetDecorator(widthFactor: 0.2);
        const end = FractionallySizedBoxWidgetDecorator(widthFactor: 0.8);
        final result = start.lerp(end, 0.5);

        expect(result.widthFactor, 0.5);
      });

      test('interpolates heightFactor correctly', () {
        const start = FractionallySizedBoxWidgetDecorator(heightFactor: 0.1);
        const end = FractionallySizedBoxWidgetDecorator(heightFactor: 0.9);
        final result = start.lerp(end, 0.5);

        expect(result.heightFactor, 0.5);
      });

      test('interpolates alignment correctly', () {
        const start = FractionallySizedBoxWidgetDecorator(
          alignment: Alignment.topLeft,
        );
        const end = FractionallySizedBoxWidgetDecorator(
          alignment: Alignment.bottomRight,
        );
        final result = start.lerp(end, 0.5);

        expect(result.alignment, const Alignment(0.0, 0.0)); // Center
      });

      test('interpolates all properties together', () {
        const start = FractionallySizedBoxWidgetDecorator(
          widthFactor: 0.0,
          heightFactor: 0.0,
          alignment: Alignment.topLeft,
        );
        const end = FractionallySizedBoxWidgetDecorator(
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
        const start = FractionallySizedBoxWidgetDecorator(
          widthFactor: 0.5,
          heightFactor: 0.5,
          alignment: Alignment.center,
        );
        final result = start.lerp(null, 0.5);

        expect(result, same(start));
      });

      test('handles null values in properties', () {
        const start = FractionallySizedBoxWidgetDecorator(widthFactor: 0.5);
        const end = FractionallySizedBoxWidgetDecorator(heightFactor: 0.5);
        final result = start.lerp(end, 0.5);

        expect(result.widthFactor, 0.25); // 0.5 to null (0) at t=0.5
        expect(result.heightFactor, 0.25); // null (0) to 0.5 at t=0.5
        expect(result.alignment, isNull);
      });

      test('handles extreme t values', () {
        const start = FractionallySizedBoxWidgetDecorator(
          widthFactor: 0.2,
          alignment: Alignment.topLeft,
        );
        const end = FractionallySizedBoxWidgetDecorator(
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
        const decorator1 = FractionallySizedBoxWidgetDecorator(
          widthFactor: 0.5,
          heightFactor: 0.8,
          alignment: Alignment.center,
        );
        const decorator2 = FractionallySizedBoxWidgetDecorator(
          widthFactor: 0.5,
          heightFactor: 0.8,
          alignment: Alignment.center,
        );

        expect(decorator1, equals(decorator2));
        expect(decorator1.hashCode, equals(decorator2.hashCode));
      });

      test('not equal when widthFactor differs', () {
        const decorator1 = FractionallySizedBoxWidgetDecorator(
          widthFactor: 0.5,
        );
        const decorator2 = FractionallySizedBoxWidgetDecorator(
          widthFactor: 0.8,
        );

        expect(decorator1, isNot(equals(decorator2)));
        // Hash codes might be equal due to hash collisions, so we only test inequality
        expect(decorator1 == decorator2, isFalse);
      });

      test('not equal when heightFactor differs', () {
        const decorator1 = FractionallySizedBoxWidgetDecorator(
          heightFactor: 0.5,
        );
        const decorator2 = FractionallySizedBoxWidgetDecorator(
          heightFactor: 0.8,
        );

        expect(decorator1, isNot(equals(decorator2)));
        // Hash codes might be equal due to hash collisions, so we only test inequality
        expect(decorator1 == decorator2, isFalse);
      });

      test('not equal when alignment differs', () {
        const decorator1 = FractionallySizedBoxWidgetDecorator(
          alignment: Alignment.center,
        );
        const decorator2 = FractionallySizedBoxWidgetDecorator(
          alignment: Alignment.topLeft,
        );

        expect(decorator1, isNot(equals(decorator2)));
        // Hash codes might be equal due to hash collisions, so we only test inequality
        expect(decorator1 == decorator2, isFalse);
      });

      test('equal when both have all null values', () {
        const decorator1 = FractionallySizedBoxWidgetDecorator();
        const decorator2 = FractionallySizedBoxWidgetDecorator();

        expect(decorator1, equals(decorator2));
        expect(decorator1.hashCode, equals(decorator2.hashCode));
      });
    });

    group('props', () {
      test('contains all properties', () {
        const decorator = FractionallySizedBoxWidgetDecorator(
          widthFactor: 0.5,
          heightFactor: 0.8,
          alignment: Alignment.center,
        );

        expect(decorator.props, [0.5, 0.8, Alignment.center]);
      });

      test('contains null values', () {
        const decorator = FractionallySizedBoxWidgetDecorator();

        expect(decorator.props, [null, null, null]);
      });
    });

    group('build', () {
      testWidgets(
        'creates FractionallySizedBox widget with default center alignment',
        (WidgetTester tester) async {
          const decorator = FractionallySizedBoxWidgetDecorator();
          const child = SizedBox(width: 50, height: 50);

          await tester.pumpWidget(decorator.build(child));

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
        const decorator = FractionallySizedBoxWidgetDecorator(
          widthFactor: 0.7,
          heightFactor: 0.9,
          alignment: Alignment.topRight,
        );
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(decorator.build(child));

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

  group('FractionallySizedBoxWidgetDecoratorMix', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        final attribute = FractionallySizedBoxWidgetDecoratorMix();

        expect(attribute.widthFactor, isNull);
        expect(attribute.heightFactor, isNull);
        expect(attribute.alignment, isNull);
      });

      test('creates with provided Prop values', () {
        final widthFactor = Prop.value(0.5);
        final heightFactor = Prop.value(0.8);
        final alignment = Prop.value<AlignmentGeometry>(Alignment.center);
        final attribute = FractionallySizedBoxWidgetDecoratorMix.raw(
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
        final attribute = FractionallySizedBoxWidgetDecoratorMix(
          widthFactor: 0.3,
          heightFactor: 0.7,
          alignment: Alignment.topLeft,
        );

        expectProp(attribute.widthFactor, 0.3);
        expectProp(attribute.heightFactor, 0.7);
        expectProp(attribute.alignment, Alignment.topLeft);
      });

      test('handles null values correctly', () {
        final attribute = FractionallySizedBoxWidgetDecoratorMix();

        expect(attribute.widthFactor, isNull);
        expect(attribute.heightFactor, isNull);
        expect(attribute.alignment, isNull);
      });

      test('handles partial values', () {
        final attribute1 = FractionallySizedBoxWidgetDecoratorMix(
          widthFactor: 0.5,
        );
        expectProp(attribute1.widthFactor, 0.5);
        expect(attribute1.heightFactor, isNull);
        expect(attribute1.alignment, isNull);

        final attribute2 = FractionallySizedBoxWidgetDecoratorMix(
          heightFactor: 0.7,
        );
        expect(attribute2.widthFactor, isNull);
        expectProp(attribute2.heightFactor, 0.7);
        expect(attribute2.alignment, isNull);

        final attribute3 = FractionallySizedBoxWidgetDecoratorMix(
          alignment: Alignment.bottomRight,
        );
        expect(attribute3.widthFactor, isNull);
        expect(attribute3.heightFactor, isNull);
        expectProp(attribute3.alignment, Alignment.bottomRight);
      });
    });

    group('resolve', () {
      test(
        'resolves to FractionallySizedBoxWidgetDecorator with resolved values',
        () {
          final attribute = FractionallySizedBoxWidgetDecoratorMix(
            widthFactor: 0.4,
            heightFactor: 0.6,
            alignment: Alignment.topRight,
          );

          const expectedDecorator = FractionallySizedBoxWidgetDecorator(
            widthFactor: 0.4,
            heightFactor: 0.6,
            alignment: Alignment.topRight,
          );
          expect(attribute, resolvesTo(expectedDecorator));
        },
      );

      test('resolves with null values', () {
        final attribute = FractionallySizedBoxWidgetDecoratorMix();

        const expectedDecorator = FractionallySizedBoxWidgetDecorator();
        expect(attribute, resolvesTo(expectedDecorator));
      });
    });

    group('merge', () {
      test('merges with other FractionallySizedBoxWidgetDecoratorMix', () {
        final attribute1 = FractionallySizedBoxWidgetDecoratorMix(
          widthFactor: 0.5,
          heightFactor: 0.5,
        );
        final attribute2 = FractionallySizedBoxWidgetDecoratorMix(
          widthFactor: 0.8,
          alignment: Alignment.topLeft,
        );

        final merged = attribute1.merge(attribute2);

        expectProp(merged.widthFactor, 0.8); // overridden
        expectProp(merged.heightFactor, 0.5); // preserved
        expectProp(merged.alignment, Alignment.topLeft); // added
      });

      test('returns original when other is null', () {
        final attribute = FractionallySizedBoxWidgetDecoratorMix(
          widthFactor: 0.5,
        );

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });

      test('merges with null values', () {
        final attribute1 = FractionallySizedBoxWidgetDecoratorMix();
        final attribute2 = FractionallySizedBoxWidgetDecoratorMix(
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
        final attribute1 = FractionallySizedBoxWidgetDecoratorMix(
          widthFactor: 0.5,
          heightFactor: 0.8,
          alignment: Alignment.center,
        );
        final attribute2 = FractionallySizedBoxWidgetDecoratorMix(
          widthFactor: 0.5,
          heightFactor: 0.8,
          alignment: Alignment.center,
        );

        expect(attribute1, equals(attribute2));
      });

      test('not equal when values differ', () {
        final attribute1 = FractionallySizedBoxWidgetDecoratorMix(
          widthFactor: 0.5,
        );
        final attribute2 = FractionallySizedBoxWidgetDecoratorMix(
          widthFactor: 0.8,
        );

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('props contains all Prop values', () {
        final attribute = FractionallySizedBoxWidgetDecoratorMix(
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

  group('FractionallySizedBoxWidgetDecoratorUtility', () {
    late FractionallySizedBoxWidgetDecoratorUtility<
      MockStyle<FractionallySizedBoxWidgetDecoratorMix>
    >
    utility;

    setUp(() {
      utility = FractionallySizedBoxWidgetDecoratorUtility(
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
      'FractionallySizedBoxWidgetDecoratorMix resolves and builds correctly',
      (WidgetTester tester) async {
        final attribute = FractionallySizedBoxWidgetDecoratorMix(
          widthFactor: 0.7,
          heightFactor: 0.9,
          alignment: Alignment.bottomCenter,
        );

        const expectedDecorator = FractionallySizedBoxWidgetDecorator(
          widthFactor: 0.7,
          heightFactor: 0.9,
          alignment: Alignment.bottomCenter,
        );
        expect(attribute, resolvesTo(expectedDecorator));

        final decorator = attribute.resolve(MockBuildContext());
        const child = SizedBox(width: 100, height: 100);

        await tester.pumpWidget(decorator.build(child));

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
      final base = FractionallySizedBoxWidgetDecoratorMix(
        widthFactor: 0.5,
        heightFactor: 0.5,
        alignment: Alignment.center,
      );

      final override1 = FractionallySizedBoxWidgetDecoratorMix(
        widthFactor: 0.8,
        heightFactor: 0.8,
      );

      final override2 = FractionallySizedBoxWidgetDecoratorMix(
        alignment: Alignment.topLeft,
      );

      final result = base.merge(override1).merge(override2);

      expectProp(result.widthFactor, 0.8);
      expectProp(result.heightFactor, 0.8);
      expectProp(result.alignment, Alignment.topLeft);
    });

    test('Lerp produces expected intermediate values', () {
      const start = FractionallySizedBoxWidgetDecorator(
        widthFactor: 0.0,
        heightFactor: 0.0,
        alignment: Alignment.topLeft,
      );
      const end = FractionallySizedBoxWidgetDecorator(
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
