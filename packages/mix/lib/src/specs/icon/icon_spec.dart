import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../attributes/animated/animated_data.dart';
import '../../attributes/animated/animated_data_dto.dart';
import '../../attributes/animated/animated_util.dart';
import '../../attributes/color/color_dto.dart';
import '../../attributes/color/color_util.dart';
import '../../attributes/enum/enum_util.dart';
import '../../attributes/modifiers/widget_modifiers_data.dart';
import '../../attributes/modifiers/widget_modifiers_data_dto.dart';
import '../../attributes/modifiers/widget_modifiers_util.dart';
import '../../attributes/shadow/shadow_dto.dart';
import '../../attributes/shadow/shadow_util.dart';
import '../../core/computed_style/computed_style_provider.dart';
import '../../core/element.dart';
import '../../core/factory/mix_data.dart';
import '../../core/helpers.dart';
import '../../core/spec.dart';
import '../../core/utility.dart';
import 'icon_widget.dart';

part 'icon_spec.g.dart';

@MixableSpec()
final class IconSpec extends Spec<IconSpec> with _$IconSpec, Diagnosticable {
  final Color? color;
  final double? size;
  final double? weight;
  final double? grade;
  final double? opticalSize;
  final TextDirection? textDirection;
  final bool? applyTextScaling;

  // TODO: add shadow utility
  final List<Shadow>? shadows;
  final double? fill;

  static const of = _$IconSpec.of;

  static const from = _$IconSpec.from;

  const IconSpec({
    this.color,
    this.size,
    this.weight,
    this.grade,
    this.opticalSize,
    this.shadows,
    this.textDirection,
    this.applyTextScaling,
    this.fill,
    super.animated,
    super.modifiers,
  });

  Widget call(
    IconData? icon, {
    String? semanticLabel,
    List<Type> orderOfModifiers = const [],
    TextDirection? textDirection,
  }) {
    return isAnimated
        ? AnimatedIconSpecWidget(
            icon,
            spec: this,
            semanticLabel: semanticLabel,
            textDirection: textDirection,
            curve: animated!.curve,
            duration: animated!.duration,
            orderOfModifiers: orderOfModifiers,
          )
        : IconSpecWidget(
            icon,
            spec: this,
            semanticLabel: semanticLabel,
            textDirection: textDirection,
            orderOfModifiers: orderOfModifiers,
          );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}

extension IconSpecUtilityExt<T extends Attribute> on IconSpecUtility<T> {
  ShadowUtility get shadow => ShadowUtility((v) => only(shadows: [v]));
}
