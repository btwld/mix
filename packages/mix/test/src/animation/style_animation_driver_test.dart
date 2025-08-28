import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

final class StyleAnimationDriverTest
    extends StyleAnimationDriver<MockSpec<double>> {
  StyleAnimationDriverTest({
    required super.vsync,
    super.unbounded,
    required super.initialSpec,
  });
  int executeAnimationCallCounter = 0;

  @override
  Future<void> executeAnimation() async {
    executeAnimationCallCounter += 1;
  }

  @override
  bool get autoAnimateOnUpdate => true;
}

void main() {
  group('StyleAnimationDriver', () {
    late StyleAnimationDriverTest driver;

    setUp(() {
      driver = StyleAnimationDriverTest(
        vsync: const TestVSync(),
        initialSpec: MockSpec(resolvedValue: .0),
      );
    });

    tearDown(() {
      driver.dispose();
    });

    test('reset should restore the driver to the begining', () {
      driver.animateTo(MockSpec(resolvedValue: .0));
      driver.animateTo(MockSpec(resolvedValue: 1.0));

      expect(driver.animation.value, MockSpec(resolvedValue: .0));

      driver.reset();

      expect(driver.controller.value, 0.0);
      expect(driver.animation.value, MockSpec(resolvedValue: .0));
    });

    testWidgets(
      'should trigger animation status changes when the animation starts',
      (tester) async {
        int startCallCount = 0;

        driver.animation.addStatusListener((status) {
          if (status == AnimationStatus.forward ||
              status == AnimationStatus.reverse) {
            startCallCount++;
          }
        });

        await driver.animateTo(MockSpec(resolvedValue: 0));
        final future = driver.animateTo(MockSpec(resolvedValue: 1));

        driver.controller.duration = 300.ms;
        driver.controller.forward(from: 0);

        await tester.pump(150.ms);

        expect(startCallCount, 1);

        await tester.pumpAndSettle();
        await future;
      },
    );

    testWidgets('should trigger status changes when the animation completes', (
      tester,
    ) async {
      int completeCallCount = 0;

      driver.animation.addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          completeCallCount++;
        }
      });

      await driver.animateTo(MockSpec(resolvedValue: 0));
      final future = driver.animateTo(MockSpec(resolvedValue: 1));

      driver.controller.duration = 300.ms;
      driver.controller.forward(from: 0);
      await tester.pumpAndSettle();

      expect(completeCallCount, 1);

      await future;
    });

    testWidgets('stop() should stop the animation ', (tester) async {
      driver.controller.duration = 300.ms;
      await driver.animateTo(MockSpec(resolvedValue: 0));
      driver.animateTo(MockSpec(resolvedValue: 1));

      driver.controller.forward(from: 0);

      await tester.pump(150.ms);
      expect(driver.controller.isAnimating, true);

      // Record the current value before stopping
      final valueBeforeStop = driver.controller.value;

      driver.stop();

      // After stop(), the controller should no longer be animating
      expect(driver.controller.isAnimating, false);

      // Pump some time and verify the value hasn't changed
      await tester.pump(100.ms);
      expect(driver.controller.value, valueBeforeStop);
    });

    testWidgets('disposes correctly', (tester) async {
      final driver = CurveAnimationDriver<MockSpec>(
        initialSpec: MockSpec(resolvedValue: 0),
        vsync: tester,
        config: const CurveAnimationConfig(
          duration: Duration(milliseconds: 100),
          curve: Curves.linear,
        ),
      );

      await tester.pumpWidget(Container());

      // Start an animation
      driver.animateTo(MockSpec(resolvedValue: 0));
      await tester.pump();

      // Dispose should not throw
      expect(() => driver.dispose(), returnsNormally);
    });

    group('initialization ', () {
      test('with no progress', () {
        final driver = StyleAnimationDriverTest(
          vsync: const TestVSync(),
          initialSpec: MockSpec(resolvedValue: 0),
        );
        addTearDown(() {
          driver.dispose();
        });

        expect(driver.animation.isAnimating, false);
        expect(driver.controller.value, 0.0);
      });

      test('with non-unbounded controller', () {
        final driver = StyleAnimationDriverTest(
          vsync: const TestVSync(),
          initialSpec: MockSpec(resolvedValue: 0),
        );
        addTearDown(() {
          driver.dispose();
        });

        final controller = driver.controller;

        expect(controller.lowerBound, 0);
        expect(controller.upperBound, 1);
      });

      test('with unbounded controller when unbounded is true', () {
        final driver = StyleAnimationDriverTest(
          vsync: const TestVSync(),
          initialSpec: MockSpec(resolvedValue: 0),
          unbounded: true,
        );
        addTearDown(() {
          driver.dispose();
        });

        final controller = driver.controller;

        expect(controller.lowerBound, double.negativeInfinity);
        expect(controller.upperBound, double.infinity);
      });
    });

    group('animateTo ', () {
      late StyleAnimationDriverTest driver;

      setUp(() {
        driver = StyleAnimationDriverTest(
          initialSpec: MockSpec(resolvedValue: 0),
          vsync: const TestVSync(),
        );
      });

      tearDown(() {
        driver.dispose();
      });

      testWidgets(
        'skips animation when target is already set and not animating',
        (tester) async {
          // Call again with the same target
          await driver.animateTo(MockSpec(resolvedValue: 0));

          // Verify executeAnimation was not called
          expect(driver.executeAnimationCallCounter, 0);
        },
      );

      test('calls executeAnimation when target style changes', () async {
        // Initial call
        await driver.animateTo(MockSpec(resolvedValue: 0));
        expect(driver.executeAnimationCallCounter, 0);

        // Call with same target style while not animating
        await driver.animateTo(MockSpec(resolvedValue: 1));
        // Counter should not increase as it should skip animation
        expect(driver.executeAnimationCallCounter, 1);

        // Call with different target style
        await driver.animateTo(MockSpec(resolvedValue: 2.0));
        expect(driver.executeAnimationCallCounter, 2);
      });
    });
  });

  group('CurveAnimationDriver', () {
    testWidgets('OnEnd should be triggered when the animation is completed', (
      tester,
    ) async {
      int counter = 0;

      final driver = CurveAnimationDriver<MockSpec<double>>(
        initialSpec: MockSpec(resolvedValue: 0),
        vsync: const TestVSync(),
        config: CurveAnimationConfig.decelerate(300.ms, onEnd: () => counter++),
      );

      addTearDown(() {
        driver.dispose();
      });

      final startStyle = MockSpec(resolvedValue: 0.0);
      final endStyle = MockSpec(resolvedValue: 1.0);

      // Set up interpolation
      await driver.animateTo(startStyle);
      final future = driver.animateTo(endStyle);

      await tester.pumpAndSettle();
      await future;

      expect(counter, 1);
    });
  });

  group('SpringAnimationDriver', () {
    test('should create an unbounded animation controller', () {
      final driver = SpringAnimationDriver<MockSpec>(
        initialSpec: MockSpec(resolvedValue: 0),
        vsync: const TestVSync(),
        config: SpringAnimationConfig.standard(),
      );

      final controller = driver.controller;

      // Verify it's unbounded
      expect(controller.lowerBound, double.negativeInfinity);
      expect(controller.upperBound, double.infinity);

      driver.dispose();
    });

    testWidgets('should complete animation and call onEnd callback', (
      tester,
    ) async {
      int callbackCount = 0;

      final driver = SpringAnimationDriver<MockSpec>(
        initialSpec: MockSpec(resolvedValue: 0),
        vsync: tester,
        config: SpringAnimationConfig.standard(
          stiffness: 100.0,
          damping: 10.0,
          mass: 1.0,
          onEnd: () => callbackCount++,
        ),
      );

      addTearDown(() {
        driver.dispose();
      });

      await tester.pumpWidget(Container());

      await driver.animateTo(MockSpec(resolvedValue: 0));
      final future = driver.animateTo(MockSpec(resolvedValue: 1));

      // Let the animation run to completion
      await tester.pumpAndSettle();
      await future;

      expect(callbackCount, 1);
      expect(driver.animation.isAnimating, false);
    });
  });

  group('PhaseAnimationDriver', () {
    late PhaseAnimationDriver<MockSpec> driver;
    late ValueNotifier<bool> trigger;

    setUp(() {
      trigger = ValueNotifier(false);
      driver = PhaseAnimationDriver<MockSpec>(
        vsync: const TestVSync(),
        curveConfigs: [
          CurveAnimationConfig(
            duration: Duration(milliseconds: 300),
            curve: Curves.linear,
          ),
          CurveAnimationConfig(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
        ],
        specs: [MockSpec(resolvedValue: 0), MockSpec(resolvedValue: 1)],
        initialSpec: MockSpec(resolvedValue: 0),
        trigger: trigger,
      );
    });

    tearDown(() {
      trigger.dispose();
      driver.dispose();
    });

    test('initializes with correct specs and curves', () {
      expect(driver.specs.length, 2);
      expect(driver.curveConfigs.length, 2);
    });

    testWidgets('animates when trigger updates', (tester) async {
      trigger.value = true;

      // Animation should be running
      await tester.pump();
      expect(driver.animation.isAnimating, true);

      // Let the animation complete
      await tester.pumpAndSettle();
      expect(driver.animation.isAnimating, false);

      // Change the trigger back to false, which should start the animation again
      trigger.value = false;
      await tester.pump();
      expect(driver.animation.isAnimating, true);

      await tester.pumpAndSettle();
      expect(driver.animation.isAnimating, false);
    });

    testWidgets('triggers animation status changes', (tester) async {
      int startCount = 0;
      int completeCount = 0;

      driver.animation.addStatusListener((status) {
        if (status == AnimationStatus.forward ||
            status == AnimationStatus.reverse) {
          startCount++;
        }
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          completeCount++;
        }
      });

      trigger.value = true;
      await tester.pumpAndSettle();

      expect(startCount, 1);
      expect(completeCount, 1);
    });
  });

  group('KeyframeAnimationDriver', () {
    late KeyframeAnimationDriver<MockSpec<double>> driver;
    late ValueNotifier<bool> trigger;
    late MockBuildContext mockContext;

    setUp(() {
      trigger = ValueNotifier(false);
      mockContext = MockBuildContext();

      final config = KeyframeAnimationConfig<MockSpec<double>>(
        trigger: trigger,
        timeline: [
          KeyframeTrack<double>('opacity', [
            Keyframe.linear(0.5, Duration(milliseconds: 100)),
            Keyframe.ease(1.0, Duration(milliseconds: 200)),
          ], initial: 0.0),
          KeyframeTrack<double>('scale', [
            Keyframe.easeIn(1.2, Duration(milliseconds: 150)),
            Keyframe.decelerate(1.0, Duration(milliseconds: 150)),
          ], initial: 1.0),
        ],
        styleBuilder: (result, style) {
          return MockStyle(result.get<double>('opacity'));
        },
        initialStyle: MockStyle(0.0),
      );

      driver = KeyframeAnimationDriver<MockSpec<double>>(
        vsync: const TestVSync(),
        config: config,
        initialSpec: MockSpec(resolvedValue: 0.0),
        context: mockContext,
      );
    });

    tearDown(() {
      trigger.dispose();
      driver.dispose();
    });

    group('duration calculation', () {
      late KeyframeAnimationDriver<MockSpec> driver;

      void setUpDriver(KeyframeAnimationConfig<MockSpec> config) {
        driver = KeyframeAnimationDriver<MockSpec>(
          vsync: const TestVSync(),
          config: config,
          initialSpec: MockSpec(resolvedValue: 0.0),
          context: mockContext,
        );
      }

      tearDown(() {
        driver.dispose();
      });

      test('calculates duration from timeline tracks', () {
        setUpDriver(
          KeyframeAnimationConfig<MockSpec>(
            trigger: ValueNotifier(false),
            timeline: [
              KeyframeTrack<double>('track1', [
                Keyframe.linear(1.0, Duration(milliseconds: 100)),
                Keyframe.linear(1.0, Duration(milliseconds: 300)),
              ], initial: 0.0),
              KeyframeTrack<double>('track2', [
                Keyframe.linear(1.0, Duration(milliseconds: 200)),
                Keyframe.linear(1.0, Duration(milliseconds: 200)),
              ], initial: 0.0),
            ],
            styleBuilder: (result, style) => style,
            initialStyle: MockStyle(MockSpec(resolvedValue: 0.0)),
          ),
        );
        expect(driver.duration, Duration(milliseconds: 400));
      });

      test('returns zero duration for empty timeline', () {
        setUpDriver(
          KeyframeAnimationConfig<MockSpec>(
            trigger: ValueNotifier(false),
            timeline: [],
            styleBuilder: (result, style) => style,
            initialStyle: MockStyle(MockSpec(resolvedValue: 0.0)),
          ),
        );
        expect(driver.duration, Duration.zero);
      });

      test('uses maximum duration from all tracks', () {
        setUpDriver(
          KeyframeAnimationConfig<MockSpec>(
            trigger: ValueNotifier(false),
            timeline: [
              KeyframeTrack<double>('track1', [
                Keyframe.linear(1.0, Duration(milliseconds: 100)),
                Keyframe.linear(1.0, Duration(milliseconds: 100)),
              ], initial: 0.0),
              KeyframeTrack<double>('track3', [
                Keyframe.linear(1.0, Duration(milliseconds: 200)),
                Keyframe.linear(1.0, Duration(milliseconds: 600)),
              ], initial: 0.0),
              KeyframeTrack<double>('track2', [
                Keyframe.linear(1.0, Duration(milliseconds: 200)),
                Keyframe.linear(1.0, Duration(milliseconds: 200)),
              ], initial: 0.0),
            ],
            styleBuilder: (result, style) => style,
            initialStyle: MockStyle(MockSpec(resolvedValue: 0.0)),
          ),
        );
        expect(driver.duration, Duration(milliseconds: 800));
      });
    });

    group('trigger handling', () {
      testWidgets('executes animation when trigger changes', (tester) async {
        bool animationStarted = false;
        driver.animation.addStatusListener((status) {
          if (status == AnimationStatus.forward) {
            animationStarted = true;
          }
        });

        trigger.value = true;
        await tester.pump();

        expect(animationStarted, true);
        await tester.pumpAndSettle();
      });

      testWidgets('handles trigger changes during animation', (tester) async {
        int animationCount = 0;
        driver.animation.addStatusListener((status) {
          if (status == AnimationStatus.forward) {
            animationCount++;
          }
        });

        // Start first animation
        trigger.value = true;
        await tester.pump(Duration(milliseconds: 50));

        // Change trigger again before first animation completes
        trigger.value = false;
        await tester.pump(Duration(milliseconds: 50));

        // Both animations should have started
        expect(animationCount, greaterThanOrEqualTo(1));
        await tester.pumpAndSettle();
      });
    });

    group('animation execution', () {
      testWidgets('resets controller before starting animation', (
        tester,
      ) async {
        // Manually set controller value
        driver.controller.value = 0.5;

        final future = driver.executeAnimation();
        await tester.pump();

        expect(driver.controller.value, 0.0);

        // Clean up
        await tester.pumpAndSettle();
        await future;
      });
    });

    group('keyframe animation result', () {
      testWidgets('transforms animation values through KeyframeAnimatable', (
        tester,
      ) async {
        // Start animation
        trigger.value = true;
        await tester.pump();

        // Pump partway through animation
        await tester.pump(Duration(milliseconds: 100));

        // Animation should be in progress
        expect(driver.animation.isAnimating, true);

        final opacityValue1 =
            (driver.animation.value as MockSpec).resolvedValue;
        expect(opacityValue1, greaterThanOrEqualTo(0.5));
        expect(opacityValue1, lessThanOrEqualTo(0.6));

        await tester.pump(Duration(milliseconds: 100));

        final opacityValue2 =
            (driver.animation.value as MockSpec).resolvedValue;
        final curvePoint = Curves.ease.transform(0.5);
        final expectedValue = lerpDouble(opacityValue1, 1.0, curvePoint)!;
        expect(opacityValue2, greaterThanOrEqualTo(expectedValue - 0.01));
        expect(opacityValue2, lessThanOrEqualTo(expectedValue + 0.01));

        // The animation value should be transformed by the KeyframeAnimatable
        final currentValue = driver.animation.value;
        expect(currentValue, isA<MockSpec>());
        await tester.pumpAndSettle();
      });
    });

    group('error handling', () {
      test('handles empty timeline gracefully', () {
        final config = KeyframeAnimationConfig<MockSpec>(
          trigger: ValueNotifier(false),
          timeline: [],
          styleBuilder: (result, style) => style,
          initialStyle: MockStyle(MockSpec(resolvedValue: 0.0)),
        );

        expect(
          () => KeyframeAnimationDriver<MockSpec>(
            vsync: const TestVSync(),
            config: config,
            initialSpec: MockSpec(resolvedValue: 0.0),
            context: mockContext,
          ),
          returnsNormally,
        );
      });
    });
  });
}
