import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('ScrollViewWidgetModifier', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        const modifier = ScrollViewWidgetModifier();

        expect(modifier.scrollDirection, isNull);
        expect(modifier.reverse, isNull);
        expect(modifier.padding, isNull);
        expect(modifier.physics, isNull);
        expect(modifier.clipBehavior, isNull);
      });

      test('assigns all parameters correctly', () {
        const scrollDirection = Axis.horizontal;
        const reverse = true;
        const padding = EdgeInsets.all(16.0);
        const physics = BouncingScrollPhysics();
        const clipBehavior = Clip.antiAlias;

        const modifier = ScrollViewWidgetModifier(
          scrollDirection: scrollDirection,
          reverse: reverse,
          padding: padding,
          physics: physics,
          clipBehavior: clipBehavior,
        );

        expect(modifier.scrollDirection, scrollDirection);
        expect(modifier.reverse, reverse);
        expect(modifier.padding, padding);
        expect(modifier.physics, physics);
        expect(modifier.clipBehavior, clipBehavior);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated values', () {
        const original = ScrollViewWidgetModifier(
          scrollDirection: Axis.vertical,
          reverse: false,
          padding: EdgeInsets.all(10.0),
          physics: ClampingScrollPhysics(),
          clipBehavior: Clip.hardEdge,
        );

        final updated = original.copyWith(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: const EdgeInsets.all(20.0),
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.antiAlias,
        );

        expect(updated.scrollDirection, Axis.horizontal);
        expect(updated.reverse, true);
        expect(updated.padding, const EdgeInsets.all(20.0));
        expect(updated.physics, isA<BouncingScrollPhysics>());
        expect(updated.clipBehavior, Clip.antiAlias);
        expect(updated, isNot(same(original)));
      });

      test('preserves original values when parameters are null', () {
        const original = ScrollViewWidgetModifier(
          scrollDirection: Axis.vertical,
          reverse: true,
          padding: EdgeInsets.all(10.0),
          physics: BouncingScrollPhysics(),
          clipBehavior: Clip.antiAlias,
        );

        final updated = original.copyWith();

        expect(updated.scrollDirection, original.scrollDirection);
        expect(updated.reverse, original.reverse);
        expect(updated.padding, original.padding);
        expect(updated.physics, original.physics);
        expect(updated.clipBehavior, original.clipBehavior);
        expect(updated, isNot(same(original)));
      });

      test('allows partial updates', () {
        const original = ScrollViewWidgetModifier(
          scrollDirection: Axis.vertical,
          reverse: false,
          padding: EdgeInsets.all(10.0),
        );

        final updatedDirection = original.copyWith(
          scrollDirection: Axis.horizontal,
        );
        expect(updatedDirection.scrollDirection, Axis.horizontal);
        expect(updatedDirection.reverse, original.reverse);
        expect(updatedDirection.padding, original.padding);

        final updatedReverse = original.copyWith(reverse: true);
        expect(updatedReverse.scrollDirection, original.scrollDirection);
        expect(updatedReverse.reverse, true);
        expect(updatedReverse.padding, original.padding);
      });
    });

    group('lerp', () {
      test('uses step function for scrollDirection', () {
        const start = ScrollViewWidgetModifier(scrollDirection: Axis.vertical);
        const end = ScrollViewWidgetModifier(scrollDirection: Axis.horizontal);

        expect(start.lerp(end, 0.0).scrollDirection, Axis.vertical);
        expect(start.lerp(end, 0.49).scrollDirection, Axis.vertical);
        expect(start.lerp(end, 0.5).scrollDirection, Axis.horizontal);
        expect(start.lerp(end, 1.0).scrollDirection, Axis.horizontal);
      });

      test('uses step function for reverse', () {
        const start = ScrollViewWidgetModifier(reverse: false);
        const end = ScrollViewWidgetModifier(reverse: true);

        expect(start.lerp(end, 0.0).reverse, false);
        expect(start.lerp(end, 0.49).reverse, false);
        expect(start.lerp(end, 0.5).reverse, true);
        expect(start.lerp(end, 1.0).reverse, true);
      });

      test('interpolates padding correctly', () {
        const start = ScrollViewWidgetModifier(padding: EdgeInsets.all(10.0));
        const end = ScrollViewWidgetModifier(padding: EdgeInsets.all(30.0));
        final result = start.lerp(end, 0.5);

        expect(result.padding, const EdgeInsets.all(20.0));
      });

      test('uses step function for physics', () {
        const start = ScrollViewWidgetModifier(
          physics: BouncingScrollPhysics(),
        );
        const end = ScrollViewWidgetModifier(physics: ClampingScrollPhysics());

        expect(start.lerp(end, 0.49).physics, isA<BouncingScrollPhysics>());
        expect(start.lerp(end, 0.5).physics, isA<ClampingScrollPhysics>());
      });

      test('uses step function for clipBehavior', () {
        const start = ScrollViewWidgetModifier(clipBehavior: Clip.hardEdge);
        const end = ScrollViewWidgetModifier(clipBehavior: Clip.antiAlias);

        expect(start.lerp(end, 0.49).clipBehavior, Clip.hardEdge);
        expect(start.lerp(end, 0.5).clipBehavior, Clip.antiAlias);
      });

      test('handles null other parameter', () {
        const start = ScrollViewWidgetModifier(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: EdgeInsets.all(10.0),
        );
        final result = start.lerp(null, 0.5);

        expect(result, same(start));
      });

      test('interpolates all properties together', () {
        const start = ScrollViewWidgetModifier(
          scrollDirection: Axis.vertical,
          reverse: false,
          padding: EdgeInsets.all(0.0),
          physics: BouncingScrollPhysics(),
          clipBehavior: Clip.none,
        );
        const end = ScrollViewWidgetModifier(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: EdgeInsets.all(100.0),
          physics: ClampingScrollPhysics(),
          clipBehavior: Clip.antiAlias,
        );

        final result = start.lerp(end, 0.25);
        expect(result.scrollDirection, Axis.vertical);
        expect(result.reverse, false);
        expect(result.padding, const EdgeInsets.all(25.0));
        expect(result.physics, isA<BouncingScrollPhysics>());
        expect(result.clipBehavior, Clip.none);

        final result2 = start.lerp(end, 0.75);
        expect(result2.scrollDirection, Axis.horizontal);
        expect(result2.reverse, true);
        expect(result2.padding, const EdgeInsets.all(75.0));
        expect(result2.physics, isA<ClampingScrollPhysics>());
        expect(result2.clipBehavior, Clip.antiAlias);
      });
    });

    group('equality and hashCode', () {
      test('equal when all properties match', () {
        const modifier1 = ScrollViewWidgetModifier(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: EdgeInsets.all(16.0),
          clipBehavior: Clip.antiAlias,
        );
        const modifier2 = ScrollViewWidgetModifier(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: EdgeInsets.all(16.0),
          clipBehavior: Clip.antiAlias,
        );

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });

      test('physics instances affect equality', () {
        // With const, Dart might optimize to the same instance
        const modifier1 = ScrollViewWidgetModifier(
          physics: BouncingScrollPhysics(),
        );
        const modifier2 = ScrollViewWidgetModifier(
          physics: BouncingScrollPhysics(),
        );

        // These might be equal due to const optimization
        // Different physics types should definitely not be equal
        const modifier3 = ScrollViewWidgetModifier(
          physics: ClampingScrollPhysics(),
        );

        expect(modifier1, isNot(equals(modifier3)));
        expect(modifier1, equals(modifier2));
      });

      test('not equal when any property differs', () {
        const base = ScrollViewWidgetModifier(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: EdgeInsets.all(16.0),
        );

        const differentDirection = ScrollViewWidgetModifier(
          scrollDirection: Axis.vertical,
          reverse: true,
          padding: EdgeInsets.all(16.0),
        );

        const differentReverse = ScrollViewWidgetModifier(
          scrollDirection: Axis.horizontal,
          reverse: false,
          padding: EdgeInsets.all(16.0),
        );

        const differentPadding = ScrollViewWidgetModifier(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: EdgeInsets.all(32.0),
        );

        expect(base, isNot(equals(differentDirection)));
        expect(base, isNot(equals(differentReverse)));
        expect(base, isNot(equals(differentPadding)));
      });

      test('equal when both have all null values', () {
        const modifier1 = ScrollViewWidgetModifier();
        const modifier2 = ScrollViewWidgetModifier();

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });
    });

    group('props', () {
      test('contains all properties', () {
        const modifier = ScrollViewWidgetModifier(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: EdgeInsets.all(16.0),
          physics: BouncingScrollPhysics(),
          clipBehavior: Clip.antiAlias,
        );

        expect(modifier.props.length, 5);
        expect(modifier.props[0], Axis.horizontal);
        expect(modifier.props[1], true);
        expect(modifier.props[2], const EdgeInsets.all(16.0));
        expect(modifier.props[3], isA<BouncingScrollPhysics>());
        expect(modifier.props[4], Clip.antiAlias);
      });

      test('contains null values', () {
        const modifier = ScrollViewWidgetModifier();

        expect(modifier.props, [null, null, null, null, null]);
      });
    });

    group('build', () {
      testWidgets('creates SingleChildScrollView with default values', (
        WidgetTester tester,
      ) async {
        const modifier = ScrollViewWidgetModifier();
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: modifier.build(child),
          ),
        );

        final scrollView = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );
        expect(scrollView.scrollDirection, Axis.vertical); // default
        expect(scrollView.reverse, false); // default
        expect(scrollView.padding, isNull);
        expect(scrollView.physics, isNull);
        expect(scrollView.clipBehavior, Clip.hardEdge); // default
        expect(scrollView.child, same(child));
      });

      testWidgets('creates SingleChildScrollView with custom values', (
        WidgetTester tester,
      ) async {
        const modifier = ScrollViewWidgetModifier(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: EdgeInsets.all(24.0),
          physics: BouncingScrollPhysics(),
          clipBehavior: Clip.antiAlias,
        );
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: modifier.build(child),
          ),
        );

        final scrollView = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );
        expect(scrollView.scrollDirection, Axis.horizontal);
        expect(scrollView.reverse, true);
        expect(scrollView.padding, const EdgeInsets.all(24.0));
        expect(scrollView.physics, isA<BouncingScrollPhysics>());
        expect(scrollView.clipBehavior, Clip.antiAlias);
        expect(scrollView.child, same(child));
      });
    });
  });

  group('ScrollViewWidgetModifierMix', () {
    group('Constructor', () {
      test('creates with null values by default', () {
        final attribute = ScrollViewWidgetModifierMix();

        expect(attribute.scrollDirection, isNull);
        expect(attribute.reverse, isNull);
        expect(attribute.padding, isNull);
        expect(attribute.physics, isNull);
        expect(attribute.clipBehavior, isNull);
      });

      test('creates with provided Prop values', () {
        final scrollDirection = Prop.value<Axis>(Axis.horizontal);
        final reverse = Prop.value<bool>(true);
        final padding = MixProp<EdgeInsetsGeometry>(EdgeInsetsMix.all(16.0));
        final physics = Prop.value<ScrollPhysics>(
          const BouncingScrollPhysics(),
        );
        final clipBehavior = Prop.value<Clip>(Clip.antiAlias);

        final attribute = ScrollViewWidgetModifierMix.create(
          scrollDirection: scrollDirection,
          reverse: reverse,
          padding: padding,
          physics: physics,
          clipBehavior: clipBehavior,
        );

        expect(attribute.scrollDirection, same(scrollDirection));
        expect(attribute.reverse, same(reverse));
        expect(attribute.padding, same(padding));
        expect(attribute.physics, same(physics));
        expect(attribute.clipBehavior, same(clipBehavior));
      });
    });

    group('only constructor', () {
      test('creates Prop values from direct values', () {
        final attribute = ScrollViewWidgetModifierMix(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: EdgeInsetsMix.all(16.0),
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.antiAlias,
        );

        expectProp(attribute.scrollDirection, Axis.horizontal);
        expectProp(attribute.reverse, true);
        expectProp(attribute.physics, isA<BouncingScrollPhysics>());
        expectProp(attribute.clipBehavior, Clip.antiAlias);
        expect(attribute.padding, isNotNull);
      });

      test('handles null values correctly', () {
        final attribute = ScrollViewWidgetModifierMix();

        expect(attribute.scrollDirection, isNull);
        expect(attribute.reverse, isNull);
        expect(attribute.padding, isNull);
        expect(attribute.physics, isNull);
        expect(attribute.clipBehavior, isNull);
      });

      test('handles partial values', () {
        final attribute1 = ScrollViewWidgetModifierMix(
          scrollDirection: Axis.horizontal,
          reverse: true,
        );
        expectProp(attribute1.scrollDirection, Axis.horizontal);
        expectProp(attribute1.reverse, true);
        expect(attribute1.padding, isNull);
        expect(attribute1.physics, isNull);
        expect(attribute1.clipBehavior, isNull);

        final attribute2 = ScrollViewWidgetModifierMix(
          padding: EdgeInsetsMix.all(16.0),
          physics: const ClampingScrollPhysics(),
        );
        expect(attribute2.scrollDirection, isNull);
        expect(attribute2.reverse, isNull);
        expect(attribute2.padding, isNotNull);
        expectProp(attribute2.physics, isA<ClampingScrollPhysics>());
        expect(attribute2.clipBehavior, isNull);
      });
    });

    group('resolve', () {
      test('resolves to ScrollViewWidgetModifier with resolved values', () {
        final attribute = ScrollViewWidgetModifierMix(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: EdgeInsetsMix.all(16.0),
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.antiAlias,
        );

        expect(
          attribute,
          resolvesTo(
            const ScrollViewWidgetModifier(
              scrollDirection: Axis.horizontal,
              reverse: true,
              padding: EdgeInsets.all(16.0),
              physics: BouncingScrollPhysics(),
              clipBehavior: Clip.antiAlias,
            ),
          ),
        );
      });

      test('resolves with null values', () {
        final attribute = ScrollViewWidgetModifierMix();

        expect(attribute, resolvesTo(const ScrollViewWidgetModifier()));
      });
    });

    group('merge', () {
      test('merges with other ScrollViewWidgetModifierMix', () {
        final attribute1 = ScrollViewWidgetModifierMix(
          scrollDirection: Axis.vertical,
          reverse: false,
          padding: EdgeInsetsMix.all(10.0),
        );
        final attribute2 = ScrollViewWidgetModifierMix(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.antiAlias,
        );

        final merged = attribute1.merge(attribute2);

        expectProp(merged.scrollDirection, Axis.horizontal); // overridden
        expectProp(merged.reverse, false); // preserved
        expect(merged.padding, isNotNull); // preserved
        expectProp(merged.physics, isA<BouncingScrollPhysics>()); // added
        expectProp(merged.clipBehavior, Clip.antiAlias); // added
      });

      test('returns original when other is null', () {
        final attribute = ScrollViewWidgetModifierMix(
          scrollDirection: Axis.horizontal,
        );

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });

      test('merges with null values', () {
        final attribute1 = ScrollViewWidgetModifierMix();
        final attribute2 = ScrollViewWidgetModifierMix(
          scrollDirection: Axis.horizontal,
          reverse: true,
        );

        final merged = attribute1.merge(attribute2);

        expectProp(merged.scrollDirection, Axis.horizontal);
        expectProp(merged.reverse, true);
        expect(merged.padding, isNull);
        expect(merged.physics, isNull);
        expect(merged.clipBehavior, isNull);
      });
    });

    group('equality and props', () {
      test('equal when all Prop values match', () {
        final attribute1 = ScrollViewWidgetModifierMix(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: EdgeInsetsMix.all(16.0),
          clipBehavior: Clip.antiAlias,
        );
        final attribute2 = ScrollViewWidgetModifierMix(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: EdgeInsetsMix.all(16.0),
          clipBehavior: Clip.antiAlias,
        );

        expect(attribute1, equals(attribute2));
      });

      // Note: Physics equality doesn't work properly in Flutter
      // so we can't reliably test physics difference for inequality

      test('not equal when values differ', () {
        final attribute1 = ScrollViewWidgetModifierMix(
          scrollDirection: Axis.horizontal,
        );
        final attribute2 = ScrollViewWidgetModifierMix(
          scrollDirection: Axis.vertical,
        );

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('props contains all Prop values', () {
        final attribute = ScrollViewWidgetModifierMix(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: EdgeInsetsMix.all(16.0),
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.antiAlias,
        );

        final props = attribute.props;
        expect(props.length, 5);
        expect(props[0], attribute.scrollDirection);
        expect(props[1], attribute.reverse);
        expect(props[2], attribute.padding);
        expect(props[3], attribute.physics);
        expect(props[4], attribute.clipBehavior);
      });
    });
  });

  group('ScrollViewWidgetModifierUtility', () {
    late ScrollViewWidgetModifierUtility<
      MockStyle<ScrollViewWidgetModifierMix>
    >
    utility;

    setUp(() {
      utility = ScrollViewWidgetModifierUtility(
        (attribute) => MockStyle(attribute),
      );
    });

    test('call() creates attribute with specified values', () {
      final result = utility.call(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.antiAlias,
      );
      final attribute = result.value;

      expectProp(attribute.scrollDirection, Axis.horizontal);
      expectProp(attribute.reverse, true);
      expect(attribute.padding, isNotNull);
      expectProp(attribute.physics, isA<BouncingScrollPhysics>());
      expectProp(attribute.clipBehavior, Clip.antiAlias);
    });

    test('direction() creates attribute with specified axis', () {
      final result = utility.direction(Axis.horizontal);
      final attribute = result.value;

      expectProp(attribute.scrollDirection, Axis.horizontal);
    });

    test('horizontal() creates attribute with horizontal direction', () {
      final result = utility.horizontal();
      final attribute = result.value;

      expectProp(attribute.scrollDirection, Axis.horizontal);
    });

    test('vertical() creates attribute with vertical direction', () {
      final result = utility.vertical();
      final attribute = result.value;

      expectProp(attribute.scrollDirection, Axis.vertical);
    });

    test('physics() creates attribute with specified physics', () {
      final result = utility.physics(const BouncingScrollPhysics());
      final attribute = result.value;

      expectProp(attribute.physics, isA<BouncingScrollPhysics>());
    });

    test(
      'neverScrollableScrollPhysics() creates attribute with never scrollable physics',
      () {
        final result = utility.neverScrollableScrollPhysics();
        final attribute = result.value;

        expectProp(attribute.physics, isA<NeverScrollableScrollPhysics>());
      },
    );

    test('bouncingScrollPhysics() creates attribute with bouncing physics', () {
      final result = utility.bouncingScrollPhysics();
      final attribute = result.value;

      expectProp(attribute.physics, isA<BouncingScrollPhysics>());
    });

    test('clampingScrollPhysics() creates attribute with clamping physics', () {
      final result = utility.clampingScrollPhysics();
      final attribute = result.value;

      expectProp(attribute.physics, isA<ClampingScrollPhysics>());
    });

    test('reverse utility creates attribute with reverse', () {
      final result = utility.reverse(true);
      final attribute = result.value;

      expectProp(attribute.reverse, true);
    });

    test('padding utility creates attribute with padding', () {
      final result = utility.padding.all(16.0);
      final attribute = result.value;

      // Test that the attribute resolves to a ScrollViewWidgetModifier with padding
      final resolved = attribute.resolve(MockBuildContext());

      expect(resolved.padding, const EdgeInsets.all(16.0));
    });

    test('clipBehavior utility creates attribute with clip behavior', () {
      final result = utility.clipBehavior(Clip.antiAlias);
      final attribute = result.value;

      expectProp(attribute.clipBehavior, Clip.antiAlias);
    });
  });

  group('Integration tests', () {
    testWidgets('ScrollViewWidgetModifierMix resolves and builds correctly', (
      WidgetTester tester,
    ) async {
      final attribute = ScrollViewWidgetModifierMix(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: EdgeInsetsMix.all(24.0),
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.antiAlias,
      );

      expect(
        attribute,
        resolvesTo(
          const ScrollViewWidgetModifier(
            scrollDirection: Axis.horizontal,
            reverse: true,
            padding: EdgeInsets.all(24.0),
            physics: BouncingScrollPhysics(),
            clipBehavior: Clip.antiAlias,
          ),
        ),
      );

      final modifier = attribute.resolve(MockBuildContext());
      const child = SizedBox(width: 1000, height: 100);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 200,
            height: 200,
            child: modifier.build(child),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.scrollDirection, Axis.horizontal);
      expect(scrollView.reverse, true);
      expect(scrollView.padding, const EdgeInsets.all(24.0));
      expect(scrollView.physics, isA<BouncingScrollPhysics>());
      expect(scrollView.clipBehavior, Clip.antiAlias);
      expect(scrollView.child, same(child));
    });

    test('Complex merge scenario preserves and overrides correctly', () {
      final base = ScrollViewWidgetModifierMix(
        scrollDirection: Axis.vertical,
        reverse: false,
        padding: EdgeInsetsMix.all(10.0),
      );

      final override1 = ScrollViewWidgetModifierMix(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
      );

      final override2 = ScrollViewWidgetModifierMix(
        reverse: true,
        clipBehavior: Clip.antiAlias,
      );

      final result = base.merge(override1).merge(override2);

      expectProp(result.scrollDirection, Axis.horizontal);
      expectProp(result.reverse, true);
      expect(result.padding, isNotNull);
      expectProp(result.physics, isA<ClampingScrollPhysics>());
      expectProp(result.clipBehavior, Clip.antiAlias);
    });

    test('Lerp produces expected intermediate values', () {
      const start = ScrollViewWidgetModifier(
        scrollDirection: Axis.vertical,
        reverse: false,
        padding: EdgeInsets.all(0.0),
        physics: BouncingScrollPhysics(),
        clipBehavior: Clip.none,
      );
      const end = ScrollViewWidgetModifier(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: EdgeInsets.all(100.0),
        physics: ClampingScrollPhysics(),
        clipBehavior: Clip.antiAlias,
      );

      final quarter = start.lerp(end, 0.25);
      final half = start.lerp(end, 0.5);
      final threeQuarter = start.lerp(end, 0.75);

      // Step functions for non-interpolatable properties
      expect(quarter.scrollDirection, Axis.vertical);
      expect(quarter.reverse, false);
      expect(quarter.physics, isA<BouncingScrollPhysics>());
      expect(quarter.clipBehavior, Clip.none);

      expect(half.scrollDirection, Axis.horizontal);
      expect(half.reverse, true);
      expect(half.physics, isA<ClampingScrollPhysics>());
      expect(half.clipBehavior, Clip.antiAlias);

      // Continuous interpolation for padding
      expect(quarter.padding, const EdgeInsets.all(25.0));
      expect(half.padding, const EdgeInsets.all(50.0));
      expect(threeQuarter.padding, const EdgeInsets.all(75.0));
    });
  });
}
