import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

part 'align_modifier.g.dart';

/// Modifier that aligns its child within the available space.
///
/// Wraps the child in an [Align] widget with the specified alignment and size factors.
@MixableModifier()
final class AlignModifier extends WidgetModifier<AlignModifier>
    with Diagnosticable {
  final AlignmentGeometry alignment;
  final double? widthFactor;
  final double? heightFactor;

  const AlignModifier({
    AlignmentGeometry? alignment,
    this.widthFactor,
    this.heightFactor,
  }) : alignment = alignment ?? Alignment.center;

  @override
  AlignModifier copyWith({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return AlignModifier(
      alignment: alignment ?? this.alignment,
      widthFactor: widthFactor ?? this.widthFactor,
      heightFactor: heightFactor ?? this.heightFactor,
    );
  }

  @override
  AlignModifier lerp(AlignModifier? other, double t) {
    if (other == null) return this;

    return AlignModifier(
      alignment: MixOps.lerp(alignment, other.alignment, t)!,
      widthFactor: MixOps.lerp(widthFactor, other.widthFactor, t),
      heightFactor: MixOps.lerp(heightFactor, other.heightFactor, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(DoubleProperty('widthFactor', widthFactor))
      ..add(DoubleProperty('heightFactor', heightFactor));
  }

  @override
  List<Object?> get props => [alignment, widthFactor, heightFactor];

  @override
  Widget build(Widget child) {
    return Align(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}

/// Utility class for applying alignment modifications.
///
/// Provides convenient methods for creating AlignModifierMix instances.
final class AlignModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, AlignModifierMix> {
  const AlignModifierUtility(super.utilityBuilder);
  T call({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return utilityBuilder(
      AlignModifierMix(
        alignment: alignment,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      ),
    );
  }
}
