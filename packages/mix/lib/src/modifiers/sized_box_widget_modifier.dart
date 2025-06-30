// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/element.dart';
import '../core/factory/mix_context.dart';
import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/utility.dart';

part 'sized_box_widget_modifier.g.dart';

@MixableSpec(components: GeneratedSpecComponents.skipUtility)
final class SizedBoxModifierSpec
    extends WidgetModifierSpec<SizedBoxModifierSpec>
    with _$SizedBoxModifierSpec, Diagnosticable {
  final double? width;
  final double? height;

  const SizedBoxModifierSpec({this.width, this.height});

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  Widget build(Widget child) {
    return SizedBox(width: width, height: height, child: child);
  }
}

final class SizedBoxModifierSpecUtility<T extends StyleElement>
    extends MixUtility<T, SizedBoxModifierSpecAttribute> {
  /// Utility for defining [SizedBoxModifierSpecAttribute.height]
  late final height = DoubleUtility((value) => call(height: value));

  /// Utility for defining [SizedBoxModifierSpecAttribute.width]
  late final width = DoubleUtility((value) => call(width: value));

  /// Utility for defining [SizedBoxModifierSpecAttribute.width]
  /// and [SizedBoxModifierSpecAttribute.height]
  late final square =
      DoubleUtility((value) => call(width: value, height: value));

  SizedBoxModifierSpecUtility(super.builder);

  T call({double? width, double? height}) {
    return builder(SizedBoxModifierSpecAttribute(width: width, height: height));
  }

  /// Utility for defining [SizedBoxModifierSpecAttribute.width] and [SizedBoxModifierSpecAttribute.height]
  /// from [Size]
  T as(Size size) => call(width: size.width, height: size.height);
}
