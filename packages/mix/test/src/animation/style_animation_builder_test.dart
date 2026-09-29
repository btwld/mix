import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

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

  group('reduced motion', () {
    const curve = CurveAnimationConfig(
      duration: Duration(milliseconds: 400),
      curve: Curves.linear,
    );
    final spring = SpringAnimationConfig.withDurationAndBounce(
      duration: const Duration(milliseconds: 800),
    );

    for (final (name, animation) in <(String, AnimationConfig)>[
      ('curve', curve),
      ('spring', spring),
    ]) {
      testWidgets('lands a $name change on the target in the same frame', (
        tester,
      ) async {
        Color? color;
        void onColor(Color? value) => color = value;

        await tester.pumpWidget(
          _colorHost(_colorSpec(Colors.red, animation), onColor: onColor),
        );
        await tester.pumpWidget(
          _colorHost(_colorSpec(Colors.blue, animation), onColor: onColor),
        );

        expect(color, Colors.blue);
      });
    }

    for (final (name, animation) in <(String, AnimationConfig)>[
      ('phase', _loopingPhase()),
      ('keyframe', _colorKeyframes()),
    ]) {
      testWidgets('never starts a looping $name', (tester) async {
        // Bare view: MaterialApp schedules a frame of its own.
        await tester.pumpWidget(
          _colorView(_colorSpec(Colors.red, animation), onColor: (_) {}),
        );

        expect(tester.binding.hasScheduledFrame, isFalse);
        await tester.pump(const Duration(milliseconds: 300));
        expect(tester.binding.hasScheduledFrame, isFalse);
      });

      testWidgets('stops a looping $name and resumes it with the flag', (
        tester,
      ) async {
        Color? color;
        Widget host({required bool reduced}) => _colorHost(
          _colorSpec(Colors.red, animation),
          reduced: reduced,
          onColor: (value) => color = value,
        );

        await tester.pumpWidget(host(reduced: false));
        await tester.pump(const Duration(milliseconds: 150));
        expect(color, isNot(Colors.red));

        await tester.pumpWidget(host(reduced: true));
        expect(color, Colors.red);
        await tester.pump();
        expect(tester.binding.hasScheduledFrame, isFalse);

        await tester.pumpWidget(host(reduced: false));
        await tester.pump(const Duration(milliseconds: 150));
        expect(color, isNot(Colors.red));
      });
    }

    testWidgets('applies from the next transition', (tester) async {
      Color? color;
      Widget host(Color target, {required bool reduced}) => _colorHost(
        _colorSpec(target, curve),
        reduced: reduced,
        onColor: (value) => color = value,
      );

      await tester.pumpWidget(host(Colors.red, reduced: false));
      await tester.pumpAndSettle();

      // A transition that is running when the flag turns on finishes.
      await tester.pumpWidget(host(Colors.blue, reduced: false));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpWidget(host(Colors.blue, reduced: true));
      expect(color, isNot(Colors.blue));
      await tester.pumpAndSettle();
      expect(color, Colors.blue);

      // The next transition jumps.
      await tester.pumpWidget(host(Colors.green, reduced: true));
      expect(color, Colors.green);

      // Clearing the flag animates the next transition again.
      await tester.pumpWidget(host(Colors.green, reduced: false));
      await tester.pumpWidget(host(Colors.red, reduced: false));
      await tester.pump(const Duration(milliseconds: 100));
      expect(color, isNot(Colors.green));
      expect(color, isNot(Colors.red));
      await tester.pumpAndSettle();
      expect(color, Colors.red);
    });

    testWidgets('a flag turning on with a spec change jumps in that frame', (
      tester,
    ) async {
      Color? color;
      void onColor(Color? value) => color = value;

      await tester.pumpWidget(
        _colorHost(
          _colorSpec(Colors.red, curve),
          reduced: false,
          onColor: onColor,
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpWidget(
        _colorHost(_colorSpec(Colors.blue, curve), onColor: onColor),
      );

      expect(color, Colors.blue);
      await tester.pump(const Duration(milliseconds: 100));
      expect(color, Colors.blue);
    });

    testWidgets('a flag clearing with a spec change animates that change', (
      tester,
    ) async {
      Color? color;
      void onColor(Color? value) => color = value;

      await tester.pumpWidget(
        _colorHost(_colorSpec(Colors.red, curve), onColor: onColor),
      );
      await tester.pumpAndSettle();
      await tester.pumpWidget(
        _colorHost(
          _colorSpec(Colors.blue, curve),
          reduced: false,
          onColor: onColor,
        ),
      );
      expect(color, Colors.red);

      await tester.pump(const Duration(milliseconds: 200));
      expect(color, isNot(Colors.red));
      expect(color, isNot(Colors.blue));
      await tester.pumpAndSettle();
      expect(color, Colors.blue);
    });

    testWidgets('fires onEnd once, after the frame', (tester) async {
      final phases = <SchedulerPhase>[];
      final animation = CurveAnimationConfig(
        duration: const Duration(milliseconds: 400),
        curve: Curves.linear,
        onEnd: () => phases.add(SchedulerBinding.instance.schedulerPhase),
      );

      await tester.pumpWidget(
        _colorHost(_colorSpec(Colors.red, animation), onColor: (_) {}),
      );
      await tester.pump();
      expect(phases, isEmpty);

      await tester.pumpWidget(
        _colorHost(_colorSpec(Colors.blue, animation), onColor: (_) {}),
      );
      expect(phases, [SchedulerPhase.postFrameCallbacks]);

      await tester.pump();
      expect(phases, hasLength(1));
    });

    for (final (name, next) in <(String, AnimationConfig)>[
      ('curve', curve),
      ('spring', spring),
    ]) {
      testWidgets(
        'a jump shows the target itself and the next $name transition '
        'starts from it',
        (tester) async {
          Color? color;
          Widget host(
            Color target,
            AnimationConfig animation, {
            required bool reduced,
          }) => _colorHost(
            _colorSpec(target, animation),
            reduced: reduced,
            onColor: (value) => color = value,
          );

          await tester.pumpWidget(host(Colors.red, curve, reduced: false));
          await tester.pumpWidget(host(Colors.blue, curve, reduced: false));
          await tester.pump(const Duration(milliseconds: 100));

          // The controller is mid-way; the jump must not lerp the target.
          await tester.pumpWidget(host(Colors.green, next, reduced: true));
          expect(color, same(Colors.green));

          await tester.pumpWidget(host(Colors.red, next, reduced: false));
          expect(color, same(Colors.green));
          await tester.pump(const Duration(milliseconds: 100));
          expect(color, isNot(Colors.green));
          expect(color, isNot(Colors.red));

          await tester.pumpAndSettle();
          // A settled spring can stop a hair short of its end.
          expect(color, isSameColorAs(Colors.red));
        },
      );
    }

    for (final (name, next) in <(String, AnimationConfig?)>[
      ('replaced by a spring', spring),
      // A null config recreates the driver with the old config.
      ('dropped', null),
      (
        'updated',
        const CurveAnimationConfig(
          duration: Duration(milliseconds: 600),
          curve: Curves.easeIn,
        ),
      ),
    ]) {
      testWidgets('a curve $name while reduced jumps', (tester) async {
        Color? color;
        void onColor(Color? value) => color = value;

        await tester.pumpWidget(
          _colorView(_colorSpec(Colors.red, curve), onColor: onColor),
        );
        await tester.pumpWidget(
          _colorView(_colorSpec(Colors.blue, next), onColor: onColor),
        );

        expect(color, Colors.blue);
        expect(tester.binding.hasScheduledFrame, isFalse);
      });
    }

    for (final (name, from) in <(String, AnimationConfig)>[
      ('a curve', curve),
      ('a looping phase', _loopingPhase()),
    ]) {
      testWidgets('$name replaced by a looping phase while reduced holds', (
        tester,
      ) async {
        Color? color;
        void onColor(Color? value) => color = value;

        await tester.pumpWidget(
          _colorView(_colorSpec(Colors.red, from), onColor: onColor),
        );
        await tester.pumpWidget(
          _colorView(
            _colorSpec(
              Colors.red,
              _loopingPhase(duration: const Duration(milliseconds: 500)),
            ),
            onColor: onColor,
          ),
        );

        expect(color, Colors.red);
        expect(tester.binding.hasScheduledFrame, isFalse);
        await tester.pump(const Duration(milliseconds: 150));
        expect(color, Colors.red);
      });
    }

    testWidgets('jumps a triggered phase to its end', (tester) async {
      final trigger = ValueNotifier(0);
      addTearDown(trigger.dispose);
      var ends = 0;
      Color? color;

      await tester.pumpWidget(
        _colorView(
          _colorSpec(
            Colors.red,
            _loopingPhase(trigger: trigger, onEnd: () => ends++),
          ),
          onColor: (value) => color = value,
        ),
      );

      trigger.value++;
      // The zero-duration run completes inside the trigger notification.
      expect(ends, 1);

      await tester.pump();
      // The sequence ends back on its first style.
      expect(color, Colors.red);
      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(ends, 1);
    });

    testWidgets('jumps a triggered keyframe to its end', (tester) async {
      final trigger = ValueNotifier(0);
      addTearDown(trigger.dispose);
      Color? color;

      await tester.pumpWidget(
        _colorView(
          _colorSpec(Colors.red, _colorKeyframes(trigger: trigger)),
          onColor: (value) => color = value,
        ),
      );
      expect(color, Colors.red);

      trigger.value++;
      await tester.pump();

      expect(color, Colors.blue);
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('follows the platform disableAnimations flag', (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      Color? color;

      await tester.pumpWidget(
        styleAnimationBuilderCapturingColor(
          _colorSpec(Colors.red, curve),
          (value) => color = value,
        ),
      );
      await tester.pumpWidget(
        styleAnimationBuilderCapturingColor(
          _colorSpec(Colors.blue, curve),
          (value) => color = value,
        ),
      );

      expect(color, Colors.blue);
    });
  });

  group('zero-length curves', () {
    testWidgets('a zero duration and delay jumps without asserting', (
      tester,
    ) async {
      var ends = 0;
      final animation = AnimationConfig.linear(
        Duration.zero,
        onEnd: () => ends++,
      );
      Color? color;

      await tester.pumpWidget(
        styleAnimationBuilderCapturingColor(
          _colorSpec(Colors.red, animation),
          (value) => color = value,
        ),
      );
      await tester.pumpWidget(
        styleAnimationBuilderCapturingColor(
          _colorSpec(Colors.blue, animation),
          (value) => color = value,
        ),
      );

      expect(color, Colors.blue);
      expect(ends, 1);
      expect(tester.takeException(), isNull);
    });

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
      Color? color;

      await tester.pumpWidget(
        styleAnimationBuilderCapturingColor(
          _colorSpec(Colors.red, animation),
          (value) => color = value,
        ),
      );
      await tester.pumpWidget(
        styleAnimationBuilderCapturingColor(
          _colorSpec(Colors.blue, animation),
          (value) => color = value,
        ),
      );
      expect(color, Colors.red);

      await tester.pump(const Duration(milliseconds: 199));
      expect(color, Colors.red);
      expect(ends, 0);

      await tester.pump(const Duration(milliseconds: 2));
      expect(color, Colors.blue);
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
      Color? color;

      await tester.pumpWidget(
        styleAnimationBuilderCapturingColor(
          _colorSpec(Colors.red, animation),
          (value) => color = value,
        ),
      );
      await tester.pumpWidget(
        styleAnimationBuilderCapturingColor(
          _colorSpec(Colors.blue, animation),
          (value) => color = value,
        ),
      );
      expect(tester.takeException(), isNull);

      await tester.pumpAndSettle();
      expect(color, Colors.blue);
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

/// A builder in a bare `MediaQuery`, without MaterialApp, which schedules
/// frames of its own.
Widget _colorView(
  StyleSpec<TestSpec> spec, {
  bool reduced = true,
  required void Function(Color?) onColor,
}) {
  return MediaQuery(
    data: MediaQueryData(disableAnimations: reduced),
    child: StyleAnimationBuilder<TestSpec>(
      spec: spec,
      builder: (context, resolved) {
        onColor(resolved.spec.color);

        return const SizedBox();
      },
    ),
  );
}

/// [_colorView] inside a MaterialApp.
Widget _colorHost(
  StyleSpec<TestSpec> spec, {
  bool reduced = true,
  required void Function(Color?) onColor,
}) {
  return MaterialApp(
    home: _colorView(spec, reduced: reduced, onColor: onColor),
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
