import 'package:flutter/widgets.dart';

import 'internal/compare_mixin.dart';
import 'style_spec.dart';

/// Base class for all resolved specifications that define widget properties.
@immutable
abstract class Spec<T extends Spec<T>> with Equatable {
  const Spec();

  Type get type => T;

  /// Creates a copy of this spec with non-null parameter values.
  T copyWith();

  /// Linearly interpolates between this and another [Spec].
  T lerp(covariant T? other, double t);
}

/// A [Tween] for interpolating between two [Spec] objects.
class SpecTween<T extends Spec<T>> extends Tween<T?> {
  SpecTween({super.begin, super.end});

  @override
  T? lerp(double t) {
    if (begin == null) return end;
    if (end == null) return begin;

    return begin?.lerp(end, t);
  }
}

class WidgeSpecTween<S extends Spec<S>> extends Tween<StyleSpec<S>?> {
  WidgeSpecTween({super.begin, super.end});

  @override
  StyleSpec<S>? lerp(double t) {
    if (begin == null) return end;
    if (end == null) return begin;

    return begin?.lerp(end, t);
  }
}
