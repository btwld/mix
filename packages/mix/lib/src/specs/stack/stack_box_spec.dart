import 'package:flutter/foundation.dart';

import '../../core/helpers.dart';
import '../../core/spec.dart';
import '../../core/style_spec.dart';
import '../box/box_spec.dart';
import 'stack_spec.dart';

final class ZBoxSpec extends Spec<ZBoxSpec> with Diagnosticable {
  /// Container styling for the outer box. Nullable to mirror FlexBoxSpec.
  final StyleSpec<BoxSpec>? box;
  final StyleSpec<StackSpec>? stack;

  const ZBoxSpec({this.box, this.stack});

  /// Creates a copy of this [ZBoxSpec] but with the given fields
  /// replaced with the new values.
  @override
  ZBoxSpec copyWith({StyleSpec<BoxSpec>? box, StyleSpec<StackSpec>? stack}) {
    return ZBoxSpec(box: box ?? this.box, stack: stack ?? this.stack);
  }

  /// Linearly interpolates between this [ZBoxSpec] and another [ZBoxSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ZBoxSpec] is returned. When [t] is 1.0, the [other] [ZBoxSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ZBoxSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ZBoxSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ZBoxSpec] using the appropriate
  /// interpolation method:
  /// - [StyleSpec.lerp] for [box].
  /// - [StyleSpec.lerp] for [stack].
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ZBoxSpec] configurations.
  @override
  ZBoxSpec lerp(ZBoxSpec? other, double t) {
    return ZBoxSpec(
      box: MixOps.lerp(box, other?.box, t),
      stack: MixOps.lerp(stack, other?.stack, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('box', box))
      ..add(DiagnosticsProperty('stack', stack));
  }

  /// The list of properties that constitute the state of this [ZBoxSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ZBoxSpec] instances for equality.
  @override
  List<Object?> get props => [box, stack];
}
