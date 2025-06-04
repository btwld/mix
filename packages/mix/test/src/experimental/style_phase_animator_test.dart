import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/experiemental/style_phase_animator.dart';

enum TestPhases implements PhaseVariant {
  phase1,
  phase2,
  phase3;

  @override
  Variant get variant => Variant(name);
}

void main() {
  group('PhaseAnimationData', () {
    test('should create with default values', () {
      const data = PhaseAnimationData();

      expect(data.duration, const Duration(milliseconds: 200));
      expect(data.curve, Curves.easeInOut);
      expect(data.delay, Duration.zero);
    });

    test('should create with custom values', () {
      const data = PhaseAnimationData(
        duration: Duration(milliseconds: 500),
        curve: Curves.bounceIn,
        delay: Duration(milliseconds: 100),
      );

      expect(data.duration, const Duration(milliseconds: 500));
      expect(data.curve, Curves.bounceIn);
      expect(data.delay, const Duration(milliseconds: 100));
    });

    test('should create zero data', () {
      const data = PhaseAnimationData.zero();

      expect(data.duration, Duration.zero);
      expect(data.curve, Curves.easeInOut);
      expect(data.delay, Duration.zero);
    });
  });

  group('StylePhaseAnimator', () {
    late Map<TestPhases, Style> testPhases;
    late PhaseAnimationData Function(TestPhases) testAnimation;
    late Widget testChild;
    late String testTrigger;

    setUp(() {
      testPhases = {
        TestPhases.phase1: Style($box.height(100), $box.width(100)),
        TestPhases.phase2: Style($box.height(200), $box.width(200)),
        TestPhases.phase3: Style($box.height(300), $box.width(300)),
      };

      testAnimation = (_) => const PhaseAnimationData(
            duration: Duration(milliseconds: 100),
            curve: Curves.linear,
          );

      testChild = Container(key: const Key('test-child'));
      testTrigger = 'initial-trigger';
    });

    BoxSpec getBoxSpec(
      WidgetTester tester, {
      Key key = const Key('test-child'),
    }) {
      final context = tester.element(find.byKey(key));
      return BoxSpec.of(context);
    }

    testWidgets('should start with first phase', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StylePhaseAnimator(
            phases: testPhases,
            animation: testAnimation,
            trigger: testTrigger,
            builder: (context, style, variant) => testChild,
          ),
        ),
      );

      await tester.pump();
      expect(find.byKey(const Key('test-child')), findsOneWidget);

      final context = tester.element(find.byKey(const Key('test-child')));
      final boxSpec = BoxSpec.of(context);

      expect(boxSpec.height, 100);
      expect(boxSpec.width, 100);
    });

    testWidgets('should cycle through phases when trigger changes',
        (tester) async {
      MaterialApp buildApp(
          Map<TestPhases, Style> testPhases,
          PhaseAnimationData Function(TestPhases) testAnimation,
          String currentTrigger,
          Widget testChild) {
        return MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  StylePhaseAnimator(
                    phases: testPhases,
                    animation: testAnimation,
                    trigger: currentTrigger,
                    builder: (context, style, variant) => testChild,
                  ),
                ],
              );
            },
          ),
        );
      }

      await tester.pumpWidget(
        buildApp(testPhases, testAnimation, 'trigger1', testChild),
      );

      await tester.pumpWidget(
        buildApp(testPhases, testAnimation, 'trigger2', testChild),
      );

      await tester.pump();

      expect(find.byKey(const Key('test-child')), findsOneWidget);

      final context = tester.element(find.byKey(const Key('test-child')));
      final boxSpec = BoxSpec.of(context);

      expect(boxSpec.height, 200);
      expect(boxSpec.width, 200);

      await tester.pump();
      final boxSpec2 = BoxSpec.of(context);

      expect(boxSpec2.height, 200);
      expect(boxSpec2.width, 200);
    });

    //TODO: Review apple docs to see if this is the correct way to test this
    testWidgets('should handle different animation configurations per phase',
        (tester) async {
      PhaseAnimationData customAnimation(TestPhases variant) {
        switch (variant.name) {
          case 'phase1':
            return const PhaseAnimationData(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeIn,
              delay: Duration(milliseconds: 0),
            );
          case 'phase2':
            return const PhaseAnimationData(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              delay: Duration(milliseconds: 100),
            );
          default:
            return const PhaseAnimationData();
        }
      }

      await tester.pumpWidget(
        MaterialApp(
          home: MixTheme(
            data: MixThemeData(),
            child: StylePhaseAnimator(
              phases: testPhases,
              animation: customAnimation,
              trigger: testTrigger,
              builder: (context, style, variant) => testChild,
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byKey(const Key('test-child')), findsOneWidget);
    });

    testWidgets('should reset to first phase when trigger changes',
        (tester) async {
      Widget buildApp(String trigger) => MaterialApp(
            home: MixTheme(
              data: MixThemeData(),
              child: StylePhaseAnimator(
                phases: testPhases,
                animation: testAnimation,
                trigger: trigger,
                builder: (context, style, variant) => testChild,
              ),
            ),
          );

      await tester.pumpWidget(
        buildApp('trigger1'),
      );
      await tester.pumpWidget(
        buildApp('trigger2'),
      );

      await tester.pump();

      final boxSpec = getBoxSpec(tester);

      expect(boxSpec.height, 200);
      expect(boxSpec.width, 200);

      await tester.pumpWidget(
        buildApp('trigger3'),
      );

      final boxSpec2 = getBoxSpec(tester);

      expect(boxSpec2.height, 100);
      expect(boxSpec2.width, 100);
    });

    //TODO: Review Implementation to see if this is the correct way to test this
    testWidgets('should dispose timer properly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MixTheme(
            data: MixThemeData(),
            child: StylePhaseAnimator(
              phases: testPhases,
              animation: testAnimation,
              trigger: testTrigger,
              builder: (context, style, variant) => testChild,
            ),
          ),
        ),
      );

      // Remove the widget from the tree
      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox(),
        ),
      );

      // Should not throw any errors
      await tester.pump();
    });

    testWidgets('should handle empty phases map', (tester) async {
      final emptyPhases = <TestPhases, Style>{};

      expect(
        () => StylePhaseAnimator(
          phases: emptyPhases,
          animation: testAnimation,
          trigger: testTrigger,
          builder: (context, style, variant) => testChild,
        ),
        throwsAssertionError,
      );
    });

    testWidgets('should animate infinitely when no trigger is provided',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StylePhaseAnimator(
            phases: testPhases,
            animation: (_) => const PhaseAnimationData(
              duration: Duration(milliseconds: 100),
              curve: Curves.linear,
            ),
            builder: (context, style, variant) => testChild,
          ),
        ),
      );

      // Initial phase
      BoxSpec boxSpec = getBoxSpec(tester);
      expect(boxSpec.height, 100);
      expect(boxSpec.width, 100);

      // After first phase animation
      await tester.pump();
      boxSpec = getBoxSpec(tester);
      expect(boxSpec.height, 200);
      expect(boxSpec.width, 200);

      // After second phase animation
      await tester.pump(const Duration(milliseconds: 100));
      boxSpec = getBoxSpec(tester);
      expect(boxSpec.height, 300);
      expect(boxSpec.width, 300);

      // Should loop back to first phase
      await tester.pump(const Duration(milliseconds: 100));
      boxSpec = getBoxSpec(tester);
      expect(boxSpec.height, 100);
      expect(boxSpec.width, 100);
    });

    group('Animation timing', () {
      Widget buildExampleWithTwoPhases(
        String trigger, {
        required Duration duration,
        required Duration delay,
      }) =>
          MaterialApp(
            home: StylePhaseAnimator(
              phases: {
                TestPhases.phase1: Style(
                  $box.height(100),
                  $box.width(100),
                ),
                TestPhases.phase2: Style(
                  $box.height(200),
                  $box.width(200),
                ),
              },
              animation: (_) => PhaseAnimationData(
                duration: duration,
                delay: delay,
                curve: Curves.linear,
              ),
              trigger: trigger,
              builder: (context, style, variant) => testChild,
            ),
          );

      testWidgets('should respect duration', (tester) async {
        await tester.pumpWidget(
          buildExampleWithTwoPhases(
            'trigger1',
            duration: const Duration(milliseconds: 100),
            delay: Duration.zero,
          ),
        );

        await tester.pumpWidget(
          buildExampleWithTwoPhases(
            'trigger2',
            duration: const Duration(milliseconds: 100),
            delay: Duration.zero,
          ),
        );

        await tester.pump();

        final boxSpec = getBoxSpec(tester);

        expect(boxSpec.height, 200);
        expect(boxSpec.width, 200);

        await tester.pump(const Duration(milliseconds: 100));

        final boxSpec2 = getBoxSpec(tester);

        expect(boxSpec2.height, 100);
        expect(boxSpec2.width, 100);
      });

      testWidgets('should respect duration and delay', (tester) async {
        await tester.pumpWidget(
          buildExampleWithTwoPhases(
            'trigger1',
            duration: const Duration(milliseconds: 100),
            delay: const Duration(milliseconds: 50),
          ),
        );

        await tester.pumpWidget(
          buildExampleWithTwoPhases(
            'trigger2',
            duration: const Duration(milliseconds: 100),
            delay: const Duration(milliseconds: 50),
          ),
        );

        await tester.pump();
        // Second phase
        final boxSpec = getBoxSpec(tester);

        expect(boxSpec.height, 200);
        expect(boxSpec.width, 200);

        // Pump duration of animation
        await tester.pump(const Duration(milliseconds: 100));

        final boxSpec2 = getBoxSpec(tester);

        expect(boxSpec2.height, 200);
        expect(boxSpec2.width, 200);

        // Pump delay of animation
        await tester.pump(const Duration(milliseconds: 50));

        final boxSpec3 = getBoxSpec(tester);

        expect(boxSpec3.height, 100);
        expect(boxSpec3.width, 100);
      });
      // Review this test
      testWidgets('should handle zero duration animations', (tester) async {
        await tester.pumpWidget(
          buildExampleWithTwoPhases(
            'trigger1',
            duration: Duration.zero,
            delay: Duration.zero,
          ),
        );

        await tester.pumpWidget(
          buildExampleWithTwoPhases(
            'trigger2',
            duration: Duration.zero,
            delay: Duration.zero,
          ),
        );

        await tester.pumpAndSettle(const Duration(milliseconds: 1));
        final boxSpec = getBoxSpec(tester);

        expect(boxSpec.height, 100);
        expect(boxSpec.width, 100);
      });
    });

    group('Complex scenarios', () {
      testWidgets('should handle rapid trigger changes', (tester) async {
        Widget buildApp(String trigger) => MaterialApp(
              home: StylePhaseAnimator(
                phases: testPhases,
                animation: (variant) => const PhaseAnimationData(
                  duration: Duration(milliseconds: 200),
                  delay: Duration(milliseconds: 50),
                ),
                trigger: trigger,
                builder: (context, style, variant) => testChild,
              ),
            );

        await tester.pumpWidget(buildApp('trigger'));

        // Rapidly change triggers
        for (int i = 0; i < 5; i++) {
          await tester.pumpWidget(buildApp('trigger$i'));
          await tester.pump();
          final boxSpec1 = getBoxSpec(tester);

          expect(boxSpec1.height, 200);
          expect(boxSpec1.width, 200);
          await tester.pump(const Duration(milliseconds: 250));

          final boxSpec2 = getBoxSpec(tester);

          expect(boxSpec2.height, 300);
          expect(boxSpec2.width, 300);
        }
      });
    });
  });
}
