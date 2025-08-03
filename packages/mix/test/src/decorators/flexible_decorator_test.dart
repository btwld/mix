import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('FlexibleWidgetDecorator', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        const decorator = FlexibleWidgetDecorator();

        expect(decorator.flex, isNull);
        expect(decorator.fit, isNull);
      });

      test('assigns all parameters correctly', () {
        const flex = 2;
        const fit = FlexFit.tight;
        const decorator = FlexibleWidgetDecorator(flex: flex, fit: fit);

        expect(decorator.flex, flex);
        expect(decorator.fit, fit);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated values', () {
        const original = FlexibleWidgetDecorator(flex: 1, fit: FlexFit.loose);

        final updated = original.copyWith(flex: 3, fit: FlexFit.tight);

        expect(updated.flex, 3);
        expect(updated.fit, FlexFit.tight);
        expect(updated, isNot(same(original)));
      });

      test('preserves original values when parameters are null', () {
        const original = FlexibleWidgetDecorator(flex: 2, fit: FlexFit.tight);

        final updated = original.copyWith();

        expect(updated.flex, original.flex);
        expect(updated.fit, original.fit);
        expect(updated, isNot(same(original)));
      });

      test('allows partial updates', () {
        const original = FlexibleWidgetDecorator(flex: 1, fit: FlexFit.loose);

        final updatedFlex = original.copyWith(flex: 4);
        expect(updatedFlex.flex, 4);
        expect(updatedFlex.fit, original.fit);

        final updatedFit = original.copyWith(fit: FlexFit.tight);
        expect(updatedFit.flex, original.flex);
        expect(updatedFit.fit, FlexFit.tight);
      });
    });

    group('lerp', () {
      test('uses step function for flex', () {
        const start = FlexibleWidgetDecorator(flex: 1);
        const end = FlexibleWidgetDecorator(flex: 3);

        expect(start.lerp(end, 0.0).flex, 1);
        expect(start.lerp(end, 0.49).flex, 1);
        expect(start.lerp(end, 0.5).flex, 3);
        expect(start.lerp(end, 1.0).flex, 3);
      });

      test('uses step function for fit', () {
        const start = FlexibleWidgetDecorator(fit: FlexFit.loose);
        const end = FlexibleWidgetDecorator(fit: FlexFit.tight);

        expect(start.lerp(end, 0.0).fit, FlexFit.loose);
        expect(start.lerp(end, 0.49).fit, FlexFit.loose);
        expect(start.lerp(end, 0.5).fit, FlexFit.tight);
        expect(start.lerp(end, 1.0).fit, FlexFit.tight);
      });

      test('interpolates all properties together', () {
        const start = FlexibleWidgetDecorator(flex: 1, fit: FlexFit.loose);
        const end = FlexibleWidgetDecorator(flex: 5, fit: FlexFit.tight);

        final result = start.lerp(end, 0.3);
        expect(result.flex, 1);
        expect(result.fit, FlexFit.loose);

        final result2 = start.lerp(end, 0.7);
        expect(result2.flex, 5);
        expect(result2.fit, FlexFit.tight);
      });

      test('handles null other parameter', () {
        const start = FlexibleWidgetDecorator(flex: 2, fit: FlexFit.tight);
        final result = start.lerp(null, 0.5);

        expect(result, same(start));
      });

      test('handles null values in properties', () {
        const start = FlexibleWidgetDecorator(flex: 1);
        const end = FlexibleWidgetDecorator(fit: FlexFit.tight);
        final result = start.lerp(end, 0.5);

        expect(result.flex, isNull);
        expect(result.fit, FlexFit.tight);
      });
    });

    group('equality and hashCode', () {
      test('equal when all properties match', () {
        const decorator1 = FlexibleWidgetDecorator(flex: 2, fit: FlexFit.tight);
        const decorator2 = FlexibleWidgetDecorator(flex: 2, fit: FlexFit.tight);

        expect(decorator1, equals(decorator2));
        expect(decorator1.hashCode, equals(decorator2.hashCode));
      });

      test('not equal when flex differs', () {
        const decorator1 = FlexibleWidgetDecorator(flex: 1);
        const decorator2 = FlexibleWidgetDecorator(flex: 2);

        expect(decorator1, isNot(equals(decorator2)));
      });

      test('not equal when fit differs', () {
        const decorator1 = FlexibleWidgetDecorator(fit: FlexFit.loose);
        const decorator2 = FlexibleWidgetDecorator(fit: FlexFit.tight);

        expect(decorator1, isNot(equals(decorator2)));
      });

      test('equal when both have all null values', () {
        const decorator1 = FlexibleWidgetDecorator();
        const decorator2 = FlexibleWidgetDecorator();

        expect(decorator1, equals(decorator2));
        expect(decorator1.hashCode, equals(decorator2.hashCode));
      });
    });

    group('props', () {
      test('contains all properties', () {
        const decorator = FlexibleWidgetDecorator(flex: 3, fit: FlexFit.tight);

        expect(decorator.props, [3, FlexFit.tight]);
      });

      test('contains null values', () {
        const decorator = FlexibleWidgetDecorator();

        expect(decorator.props, [null, null]);
      });
    });

    group('build', () {
      testWidgets('creates Flexible widget with default values', (
        WidgetTester tester,
      ) async {
        const decorator = FlexibleWidgetDecorator();
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(children: [decorator.build(child)]),
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
        const decorator = FlexibleWidgetDecorator(flex: 3, fit: FlexFit.tight);
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(children: [decorator.build(child)]),
          ),
        );

        final flexible = tester.widget<Flexible>(find.byType(Flexible));
        expect(flexible.flex, 3);
        expect(flexible.fit, FlexFit.tight);
        expect(flexible.child, same(child));
      });
    });
  });

  group('FlexibleWidgetDecoratorMix', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        final attribute = FlexibleWidgetDecoratorMix();

        expect(attribute.flex, isNull);
        expect(attribute.fit, isNull);
      });

      test('creates with provided Prop values', () {
        final flex = Prop.value(2);
        final fit = Prop.value(FlexFit.tight);
        final attribute = FlexibleWidgetDecoratorMix.raw(flex: flex, fit: fit);

        expect(attribute.flex, same(flex));
        expect(attribute.fit, same(fit));
      });
    });

    group('only constructor', () {
      test('creates Prop values from direct values', () {
        final attribute = FlexibleWidgetDecoratorMix(
          flex: 3,
          fit: FlexFit.loose,
        );

        expectProp(attribute.flex, 3);
        expectProp(attribute.fit, FlexFit.loose);
      });

      test('handles null values correctly', () {
        final attribute = FlexibleWidgetDecoratorMix();

        expect(attribute.flex, isNull);
        expect(attribute.fit, isNull);
      });

      test('handles partial values', () {
        final attribute1 = FlexibleWidgetDecoratorMix(flex: 2);
        expectProp(attribute1.flex, 2);
        expect(attribute1.fit, isNull);

        final attribute2 = FlexibleWidgetDecoratorMix(fit: FlexFit.tight);
        expect(attribute2.flex, isNull);
        expectProp(attribute2.fit, FlexFit.tight);
      });
    });

    group('resolve', () {
      test('resolves to FlexibleWidgetDecorator with resolved values', () {
        final attribute = FlexibleWidgetDecoratorMix(
          flex: 4,
          fit: FlexFit.tight,
        );

        expect(
          attribute,
          resolvesTo(const FlexibleWidgetDecorator(flex: 4, fit: FlexFit.tight)),
        );
      });

      test('resolves with null values', () {
        final attribute = FlexibleWidgetDecoratorMix();

        expect(attribute, resolvesTo(const FlexibleWidgetDecorator()));
      });
    });

    group('merge', () {
      test('merges with other FlexibleWidgetDecoratorMix', () {
        final attribute1 = FlexibleWidgetDecoratorMix(
          flex: 1,
          fit: FlexFit.loose,
        );
        final attribute2 = FlexibleWidgetDecoratorMix(
          flex: 3,
          fit: FlexFit.tight,
        );

        final merged = attribute1.merge(attribute2);

        expectProp(merged.flex, 3); // overridden
        expectProp(merged.fit, FlexFit.tight); // overridden
      });

      test('returns original when other is null', () {
        final attribute = FlexibleWidgetDecoratorMix(flex: 2);

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });

      test('merges with null values', () {
        final attribute1 = FlexibleWidgetDecoratorMix();
        final attribute2 = FlexibleWidgetDecoratorMix(fit: FlexFit.tight);

        final merged = attribute1.merge(attribute2);

        expect(merged.flex, isNull);
        expectProp(merged.fit, FlexFit.tight);
      });
    });

    group('equality and props', () {
      test('equal when all Prop values match', () {
        final attribute1 = FlexibleWidgetDecoratorMix(
          flex: 2,
          fit: FlexFit.tight,
        );
        final attribute2 = FlexibleWidgetDecoratorMix(
          flex: 2,
          fit: FlexFit.tight,
        );

        expect(attribute1, equals(attribute2));
      });

      test('not equal when values differ', () {
        final attribute1 = FlexibleWidgetDecoratorMix(flex: 1);
        final attribute2 = FlexibleWidgetDecoratorMix(flex: 2);

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('props contains all Prop values', () {
        final attribute = FlexibleWidgetDecoratorMix(
          flex: 3,
          fit: FlexFit.tight,
        );

        final props = attribute.props;
        expect(props.length, 2);
        expect(props[0], attribute.flex);
        expect(props[1], attribute.fit);
      });
    });
  });

  group('FlexibleWidgetDecoratorUtility', () {
    late FlexibleWidgetDecoratorUtility<MockStyle<FlexibleWidgetDecoratorMix>> utility;

    setUp(() {
      utility = FlexibleWidgetDecoratorUtility((attribute) => MockStyle(attribute));
    });

    test('tight() creates attribute with tight fit', () {
      final result = utility.tight();
      final attribute = result.value;

      expect(attribute.flex, isNull);
      expectProp(attribute.fit, FlexFit.tight);
    });

    test('tight() with flex creates attribute with tight fit and flex', () {
      final result = utility.tight(flex: 3);
      final attribute = result.value;

      expectProp(attribute.flex, 3);
      expectProp(attribute.fit, FlexFit.tight);
    });

    test('loose() creates attribute with loose fit', () {
      final result = utility.loose();
      final attribute = result.value;

      expect(attribute.flex, isNull);
      expectProp(attribute.fit, FlexFit.loose);
    });

    test('loose() with flex creates attribute with loose fit and flex', () {
      final result = utility.loose(flex: 2);
      final attribute = result.value;

      expectProp(attribute.flex, 2);
      expectProp(attribute.fit, FlexFit.loose);
    });

    test('expanded() is alias for tight()', () {
      final expanded = utility.expanded();
      final expandedAttr = expanded.value;

      expect(expandedAttr.flex, isNull);
      expectProp(expandedAttr.fit, FlexFit.tight);
    });

    test('expanded() with flex is alias for tight() with flex', () {
      final expanded = utility.expanded(flex: 4);
      final expandedAttr = expanded.value;

      expectProp(expandedAttr.flex, 4);
      expectProp(expandedAttr.fit, FlexFit.tight);
    });

    test('call() creates attribute with specified values', () {
      final result = utility.call(flex: 5, fit: FlexFit.tight);
      final attribute = result.value;

      expectProp(attribute.flex, 5);
      expectProp(attribute.fit, FlexFit.tight);
    });

    test('call() handles null values', () {
      final result = utility.call();
      final attribute = result.value;

      expect(attribute.flex, isNull);
      expect(attribute.fit, isNull);
    });

    test('flexToken() creates attribute with token', () {
      const token = MixToken<int>('test.flex');
      final result = utility.flexToken(token);
      final attribute = result.value;

      expect(attribute.flex, isA<Prop<int>>());
      expect(attribute.fit, isNull);
    });

    test('fitToken() creates attribute with token', () {
      const token = MixToken<FlexFit>('test.fit');
      final result = utility.fitToken(token);
      final attribute = result.value;

      expect(attribute.flex, isNull);
      expect(attribute.fit, isA<Prop<FlexFit>>());
    });
  });

  group('Integration tests', () {
    testWidgets('FlexibleWidgetDecoratorMix resolves and builds correctly', (
      WidgetTester tester,
    ) async {
      final attribute = FlexibleWidgetDecoratorMix(flex: 2, fit: FlexFit.tight);

      expect(
        attribute,
        resolvesTo(const FlexibleWidgetDecorator(flex: 2, fit: FlexFit.tight)),
      );

      final decorator = attribute.resolve(MockBuildContext());
      const child = SizedBox(width: 100, height: 100);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(children: [decorator.build(child)]),
        ),
      );

      final flexible = tester.widget<Flexible>(find.byType(Flexible));
      expect(flexible.flex, 2);
      expect(flexible.fit, FlexFit.tight);
      expect(flexible.child, same(child));
    });

    test('Complex merge scenario preserves and overrides correctly', () {
      final base = FlexibleWidgetDecoratorMix(flex: 1, fit: FlexFit.loose);

      final override1 = FlexibleWidgetDecoratorMix(flex: 3);

      final override2 = FlexibleWidgetDecoratorMix(fit: FlexFit.tight);

      final result = base.merge(override1).merge(override2);

      expectProp(result.flex, 3);
      expectProp(result.fit, FlexFit.tight);
    });

    test('Lerp with step function behavior', () {
      const start = FlexibleWidgetDecorator(flex: 1, fit: FlexFit.loose);
      const end = FlexibleWidgetDecorator(flex: 5, fit: FlexFit.tight);

      final quarter = start.lerp(end, 0.25);
      final half = start.lerp(end, 0.5);
      final threeQuarter = start.lerp(end, 0.75);

      // Step function behavior
      expect(quarter.flex, 1);
      expect(quarter.fit, FlexFit.loose);

      expect(half.flex, 5);
      expect(half.fit, FlexFit.tight);

      expect(threeQuarter.flex, 5);
      expect(threeQuarter.fit, FlexFit.tight);
    });
  });
}
