import 'package:flutter/foundation.dart';

import '../../core/spec.dart';
import '../../properties/container/container_spec.dart';
import '../../properties/layout/flex_layout_spec.dart';

/// Specification that combines container styling and flex layout properties.
///
/// Provides comprehensive styling for container widgets that need both
/// container decoration and flex layout capabilities. Merges [ContainerSpec] and
/// [FlexLayoutSpec] into a unified specification.
final class FlexBoxSpec extends Spec<FlexBoxSpec> with Diagnosticable {
  /// Container styling properties for decoration, padding, constraints, etc.
  final ContainerSpec? container;

  /// Flex layout properties for direction, alignment, spacing, etc.
  final FlexLayoutSpec? flex;

  const FlexBoxSpec({this.container, this.flex});

  /// Creates a copy of this [FlexBoxSpec] but with the given fields
  /// replaced with the new values.
  @override
  FlexBoxSpec copyWith({ContainerSpec? container, FlexLayoutSpec? flex}) {
    return FlexBoxSpec(
      container: container ?? this.container,
      flex: flex ?? this.flex,
    );
  }

  /// Linearly interpolates between this [FlexBoxSpec] and another [FlexBoxSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [FlexBoxSpec] is returned. When [t] is 1.0, the [other] [FlexBoxSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [FlexBoxSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [FlexBoxSpec] instance.
  ///
  /// The interpolation is performed on each property of the [FlexBoxSpec] using the appropriate
  /// interpolation method:
  /// - [ContainerSpec.lerp] for [container].
  /// - [FlexLayoutSpec.lerp] for [flex].
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [FlexBoxSpec] configurations.
  @override
  FlexBoxSpec lerp(FlexBoxSpec? other, double t) {
    return FlexBoxSpec(
      container: container?.lerp(other?.container, t),
      flex: flex?.lerp(other?.flex, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('flex', flex));
  }

  /// The list of properties that constitute the state of this [FlexBoxSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexBoxSpec] instances for equality.
  @override
  List<Object?> get props => [container, flex];
}
