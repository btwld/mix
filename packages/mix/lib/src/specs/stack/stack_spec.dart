import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/spec.dart';

final class StackSpec extends Spec<StackSpec> with Diagnosticable {
  final AlignmentGeometry? alignment;
  final StackFit? fit;
  final TextDirection? textDirection;
  final Clip? clipBehavior;

  const StackSpec({
    this.alignment,
    this.fit,
    this.textDirection,
    this.clipBehavior,
  });

  /// Creates a copy of this [StackSpec] but with the given fields
  /// replaced with the new values.
  @override
  StackSpec copyWith({
    AlignmentGeometry? alignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? clipBehavior,
  }) {
    return StackSpec(
      alignment: alignment ?? this.alignment,
      fit: fit ?? this.fit,
      textDirection: textDirection ?? this.textDirection,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [StackSpec] and another [StackSpec] based on the given parameter [t].
  @override
  StackSpec lerp(StackSpec? other, double t) {
    return StackSpec(
      alignment: MixOps.lerp(alignment, other?.alignment, t),
      fit: MixOps.lerpSnap(fit, other?.fit, t),
      textDirection: MixOps.lerpSnap(textDirection, other?.textDirection, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(EnumProperty<StackFit>('fit', fit))
      ..add(EnumProperty<TextDirection>('textDirection', textDirection))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }

  /// The list of properties that constitute the state of this [StackSpec].
  @override
  List<Object?> get props => [alignment, fit, textDirection, clipBehavior];
}
