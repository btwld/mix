import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

Widget styleAnimationBuilderCapturingColor(
  StyleSpec<TestSpec> spec,
  void Function(Color?) onColor,
) {
  return MaterialApp(
    home: StyleAnimationBuilder<TestSpec>(
      spec: spec,
      builder: (context, resolved) {
        onColor(resolved.spec.color);
        return Container(color: resolved.spec.color);
      },
    ),
  );
}

void main() {
  group('AnimationStyleWidget', () {
    testWidgets('builds with initial style', (tester) async {
      const animationConfig = CurveAnimationConfig(
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      );
      const spec = StyleSpec<TestSpec>(
        spec: TestSpec(),
        animation: animationConfig,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            spec: spec,
            builder: (context, spec) => Container(
              key: const Key('test-container'),
              color: spec.spec.color,
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('test-container')), findsOneWidget);
    });

    testWidgets('triggers animation on mount', (tester) async {
      const animationConfig = CurveAnimationConfig(
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      );
      const spec = StyleSpec<TestSpec>(
        spec: TestSpec(),
        animation: animationConfig,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            spec: spec,
            builder: (context, spec) =>
                Container(key: ValueKey(spec.spec.color)),
          ),
        ),
      );

      // Wait for post frame callback and animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Animation should be in progress
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('animates to new style when updated', (tester) async {
      const animationConfig = CurveAnimationConfig(
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      );
      const spec1 = StyleSpec<TestSpec>(
        spec: TestSpec(color: Colors.red),
        animation: animationConfig,
      );
      const spec2 = StyleSpec<TestSpec>(
        spec: TestSpec(color: Colors.blue),
        animation: animationConfig,
      );
      Color? capturedColor;

      await tester.pumpWidget(
        styleAnimationBuilderCapturingColor(
          spec1,
          (color) => capturedColor = color,
        ),
      );
      await tester.pumpAndSettle();
      expect(capturedColor, Colors.red);

      await tester.pumpWidget(
        styleAnimationBuilderCapturingColor(
          spec2,
          (color) => capturedColor = color,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(capturedColor, isNot(Colors.red));
      expect(capturedColor, isNot(Colors.blue));

      await tester.pumpAndSettle();
      expect(capturedColor, Colors.blue);
    });

    testWidgets('updates when animation config changes', (tester) async {
      const config1 = CurveAnimationConfig(
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      );
      const config2 = CurveAnimationConfig(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
      const spec1 = StyleSpec<TestSpec>(
        spec: TestSpec(color: Colors.red),
        animation: config1,
      );
      const spec2 = StyleSpec<TestSpec>(
        spec: TestSpec(color: Colors.blue),
        animation: config2,
      );
      Color? capturedColor;

      await tester.pumpWidget(
        styleAnimationBuilderCapturingColor(
          spec1,
          (color) => capturedColor = color,
        ),
      );
      await tester.pumpAndSettle();
      expect(capturedColor, Colors.red);

      await tester.pumpWidget(
        styleAnimationBuilderCapturingColor(
          spec2,
          (color) => capturedColor = color,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(capturedColor, isNot(Colors.red));
      expect(capturedColor, isNot(Colors.blue));

      await tester.pumpAndSettle();
      expect(capturedColor, Colors.blue);
    });

    testWidgets('disposes correctly', (tester) async {
      const animationConfig = CurveAnimationConfig(
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      );
      const spec = StyleSpec<TestSpec>(
        spec: TestSpec(),
        animation: animationConfig,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            spec: spec,
            builder: (context, resolvedStyle) => Container(),
          ),
        ),
      );

      // Replace widget to trigger dispose
      await tester.pumpWidget(Container());

      // Widget should be disposed without errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('handles empty spec gracefully', (tester) async {
      const animationConfig = CurveAnimationConfig(
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      );
      // Create a style with an empty/default spec
      const spec = StyleSpec<TestSpec>(
        spec: TestSpec(color: Colors.transparent),
        animation: animationConfig,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            spec: spec,
            builder: (context, spec) =>
                Container(key: const Key('test-container')),
          ),
        ),
      );

      // Should render container even with empty/default spec
      expect(find.byKey(const Key('test-container')), findsOneWidget);
    });

    testWidgets('switches from curve to spring animation config', (
      tester,
    ) async {
      const curveConfig = CurveAnimationConfig(
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      );
      final springConfig = SpringAnimationConfig.standard();

      const specWithCurve = StyleSpec<TestSpec>(
        spec: TestSpec(color: Colors.red),
        animation: curveConfig,
      );
      final specWithSpring = StyleSpec<TestSpec>(
        spec: const TestSpec(color: Colors.blue),
        animation: springConfig,
      );

      // Start with curve animation
      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            spec: specWithCurve,
            builder: (context, spec) => Container(
              key: const Key('test-container'),
              color: spec.spec.color,
            ),
          ),
        ),
      );

      await tester.pump();

      // Switch to spring animation
      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            spec: specWithSpring,
            builder: (context, spec) => Container(
              key: const Key('test-container'),
              color: spec.spec.color,
            ),
          ),
        ),
      );

      // Should not throw, animation driver should switch correctly
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('test-container')), findsOneWidget);
    });

    testWidgets('switches from animation to no animation config', (
      tester,
    ) async {
      const curveConfig = CurveAnimationConfig(
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      );

      const specWithAnimation = StyleSpec<TestSpec>(
        spec: TestSpec(color: Colors.red),
        animation: curveConfig,
      );
      const specWithoutAnimation = StyleSpec<TestSpec>(
        spec: TestSpec(color: Colors.blue),
        animation: null,
      );

      // Start with animation
      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            spec: specWithAnimation,
            builder: (context, spec) => Container(
              key: const Key('test-container'),
              color: spec.spec.color,
            ),
          ),
        ),
      );

      await tester.pump();

      // Switch to no animation
      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            spec: specWithoutAnimation,
            builder: (context, spec) => Container(
              key: const Key('test-container'),
              color: spec.spec.color,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find.byKey(const Key('test-container')),
      );
      expect(container.color, Colors.blue);
    });

    testWidgets(
      'animates with previous config when transitioning to null animation',
      (tester) async {
        const curveConfig = CurveAnimationConfig(
          duration: Duration(milliseconds: 200),
          curve: Curves.linear,
        );

        const specWithAnimation = StyleSpec<TestSpec>(
          spec: TestSpec(color: Colors.red),
          animation: curveConfig,
        );
        const specWithoutAnimation = StyleSpec<TestSpec>(
          spec: TestSpec(color: Colors.blue),
          animation: null,
        );

        Color? capturedColor;

        // Start with the animated spec and let it settle on red.
        await tester.pumpWidget(
          styleAnimationBuilderCapturingColor(
            specWithAnimation,
            (color) => capturedColor = color,
          ),
        );
        await tester.pumpAndSettle();

        expect(capturedColor, Colors.red);

        // Switch to a spec with a null animation config. The builder should
        // fall back to the previous config and keep animating instead of
        // jumping straight to the new target value.
        await tester.pumpWidget(
          styleAnimationBuilderCapturingColor(
            specWithoutAnimation,
            (color) => capturedColor = color,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(
          capturedColor,
          isNot(Colors.red),
          reason: 'animation should have progressed past the start value',
        );
        expect(
          capturedColor,
          isNot(Colors.blue),
          reason:
              'animation should not have jumped to the target value instantly',
        );

        // After the previous config's duration completes, the spec lands
        // on the new target.
        await tester.pumpAndSettle();

        expect(capturedColor, Colors.blue);
      },
    );

    testWidgets('handles null animation value gracefully', (tester) async {
      // Create spec with animation that produces null value
      const animationConfig = CurveAnimationConfig(
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      );
      const spec = StyleSpec<TestSpec>(
        spec: TestSpec(),
        animation: animationConfig,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            spec: spec,
            builder: (context, spec) {
              // Builder should receive valid spec even during animation
              expect(spec, isNotNull);
              return Container(key: const Key('test-container'));
            },
          ),
        ),
      );

      // Pump through animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byKey(const Key('test-container')), findsOneWidget);
    });
  });

  group('interrupted implicit animation (regression)', () {
    testWidgets(
      'a delayed transition holds the interrupted value instead of snapping to '
      'the start',
      (tester) async {
        Color? captured;
        Widget build(StyleSpec<TestSpec> spec) =>
            styleAnimationBuilderCapturingColor(spec, (c) => captured = c);

        const red = StyleSpec<TestSpec>(
          spec: TestSpec(color: Colors.red),
          animation: CurveAnimationConfig(
            duration: Duration(milliseconds: 200),
            curve: Curves.linear,
          ),
        );
        const blue = StyleSpec<TestSpec>(
          spec: TestSpec(color: Colors.blue),
          animation: CurveAnimationConfig(
            duration: Duration(milliseconds: 200),
            curve: Curves.linear,
          ),
        );
        const greenDelayed = StyleSpec<TestSpec>(
          spec: TestSpec(color: Colors.green),
          animation: CurveAnimationConfig(
            duration: Duration(milliseconds: 200),
            curve: Curves.linear,
            delay: Duration(milliseconds: 100),
          ),
        );

        await tester.pumpWidget(build(red));
        await tester.pumpAndSettle();
        expect(captured, Colors.red);

        // Begin red -> blue and stop halfway.
        await tester.pumpWidget(build(blue));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        final interrupted = captured;
        expect(interrupted, isNot(Colors.red));
        expect(interrupted, isNot(Colors.blue));

        // Interrupt with a delayed transition to green. During the delay the
        // value must hold where it was, not jump back to the driver's original
        // red (`_initialSpec`).
        await tester.pumpWidget(build(greenDelayed));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
        expect(
          captured,
          interrupted,
          reason: 'the delay must hold the interrupted value',
        );
        expect(captured, isNot(Colors.red));

        // Once the delay elapses it animates to the new target.
        await tester.pumpAndSettle();
        expect(captured, Colors.green);
      },
    );
  });

  group('implicit animation removal (regression)', () {
    testWidgets(
      'spring removal reuses the previous config to animate to the new target',
      (tester) async {
        Color? captured;
        Widget build(StyleSpec<TestSpec> spec) =>
            styleAnimationBuilderCapturingColor(spec, (c) => captured = c);

        final withSpring = StyleSpec<TestSpec>(
          spec: const TestSpec(color: Colors.red),
          animation: SpringAnimationConfig.standard(),
        );
        const withoutAnimation = StyleSpec<TestSpec>(
          spec: TestSpec(color: Colors.blue),
          animation: null,
        );

        await tester.pumpWidget(build(withSpring));
        await tester.pumpAndSettle();
        expect(captured, Colors.red);

        await tester.pumpWidget(build(withoutAnimation));
        await tester.pump();
        // The spring should animate out rather than jump straight to blue.
        expect(
          captured,
          isNot(Colors.blue),
          reason: 'spring removal should animate, not jump to the target',
        );

        await tester.pumpAndSettle();
        // A spring settles within its tolerance rather than exactly on the end
        // control value, so assert channel closeness to the target instead of
        // exact equality.
        final settled = captured!;
        expect(settled.r, closeTo(Colors.blue.r, 0.02));
        expect(settled.g, closeTo(Colors.blue.g, 0.02));
        expect(settled.b, closeTo(Colors.blue.b, 0.02));
      },
    );
  });

  group('phase and keyframe removal (regression)', () {
    testWidgets(
      'removing a looping phase animation shows the new target immediately and '
      'stops the loop',
      (tester) async {
        double? captured;
        await tester.pumpWidget(
          _mockAnimationApp(_mockSpec(1.0, _loopingPhaseConfig()), (v) {
            captured = v;
          }),
        );
        await tester.pump(const Duration(milliseconds: 50));
        expect(tester.hasRunningAnimations, isTrue);

        await tester.pumpWidget(
          _mockAnimationApp(_mockSpec(42.0, null), (v) {
            captured = v;
          }),
        );
        await tester.pump();

        expect(captured, 42.0);
        expect(tester.hasRunningAnimations, isFalse);
      },
    );

    testWidgets(
      'removing a looping keyframe animation shows the new target immediately '
      'and stops the loop',
      (tester) async {
        double? captured;
        await tester.pumpWidget(
          _mockAnimationApp(_mockSpec(1.0, _loopingKeyframeConfig()), (v) {
            captured = v;
          }),
        );
        await tester.pump(const Duration(milliseconds: 50));
        expect(tester.hasRunningAnimations, isTrue);

        await tester.pumpWidget(
          _mockAnimationApp(_mockSpec(42.0, null), (v) {
            captured = v;
          }),
        );
        await tester.pump();

        expect(captured, 42.0);
        expect(tester.hasRunningAnimations, isFalse);
      },
    );
  });

  group('driver transition matrix (regression)', () {
    final families = <String, AnimationConfig? Function()>{
      'null': () => null,
      'curve': _curveConfig,
      'spring': SpringAnimationConfig.standard,
      'phase': _loopingPhaseConfig,
      'keyframe': _loopingKeyframeConfig,
    };
    // Configs that settle to the widget's target value (they retarget via
    // `didUpdateSpec`), so we can assert the final rendered spec == target.
    const settlingNew = ['null', 'curve', 'spring'];
    // Looping configs never settle; we only assert the new loop took over.
    const loopingNew = ['phase', 'keyframe'];

    for (final oldEntry in families.entries) {
      for (final newKey in settlingNew) {
        testWidgets(
          '${oldEntry.key} -> $newKey disposes old and reaches target',
          (tester) async {
            double? captured;
            await tester.pumpWidget(
              _mockAnimationApp(_mockSpec(1.0, oldEntry.value()), (v) {
                captured = v;
              }),
            );
            await tester.pump(const Duration(milliseconds: 20));

            await tester.pumpWidget(
              _mockAnimationApp(_mockSpec(2.0, families[newKey]!()), (v) {
                captured = v;
              }),
            );
            await tester.pumpAndSettle();

            expect(tester.takeException(), isNull);
            expect(
              captured,
              2.0,
              reason: '${oldEntry.key} -> $newKey should render the new target',
            );
            expect(
              tester.hasRunningAnimations,
              isFalse,
              reason: 'the old ${oldEntry.key} ticker should be disposed',
            );
          },
        );
      }

      for (final newKey in loopingNew) {
        testWidgets(
          '${oldEntry.key} -> $newKey disposes old and starts new loop',
          (tester) async {
            await tester.pumpWidget(
              _mockAnimationApp(_mockSpec(1.0, oldEntry.value()), (_) {}),
            );
            await tester.pump(const Duration(milliseconds: 20));

            await tester.pumpWidget(
              _mockAnimationApp(_mockSpec(2.0, families[newKey]!()), (_) {}),
            );
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 20));

            expect(tester.takeException(), isNull);
            expect(
              tester.hasRunningAnimations,
              isTrue,
              reason: '${oldEntry.key} -> $newKey should run the new loop',
            );

            // Unmount so the repeating controller is disposed before teardown.
            await tester.pumpWidget(const SizedBox());
          },
        );
      }
    }
  });
}

// Builds a MaterialApp hosting a StyleAnimationBuilder over a MockSpec and
// reports the resolved value on every rebuild.
Widget _mockAnimationApp(
  StyleSpec<MockSpec<double>> spec,
  void Function(double?) onValue,
) {
  return MaterialApp(
    home: StyleAnimationBuilder<MockSpec<double>>(
      spec: spec,
      builder: (context, resolved) {
        onValue(resolved.spec.resolvedValue);

        return const SizedBox();
      },
    ),
  );
}

StyleSpec<MockSpec<double>> _mockSpec(
  double value,
  AnimationConfig? animation,
) {
  return StyleSpec<MockSpec<double>>(
    spec: MockSpec<double>(resolvedValue: value),
    animation: animation,
  );
}

AnimationConfig _curveConfig() => const CurveAnimationConfig(
  duration: Duration(milliseconds: 100),
  curve: Curves.linear,
);

// A looping (untriggered) phase animation cycling between two phases.
AnimationConfig _loopingPhaseConfig() {
  return PhaseAnimationConfig<MockSpec<double>, MockStyle<double>>(
    styles: [MockStyle(0.0), MockStyle(1.0)],
    curveConfigs: const [
      CurveAnimationConfig(
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      ),
      CurveAnimationConfig(
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      ),
    ],
    trigger: null,
  );
}

// A looping (untriggered) keyframe animation.
AnimationConfig _loopingKeyframeConfig() {
  return KeyframeAnimationConfig<MockSpec<double>>(
    trigger: null,
    timeline: [
      KeyframeTrack<double>('value', const [
        Keyframe.linear(1.0, Duration(milliseconds: 100)),
      ], initial: 0.0),
    ],
    styleBuilder: (result, style) => MockStyle(result.get<double>('value')),
    initialStyle: MockStyle(0.0),
  );
}

// Test helpers
class TestSpec extends Spec<TestSpec> {
  final Color color;

  const TestSpec({this.color = Colors.black});

  @override
  TestSpec copyWith({Color? color}) {
    return TestSpec(color: color ?? this.color);
  }

  @override
  TestSpec lerp(TestSpec? other, double t) {
    if (other == null) return this;
    return TestSpec(color: Color.lerp(color, other.color, t) ?? color);
  }

  @override
  List<Object?> get props => [color];
}
