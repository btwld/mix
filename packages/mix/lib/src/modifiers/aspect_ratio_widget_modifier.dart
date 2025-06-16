// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/element.dart';
import '../core/factory/mix_data.dart';
import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/utility.dart';

part 'aspect_ratio_widget_modifier.g.dart';

@MixableSpec(
  components:
      GeneratedSpecComponents.skipUtility & GeneratedSpecComponents.skipStyle,
)
final class AspectRatioModifierSpec
    extends WidgetModifierSpec<AspectRatioModifierSpec>
    with _$AspectRatioModifierSpec, Diagnosticable {
  final double aspectRatio;

  const AspectRatioModifierSpec([double? aspectRatio])
      : aspectRatio = aspectRatio ?? 1.0;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  Widget build(Widget child) {
    return AspectRatio(aspectRatio: aspectRatio, child: child);
  }
}

final class AspectRatioModifierSpecUtility<T extends StyleElement>
    extends MixUtility<T, AspectRatioModifierSpecAttribute> {
  const AspectRatioModifierSpecUtility(super.builder);
  T call(double value) {
    return builder(AspectRatioModifierSpecAttribute(aspectRatio: value));
  }
}
