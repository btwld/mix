import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Test implementation that uses the animation mixin
class TestAnimationStyler extends Style<BoxSpec>
    with AnimationStyleMixin<BoxSpec, TestAnimationStyler> {
  final List<AnimationConfig> calledWith;

  TestAnimationStyler({
    super.variants,
    super.modifier,
    super.animation,
    List<AnimationConfig>? calledWith,
  }) : calledWith = calledWith ?? <AnimationConfig>[];

  @override
  TestAnimationStyler animate(AnimationConfig config) {
    calledWith.add(config);
    return this;
  }

  @override
  TestAnimationStyler withVariants(List<VariantStyle<BoxSpec>> variants) {
    return TestAnimationStyler(
      variants: variants,
      modifier: $modifier,
      animation: $animation,
      calledWith: calledWith,
    );
  }

  @override
  StyleSpec<BoxSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: BoxSpec(),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  TestAnimationStyler merge(TestAnimationStyler? other) {
    return TestAnimationStyler(
      variants: $variants,
      modifier: $modifier,
      animation: $animation,
      calledWith: calledWith,
    );
  }

  @override
  List<Object?> get props => [$animation, $modifier, $variants];
}

void main() {
  group('AnimationStyleMixin', () {
    late TestAnimationStyler testStyler;
    late ValueNotifier<double> testTrigger;

    setUp(() {
      testStyler = TestAnimationStyler();
      testTrigger = ValueNotifier<double>(0.0);
    });

    tearDown(() {
      testTrigger.dispose();
    });

    group('keyframeAnimation', () {
      test('should call animate with KeyframeAnimationConfig', () {
        final timeline = <KeyframeTrack<double>>[
          KeyframeTrack<double>('opacity', [
            Keyframe(
              0.0,
              const Duration(milliseconds: 250),
              curve: Curves.easeIn,
            ),
            Keyframe(
              1.0,
              const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            ),
          ], initial: 0.0),
        ];

        testStyler.keyframeAnimation(
          trigger: testTrigger,
          timeline: timeline,
          styleBuilder: (values, style) => style,
        );

        expect(testStyler.calledWith.length, equals(1));
        final config = testStyler.calledWith.first;
        expect(config, isA<KeyframeAnimationConfig<BoxSpec>>());

        final keyframeConfig = config as KeyframeAnimationConfig<BoxSpec>;
        expect(keyframeConfig.trigger, equals(testTrigger));
        expect(keyframeConfig.timeline, equals(timeline));
        expect(keyframeConfig.initialStyle, equals(testStyler));
      });

      test('should support custom style builder', () {
        final timeline = <KeyframeTrack<double>>[
          KeyframeTrack<double>('scale', [
            Keyframe(
              0.5,
              const Duration(milliseconds: 150),
              curve: Curves.linear,
            ),
            Keyframe(
              1.0,
              const Duration(milliseconds: 150),
              curve: Curves.linear,
            ),
          ], initial: 0.5),
        ];

        TestAnimationStyler builderResult = TestAnimationStyler();
        final expectedResult = TestAnimationStyler();

        testStyler.keyframeAnimation(
          trigger: testTrigger,
          timeline: timeline,
          styleBuilder: (values, style) {
            builderResult = style;
            return expectedResult;
          },
        );

        expect(testStyler.calledWith.length, equals(1));
        final config =
            testStyler.calledWith.first as KeyframeAnimationConfig<BoxSpec>;

        // Test the style builder by calling it
        final testValues = <String, Object>{'opacity': 0.5};
        final result = config.styleBuilder(
          KeyframeAnimationResult(testValues),
          testStyler,
        );

        expect(builderResult, equals(testStyler));
        expect(result, equals(expectedResult));
      });
    });

    group('phaseAnimation', () {
      test('should call animate with PhaseAnimationConfig', () {
        final phases = ['start', 'middle', 'end'];

        testStyler.phaseAnimation<String>(
          trigger: testTrigger,
          phases: phases,
          styleBuilder: (phase, style) => style,
          configBuilder: (phase) => CurveAnimationConfig(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          ),
        );

        expect(testStyler.calledWith.length, equals(1));
        final config = testStyler.calledWith.first;
        expect(
          config,
          isA<PhaseAnimationConfig<BoxSpec, TestAnimationStyler>>(),
        );

        final phaseConfig =
            config as PhaseAnimationConfig<BoxSpec, TestAnimationStyler>;
        expect(phaseConfig.trigger, equals(testTrigger));
        expect(phaseConfig.styles.length, equals(3));
        expect(phaseConfig.curveConfigs.length, equals(3));
      });

      test('should call style builder for each phase', () {
        final phases = [1, 2, 3];
        final capturedPhases = <int>[];
        final capturedStyles = <TestAnimationStyler>[];

        testStyler.phaseAnimation<int>(
          trigger: testTrigger,
          phases: phases,
          styleBuilder: (phase, style) {
            capturedPhases.add(phase);
            capturedStyles.add(style);
            return style;
          },
          configBuilder: (phase) => CurveAnimationConfig(
            duration: Duration(milliseconds: phase * 100),
            curve: Curves.linear,
          ),
        );

        expect(capturedPhases, equals([1, 2, 3]));
        expect(capturedStyles.length, equals(3));
        for (final style in capturedStyles) {
          expect(style, equals(testStyler));
        }
      });

      test('should call config builder for each phase', () {
        final phases = ['a', 'b'];
        final capturedPhases = <String>[];
        final configs = <CurveAnimationConfig>[];

        testStyler.phaseAnimation<String>(
          trigger: testTrigger,
          phases: phases,
          styleBuilder: (phase, style) => style,
          configBuilder: (phase) {
            capturedPhases.add(phase);
            final config = CurveAnimationConfig(
              duration: Duration(milliseconds: phase.codeUnitAt(0)),
              curve: Curves.bounceIn,
            );
            configs.add(config);
            return config;
          },
        );

        expect(capturedPhases, equals(['a', 'b']));

        final animationConfig =
            testStyler.calledWith.first
                as PhaseAnimationConfig<BoxSpec, TestAnimationStyler>;
        expect(animationConfig.curveConfigs, equals(configs));
      });

      test('should handle empty phases list', () {
        testStyler.phaseAnimation<int>(
          trigger: testTrigger,
          phases: [],
          styleBuilder: (phase, style) => style,
          configBuilder: (phase) => CurveAnimationConfig(
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          ),
        );

        expect(testStyler.calledWith.length, equals(1));
        final config =
            testStyler.calledWith.first
                as PhaseAnimationConfig<BoxSpec, TestAnimationStyler>;
        expect(config.styles, isEmpty);
        expect(config.curveConfigs, isEmpty);
      });
    });

    group('method chaining', () {
      test('should support method chaining', () {
        final timeline = <KeyframeTrack<double>>[
          KeyframeTrack<double>('position', [
            Keyframe(
              0.0,
              const Duration(milliseconds: 50),
              curve: Curves.linear,
            ),
            Keyframe(
              100.0,
              const Duration(milliseconds: 50),
              curve: Curves.linear,
            ),
          ], initial: 0.0),
        ];

        final result = testStyler.keyframeAnimation(
          trigger: testTrigger,
          timeline: timeline,
          styleBuilder: (values, style) => style,
        );

        expect(result, same(testStyler));
        expect(testStyler.calledWith.length, equals(1));
      });
    });

    group('animation types', () {
      test('should distinguish between keyframe and phase animations', () {
        // Create keyframe animation
        testStyler.keyframeAnimation(
          trigger: testTrigger,
          timeline: <KeyframeTrack<double>>[
            KeyframeTrack<double>('test_track', [
              Keyframe(
                0.0,
                const Duration(milliseconds: 50),
                curve: Curves.linear,
              ),
              Keyframe(
                1.0,
                const Duration(milliseconds: 50),
                curve: Curves.linear,
              ),
            ], initial: 0.0),
          ],
          styleBuilder: (values, style) => style,
        );

        // Create phase animation
        testStyler.phaseAnimation<String>(
          trigger: testTrigger,
          phases: ['phase1'],
          styleBuilder: (phase, style) => style,
          configBuilder: (phase) => CurveAnimationConfig(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
          ),
        );

        expect(testStyler.calledWith.length, equals(2));
        expect(
          testStyler.calledWith[0],
          isA<KeyframeAnimationConfig<BoxSpec>>(),
        );
        expect(
          testStyler.calledWith[1],
          isA<PhaseAnimationConfig<BoxSpec, TestAnimationStyler>>(),
        );
      });
    });
  });
}
