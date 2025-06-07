// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/element.dart';
import '../core/factory/mix_data.dart';
import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/utility.dart';

part 'fractionally_sized_box_widget_modifier.g.dart';

@MixableSpec(components: GeneratedSpecComponents.skipUtility)
final class FractionallySizedBoxModifierSpec
    extends WidgetModifierSpec<FractionallySizedBoxModifierSpec>
    with _$FractionallySizedBoxModifierSpec, Diagnosticable {
  final double? widthFactor;
  final double? heightFactor;
  final AlignmentGeometry? alignment;

  const FractionallySizedBoxModifierSpec({
    this.widthFactor,
    this.heightFactor,
    this.alignment,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  FractionallySizedBoxModifierSpecAttribute toAttribute() {
    return FractionallySizedBoxModifierSpecAttribute(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      alignment: alignment,
    );
  }

  @override
  Widget build(Widget child) {
    return FractionallySizedBox(
      alignment: alignment ?? Alignment.center,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}

final class FractionallySizedBoxModifierSpecUtility<T extends Attribute>
    extends MixUtility<T, FractionallySizedBoxModifierSpecAttribute> {
  const FractionallySizedBoxModifierSpecUtility(super.builder);

  T call({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return builder(
      FractionallySizedBoxModifierSpecAttribute(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        alignment: alignment,
      ),
    );
  }
}
