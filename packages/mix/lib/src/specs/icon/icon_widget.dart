import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/style_builder.dart';
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
    super.key,
  });

  /// The icon to display.
  final IconData? icon;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context, IconSpec spec) {
    return _createIconSpecWidget(
      spec: spec,
      icon: icon,
      semanticLabel: semanticLabel,
    );
  }
}

/// Creates an [Icon] widget from an [IconSpec] and optional overrides.
Icon _createIconSpecWidget({
  required IconSpec? spec,
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

/// Extension to convert [IconSpec] directly to an [Icon] widget.
@internal
extension IconSpecWidget on IconSpec {
  Icon call({IconData? icon, String? semanticLabel}) {
    return _createIconSpecWidget(
      spec: this,
      icon: icon,
      semanticLabel: semanticLabel,
    );
  }
}

@internal
extension IconSpecWrappedWidget on StyleSpec<IconSpec> {
  Widget call({IconData? icon, String? semanticLabel}) {
    return StyleSpecBuilder(
      builder: (context, spec) {
        return _createIconSpecWidget(
          spec: spec,
          icon: icon,
          semanticLabel: semanticLabel,
        );
      },
      wrappedSpec: this,
    );
  }
}
