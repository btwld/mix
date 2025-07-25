import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';


void main() {
  group('CurveAnimationDriver', () {
    late AnimationController controller;
    late CurveAnimationDriver<MockSpec> driver;

    setUp(() {
      controller = AnimationController(
        vsync: const TestVSync(),
      );
      driver = CurveAnimationDriver<MockSpec>(
        vsync: const TestVSync(),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });

    tearDown(() {
      driver.dispose();
      controller.dispose();
    });

    test('initializes with correct properties', () {
      expect(driver.duration, const Duration(milliseconds: 300));
      expect(driver.curve, Curves.easeInOut);
      expect(driver.isAnimating, false);
      expect(driver.progress, 0.0);
    });

    testWidgets('animates to target style', (tester) async {
      final endStyle = MockResolvedStyle();

      bool animationStarted = false;
      bool animationCompleted = false;

      driver.addOnStartListener(() => animationStarted = true);
      driver.addOnCompleteListener(() => animationCompleted = true);

      await tester.pumpWidget(Container());

      // Start animation
      final future = driver.animateTo(endStyle);

      // Should start immediately
      await tester.pump();
      expect(animationStarted, true);
      expect(driver.isAnimating, true);

      // Mid animation
      await tester.pump(const Duration(milliseconds: 150));
      expect(driver.progress, greaterThan(0.0));
      expect(driver.progress, lessThan(1.0));

      // Complete animation
      await tester.pumpAndSettle();
      await future;

      expect(animationCompleted, true);
      expect(driver.isAnimating, false);
      expect(driver.progress, 1.0);
    });

    test('interpolates correctly with curve', () {
      final startStyle = MockResolvedStyle();
      final endStyle = MockResolvedStyle();

      // Set up interpolation
      driver.animateTo(startStyle);
      driver.animateTo(endStyle);

      // Test interpolation at different points
      final interpolated = driver.interpolateAt(0.5);
      expect(interpolated, isNotNull);
    });

    test('handles stop correctly', () {
      final style = MockResolvedStyle();

      driver.animateTo(style);
      driver.stop();

      expect(driver.isAnimating, false);
    });

    test('handles reset correctly', () {
      final style = MockResolvedStyle();

      driver.animateTo(style);
      driver.reset();

      expect(driver.progress, 0.0);
      expect(driver.currentResolvedStyle, null);
    });

    test('removes listeners correctly', () {
      int callCount = 0;
      void callback() => callCount++;

      driver.addOnStartListener(callback);
      driver.removeOnStartListener(callback);

      driver.animateTo(MockResolvedStyle());

      expect(callCount, 0);
    });
  });

  group('SpringAnimationDriver', () {
    late SpringAnimationDriver<MockSpec> driver;

    setUp(() {
      driver = SpringAnimationDriver<MockSpec>(
        vsync: const TestVSync(),
        stiffness: 200.0,
        damping: 15.0,
        mass: 1.0,
      );
    });

    tearDown(() {
      driver.dispose();
    });

    test('initializes with correct spring properties', () {
      expect(driver.spring.mass, 1.0);
      expect(driver.spring.stiffness, 200.0);
      expect(driver.spring.damping, 15.0);
    });

    testWidgets('animates with spring physics', (tester) async {
      final endStyle = MockResolvedStyle();

      await tester.pumpWidget(Container());

      // Start animation
      final future = driver.animateTo(endStyle);

      // Spring animations don't have fixed duration
      await tester.pump();
      expect(driver.isAnimating, true);

      // Let spring settle
      await tester.pumpAndSettle();
      await future;

      expect(driver.isAnimating, false);
    });

    test('interpolates linearly', () {
      final startStyle = MockResolvedStyle();
      final endStyle = MockResolvedStyle();

      driver.animateTo(startStyle);
      driver.animateTo(endStyle);

      // Spring driver uses linear interpolation
      final interpolated = driver.interpolateAt(0.5);
      expect(interpolated, isNotNull);
    });
  });

  group('NoAnimationDriver', () {
    late NoAnimationDriver<MockSpec> driver;

    setUp(() {
      driver = NoAnimationDriver<MockSpec>(
        vsync: const TestVSync(),
      );
    });

    tearDown(() {
      driver.dispose();
    });

    test('updates immediately without animation', () async {
      final style = MockResolvedStyle();

      await driver.animateTo(style);

      expect(driver.currentResolvedStyle, style);
      expect(driver.isAnimating, false);
    });
  });

  group('AnimationDriver lifecycle', () {
    testWidgets('disposes correctly', (tester) async {
      final driver = CurveAnimationDriver<MockSpec>(
        vsync: tester,
        duration: const Duration(milliseconds: 100),
      );

      await tester.pumpWidget(Container());

      // Start an animation
      driver.animateTo(MockResolvedStyle());
      await tester.pump();

      // Dispose should not throw
      expect(() => driver.dispose(), returnsNormally);
    });

  });
}

// Test helpers
class MockSpec extends Spec<MockSpec> {
  const MockSpec();

  @override
  MockSpec copyWith() => this;

  @override
  MockSpec lerp(MockSpec? other, double t) => other ?? this;

  @override
  List<Object?> get props => [];

  Widget build(BuildContext context) => Container();
}

class MockResolvedStyle extends ResolvedStyle<MockSpec> {
  MockResolvedStyle() : super(spec: const MockSpec());

  @override
  ResolvedStyle<MockSpec> lerp(ResolvedStyle<MockSpec>? other, double t) {
    return other ?? this;
  }
}