import 'package:flutter/widgets.dart';

import '../spec.dart';
import '../style.dart';

/// Base class for animation drivers that handle style interpolation.
///
/// Animation drivers define how styles should be animated between changes.
abstract class AnimationDriver<S extends Spec<S>> {
  const AnimationDriver();

  /// Builds the animated widget with the given style and builder.
  Widget build({
    required BuildContext context,
    required SpecStyle<S> style,
    required Widget Function(BuildContext context, ResolvedStyle<S> resolved)
    builder,
  });
}

/// A driver that performs no animation - just passes through the resolved style.
class NoAnimationDriver<S extends Spec<S>> extends AnimationDriver<S> {
  const NoAnimationDriver();

  @override
  Widget build({
    required BuildContext context,
    required SpecStyle<S> style,
    required Widget Function(BuildContext context, ResolvedStyle<S> resolved)
    builder,
  }) {
    final resolved = style.build(context);

    return builder(context, resolved);
  }
}

/// A driver for implicit animations using Flutter's animation system.
class ImplicitAnimationDriver<S extends Spec<S>> extends AnimationDriver<S> {
  final Duration duration;
  final Curve curve;
  final VoidCallback? onEnd;

  const ImplicitAnimationDriver({
    required this.duration,
    this.curve = Curves.linear,
    this.onEnd,
  });

  @override
  Widget build({
    required BuildContext context,
    required SpecStyle<S> style,
    required Widget Function(BuildContext context, ResolvedStyle<S> resolved)
    builder,
  }) {
    return _ImplicitAnimationWidget<S>(
      style: style,
      builder: builder,
      duration: duration,
      curve: curve,
      onEnd: onEnd,
    );
  }
}

// Internal widget for implicit animations
class _ImplicitAnimationWidget<S extends Spec<S>>
    extends ImplicitlyAnimatedWidget {
  const _ImplicitAnimationWidget({
    super.key,
    required this.style,
    required this.builder,
    required super.duration,
    super.curve,
    super.onEnd,
  });

  final SpecStyle<S> style;
  final Widget Function(BuildContext context, ResolvedStyle<S> resolved)
  builder;

  @override
  _ImplicitAnimationWidgetState<S> createState() =>
      _ImplicitAnimationWidgetState();
}

class _ImplicitAnimationWidgetState<S extends Spec<S>>
    extends AnimatedWidgetBaseState<_ImplicitAnimationWidget<S>> {
  ResolvedStyleTween<S>? _resolved;

  @override
  void forEachTween(TweenVisitor<Object?> visitor) {
    final resolved = widget.style.resolve(context);
    _resolved =
        visitor(
              _resolved,
              resolved,
              (Object? value) =>
                  ResolvedStyleTween<S>(begin: value as ResolvedStyle<S>),
            )
            as ResolvedStyleTween<S>?;
  }

  @override
  Widget build(BuildContext context) {
    final animatedResolved = _resolved!.evaluate(animation);

    return widget.builder(context, animatedResolved);
  }
}

/// Tween for interpolating between ResolvedStyle values.
class ResolvedStyleTween<S extends Spec<S>> extends Tween<ResolvedStyle<S>> {
  ResolvedStyleTween({super.begin, super.end});

  @override
  ResolvedStyle<S> lerp(double t) => begin!.lerp(end, t);
}
