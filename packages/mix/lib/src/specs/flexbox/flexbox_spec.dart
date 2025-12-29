import 'package:flutter/foundation.dart';

import '../../core/spec.dart';
import '../../core/style_spec.dart';
import '../box/box_spec.dart';
import '../flex/flex_spec.dart';

/// Specification that combines box styling and flex layout properties.
///
/// Provides comprehensive styling for widgets that need both
/// box decoration and flex layout capabilities. Merges [BoxSpec] and
/// [FlexSpec] into a unified specification.
@immutable
final class FlexBoxSpec extends Spec<FlexBoxSpec> with Diagnosticable {
  /// Box styling properties for decoration, padding, constraints, etc.
  final StyleSpec<BoxSpec>? box;

  /// Flex layout properties for direction, alignment, spacing, etc.
  final StyleSpec<FlexSpec>? flex;

  const FlexBoxSpec({this.box, this.flex});

  /// Creates a copy of this [FlexBoxSpec] but with the given fields
  /// replaced with the new values.
  @override
  FlexBoxSpec copyWith({StyleSpec<BoxSpec>? box, StyleSpec<FlexSpec>? flex}) {
    return FlexBoxSpec(box: box ?? this.box, flex: flex ?? this.flex);
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
  /// - [StyleSpec.lerp] for [box].
  /// - [StyleSpec.lerp] for [flex].
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [FlexBoxSpec] configurations.
  @override
  FlexBoxSpec lerp(FlexBoxSpec? other, double t) {
    return FlexBoxSpec(
      box: box?.lerp(other?.box, t),
      flex: flex?.lerp(other?.flex, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('box', box))
      ..add(DiagnosticsProperty('flex', flex));
  }

  /// The list of properties that constitute the state of this [FlexBoxSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexBoxSpec] instances for equality.
  @override
  List<Object?> get props => [box, flex];
}
