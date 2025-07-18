import 'package:flutter/widgets.dart';

import '../internal/compare_mixin.dart';

@immutable
abstract class Spec<T extends Spec<T>> with EqualityMixin {
  const Spec();

  Type get type => T;

  /// Creates a copy of this spec with the given fields
  /// replaced by the non-null parameter values.
  T copyWith();

  /// Linearly interpolate with another [Spec] object.
  T lerp(covariant T? other, double t);
}

class MultiSpec extends Spec<MultiSpec> {
  final Map<Type, Spec> _specs;

  MultiSpec(List<Spec> specs)
    : _specs = {for (var spec in specs) spec.type: spec};

  @override
  MultiSpec copyWith({List<Spec>? specs}) {
    if (specs == null) return this;

    return MultiSpec(specs);
  }

  @override
  MultiSpec lerp(MultiSpec? other, double t) {
    if (other == null) return this;

    final interpolatedSpecs = <Spec>[];

    // Get all unique types from both specs
    final allTypes = {..._specs.keys, ...other._specs.keys};

    for (final type in allTypes) {
      final spec = _specs[type];
      final otherSpec = other._specs[type];

      if (spec != null && otherSpec != null) {
        // Both specs have this type, interpolate between them
        interpolatedSpecs.add(spec.lerp(otherSpec, t) as Spec);
      } else if (spec != null) {
        // Only this spec has this type
        interpolatedSpecs.add(spec);
      } else if (otherSpec != null) {
        // Only other spec has this type
        interpolatedSpecs.add(otherSpec);
      }
    }

    return MultiSpec(interpolatedSpecs);
  }

  @override
  get props => [_specs];
}
