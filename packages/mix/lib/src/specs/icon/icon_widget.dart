import 'package:flutter/material.dart';

import '../../core/style_widget.dart';
import 'icon_spec.dart';

class StyledIcon extends StyleWidget<IconSpec> {
  const StyledIcon(
    this.icon, {
    this.semanticLabel,
    super.style = const IconSpecAttribute(),
    super.key,

    this.textDirection,

    super.orderOfModifiers,
  });

  final IconData? icon;
  final String? semanticLabel;
  // TODO: Should textDirection be a contructor argument or a style attribute?
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context, IconSpec spec) {
    return Icon(
      icon,
      size: spec.size,
      fill: spec.fill,
      weight: spec.weight,
      grade: spec.grade,
      opticalSize: spec.opticalSize,
      color: spec.color,
      shadows: spec.shadows,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
  }
}
