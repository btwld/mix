// ignore_for_file: non_constant_identifier_names, constant_identifier_names, long-parameter-list, prefer-named-boolean-parameters

import '../animation_config.dart';
import '../attribute.dart';
import '../modifier.dart';
import '../spec.dart';

abstract class Style<S extends Spec<S>> extends SpecAttribute<S> {
  const Style._();

  Style<S> withAttribute(covariant SpecAttribute<S> attribute);

  /// Each subclass implements its own merge logic
  @override
  Style<S> merge(covariant Style<S>? other);

  /// Unique key used for merging elements of the same type
  @override
  Object get mergeKey => runtimeType;
}

/// Result of Style.resolve() containing fully resolved styling data
/// Generic type parameter T for the resolved SpecAttribute
class ResolvedStyle<V extends Spec<V>> {
  final V? spec; // Resolved spec
  final AnimationConfig? animation; // Animation config
  final List<ModifierSpec>? modifiers; // Modifiers config

  const ResolvedStyle({required this.spec, this.animation, this.modifiers});

  /// Linearly interpolate between two ResolvedStyles
  ResolvedStyle<V> lerp(ResolvedStyle<V>? other, double t) {
    if (other == null || t == 0.0) return this;
    if (t == 1.0) return other;

    // Lerp the spec if it's a Spec type
    final lerpedSpec = (spec as Spec<V>).lerp(other.spec, t);

    // For modifiers and animation, use the target (end) values
    // We can't meaningfully interpolate these
    return ResolvedStyle(
      spec: lerpedSpec,
      animation: other.animation ?? animation,
      modifiers: t < 0.5 ? modifiers : other.modifiers,
    );
  }
}
