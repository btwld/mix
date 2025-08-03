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
      final style = TestResolvedStyle();

      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            animationConfig: animationConfig,
            resolvedStyle: style,
            builder: (context, resolvedStyle) => Container(
              key: const Key('test-container'),
              color: resolvedStyle.spec?.color,
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
      final style = TestResolvedStyle();

      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            animationConfig: animationConfig,
            resolvedStyle: style,
            builder: (context, resolvedStyle) =>
                Container(key: ValueKey(resolvedStyle.spec?.color)),
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
      final style1 = TestResolvedStyle(color: Colors.red);
      final style2 = TestResolvedStyle(color: Colors.blue);

      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            animationConfig: animationConfig,
            resolvedStyle: style1,
            builder: (context, resolvedStyle) =>
                Container(key: ValueKey(resolvedStyle.spec?.color)),
          ),
        ),
      );

      await tester.pump();

      // Update style
      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            animationConfig: animationConfig,
            resolvedStyle: style2,
            builder: (context, resolvedStyle) =>
                Container(key: ValueKey(resolvedStyle.spec?.color)),
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
      final style = TestResolvedStyle(color: Colors.red);

      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            animationConfig: config1,
            resolvedStyle: style,
            builder: (context, resolvedStyle) =>
                Container(color: resolvedStyle.spec?.color),
          ),
        ),
      );

      await tester.pump();

      // Change config
      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            animationConfig: config2,
            resolvedStyle: style,
            builder: (context, resolvedStyle) =>
                Container(color: resolvedStyle.spec?.color),
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
      final style = TestResolvedStyle();

      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            animationConfig: animationConfig,
            resolvedStyle: style,
            builder: (context, resolvedStyle) => Container(),
          ),
        ),
      );

      // Replace widget to trigger dispose
      await tester.pumpWidget(Container());

      // Widget should be disposed without errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('handles null spec gracefully', (tester) async {
      const animationConfig = CurveAnimationConfig(
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      );
      final style = TestResolvedStyle(hasNullSpec: true);

      await tester.pumpWidget(
        MaterialApp(
          home: StyleAnimationBuilder<TestSpec>(
            animationConfig: animationConfig,
            resolvedStyle: style,
            builder: (context, resolvedStyle) =>
                Container(key: const Key('test-container')),
          ),
        ),
      );

      // Should render container even with null spec
      expect(find.byKey(const Key('test-container')), findsOneWidget);
    });
  });
}

// Test helpers
class TestSpec extends Spec<TestSpec> {
  final Color color;

  const TestSpec({this.color = Colors.black});

  @override
  TestSpec copyWith({Color? color}) => TestSpec(color: color ?? this.color);

  @override
  TestSpec lerp(TestSpec? other, double t) {
    if (other == null) return this;
    return TestSpec(color: Color.lerp(color, other.color, t) ?? color);
  }

  @override
  List<Object?> get props => [color];

  Widget build(BuildContext context) => Container(color: color);
}

class TestResolvedStyle extends ResolvedStyle<TestSpec> {
  final Color color;
  final bool hasNullSpec;

  TestResolvedStyle({this.color = Colors.black, this.hasNullSpec = false})
    : super(spec: hasNullSpec ? null : TestSpec(color: color));

  @override
  ResolvedStyle<TestSpec> lerp(ResolvedStyle<TestSpec>? other, double t) {
    if (other == null) return this;
    return TestResolvedStyle(
      color: Color.lerp(color, (other as TestResolvedStyle).color, t) ?? color,
    );
  }
}
