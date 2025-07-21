import 'package:flutter/widgets.dart';

import '../spec.dart';
import '../style.dart';
import 'animation_driver.dart';

/// A driver for controlled animations that gives full control over the animation.
///
/// This driver allows external control of animation progress through a controller.
class ControlledAnimationDriver<S extends Spec<S>> extends AnimationDriver<S> {
  final AnimationController controller;
  final SpecAttribute<S> endStyle;

  const ControlledAnimationDriver({
    required this.controller,
    required this.endStyle,
  });

  @override
  Widget build({
    required BuildContext context,
    required SpecAttribute<S> style,
    required Widget Function(BuildContext context, ResolvedStyle<S> resolved)
    builder,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final startResolved = style.resolve(context);
        final endResolved = endStyle.resolve(context);

        final interpolatedResolved = startResolved.lerp(
          endResolved,
          controller.value,
        );

        return builder(context, interpolatedResolved);
      },
    );
  }
}

/// A driver that uses a custom animation with a Tween.
class TweenAnimationDriver<S extends Spec<S>, T> extends AnimationDriver<S> {
  final AnimationController controller;
  final Tween<T> tween;
  final SpecAttribute<S> Function(T value) styleBuilder;

  const TweenAnimationDriver({
    required this.controller,
    required this.tween,
    required this.styleBuilder,
  });

  @override
  Widget build({
    required BuildContext context,
    required SpecAttribute<S> style,
    required Widget Function(BuildContext context, ResolvedStyle<S> resolved)
    builder,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final animation = tween.animate(controller);
        final animatedStyle = styleBuilder(animation.value);
        final resolved = animatedStyle.resolve(context);

        return builder(context, resolved);
      },
    );
  }
}
