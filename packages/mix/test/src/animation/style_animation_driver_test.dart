import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

final class StyleAnimationDriverTest extends StyleAnimationDriver<MockSpec> {
  StyleAnimationDriverTest({
    required super.vsync,
    super.unbounded,
    required super.initialStyle,
  });
  int executeAnimationCallCounter = 0;

  @override
  Future<void> executeAnimation() async {
    executeAnimationCallCounter += 1;
  }
}

void main() {
  group('StyleAnimationDriver', () {
    late StyleAnimationDriverTest driver;

    setUp(() {
      driver = StyleAnimationDriverTest(
        vsync: const TestVSync(),
        initialStyle: MockResolvedStyle(0),
      );
    });

    tearDown(() {
      driver.dispose();
    });

    test(
      'interpolateAt should linearly interpolate between start and end styles',
      () {
        final endStyle = MockResolvedStyle(1);

        // Set up interpolation
        driver.animateTo(endStyle);

        // Test interpolation at different points
        for (var point in [0.3, 0.5, 0.8]) {
          final interpolated = driver.interpolateAt(point);

          expect(interpolated.spec?.value, point);
        }
      },
    );

    test('reset should restore the driver to the begining', () {
      driver.animateTo(MockResolvedStyle(0));
      driver.animateTo(MockResolvedStyle(1));

      expect(driver.currentResolvedStyle, MockResolvedStyle(0));

      driver.reset();

      expect(driver.progress, 0.0);
      expect(driver.currentResolvedStyle, MockResolvedStyle(0));
    });

    testWidgets('should trigger onStart callback when the animation starts', (
      tester,
    ) async {
      int callCount = 0;
      void callback() => callCount++;

      driver.addOnStartListener(callback);
      await driver.animateTo(MockResolvedStyle(0));
      final future = driver.animateTo(MockResolvedStyle(1));

      driver.controller.duration = 300.ms;
      driver.controller.forward(from: 0);

      await tester.pump(150.ms);

      expect(callCount, 1);

      await tester.pumpAndSettle();
      await future;
    });

    testWidgets(
      'should trigger onComplete callback when the animation completes',
      (tester) async {
        int callCount = 0;
        void callback() => callCount++;

        driver.addOnCompleteListener(callback);
        await driver.animateTo(MockResolvedStyle(0));
        final future = driver.animateTo(MockResolvedStyle(1));

        driver.controller.duration = 300.ms;
        driver.controller.forward(from: 0);
        await tester.pumpAndSettle();

        expect(callCount, 1);

        await future;
      },
    );

    testWidgets('stop() should stop the animation ', (tester) async {
      await driver.animateTo(MockResolvedStyle(0));
      driver.animateTo(MockResolvedStyle(1));

      driver.controller.duration = 300.ms;
      driver.controller.forward(from: 0);

      await tester.pump(150.ms);
      expect(driver.isAnimating, true);
      driver.stop();

      expect(driver.isAnimating, false);
    });

    testWidgets('disposes correctly', (tester) async {
      final driver = CurveAnimationDriver<MockSpec>(
        initialStyle: MockResolvedStyle(0),
        vsync: tester,
        config: const CurveAnimationConfig(
          duration: Duration(milliseconds: 100),
          curve: Curves.linear,
        ),
      );

      await tester.pumpWidget(Container());

      // Start an animation
      driver.animateTo(MockResolvedStyle());
      await tester.pump();

      // Dispose should not throw
      expect(() => driver.dispose(), returnsNormally);
    });

    group('initialization ', () {
      test('with no progress', () {
        final driver = StyleAnimationDriverTest(
          vsync: const TestVSync(),
          initialStyle: MockResolvedStyle(0),
        );
        addTearDown(() {
          driver.dispose();
        });

        expect(driver.isAnimating, false);
        expect(driver.progress, 0.0);
      });

      test('with non-unbounded controller', () {
        final driver = StyleAnimationDriverTest(
          vsync: const TestVSync(),
          initialStyle: MockResolvedStyle(0),
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
          initialStyle: MockResolvedStyle(0),
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
          vsync: const TestVSync(),
          initialStyle: MockResolvedStyle(0),
        );
      });

      tearDown(() {
        driver.dispose();
      });

      testWidgets(
        'skips animation when target is already set and not animating',
        (tester) async {
          // Call again with the same target
          await driver.animateTo(MockResolvedStyle(0));

          // Verify executeAnimation was not called
          expect(driver.executeAnimationCallCounter, 0);
        },
      );

      test('calls executeAnimation when target style changes', () async {
        // Initial call
        await driver.animateTo(MockResolvedStyle(0));
        expect(driver.executeAnimationCallCounter, 0);

        // Call with same target style while not animating
        await driver.animateTo(MockResolvedStyle(1));
        // Counter should not increase as it should skip animation
        expect(driver.executeAnimationCallCounter, 1);

        // Call with different target style
        await driver.animateTo(MockResolvedStyle(2.0));
        expect(driver.executeAnimationCallCounter, 2);
      });
    });
  });

  group('CurveAnimationDriver', () {
    test(
      'interpolateAt should apply the curve when interpolating between styles',
      () {
        final curve = Curves.easeInOut;

        final driver = CurveAnimationDriver<MockSpec>(
          initialStyle: MockResolvedStyle(0),
          vsync: const TestVSync(),
          config: CurveAnimationConfig(
            duration: Duration(milliseconds: 300),
            curve: curve,
          ),
        );

        addTearDown(() {
          driver.dispose();
        });

        final startStyle = MockResolvedStyle(0);
        final endStyle = MockResolvedStyle(1);

        // Set up interpolation
        driver.animateTo(startStyle);
        driver.animateTo(endStyle);

        // Test interpolation at different points
        for (var point in [0.3, 0.5, 0.8]) {
          final interpolated = driver.interpolateAt(point);
          final valueOnCurve = curve.transform(point);

          expect(interpolated.spec?.value, valueOnCurve);
        }
      },
    );

    testWidgets('OnEnd should be triggered when the animation is completed', (
      tester,
    ) async {
      int counter = 0;

      final driver = CurveAnimationDriver<MockSpec>(
        initialStyle: MockResolvedStyle(0),
        vsync: const TestVSync(),
        config: CurveAnimationConfig.decelerate(300.ms, onEnd: () => counter++),
      );

      addTearDown(() {
        driver.dispose();
      });

      final startStyle = MockResolvedStyle(0);
      final endStyle = MockResolvedStyle(1);

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
        initialStyle: MockResolvedStyle(0),
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
        initialStyle: MockResolvedStyle(0),
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

      await driver.animateTo(MockResolvedStyle(0));
      final future = driver.animateTo(MockResolvedStyle(1));

      // Let the animation run to completion
      await tester.pumpAndSettle();
      await future;

      expect(callbackCount, 1);
      expect(driver.isAnimating, false);
    });
  });

  group('PhaseAnimationDriver', () {
    late PhaseAnimationDriver<MockSpec> driver;
    late ValueNotifier<bool> trigger;

    setUp(() {
      trigger = ValueNotifier(false);
      driver = PhaseAnimationDriver<MockSpec>(
        vsync: const TestVSync(),
        curvesAndDurations: [
          CurveAnimationConfig(
            duration: Duration(milliseconds: 300),
            curve: Curves.linear,
          ),
          CurveAnimationConfig(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
        ],
        specs: [MockSpec(0), MockSpec(1)],
        initialStyle: MockResolvedStyle(0),
        trigger: trigger,
      );
    });

    tearDown(() {
      trigger.dispose();
      driver.dispose();
    });

    test('initializes with correct specs and curves', () {
      expect(driver.specs.length, 2);
      expect(driver.curvesAndDurations.length, 2);
    });

    testWidgets('animates when trigger updates', (tester) async {
      trigger.value = true;

      // Animation should be running
      await tester.pump();
      expect(driver.isAnimating, true);

      // Let the animation complete
      await tester.pumpAndSettle();
      expect(driver.isAnimating, false);

      // Change the trigger back to false, which should start the animation again
      trigger.value = false;
      await tester.pump();
      expect(driver.isAnimating, true);

      await tester.pumpAndSettle();
      expect(driver.isAnimating, false);
    });

    testWidgets('triggers onStart and onComplete callbacks', (tester) async {
      int startCount = 0;
      int completeCount = 0;

      driver.addOnStartListener(() => startCount++);
      driver.addOnCompleteListener(() => completeCount++);

      trigger.value = true;
      await tester.pumpAndSettle();

      expect(startCount, 1);
      expect(completeCount, 1);
    });
  });
}

// Test helpers
class MockSpec extends Spec<MockSpec> {
  final double value;

  const MockSpec([this.value = 0]);

  @override
  MockSpec copyWith() => this;

  @override
  MockSpec lerp(MockSpec? other, double t) {
    return MockSpec(lerpDouble(value, other?.value, t)!);
  }

  @override
  List<Object?> get props => [];

  Widget build(BuildContext context) => Container();
}

class MockResolvedStyle extends ResolvedStyle<MockSpec> {
  final double value;
  MockResolvedStyle([this.value = 0]) : super(spec: MockSpec(value));

  @override
  List<Object?> get props => [value];
}
