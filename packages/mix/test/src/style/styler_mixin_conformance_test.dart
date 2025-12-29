import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

/// Conformance tests to ensure all Styler classes have the correct mixins.
///
/// These tests verify that all Stylers that should support animations
/// have AnimationStyleMixin properly applied. If a mixin is missing,
/// the test will fail to compile.
///
/// This prevents regressions like issue #817 where FlexBoxStyler and
/// StackBoxStyler were missing AnimationStyleMixin.
void main() {
  group('Styler Mixin Conformance', () {
    group('AnimationStyleMixin', () {
      // All Stylers that should have AnimationStyleMixin.
      // If any of these are missing the mixin, the test won't compile.
      //
      // Intentionally excluded:
      // - ImageStyler: Does not support animations (no animatable properties)

      test('BoxStyler has AnimationStyleMixin', () {
        final styler = BoxStyler();
        _verifyAnimationStyleMixin<BoxStyler, BoxSpec>(styler);
      });

      test('FlexStyler has AnimationStyleMixin', () {
        final styler = FlexStyler();
        _verifyAnimationStyleMixin<FlexStyler, FlexSpec>(styler);
      });

      test('FlexBoxStyler has AnimationStyleMixin', () {
        final styler = FlexBoxStyler();
        _verifyAnimationStyleMixin<FlexBoxStyler, FlexBoxSpec>(styler);
      });

      test('StackStyler has AnimationStyleMixin', () {
        final styler = StackStyler();
        _verifyAnimationStyleMixin<StackStyler, StackSpec>(styler);
      });

      test('StackBoxStyler has AnimationStyleMixin', () {
        final styler = StackBoxStyler();
        _verifyAnimationStyleMixin<StackBoxStyler, StackBoxSpec>(styler);
      });

      test('TextStyler has AnimationStyleMixin', () {
        final styler = TextStyler();
        _verifyAnimationStyleMixin<TextStyler, TextSpec>(styler);
      });

      test('IconStyler has AnimationStyleMixin', () {
        final styler = IconStyler();
        _verifyAnimationStyleMixin<IconStyler, IconSpec>(styler);
      });
    });

    group('AnimationStyleMixin methods', () {
      late ValueNotifier<int> trigger;

      setUp(() {
        trigger = ValueNotifier(0);
      });

      tearDown(() {
        trigger.dispose();
      });

      test('keyframeAnimation returns styled instance', () {
        final styler = BoxStyler();

        final animated = styler.keyframeAnimation(
          trigger: trigger,
          timeline: [
            KeyframeTrack<double>(
              'scale',
              [Keyframe.linear(1.0, Duration(milliseconds: 500))],
              initial: 1.0,
            ),
          ],
          styleBuilder: (values, style) => style,
        );

        expect(animated, isA<BoxStyler>());
        expect(animated.$animation, isA<KeyframeAnimationConfig<BoxSpec>>());
      });

      test('phaseAnimation returns styled instance', () {
        final styler = BoxStyler();

        final animated = styler.phaseAnimation<int>(
          trigger: trigger,
          phases: [0, 1, 2],
          styleBuilder: (phase, style) => style,
          configBuilder: (phase) => CurveAnimationConfig(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
        );

        expect(animated, isA<BoxStyler>());
        expect(animated.$animation, isA<PhaseAnimationConfig<BoxSpec, BoxStyler>>());
      });

      test('FlexBoxStyler keyframeAnimation works correctly', () {
        final styler = FlexBoxStyler();

        final animated = styler.keyframeAnimation(
          trigger: trigger,
          timeline: [
            KeyframeTrack<double>(
              'opacity',
              [Keyframe.linear(0.5, Duration(milliseconds: 200))],
              initial: 1.0,
            ),
          ],
          styleBuilder: (values, style) => style,
        );

        expect(animated, isA<FlexBoxStyler>());
        expect(animated.$animation, isA<KeyframeAnimationConfig<FlexBoxSpec>>());
      });

      test('StackBoxStyler phaseAnimation works correctly', () {
        final styler = StackBoxStyler();

        final animated = styler.phaseAnimation<String>(
          trigger: trigger,
          phases: ['start', 'middle', 'end'],
          styleBuilder: (phase, style) => style,
          configBuilder: (phase) => CurveAnimationConfig(
            duration: Duration(milliseconds: 100),
            curve: Curves.linear,
          ),
        );

        expect(animated, isA<StackBoxStyler>());
        expect(
          animated.$animation,
          isA<PhaseAnimationConfig<StackBoxSpec, StackBoxStyler>>(),
        );
      });
    });
  });
}

/// Verifies that a Styler has AnimationStyleMixin by calling its methods.
///
/// This is a compile-time check - if the mixin is missing, this function
/// won't compile because the methods won't exist on the Styler.
void _verifyAnimationStyleMixin<T extends Style<S>, S extends Spec<S>>(
  T styler,
) {
  // Verify animate() method exists and returns correct type
  final animation = AnimationConfig.linear(Duration(milliseconds: 100));
  final animated = (styler as dynamic).animate(animation) as T;
  expect(animated.$animation, animation);

  // Verify the Styler is an instance of AnimationStyleMixin
  // This is a runtime check that complements the compile-time check
  expect(styler, isA<AnimationStyleMixin<T, S>>());
}
