import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('PaddingWidgetDecorator', () {
    group('Constructor', () {
      test('creates with zero padding by default', () {
        const decorator = PaddingWidgetDecorator();

        expect(decorator.padding, EdgeInsets.zero);
      });

      test('creates with specified padding', () {
        const padding = EdgeInsets.all(16.0);
        const decorator = PaddingWidgetDecorator(padding);

        expect(decorator.padding, padding);
      });

      test('creates with null padding defaults to zero', () {
        const decorator = PaddingWidgetDecorator(null);

        expect(decorator.padding, EdgeInsets.zero);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated padding', () {
        const original = PaddingWidgetDecorator(EdgeInsets.all(10.0));
        final updated = original.copyWith(padding: const EdgeInsets.all(20.0));

        expect(updated.padding, const EdgeInsets.all(20.0));
        expect(updated, isNot(same(original)));
      });

      test('preserves original value when parameter is null', () {
        const original = PaddingWidgetDecorator(EdgeInsets.all(10.0));
        final updated = original.copyWith();

        expect(updated.padding, original.padding);
        expect(updated, isNot(same(original)));
      });
    });

    group('lerp', () {
      test('interpolates padding correctly', () {
        const start = PaddingWidgetDecorator(EdgeInsets.all(10.0));
        const end = PaddingWidgetDecorator(EdgeInsets.all(30.0));
        final result = start.lerp(end, 0.5);

        expect(result.padding, const EdgeInsets.all(20.0));
      });

      test('interpolates asymmetric padding correctly', () {
        const start = PaddingWidgetDecorator(EdgeInsets.fromLTRB(10, 20, 30, 40));
        const end = PaddingWidgetDecorator(EdgeInsets.fromLTRB(20, 40, 60, 80));
        final result = start.lerp(end, 0.5);

        expect(result.padding, const EdgeInsets.fromLTRB(15, 30, 45, 60));
      });

      test('handles null other parameter', () {
        const start = PaddingWidgetDecorator(EdgeInsets.all(10.0));
        final result = start.lerp(null, 0.5);

        expect(result, same(start));
      });

      test('handles extreme t values', () {
        const start = PaddingWidgetDecorator(EdgeInsets.all(10.0));
        const end = PaddingWidgetDecorator(EdgeInsets.all(30.0));

        final result0 = start.lerp(end, 0.0);
        expect(result0.padding, const EdgeInsets.all(10.0));

        final result1 = start.lerp(end, 1.0);
        expect(result1.padding, const EdgeInsets.all(30.0));
      });
    });

    group('equality and hashCode', () {
      test('equal when padding matches', () {
        const decorator1 = PaddingWidgetDecorator(EdgeInsets.all(10.0));
        const decorator2 = PaddingWidgetDecorator(EdgeInsets.all(10.0));

        expect(decorator1, equals(decorator2));
        expect(decorator1.hashCode, equals(decorator2.hashCode));
      });

      test('not equal when padding differs', () {
        const decorator1 = PaddingWidgetDecorator(EdgeInsets.all(10.0));
        const decorator2 = PaddingWidgetDecorator(EdgeInsets.all(20.0));

        expect(decorator1, isNot(equals(decorator2)));
        // Hash codes might be equal due to hash collisions, so we only test inequality
        expect(decorator1 == decorator2, isFalse);
      });

      test('equal when both have zero padding', () {
        const decorator1 = PaddingWidgetDecorator();
        const decorator2 = PaddingWidgetDecorator(EdgeInsets.zero);

        expect(decorator1, equals(decorator2));
        expect(decorator1.hashCode, equals(decorator2.hashCode));
      });
    });

    group('props', () {
      test('contains padding', () {
        const padding = EdgeInsets.all(16.0);
        const decorator = PaddingWidgetDecorator(padding);

        expect(decorator.props, [padding]);
      });
    });

    group('build', () {
      testWidgets('creates Padding widget with specified padding', (
        WidgetTester tester,
      ) async {
        const padding = EdgeInsets.all(16.0);
        const decorator = PaddingWidgetDecorator(padding);
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(decorator.build(child));

        final paddingWidget = tester.widget<Padding>(find.byType(Padding));
        expect(paddingWidget.padding, padding);
        expect(paddingWidget.child, same(child));
      });

      testWidgets('creates Padding widget with zero padding by default', (
        WidgetTester tester,
      ) async {
        const decorator = PaddingWidgetDecorator();
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(decorator.build(child));

        final paddingWidget = tester.widget<Padding>(find.byType(Padding));
        expect(paddingWidget.padding, EdgeInsets.zero);
        expect(paddingWidget.child, same(child));
      });
    });
  });

  group('PaddingWidgetDecoratorMix', () {
    group('Constructor', () {
      test('creates with null padding by default', () {
        final attribute = PaddingWidgetDecoratorMix();

        expect(attribute.padding, isNull);
      });

      test('creates with provided MixProp padding', () {
        final padding = MixProp<EdgeInsetsGeometry>(EdgeInsetsMix.all(16.0));
        final attribute = PaddingWidgetDecoratorMix.raw(padding: padding);

        expect(attribute.padding, same(padding));
      });
    });

    group('only constructor', () {
      test('creates MixProp from EdgeInsetsMix', () {
        final edgeInsetsMix = EdgeInsetsMix.all(16.0);
        final attribute = PaddingWidgetDecoratorMix(padding: edgeInsetsMix);

        expectProp(attribute.padding, edgeInsetsMix);
      });

      test('handles null padding', () {
        final attribute = PaddingWidgetDecoratorMix();

        expect(attribute.padding, isNull);
      });

      test('creates from EdgeInsets values', () {
        final edgeInsetsMix = EdgeInsetsMix(
          top: 10.0,
          bottom: 20.0,
          left: 30.0,
          right: 40.0,
        );
        final attribute = PaddingWidgetDecoratorMix(padding: edgeInsetsMix);

        expect(attribute.padding, isNotNull);
        expectProp(attribute.padding, isA<EdgeInsetsMix>());
        expect(
          attribute,
          resolvesTo(
            const PaddingWidgetDecorator(EdgeInsets.fromLTRB(30, 10, 40, 20)),
          ),
        );
      });
    });

    group('resolve', () {
      test('resolves to PaddingWidgetDecorator with resolved padding', () {
        final edgeInsetsMix = EdgeInsetsMix.all(16.0);
        final attribute = PaddingWidgetDecoratorMix(padding: edgeInsetsMix);

        expect(
          attribute,
          resolvesTo(const PaddingWidgetDecorator(EdgeInsets.all(16.0))),
        );
      });

      test('resolves with null padding to zero padding', () {
        final attribute = PaddingWidgetDecoratorMix();

        expect(attribute, resolvesTo(const PaddingWidgetDecorator(EdgeInsets.zero)));
      });

      test('resolves EdgeInsetsDirectionalMix correctly', () {
        final edgeInsetsMix = EdgeInsetsDirectionalMix(
          top: 10.0,
          bottom: 20.0,
          start: 30.0,
          end: 40.0,
        );
        final attribute = PaddingWidgetDecoratorMix(padding: edgeInsetsMix);

        expect(
          attribute,
          resolvesTo(
            const PaddingWidgetDecorator(
              EdgeInsetsDirectional.fromSTEB(30, 10, 40, 20),
            ),
          ),
        );
      });
    });

    group('merge', () {
      test('merges with other PaddingWidgetDecoratorMix', () {
        final attribute1 = PaddingWidgetDecoratorMix(
          padding: EdgeInsetsMix.all(10.0),
        );
        final attribute2 = PaddingWidgetDecoratorMix(
          padding: EdgeInsetsMix.all(20.0),
        );

        final merged = attribute1.merge(attribute2);

        // MixProp accumulates, but since both set all sides, second wins
        expect(merged.padding, isNotNull);
        expect(merged, resolvesTo(const PaddingWidgetDecorator(EdgeInsets.all(20.0))));
      });

      test('returns original when other is null', () {
        final attribute = PaddingWidgetDecoratorMix(
          padding: EdgeInsetsMix.all(10.0),
        );

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });

      test('merges with partial values', () {
        final attribute1 = PaddingWidgetDecoratorMix(
          padding: EdgeInsetsMix(top: 10.0, bottom: 10.0),
        );
        final attribute2 = PaddingWidgetDecoratorMix(
          padding: EdgeInsetsMix(left: 20.0, right: 20.0),
        );

        final merged = attribute1.merge(attribute2);

        // MixProp accumulates - properties from both attributes combine
        expect(merged.padding, isNotNull);
        expect(
          merged,
          resolvesTo(
            const PaddingWidgetDecorator(EdgeInsets.fromLTRB(20, 10, 20, 10)),
          ),
        );
      });
    });

    group('equality and props', () {
      test('equal when padding matches', () {
        final attribute1 = PaddingWidgetDecoratorMix(
          padding: EdgeInsetsMix.all(16.0),
        );
        final attribute2 = PaddingWidgetDecoratorMix(
          padding: EdgeInsetsMix.all(16.0),
        );

        expect(attribute1, equals(attribute2));
      });

      test('not equal when padding differs', () {
        final attribute1 = PaddingWidgetDecoratorMix(
          padding: EdgeInsetsMix.all(10.0),
        );
        final attribute2 = PaddingWidgetDecoratorMix(
          padding: EdgeInsetsMix.all(20.0),
        );

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('props contains padding', () {
        final attribute = PaddingWidgetDecoratorMix(
          padding: EdgeInsetsMix.all(16.0),
        );

        final props = attribute.props;
        expect(props.length, 1);
        expect(props[0], attribute.padding);
      });
    });
  });

  group('PaddingWidgetDecoratorUtility', () {
    late PaddingWidgetDecoratorUtility<MockStyle<PaddingWidgetDecoratorMix>> utility;

    setUp(() {
      utility = PaddingWidgetDecoratorUtility((attribute) => MockStyle(attribute));
    });

    test('call() creates attribute with specified padding', () {
      final edgeInsetsMix = EdgeInsetsMix.all(16.0);
      final result = utility.call(padding: edgeInsetsMix);
      final attribute = result.value;

      expectProp(attribute.padding, edgeInsetsMix);
    });

    test('call() handles null padding', () {
      final result = utility.call();
      final attribute = result.value;

      expect(attribute.padding, isNull);
    });

    test('padding utility creates attributes', () {
      final result = utility.call(padding: EdgeInsetsMix.all(16.0));
      final attribute = result.value;

      expect(attribute.padding, isNotNull);
      expectProp(attribute.padding, isA<EdgeInsetsMix>());
      expect(
        attribute,
        resolvesTo(const PaddingWidgetDecorator(EdgeInsets.all(16.0))),
      );
    });

    test('padding utility supports various configurations', () {
      // Test all padding
      final allResult = utility.call(padding: EdgeInsetsMix.all(16.0));
      final allAttr = allResult.value;
      expect(allAttr, resolvesTo(const PaddingWidgetDecorator(EdgeInsets.all(16.0))));

      // Test horizontal padding
      final horizontalResult = utility.call(
        padding: EdgeInsetsMix.symmetric(horizontal: 15.0),
      );
      final horizontalAttr = horizontalResult.value;
      expect(
        horizontalAttr,
        resolvesTo(
          const PaddingWidgetDecorator(EdgeInsets.symmetric(horizontal: 15.0)),
        ),
      );

      // Test vertical padding
      final verticalResult = utility.call(
        padding: EdgeInsetsMix.symmetric(vertical: 25.0),
      );
      final verticalAttr = verticalResult.value;
      expect(
        verticalAttr,
        resolvesTo(const PaddingWidgetDecorator(EdgeInsets.symmetric(vertical: 25.0))),
      );

      // Test individual sides
      final topResult = utility.call(padding: EdgeInsetsMix(top: 10.0));
      final topAttr = topResult.value;
      expect(topAttr, resolvesTo(PaddingWidgetDecorator(EdgeInsets.only(top: 10.0))));

      final leftResult = utility.call(padding: EdgeInsetsMix(left: 20.0));
      final leftAttr = leftResult.value;
      expect(
        leftAttr,
        resolvesTo(PaddingWidgetDecorator(EdgeInsets.only(left: 20.0))),
      );
    });
  });

  group('Integration tests', () {
    testWidgets('PaddingWidgetDecoratorMix resolves and builds correctly', (
      WidgetTester tester,
    ) async {
      final attribute = PaddingWidgetDecoratorMix(
        padding: EdgeInsetsMix.all(24.0),
      );

      expect(
        attribute,
        resolvesTo(const PaddingWidgetDecorator(EdgeInsets.all(24.0))),
      );

      final decorator = attribute.resolve(MockBuildContext());
      const child = SizedBox(width: 100, height: 100);

      await tester.pumpWidget(decorator.build(child));

      final paddingWidget = tester.widget<Padding>(find.byType(Padding));
      expect(paddingWidget.padding, const EdgeInsets.all(24.0));
      expect(paddingWidget.child, same(child));
    });

    test('Complex merge scenario preserves and overrides correctly', () {
      final base = PaddingWidgetDecoratorMix(padding: EdgeInsetsMix.all(10.0));

      final override1 = PaddingWidgetDecoratorMix(
        padding: EdgeInsetsMix(
          left: 20.0,
          right: 20.0,
          top: 10.0,
          bottom: 10.0,
        ),
      );

      final override2 = PaddingWidgetDecoratorMix(
        padding: EdgeInsetsMix(top: 30.0),
      );

      final result = base.merge(override1).merge(override2);

      // MixProp accumulates: base -> override1 -> override2
      // Final result: left/right from override1, top from override2, bottom from override1
      expect(
        result,
        resolvesTo(const PaddingWidgetDecorator(EdgeInsets.fromLTRB(20, 30, 20, 10))),
      );
    });

    test('Lerp produces expected intermediate values', () {
      const start = PaddingWidgetDecorator(EdgeInsets.all(0.0));
      const end = PaddingWidgetDecorator(EdgeInsets.all(100.0));

      final quarter = start.lerp(end, 0.25);
      final half = start.lerp(end, 0.5);
      final threeQuarter = start.lerp(end, 0.75);

      expect(quarter.padding, const EdgeInsets.all(25.0));
      expect(half.padding, const EdgeInsets.all(50.0));
      expect(threeQuarter.padding, const EdgeInsets.all(75.0));
    });

    test('EdgeInsetsDirectional works correctly', () {
      final attribute = PaddingWidgetDecoratorMix(
        padding: EdgeInsetsDirectionalMix(
          start: 10.0,
          end: 20.0,
          top: 30.0,
          bottom: 40.0,
        ),
      );

      expect(
        attribute,
        resolvesTo(
          const PaddingWidgetDecorator(EdgeInsetsDirectional.fromSTEB(10, 30, 20, 40)),
        ),
      );
    });
  });
}
