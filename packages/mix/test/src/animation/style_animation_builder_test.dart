import 'package:flutter/material.dart';
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
