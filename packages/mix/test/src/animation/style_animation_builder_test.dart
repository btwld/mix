import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('AnimationStyleWidget', () {
    testWidgets('builds with initial style', (tester) async {
      const animationConfig = CurveAnimationConfig(
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      );
      const spec = WidgetSpec<TestSpec>(spec: TestSpec());

      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            animationConfig: animationConfig,
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
      const spec = WidgetSpec<TestSpec>(spec: TestSpec());

      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            animationConfig: animationConfig,
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
      const spec1 = WidgetSpec<TestSpec>(spec: TestSpec(color: Colors.red));
      const spec2 = WidgetSpec<TestSpec>(spec: TestSpec(color: Colors.blue));

      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            animationConfig: animationConfig,
            spec: spec1,
            builder: (context, spec) =>
                Container(key: ValueKey(spec.spec.color)),
          ),
        ),
      );

      await tester.pump();

      // Update style
      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            animationConfig: animationConfig,
            spec: spec2,
            builder: (context, spec) =>
                Container(key: ValueKey(spec.spec.color)),
          ),
        ),
      );

      // Animation should trigger
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();
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
      const spec = WidgetSpec<TestSpec>(spec: TestSpec(color: Colors.red));

      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            animationConfig: config1,
            spec: spec,
            builder: (context, spec) => Container(color: spec.spec.color),
          ),
        ),
      );

      await tester.pump();

      // Change config
      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            animationConfig: config2,
            spec: spec,
            builder: (context, spec) => Container(color: spec.spec.color),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();
    });

    testWidgets('disposes correctly', (tester) async {
      const animationConfig = CurveAnimationConfig(
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      );
      const spec = WidgetSpec<TestSpec>(spec: TestSpec());

      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            animationConfig: animationConfig,
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
      const spec = WidgetSpec<TestSpec>(
        spec: TestSpec(color: Colors.transparent),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            animationConfig: animationConfig,
            spec: spec,
            builder: (context, spec) =>
                Container(key: const Key('test-container')),
          ),
        ),
      );

      // Should render container even with empty/default spec
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

  Widget build(BuildContext context) => Container(color: color);
}
