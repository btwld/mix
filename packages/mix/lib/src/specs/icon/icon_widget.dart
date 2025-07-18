import 'package:flutter/material.dart';

import '../../core/factory/style_mix.dart';
import '../../core/styled_widget.dart';
import 'icon_spec.dart';
import 'icon_style.dart';

class StyledIcon extends StyleWidget<IconSpec> {
  const StyledIcon(
    this.icon, {
    this.semanticLabel,
    super.style = const IconStyle(),
    super.key,

    this.textDirection,

    super.orderOfModifiers,
  });

  final IconData? icon;
  final String? semanticLabel;
  // TODO: Should textDirection be a contructor argument or a style attribute?
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context, ResolvedStyle<IconSpec> resolved) {
    final spec = resolved.spec;

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
