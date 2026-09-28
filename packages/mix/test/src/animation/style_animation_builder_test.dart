import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
        _motionView(
          StyleAnimationBuilder<TestSpec>(
            spec: StyleSpec<TestSpec>(spec: spec.spec, animation: animation),
            builder: (context, resolved) => const SizedBox(),
          ),
        ),
      );
      // Mounted without MaterialApp, which schedules a frame of its own. The
      // driver is created once the flag is known, so the phase loop never
      // starts and the mount leaves no frame scheduled.
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
        _motionView(
          StyleAnimationBuilder<TestSpec>(
            spec: StyleSpec<TestSpec>(
              spec: const TestSpec(color: Colors.red),
              animation: animation,
            ),
            builder: (context, resolved) => const SizedBox(),
          ),
        ),
      );
      // Mounted without MaterialApp, which schedules a frame of its own. The
      // driver is created once the flag is known, so the keyframe loop never
      // starts and the mount leaves no frame scheduled.
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
      final phases = <SchedulerPhase>[];
      final animation = CurveAnimationConfig(
        duration: const Duration(milliseconds: 400),
        curve: Curves.linear,
        onEnd: () {
          ends++;
          phases.add(SchedulerBinding.instance.schedulerPhase);
        },
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
      expect(phases, [SchedulerPhase.postFrameCallbacks]);

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

    testWidgets('a flag turning on with a spec change jumps in that frame', (
      tester,
    ) async {
      const animation = CurveAnimationConfig(
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
      );
      Color? capturedColor;
      void onColor(Color? color) => capturedColor = color;

      await tester.pumpWidget(
        _colorHost(
          _colorSpec(Colors.red, animation),
          reduced: false,
          onColor: onColor,
        ),
      );
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        _colorHost(
          _colorSpec(Colors.blue, animation),
          reduced: true,
          onColor: onColor,
        ),
      );

      expect(capturedColor, Colors.blue);
      await tester.pump(const Duration(milliseconds: 100));
      expect(capturedColor, Colors.blue);
    });

    testWidgets('a flag clearing with a spec change animates that change', (
      tester,
    ) async {
      const animation = CurveAnimationConfig(
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
      );
      Color? capturedColor;
      void onColor(Color? color) => capturedColor = color;

      await tester.pumpWidget(
        _colorHost(
          _colorSpec(Colors.red, animation),
          reduced: true,
          onColor: onColor,
        ),
      );
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        _colorHost(
          _colorSpec(Colors.blue, animation),
          reduced: false,
          onColor: onColor,
        ),
      );
      expect(capturedColor, Colors.red);

      await tester.pump(const Duration(milliseconds: 200));
      expect(capturedColor, isNot(Colors.red));
      expect(capturedColor, isNot(Colors.blue));

      await tester.pumpAndSettle();
      expect(capturedColor, Colors.blue);
    });

    for (final (name, next) in <(String, AnimationConfig)>[
      (
        'curve',
        const CurveAnimationConfig(
          duration: Duration(milliseconds: 400),
          curve: Curves.linear,
        ),
      ),
      (
        'spring',
        SpringAnimationConfig.withDurationAndBounce(
          duration: const Duration(milliseconds: 800),
        ),
      ),
    ]) {
      testWidgets(
        'a jump shows the target itself and the next $name transition '
        'starts from it',
        (tester) async {
          const animation = CurveAnimationConfig(
            duration: Duration(milliseconds: 400),
            curve: Curves.linear,
          );
          Color? capturedColor;
          void onColor(Color? color) => capturedColor = color;

          await tester.pumpWidget(
            _colorHost(
              _colorSpec(Colors.red, animation),
              reduced: false,
              onColor: onColor,
            ),
          );
          await tester.pumpWidget(
            _colorHost(
              _colorSpec(Colors.blue, animation),
              reduced: false,
              onColor: onColor,
            ),
          );
          await tester.pump(const Duration(milliseconds: 100));

          // The controller is mid-way; the jump must not lerp the target.
          await tester.pumpWidget(
            _colorHost(
              _colorSpec(Colors.green, next),
              reduced: true,
              onColor: onColor,
            ),
          );
          expect(capturedColor, same(Colors.green));

          await tester.pumpWidget(
            _colorHost(
              _colorSpec(Colors.red, next),
              reduced: false,
              onColor: onColor,
            ),
          );
          expect(capturedColor, same(Colors.green));
          await tester.pump(const Duration(milliseconds: 100));
          expect(capturedColor, isNot(Colors.green));
          expect(capturedColor, isNot(Colors.red));

          await tester.pumpAndSettle();
          // A settled spring can stop a hair short of its end.
          expect(capturedColor, isSameColorAs(Colors.red));
        },
      );
    }

    testWidgets('a zero duration holds through the delay, then lands', (
      tester,
    ) async {
      var ends = 0;
      final animation = CurveAnimationConfig(
        duration: Duration.zero,
        delay: const Duration(milliseconds: 200),
        curve: Curves.linear,
        onEnd: () => ends++,
      );
      Color? capturedColor;

      await tester.pumpWidget(
        styleAnimationBuilderCapturingColor(
          _colorSpec(Colors.red, animation),
          (color) => capturedColor = color,
        ),
      );
      await tester.pumpWidget(
        styleAnimationBuilderCapturingColor(
          _colorSpec(Colors.blue, animation),
          (color) => capturedColor = color,
        ),
      );
      expect(capturedColor, Colors.red);

      await tester.pump(const Duration(milliseconds: 199));
      expect(capturedColor, Colors.red);
      expect(ends, 0);

      await tester.pump(const Duration(milliseconds: 2));
      expect(capturedColor, Colors.blue);
      expect(ends, 1);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a sub-millisecond curve animates without asserting', (
      tester,
    ) async {
      const animation = CurveAnimationConfig(
        duration: Duration(microseconds: 500),
        delay: Duration(microseconds: 500),
        curve: Curves.linear,
      );
      Color? capturedColor;

      await tester.pumpWidget(
        styleAnimationBuilderCapturingColor(
          _colorSpec(Colors.red, animation),
          (color) => capturedColor = color,
        ),
      );
      await tester.pumpWidget(
        styleAnimationBuilderCapturingColor(
          _colorSpec(Colors.blue, animation),
          (color) => capturedColor = color,
        ),
      );
      expect(tester.takeException(), isNull);

      await tester.pumpAndSettle();
      expect(capturedColor, Colors.blue);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a curve replaced by a spring while reduced jumps', (
      tester,
    ) async {
      const curve = CurveAnimationConfig(
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
      );
      final spring = SpringAnimationConfig.withDurationAndBounce(
        duration: const Duration(milliseconds: 800),
      );
      Color? capturedColor;
      void onColor(Color? color) => capturedColor = color;

      await tester.pumpWidget(
        _colorView(
          _colorSpec(Colors.red, curve),
          reduced: true,
          onColor: onColor,
        ),
      );
      await tester.pumpWidget(
        _colorView(
          _colorSpec(Colors.blue, spring),
          reduced: true,
          onColor: onColor,
        ),
      );

      expect(capturedColor, Colors.blue);
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('a curve dropped while reduced jumps with the old config', (
      tester,
    ) async {
      const curve = CurveAnimationConfig(
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
      );
      Color? capturedColor;
      void onColor(Color? color) => capturedColor = color;

      await tester.pumpWidget(
        _colorView(
          _colorSpec(Colors.red, curve),
          reduced: true,
          onColor: onColor,
        ),
      );
      // A null config recreates the driver with the old config.
      await tester.pumpWidget(
        _colorView(
          _colorSpec(Colors.blue, null),
          reduced: true,
          onColor: onColor,
        ),
      );

      expect(capturedColor, Colors.blue);
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('a curve replaced by a looping phase while reduced holds', (
      tester,
    ) async {
      const curve = CurveAnimationConfig(
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
      );
      Color? capturedColor;
      void onColor(Color? color) => capturedColor = color;

      await tester.pumpWidget(
        _colorView(
          _colorSpec(Colors.red, curve),
          reduced: true,
          onColor: onColor,
        ),
      );
      await tester.pumpWidget(
        _colorView(
          _colorSpec(Colors.red, _loopingPhase()),
          reduced: true,
          onColor: onColor,
        ),
      );

      expect(capturedColor, Colors.red);
      expect(tester.binding.hasScheduledFrame, isFalse);
      await tester.pump(const Duration(milliseconds: 150));
      expect(capturedColor, Colors.red);
    });

    testWidgets('a curve config update while reduced jumps', (tester) async {
      Color? capturedColor;
      void onColor(Color? color) => capturedColor = color;

      await tester.pumpWidget(
        _colorView(
          _colorSpec(
            Colors.red,
            const CurveAnimationConfig(
              duration: Duration(milliseconds: 400),
              curve: Curves.linear,
            ),
          ),
          reduced: true,
          onColor: onColor,
        ),
      );
      await tester.pumpWidget(
        _colorView(
          _colorSpec(
            Colors.blue,
            const CurveAnimationConfig(
              duration: Duration(milliseconds: 600),
              curve: Curves.easeIn,
            ),
          ),
          reduced: true,
          onColor: onColor,
        ),
      );

      expect(capturedColor, Colors.blue);
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('a looping phase config update while reduced holds', (
      tester,
    ) async {
      Color? capturedColor;
      void onColor(Color? color) => capturedColor = color;

      await tester.pumpWidget(
        _colorView(
          _colorSpec(Colors.red, _loopingPhase()),
          reduced: true,
          onColor: onColor,
        ),
      );
      await tester.pumpWidget(
        _colorView(
          _colorSpec(
            Colors.red,
            _loopingPhase(duration: const Duration(milliseconds: 500)),
          ),
          reduced: true,
          onColor: onColor,
        ),
      );

      expect(capturedColor, Colors.red);
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('a triggered phase under reduced motion jumps to its end', (
      tester,
    ) async {
      final trigger = ValueNotifier(0);
      addTearDown(trigger.dispose);
      var ends = 0;
      final animation = _loopingPhase(trigger: trigger, onEnd: () => ends++);
      Color? capturedColor;

      await tester.pumpWidget(
        _colorView(
          _colorSpec(Colors.red, animation),
          reduced: true,
          onColor: (color) => capturedColor = color,
        ),
      );

      trigger.value++;
      // The zero-duration run completes inside the trigger notification.
      expect(ends, 1);

      await tester.pump();
      // The sequence ends back on its first style.
      expect(capturedColor, Colors.red);
      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(ends, 1);
    });

    testWidgets('a triggered keyframe under reduced motion jumps to its end', (
      tester,
    ) async {
      final trigger = ValueNotifier(0);
      addTearDown(trigger.dispose);
      Color? capturedColor;

      await tester.pumpWidget(
        _colorView(
          _colorSpec(Colors.red, _colorKeyframes(trigger: trigger)),
          reduced: true,
          onColor: (color) => capturedColor = color,
        ),
      );
      expect(capturedColor, Colors.red);

      trigger.value++;
      await tester.pump();

      expect(capturedColor, Colors.blue);
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('a looping keyframe stops and resumes with the flag', (
      tester,
    ) async {
      Color? capturedColor;

      Widget host({required bool reduced}) => _colorHost(
        _colorSpec(Colors.red, _colorKeyframes()),
        reduced: reduced,
        onColor: (color) => capturedColor = color,
      );

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

    testWidgets('the platform disableAnimations flag reduces motion', (
      tester,
    ) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      const animation = CurveAnimationConfig(
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
      );
      Color? capturedColor;

      await tester.pumpWidget(
        styleAnimationBuilderCapturingColor(
          _colorSpec(Colors.red, animation),
          (color) => capturedColor = color,
        ),
      );
      await tester.pumpWidget(
        styleAnimationBuilderCapturingColor(
          _colorSpec(Colors.blue, animation),
          (color) => capturedColor = color,
        ),
      );

      expect(capturedColor, Colors.blue);
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

/// A subtree without MaterialApp, which schedules frames of its own.
Widget _motionView(Widget child, {bool reduced = true}) {
  return MediaQuery(
    data: MediaQueryData(disableAnimations: reduced),
    child: child,
  );
}

/// A MaterialApp whose subtree sets `disableAnimations` to [reduced].
Widget _colorHost(
  StyleSpec<TestSpec> spec, {
  required bool reduced,
  required void Function(Color?) onColor,
}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(disableAnimations: reduced),
      child: styleAnimationBuilderCapturingColor(spec, onColor, wrapApp: false),
    ),
  );
}

/// A builder in a bare [_motionView] that records the resolved color.
Widget _colorView(
  StyleSpec<TestSpec> spec, {
  required bool reduced,
  required void Function(Color?) onColor,
}) {
  return _motionView(
    StyleAnimationBuilder<TestSpec>(
      spec: spec,
      builder: (context, resolved) {
        onColor(resolved.spec.color);

        return const SizedBox();
      },
    ),
    reduced: reduced,
  );
}

StyleSpec<TestSpec> _colorSpec(Color color, AnimationConfig? animation) {
  return StyleSpec<TestSpec>(
    spec: TestSpec(color: color),
    animation: animation,
  );
}

PhaseAnimationConfig<TestSpec, _TestStyle> _loopingPhase({
  Duration duration = const Duration(milliseconds: 300),
  Listenable? trigger,
  VoidCallback? onEnd,
}) {
  return PhaseAnimationConfig<TestSpec, _TestStyle>(
    styles: const [
      _TestStyle(TestSpec(color: Colors.red)),
      _TestStyle(TestSpec(color: Colors.blue)),
    ],
    curveConfigs: [
      CurveAnimationConfig(duration: duration, curve: Curves.linear),
      CurveAnimationConfig(
        duration: duration,
        curve: Curves.linear,
        onEnd: onEnd,
      ),
    ],
    trigger: trigger,
  );
}

KeyframeAnimationConfig<TestSpec> _colorKeyframes({Listenable? trigger}) {
  return KeyframeAnimationConfig<TestSpec>(
    trigger: trigger,
    initialStyle: const _TestStyle(TestSpec(color: Colors.red)),
    timeline: [
      KeyframeTrack<Color>(
        'color',
        [const Keyframe.linear(Colors.blue, Duration(milliseconds: 300))],
        initial: Colors.red,
        tweenBuilder: ({begin, end}) => ColorTween(begin: begin, end: end),
      ),
    ],
    styleBuilder: (result, style) =>
        _TestStyle(TestSpec(color: result.get<Color>('color'))),
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
