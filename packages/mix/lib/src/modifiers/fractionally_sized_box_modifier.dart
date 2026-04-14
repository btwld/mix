import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

part 'fractionally_sized_box_modifier.g.dart';

/// Modifier that sizes its child to a fraction of the available space.
///
/// Wraps the child in a [FractionallySizedBox] widget with the specified factors.
@MixableModifier()
final class FractionallySizedBoxModifier
    extends WidgetModifier<FractionallySizedBoxModifier>
    with Diagnosticable {
  final double? widthFactor;
  final double? heightFactor;
  final AlignmentGeometry alignment;

  const FractionallySizedBoxModifier({
    this.widthFactor,
    this.heightFactor,
    AlignmentGeometry? alignment,
  }) : alignment = alignment ?? Alignment.center;

  @override
  FractionallySizedBoxModifier copyWith({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) {
    return FractionallySizedBoxModifier(
      widthFactor: widthFactor ?? this.widthFactor,
      heightFactor: heightFactor ?? this.heightFactor,
      alignment: alignment ?? this.alignment,
    );
  }

  @override
  FractionallySizedBoxModifier lerp(
    FractionallySizedBoxModifier? other,
    double t,
  ) {
    if (other == null) return this;

    return FractionallySizedBoxModifier(
      widthFactor: MixOps.lerp(widthFactor, other.widthFactor, t),
      heightFactor: MixOps.lerp(heightFactor, other.heightFactor, t),
      alignment: MixOps.lerp(alignment, other.alignment, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('widthFactor', widthFactor))
      ..add(DoubleProperty('heightFactor', heightFactor))
      ..add(DiagnosticsProperty('alignment', alignment));
  }

  @override
  List<Object?> get props => [widthFactor, heightFactor, alignment];

  @override
  Widget build(Widget child) {
    return FractionallySizedBox(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}

/// Utility class for applying fractionally sized box modifications.
///
/// Provides convenient methods for creating FractionallySizedBoxModifierMix instances.
final class FractionallySizedBoxModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, FractionallySizedBoxModifierMix> {
  const FractionallySizedBoxModifierUtility(super.utilityBuilder);

  T call({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return utilityBuilder(
      FractionallySizedBoxModifierMix(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        alignment: alignment,
      ),
    );
  }
}
