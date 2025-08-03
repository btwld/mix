import 'package:flutter/material.dart';

import '../../core/style_widget.dart';
import 'icon_spec.dart';

class StyledIcon extends StyleWidget<IconSpec> {
  const StyledIcon(this.icon, {this.semanticLabel, super.style, super.key});

  final IconData? icon;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context, IconSpec? spec) {
    return Icon(
      icon ?? spec?.icon,
      size: spec?.size,
      fill: spec?.fill,
      weight: spec?.weight,
      grade: spec?.grade,
      opticalSize: spec?.opticalSize,
      color: spec?.color,
      shadows: spec?.shadows,
      semanticLabel: semanticLabel ?? spec?.semanticsLabel,
      textDirection: spec?.textDirection,
      applyTextScaling: spec?.applyTextScaling,
      blendMode: spec?.blendMode,
    );
  }
}
