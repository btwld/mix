import 'package:flutter/material.dart';

import '../../core/style_spec.dart';
import '../../core/style_widget.dart';
import 'icon_spec.dart';
import 'icon_style.dart';

/// Displays an icon with Mix styling.
///
/// Applies [IconSpec] for custom icon appearance.
class StyledIcon extends StyleWidget<IconSpec> {
  const StyledIcon({
    this.icon,
    this.semanticLabel,
    super.style = const IconStyler.create(),
    super.styleSpec,
    super.key,
  });


  /// The icon to display.
  final IconData? icon;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context, IconSpec spec) {
    return Icon(
      icon ?? spec.icon,
      size: spec.size,
      fill: spec.fill,
      weight: spec.weight,
      grade: spec.grade,
      opticalSize: spec.opticalSize,
      color: spec.color,
      shadows: spec.shadows,
      semanticLabel: semanticLabel ?? spec.semanticsLabel,
      textDirection: spec.textDirection,
      applyTextScaling: spec.applyTextScaling,
      blendMode: spec.blendMode,
    );
  }
}

extension IconSpecWrappedWidget on StyleSpec<IconSpec> {
  /// Creates a widget that resolves this [StyleSpec<IconSpec>] with context.
  @Deprecated(
    'Use StyledIcon(icon: icon, semanticLabel: semanticLabel, styleSpec: styleSpec) instead',
  )
  Widget createWidget({IconData? icon, String? semanticLabel}) {
    return call(icon: icon, semanticLabel: semanticLabel);
  }

  /// Convenient shorthand for creating a StyledIcon widget with this StyleSpec.
  @Deprecated(
    'Use StyledIcon(icon: icon, semanticLabel: semanticLabel, styleSpec: styleSpec) instead',
  )
  Widget call({IconData? icon, String? semanticLabel}) {
    return StyledIcon(
      icon: icon,
      semanticLabel: semanticLabel,
      styleSpec: this,
    );
  }
}
