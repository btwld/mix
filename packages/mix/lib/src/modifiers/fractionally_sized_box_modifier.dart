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
    with Diagnosticable, _$FractionallySizedBoxModifierMethods {
  @override
  final double? widthFactor;
  @override
  final double? heightFactor;
  @override
  final AlignmentGeometry alignment;

  const FractionallySizedBoxModifier({
    this.widthFactor,
    this.heightFactor,
    AlignmentGeometry? alignment,
  }) : alignment = alignment ?? Alignment.center;

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
