import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('SizedBoxWidgetDecorator', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        const decorator = SizedBoxWidgetDecorator();

        expect(decorator.width, isNull);
        expect(decorator.height, isNull);
      });

      test('assigns all parameters correctly', () {
        const width = 100.0;
        const height = 100.0;
        const decorator = SizedBoxWidgetDecorator(width: width, height: height);

        expect(decorator.width, width);
        expect(decorator.height, height);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated values', () {
        const original = SizedBoxWidgetDecorator(width: 100.0, height: 100.0);

        final updated = original.copyWith(width: 200.0, height: 150.0);

        expect(updated.width, 200.0);
        expect(updated.height, 150.0);
        expect(updated, isNot(same(original)));
      });

      test('preserves original values when parameters are null', () {
        const original = SizedBoxWidgetDecorator(width: 100.0, height: 100.0);

        final updated = original.copyWith();

        expect(updated.width, original.width);
        expect(updated.height, original.height);
        expect(updated, isNot(same(original)));
      });

      test('allows partial updates', () {
        const original = SizedBoxWidgetDecorator(width: 100.0, height: 100.0);

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
        const start = SizedBoxWidgetDecorator(width: 100.0);
        const end = SizedBoxWidgetDecorator(width: 200.0);
        final result = start.lerp(end, 0.5);

        expect(result.width, 150.0);
      });

      test('interpolates height correctly', () {
        const start = SizedBoxWidgetDecorator(height: 100.0);
        const end = SizedBoxWidgetDecorator(height: 200.0);
        final result = start.lerp(end, 0.5);

        expect(result.height, 150.0);
      });

      test('interpolates all properties together', () {
        const start = SizedBoxWidgetDecorator(width: 100.0, height: 100.0);
        const end = SizedBoxWidgetDecorator(width: 200.0, height: 200.0);
        final result = start.lerp(end, 0.25);

        expect(result.width, 125.0);
        expect(result.height, 125.0);
      });

      test('handles null other parameter', () {
        const start = SizedBoxWidgetDecorator(width: 100.0, height: 100.0);
        final result = start.lerp(null, 0.5);

        expect(result, same(start));
      });

      test('handles null values in properties', () {
        const start = SizedBoxWidgetDecorator(width: 100.0);
        const end = SizedBoxWidgetDecorator(height: 200.0);
        final result = start.lerp(end, 0.5);

        expect(result.width, 50.0); // 100.0 to 0.0 at t=0.5
        expect(result.height, 100.0); // 0.0 to 200.0 at t=0.5
      });

      test('handles extreme t values', () {
        const start = SizedBoxWidgetDecorator(width: 100.0, height: 100.0);
        const end = SizedBoxWidgetDecorator(width: 200.0, height: 200.0);

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
        const decorator1 = SizedBoxWidgetDecorator(width: 100.0, height: 100.0);
        const decorator2 = SizedBoxWidgetDecorator(width: 100.0, height: 100.0);

        expect(decorator1, equals(decorator2));
        expect(decorator1.hashCode, equals(decorator2.hashCode));
      });

      test('not equal when width differs', () {
        const decorator1 = SizedBoxWidgetDecorator(width: 100.0);
        const decorator2 = SizedBoxWidgetDecorator(width: 200.0);

        expect(decorator1, isNot(equals(decorator2)));
      });

      test('not equal when height differs', () {
        const decorator1 = SizedBoxWidgetDecorator(height: 100.0);
        const decorator2 = SizedBoxWidgetDecorator(height: 200.0);

        expect(decorator1, isNot(equals(decorator2)));
      });

      test('equal when both have all null values', () {
        const decorator1 = SizedBoxWidgetDecorator();
        const decorator2 = SizedBoxWidgetDecorator();

        expect(decorator1, equals(decorator2));
        expect(decorator1.hashCode, equals(decorator2.hashCode));
      });
    });

    group('props', () {
      test('contains all properties', () {
        const decorator = SizedBoxWidgetDecorator(width: 100.0, height: 200.0);

        expect(decorator.props, [100.0, 200.0]);
      });

      test('contains null values', () {
        const decorator = SizedBoxWidgetDecorator();

        expect(decorator.props, [null, null]);
      });
    });

    group('build', () {
      testWidgets('creates SizedBox widget with default values', (
        WidgetTester tester,
      ) async {
        const decorator = SizedBoxWidgetDecorator();
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(decorator.build(child));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.width, isNull);
        expect(sizedBox.height, isNull);
        expect(sizedBox.child, same(child));
      });

      testWidgets('creates SizedBox widget with custom dimensions', (
        WidgetTester tester,
      ) async {
        const decorator = SizedBoxWidgetDecorator(width: 100.0, height: 200.0);
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(decorator.build(child));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.width, 100.0);
        expect(sizedBox.height, 200.0);
        expect(sizedBox.child, same(child));
      });
    });
  });

  group('SizedBoxWidgetDecoratorMix', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        final attribute = SizedBoxWidgetDecoratorMix();

        expect(attribute.width, isNull);
        expect(attribute.height, isNull);
      });

      test('creates with provided Prop values', () {
        final width = Prop.value(100.0);
        final height = Prop.value(200.0);
        final attribute = SizedBoxWidgetDecoratorMix.raw(
          width: width,
          height: height,
        );

        expect(attribute.width, same(width));
        expect(attribute.height, same(height));
      });
    });

    group('only constructor', () {
      test('creates Prop values from direct values', () {
        final attribute = SizedBoxWidgetDecoratorMix(
          width: 100.0,
          height: 200.0,
        );

        expect(attribute.width!, resolvesTo(100.0));
        expect(attribute.height!, resolvesTo(200.0));
      });

      test('handles null values correctly', () {
        final attribute = SizedBoxWidgetDecoratorMix();

        expect(attribute.width, isNull);
        expect(attribute.height, isNull);
      });

      test('handles partial values', () {
        final attribute1 = SizedBoxWidgetDecoratorMix(width: 100.0);
        expect(attribute1.width!, resolvesTo(100.0));
        expect(attribute1.height, isNull);

        final attribute2 = SizedBoxWidgetDecoratorMix(height: 200.0);
        expect(attribute2.width, isNull);
        expect(attribute2.height!, resolvesTo(200.0));
      });
    });

    group('resolve', () {
      test('resolves to SizedBoxWidgetDecorator with resolved values', () {
        final attribute = SizedBoxWidgetDecoratorMix(
          width: 100.0,
          height: 200.0,
        );

        const expectedDecorator = SizedBoxWidgetDecorator(width: 100.0, height: 200.0);

        expect(attribute, resolvesTo(expectedDecorator));
      });

      test('resolves with null values', () {
        final attribute = SizedBoxWidgetDecoratorMix();

        const expectedDecorator = SizedBoxWidgetDecorator();

        expect(attribute, resolvesTo(expectedDecorator));
      });
    });

    group('merge', () {
      test('merges with other SizedBoxWidgetDecoratorMix', () {
        final attribute1 = SizedBoxWidgetDecoratorMix(
          width: 100.0,
          height: 100.0,
        );
        final attribute2 = SizedBoxWidgetDecoratorMix(
          width: 200.0,
          height: 200.0,
        );

        final merged = attribute1.merge(attribute2);

        expect(merged.width!, resolvesTo(200.0)); // overridden
        expect(merged.height!, resolvesTo(200.0)); // overridden
      });

      test('returns original when other is null', () {
        final attribute = SizedBoxWidgetDecoratorMix(width: 100.0);

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });

      test('merges with null values', () {
        final attribute1 = SizedBoxWidgetDecoratorMix();
        final attribute2 = SizedBoxWidgetDecoratorMix(
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
        final attribute1 = SizedBoxWidgetDecoratorMix(
          width: 100.0,
          height: 200.0,
        );
        final attribute2 = SizedBoxWidgetDecoratorMix(
          width: 100.0,
          height: 200.0,
        );

        expect(attribute1, equals(attribute2));
      });

      test('not equal when values differ', () {
        final attribute1 = SizedBoxWidgetDecoratorMix(width: 100.0);
        final attribute2 = SizedBoxWidgetDecoratorMix(width: 200.0);

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('props contains all Prop values', () {
        final attribute = SizedBoxWidgetDecoratorMix(
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
    testWidgets('SizedBoxWidgetDecoratorMix resolves and builds correctly', (
      WidgetTester tester,
    ) async {
      final attribute = SizedBoxWidgetDecoratorMix(width: 150.0, height: 250.0);

      final decorator = attribute.resolve(MockBuildContext());
      const child = SizedBox(width: 100, height: 100);

      await tester.pumpWidget(decorator.build(child));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, 150.0);
      expect(sizedBox.height, 250.0);
      expect(sizedBox.child, same(child));
    });

    test('Complex merge scenario preserves and overrides correctly', () {
      final base = SizedBoxWidgetDecoratorMix(width: 100.0, height: 100.0);

      final override1 = SizedBoxWidgetDecoratorMix(width: 200.0);

      final override2 = SizedBoxWidgetDecoratorMix(height: 300.0);

      final result = base.merge(override1).merge(override2);

      expect(result.width!, resolvesTo(200.0));
      expect(result.height!, resolvesTo(300.0));
    });

    test('Lerp produces expected intermediate values', () {
      const start = SizedBoxWidgetDecorator(width: 100.0, height: 100.0);
      const end = SizedBoxWidgetDecorator(width: 200.0, height: 200.0);

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
