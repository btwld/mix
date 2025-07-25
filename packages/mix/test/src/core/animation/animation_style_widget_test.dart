import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('AnimationStyleWidget', () {
    testWidgets('builds with initial style', (tester) async {
      final driver = TestAnimationDriver<TestSpec>(
        vsync: const TestVSync(),
      );
      final style = TestResolvedStyle();

      await tester.pumpWidget(
        MaterialApp(
          home: AnimationStyleWidget<TestSpec>(
            driver: driver,
            style: style,
            builder: (context, spec) => Container(
              key: const Key('test-container'),
              color: spec.color,
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('test-container')), findsOneWidget);
    });

    testWidgets('triggers animation on mount', (tester) async {
      final driver = TestAnimationDriver<TestSpec>(
        vsync: const TestVSync(),
      );
      final style = TestResolvedStyle();

      bool animationTriggered = false;
      driver.onAnimateTo = (target) {
        animationTriggered = true;
        expect(target, style);
      };

      await tester.pumpWidget(
        MaterialApp(
          home: AnimationStyleWidget<TestSpec>(
            driver: driver,
            style: style,
            builder: (context, spec) => Container(),
          ),
        ),
      );

      // Wait for post frame callback
      await tester.pump();

      expect(animationTriggered, true);
    });

    testWidgets('animates to new style when updated', (tester) async {
      final driver = TestAnimationDriver<TestSpec>(
        vsync: const TestVSync(),
      );
      final style1 = TestResolvedStyle(color: Colors.red);
      final style2 = TestResolvedStyle(color: Colors.blue);

      int animateToCallCount = 0;
      driver.onAnimateTo = (target) {
        animateToCallCount++;
      };

      await tester.pumpWidget(
        MaterialApp(
          home: AnimationStyleWidget<TestSpec>(
            driver: driver,
            style: style1,
            builder: (context, spec) => Container(),
          ),
        ),
      );

      await tester.pump();
      expect(animateToCallCount, 1);

      // Update style
      await tester.pumpWidget(
        MaterialApp(
          home: AnimationStyleWidget<TestSpec>(
            driver: driver,
            style: style2,
            builder: (context, spec) => Container(),
          ),
        ),
      );

      expect(animateToCallCount, 2);
    });

    testWidgets('updates when driver changes', (tester) async {
      final driver1 = TestAnimationDriver<TestSpec>(
        vsync: const TestVSync(),
      );
      final driver2 = TestAnimationDriver<TestSpec>(
        vsync: const TestVSync(),
      );
      final style = TestResolvedStyle();

      await tester.pumpWidget(
        MaterialApp(
          home: AnimationStyleWidget<TestSpec>(
            driver: driver1,
            style: style,
            builder: (context, spec) => Container(
              color: spec.color,
            ),
          ),
        ),
      );

      driver1.testResolvedStyle = TestResolvedStyle(color: Colors.red);
      driver1.notifyListeners();
      await tester.pump();

      // Change driver
      await tester.pumpWidget(
        MaterialApp(
          home: AnimationStyleWidget<TestSpec>(
            driver: driver2,
            style: style,
            builder: (context, spec) => Container(
              color: spec.color,
            ),
          ),
        ),
      );

      driver2.testResolvedStyle = TestResolvedStyle(color: Colors.blue);
      driver2.notifyListeners();
      await tester.pump();

      // Should update with new driver
      final container = tester.widget<Container>(find.byType(Container).last);
      expect(container.color, Colors.blue);

      driver1.dispose();
      driver2.dispose();
    });

    testWidgets('disposes correctly', (tester) async {
      final driver = TestAnimationDriver<TestSpec>(
        vsync: const TestVSync(),
      );
      final style = TestResolvedStyle();

      await tester.pumpWidget(
        MaterialApp(
          home: AnimationStyleWidget<TestSpec>(
            driver: driver,
            style: style,
            builder: (context, spec) => Container(),
          ),
        ),
      );

      await tester.pumpWidget(Container());

      // Should remove listener on dispose
      driver.notifyListeners(); // Should not throw

      driver.dispose();
    });

    testWidgets('handles null spec gracefully', (tester) async {
      final driver = TestAnimationDriver<TestSpec>(
        vsync: const TestVSync(),
      );
      final style = TestResolvedStyle(hasNullSpec: true);

      await tester.pumpWidget(
        MaterialApp(
          home: AnimationStyleWidget<TestSpec>(
            driver: driver,
            style: style,
            builder: (context, spec) => Container(
              key: const Key('test-container'),
            ),
          ),
        ),
      );

      // Should render SizedBox.shrink when spec is null
      expect(find.byKey(const Key('test-container')), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
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
    return TestSpec(
      color: Color.lerp(color, other.color, t) ?? color,
    );
  }

  @override
  List<Object?> get props => [color];

  Widget build(BuildContext context) => Container(color: color);
}

class TestResolvedStyle extends ResolvedStyle<TestSpec> {
  final Color color;
  final bool hasNullSpec;

  TestResolvedStyle({
    this.color = Colors.black,
    this.hasNullSpec = false,
  }) : super(spec: hasNullSpec ? null : TestSpec(color: color));

  @override
  ResolvedStyle<TestSpec> lerp(ResolvedStyle<TestSpec>? other, double t) {
    if (other == null) return this;
    return TestResolvedStyle(
      color: Color.lerp(color, (other as TestResolvedStyle).color, t) ?? color,
    );
  }
}

class TestAnimationDriver<S extends Spec<S>> extends AnimationDriver<S> {
  TestAnimationDriver({required super.vsync});

  void Function(ResolvedStyle<S>)? onAnimateTo;
  ResolvedStyle<S>? testResolvedStyle;

  @override
  ResolvedStyle<S>? get currentResolvedStyle => testResolvedStyle ?? super.currentResolvedStyle;

  @override
  Future<void> animateTo(ResolvedStyle<S> targetStyle) async {
    onAnimateTo?.call(targetStyle);
    testResolvedStyle = targetStyle;
    notifyListeners();
  }

  @override
  ResolvedStyle<S> interpolateAt(double t) {
    return targetResolvedStyle ?? testResolvedStyle!;
  }
}