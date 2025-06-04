import 'package:flutter/widgets.dart';

import 'spec.dart';

/// Generic tween for any spec type.
/// 
/// Leverages the existing `lerp` method from code generation,
/// eliminating custom tween classes per spec type.
class SpecTween<S extends Spec<S>> extends Tween<S?> {
  SpecTween({super.begin, super.end});

  @override
  S? lerp(double t) {
    if (begin == null && end == null) return null;
    if (begin == null) return end;
    if (end == null) return begin;
    return begin!.lerp(end, t);
  }
}

/// Base class for implicitly animated spec widgets following Flutter conventions.
/// 
/// Follows the same pattern as Flutter's `ImplicitlyAnimatedWidget`,
/// providing a type-safe foundation that eliminates separate AnimatedXSpecWidget classes.
/// 
/// Subclasses implement the `build()` method to create their specific widget
/// using the animated spec values provided during animation.
abstract class ImplicitlyAnimatedSpecWidget<S extends Spec<S>> extends ImplicitlyAnimatedWidget {
  /// Creates an implicitly animated spec widget.
  /// 
  /// The [spec] defines the target spec to animate to.
  /// Standard [ImplicitlyAnimatedWidget] parameters are supported.
  const ImplicitlyAnimatedSpecWidget({
    required this.spec,
    required super.duration,
    super.curve = Curves.linear,
    super.onEnd,
    super.key,
  });

  /// The target spec to animate to.
  /// 
  /// During animation, interpolated values between the previous spec
  /// and this target spec are provided to the [build] method.
  final S spec;

  /// Builds the widget using the current animated spec.
  /// 
  /// Called on every animation frame with interpolated spec values.
  /// The [animatedSpec] contains current animated values and equals [spec] when complete.
  /// 
  /// Implementations should create their specific widget using the
  /// provided [animatedSpec], which is automatically managed by the animation system.
  Widget build(BuildContext context, S animatedSpec);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedSpecWidget<S>> createState() =>
      _ImplicitlyAnimatedSpecWidgetState<S>();
}
class _ImplicitlyAnimatedSpecWidgetState<S extends Spec<S>>
    extends ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedSpecWidget<S>> {
  SpecTween<S>? _specTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _specTween = visitor(
      _specTween,
      widget.spec,
      (dynamic value) {
        // Type-safe tween creation with validation
        if (value == null) return SpecTween<S>(begin: null);
        if (value is! S) {
          throw ArgumentError(
            'Expected spec of type $S, got ${value.runtimeType}. '
            'Check that the correct spec type is being used in the animation.',
          );
        }
        return SpecTween<S>(begin: value);
      },
    ) as SpecTween<S>?;
  }

  @override
  Widget build(BuildContext context) {
    // Get the current animated spec value
    final animatedSpec = _specTween?.evaluate(animation) ?? widget.spec;
    
    // Call the widget's build method with the animated spec
    // Direct method call - no function call overhead or proxy widgets
    return widget.build(context, animatedSpec);
  }
}
