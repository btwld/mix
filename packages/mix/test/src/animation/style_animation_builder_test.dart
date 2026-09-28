import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

Widget styleAnimationBuilderCapturingColor(
  StyleSpec<TestSpec> spec,
  void Function(Color?) onColor, {
  bool wrapApp = true,
}) {
  final builder = StyleAnimationBuilder<TestSpec>(
    spec: spec,
    builder: (context, resolved) {
      onColor(resolved.spec.color);
      return Container(color: resolved.spec.color);
    },
  );
  if (!wrapApp) return builder;

  return MaterialApp(home: builder);
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

    testWidgets('reduced motion lands a curve on the target in one pump', (
      tester,
    ) async {
      const animation = CurveAnimationConfig(
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
      );
      const red = StyleSpec<TestSpec>(
        spec: TestSpec(color: Colors.red),
        animation: animation,
      );
      const blue = StyleSpec<TestSpec>(
        spec: TestSpec(color: Colors.blue),
        animation: animation,
      );
      Color? capturedColor;

      await tester.pumpWidget(
        _reducedMotionApp(
          styleAnimationBuilderCapturingColor(
            red,
            (color) => capturedColor = color,
            wrapApp: false,
          ),
        ),
      );
      await tester.pump();
      expect(capturedColor, Colors.red);

      await tester.pumpWidget(
        _reducedMotionApp(
          styleAnimationBuilderCapturingColor(
            blue,
            (color) => capturedColor = color,
            wrapApp: false,
          ),
        ),
      );

      expect(capturedColor, Colors.blue);
    });

    testWidgets('reduced motion lands a spring on the target in one pump', (
      tester,
    ) async {
      final animation = SpringAnimationConfig.withDurationAndBounce(
        duration: const Duration(milliseconds: 800),
      );
      final red = StyleSpec<TestSpec>(
        spec: const TestSpec(color: Colors.red),
        animation: animation,
      );
      final blue = StyleSpec<TestSpec>(
        spec: const TestSpec(color: Colors.blue),
        animation: animation,
      );
      Color? capturedColor;

      await tester.pumpWidget(
        _reducedMotionApp(
          styleAnimationBuilderCapturingColor(
            red,
            (color) => capturedColor = color,
            wrapApp: false,
          ),
        ),
      );
      await tester.pump();
      expect(capturedColor, Colors.red);

      await tester.pumpWidget(
        _reducedMotionApp(
          styleAnimationBuilderCapturingColor(
            blue,
            (color) => capturedColor = color,
            wrapApp: false,
          ),
        ),
      );

      expect(capturedColor, Colors.blue);
    });

    testWidgets('reduced motion holds a looping phase without scheduling', (
      tester,
    ) async {
      final animation = PhaseAnimationConfig<TestSpec, _TestStyle>(
        styles: const [
          _TestStyle(TestSpec(color: Colors.red)),
          _TestStyle(TestSpec(color: Colors.blue)),
        ],
        curveConfigs: const [
          CurveAnimationConfig(
            duration: Duration(milliseconds: 300),
            curve: Curves.linear,
          ),
          CurveAnimationConfig(
            duration: Duration(milliseconds: 300),
            curve: Curves.linear,
          ),
        ],
        trigger: null,
      );
      const spec = StyleSpec<TestSpec>(
        spec: TestSpec(color: Colors.red),
        animation: null,
      );

      await tester.pumpWidget(
        _reducedMotionApp(
          StyleAnimationBuilder<TestSpec>(
            spec: StyleSpec<TestSpec>(spec: spec.spec, animation: animation),
            builder: (context, resolved) => const SizedBox(),
          ),
        ),
      );
      // MaterialApp schedules one frame of its own. The phase loop must not
      // schedule another after that frame is drawn.
      await tester.pump();

      expect(tester.binding.hasScheduledFrame, isFalse);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('reduced motion holds a looping keyframe without scheduling', (
      tester,
    ) async {
      final animation = KeyframeAnimationConfig<TestSpec>(
        trigger: null,
        initialStyle: const _TestStyle(TestSpec(color: Colors.red)),
        timeline: [
          KeyframeTrack<Color>(
            'color',
            [const Keyframe.linear(Colors.blue, Duration(milliseconds: 300))],
            initial: Colors.red,
            tweenBuilder: ({begin, end}) => ColorTween(begin: begin, end: end),
          ),
        ],
        styleBuilder: (result, style) => style,
      );

      await tester.pumpWidget(
        _reducedMotionApp(
          StyleAnimationBuilder<TestSpec>(
            spec: StyleSpec<TestSpec>(
              spec: const TestSpec(color: Colors.red),
              animation: animation,
            ),
            builder: (context, resolved) => const SizedBox(),
          ),
        ),
      );
      // MaterialApp schedules one frame of its own. The keyframe loop must
      // not schedule another after that frame is drawn.
      await tester.pump();

      expect(tester.binding.hasScheduledFrame, isFalse);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('reduced motion applies from the next transition', (
      tester,
    ) async {
      const animation = CurveAnimationConfig(
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
      );
      const red = StyleSpec<TestSpec>(
        spec: TestSpec(color: Colors.red),
        animation: animation,
      );
      const blue = StyleSpec<TestSpec>(
        spec: TestSpec(color: Colors.blue),
        animation: animation,
      );
      const green = StyleSpec<TestSpec>(
        spec: TestSpec(color: Colors.green),
        animation: animation,
      );
      Color? capturedColor;

      Widget host(StyleSpec<TestSpec> spec, {required bool reduced}) {
        return MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: reduced),
            child: styleAnimationBuilderCapturingColor(
              spec,
              (color) => capturedColor = color,
              wrapApp: false,
            ),
          ),
        );
      }

      await tester.pumpWidget(host(red, reduced: false));
      await tester.pumpAndSettle();

      // A transition that is running when the flag turns on finishes.
      await tester.pumpWidget(host(blue, reduced: false));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpWidget(host(blue, reduced: true));
      expect(capturedColor, isNot(Colors.blue));
      await tester.pumpAndSettle();
      expect(capturedColor, Colors.blue);

      // The next transition jumps.
      await tester.pumpWidget(host(green, reduced: true));
      expect(capturedColor, Colors.green);

      // Clearing the flag animates the next transition again.
      await tester.pumpWidget(host(green, reduced: false));
      await tester.pumpWidget(host(red, reduced: false));
      await tester.pump(const Duration(milliseconds: 100));
      expect(capturedColor, isNot(Colors.green));
      expect(capturedColor, isNot(Colors.red));
      await tester.pumpAndSettle();
      expect(capturedColor, Colors.red);
    });

    testWidgets('a looping phase stops and resumes with the flag', (
      tester,
    ) async {
      final animation = PhaseAnimationConfig<TestSpec, _TestStyle>(
        styles: const [
          _TestStyle(TestSpec(color: Colors.red)),
          _TestStyle(TestSpec(color: Colors.blue)),
        ],
        curveConfigs: const [
          CurveAnimationConfig(
            duration: Duration(milliseconds: 300),
            curve: Curves.linear,
          ),
          CurveAnimationConfig(
            duration: Duration(milliseconds: 300),
            curve: Curves.linear,
          ),
        ],
        trigger: null,
      );
      Color? capturedColor;

      Widget host({required bool reduced}) {
        return MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: reduced),
            child: StyleAnimationBuilder<TestSpec>(
              spec: StyleSpec<TestSpec>(
                spec: const TestSpec(color: Colors.red),
                animation: animation,
              ),
              builder: (context, resolved) {
                capturedColor = resolved.spec.color;

                return const SizedBox();
              },
            ),
          ),
        );
      }

      await tester.pumpWidget(host(reduced: false));
      await tester.pump(const Duration(milliseconds: 150));
      expect(capturedColor, isNot(Colors.red));

      await tester.pumpWidget(host(reduced: true));
      expect(capturedColor, Colors.red);
      await tester.pump();
      expect(tester.binding.hasScheduledFrame, isFalse);

      await tester.pumpWidget(host(reduced: false));
      await tester.pump(const Duration(milliseconds: 150));
      expect(capturedColor, isNot(Colors.red));
    });

    testWidgets('reduced motion fires onEnd once after the frame', (
      tester,
    ) async {
      var ends = 0;
      final animation = CurveAnimationConfig(
        duration: const Duration(milliseconds: 400),
        curve: Curves.linear,
        onEnd: () => ends++,
      );
      final red = StyleSpec<TestSpec>(
        spec: const TestSpec(color: Colors.red),
        animation: animation,
      );
      final blue = StyleSpec<TestSpec>(
        spec: const TestSpec(color: Colors.blue),
        animation: animation,
      );

      await tester.pumpWidget(
        _reducedMotionApp(
          styleAnimationBuilderCapturingColor(red, (_) {}, wrapApp: false),
        ),
      );
      await tester.pump();
      expect(ends, 0);

      await tester.pumpWidget(
        _reducedMotionApp(
          styleAnimationBuilderCapturingColor(blue, (_) {}, wrapApp: false),
        ),
      );
      expect(ends, 1);

      await tester.pump();
      expect(ends, 1);
    });

    testWidgets('linear zero duration jumps without asserting', (tester) async {
      var ends = 0;
      final animation = AnimationConfig.linear(
        Duration.zero,
        onEnd: () => ends++,
      );
      final red = StyleSpec<TestSpec>(
        spec: const TestSpec(color: Colors.red),
        animation: animation,
      );
      final blue = StyleSpec<TestSpec>(
        spec: const TestSpec(color: Colors.blue),
        animation: animation,
      );
      Color? capturedColor;

      await tester.pumpWidget(
        MaterialApp(
          home: styleAnimationBuilderCapturingColor(
            red,
            (color) => capturedColor = color,
            wrapApp: false,
          ),
        ),
      );
      await tester.pump();
      expect(capturedColor, Colors.red);
      expect(ends, 0);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(
        MaterialApp(
          home: styleAnimationBuilderCapturingColor(
            blue,
            (color) => capturedColor = color,
            wrapApp: false,
          ),
        ),
      );

      expect(capturedColor, Colors.blue);
      expect(ends, 1);
      expect(tester.takeException(), isNull);
    });
  });
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

Widget _reducedMotionApp(Widget child) {
  return MaterialApp(
    home: MediaQuery(
      data: const MediaQueryData(disableAnimations: true),
      child: child,
    ),
  );
}

class _TestStyle extends Style<TestSpec> {
  final TestSpec spec;

  const _TestStyle(this.spec)
    : super(variants: null, modifier: null, animation: null);

  @override
  _TestStyle merge(covariant _TestStyle? other) => other ?? this;

  @override
  StyleSpec<TestSpec> resolve(BuildContext context) {
    return StyleSpec(spec: spec);
  }

  @override
  List<Object?> get props => [spec];
}
