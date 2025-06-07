// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/element.dart';
import '../core/factory/mix_data.dart';
import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/spec.dart';
import '../core/utility.dart';

part 'align_widget_modifier.g.dart';

@MixableSpec(components: GeneratedSpecComponents.skipUtility)
final class AlignModifierSpec extends WidgetModifierSpec<AlignModifierSpec>
    with _$AlignModifierSpec, Diagnosticable {
  final AlignmentGeometry? alignment;
  final double? widthFactor;
  final double? heightFactor;

  const AlignModifierSpec({
    this.alignment,
    this.widthFactor,
    this.heightFactor,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  WidgetModifierSpecAttribute<AlignModifierSpec> toAttribute() {
    return AlignModifierSpecAttribute(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
    );
  }

  @override
  Widget build(Widget child) {
    return Align(
      alignment: alignment ?? Alignment.center,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}

final class AlignModifierSpecUtility<T extends Attribute>
    extends MixUtility<T, AlignModifierSpecAttribute> {
  const AlignModifierSpecUtility(super.builder);
  T call({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return builder(
      AlignModifierSpecAttribute(
        alignment: alignment,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      ),
    );
  }
}
