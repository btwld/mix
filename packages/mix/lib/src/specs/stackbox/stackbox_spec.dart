import 'package:flutter/foundation.dart';

import '../../core/spec.dart';
import '../../core/style_spec.dart';
import '../box/box_spec.dart';
import '../stack/stack_spec.dart';

/// Specification that combines box styling and stack layout properties.
///
/// Provides comprehensive styling for widgets that need both
/// box decoration and stack layout capabilities. Merges [BoxSpec] and
/// [StackSpec] into a unified specification.
@immutable
final class StackBoxSpec extends Spec<StackBoxSpec> with Diagnosticable {
  /// Box styling properties for decoration, padding, constraints, etc.
  final StyleSpec<BoxSpec>? box;

  /// Stack layout properties for alignment, fit, clipping, etc.
  final StyleSpec<StackSpec>? stack;

  const StackBoxSpec({this.box, this.stack});

  /// Creates a copy of this [StackBoxSpec] but with the given fields
  /// replaced with the new values.
  @override
  StackBoxSpec copyWith({
    StyleSpec<BoxSpec>? box,
    StyleSpec<StackSpec>? stack,
  }) {
    return StackBoxSpec(box: box ?? this.box, stack: stack ?? this.stack);
  }

  /// Linearly interpolates between this [StackBoxSpec] and another [StackBoxSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [StackBoxSpec] is returned. When [t] is 1.0, the [other] [StackBoxSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [StackBoxSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [StackBoxSpec] instance.
  ///
  /// The interpolation is performed on each property of the [StackBoxSpec] using the appropriate
  /// interpolation method:
  /// - [StyleSpec.lerp] for [box].
  /// - [StyleSpec.lerp] for [stack].
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [StackBoxSpec] configurations.
  @override
  StackBoxSpec lerp(StackBoxSpec? other, double t) {
    return StackBoxSpec(
      box: box?.lerp(other?.box, t),
      stack: stack?.lerp(other?.stack, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('box', box))
      ..add(DiagnosticsProperty('stack', stack));
  }

  /// The list of properties that constitute the state of this [StackBoxSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [StackBoxSpec] instances for equality.
  @override
  List<Object?> get props => [box, stack];
}

@Deprecated('Use StackBoxSpec instead')
typedef ZBoxSpec = StackBoxSpec;
