import 'package:flutter/widgets.dart';

import 'equatable.dart';

// Re-export the equality helpers so generated `_$XSpec` mixins (which
// `part of` a file that imports `spec.dart`) can reach `propsEquals`,
// `propsHash`, and `propsDiff` without leaking the package entrypoint
// into `lib/src` (DCM rule `avoid-importing-entrypoint-exports`).
export 'equatable.dart' show Equatable, propsEquals, propsHash, propsDiff;

/// Base class for all resolved specifications that define widget properties.
///
/// Specs are the final resolved form of styling attributes after applying
/// context-specific values and merging operations. Mixes in [Equatable] so
/// every Spec — generated or hand-written — carries value equality by
/// contract. Concrete subclasses either satisfy the Equatable interface via
/// the `_$XSpec` mixin emitted by `mix_generator` or by supplying `props`
/// directly.
@immutable
abstract class Spec<T extends Spec<T>> with Equatable {
  const Spec();

  Type get type => T;

  /// Creates a copy of this spec with the given fields
  /// replaced by the non-null parameter values.
  T copyWith();

  /// Linearly interpolates with another [Spec] object.
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
