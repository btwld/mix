import 'package:flutter/material.dart';

import '../../core/style_widget.dart';
import 'icon_attribute.dart';
import 'icon_spec.dart';

/// Displays an icon with Mix styling.
///
/// Applies [IconWidgetSpec] for custom icon appearance.
class StyledIcon extends StyleWidget<IconWidgetSpec> {
  const StyledIcon({
    this.icon,
    this.semanticLabel,
    super.style = const IconMix.create(),
    super.key,
  });

  /// The icon to display.
  final IconData? icon;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context, IconWidgetSpec spec) {
    return createIconSpecWidget(
      spec: spec,
      icon: icon,
      semanticLabel: semanticLabel,
    );
  }
}

/// Creates an [Icon] widget from an [IconWidgetSpec] and optional overrides.
Icon createIconSpecWidget({
  required IconWidgetSpec? spec,
  IconData? icon,
  String? semanticLabel,
}) {
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

/// Extension to convert [IconWidgetSpec] directly to an [Icon] widget.
extension IconSpecWidget on IconWidgetSpec {
  Icon call({IconData? icon, String? semanticLabel}) {
    return createIconSpecWidget(
      spec: this,
      icon: icon,
      semanticLabel: semanticLabel,
    );
  }
}
