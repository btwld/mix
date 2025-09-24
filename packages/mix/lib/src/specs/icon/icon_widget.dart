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
    super.spec,
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

/// Extension to convert [IconSpec] directly to a [StyledIcon] widget.
extension IconSpecWidget on IconSpec {
  /// Creates a [StyledIcon] widget from this [IconSpec].
  @Deprecated(
    'Use StyledIcon(spec: this, icon: icon, semanticLabel: semanticLabel) instead',
  )
  Widget createWidget({IconData? icon, String? semanticLabel}) {
    return StyledIcon(spec: this, icon: icon, semanticLabel: semanticLabel);
  }

  @Deprecated(
    'Use StyledIcon(spec: this, icon: icon, semanticLabel: semanticLabel) instead',
  )
  Widget call({IconData? icon, String? semanticLabel}) {
    return StyledIcon(spec: this, icon: icon, semanticLabel: semanticLabel);
  }
}

extension IconSpecWrappedWidget on StyleSpec<IconSpec> {
  /// Creates a widget that resolves this [StyleSpec<IconSpec>] with context.
  @Deprecated(
    'Use StyleSpecBuilder directly for custom logic, or styleSpec(icon: icon, semanticLabel: semanticLabel) for simple cases',
  )
  Widget createWidget({IconData? icon, String? semanticLabel}) {
    return StyleSpecBuilder<IconSpec>(builder: (context, spec) {
      return StyledIcon(spec: spec, icon: icon, semanticLabel: semanticLabel);
    }, styleSpec: this);
  }

  /// Convenient shorthand for creating a StyledIcon widget with this StyleSpec.
  Widget call({IconData? icon, String? semanticLabel}) {
    return StyleSpecBuilder<IconSpec>(builder: (context, spec) {
      return StyledIcon(spec: spec, icon: icon, semanticLabel: semanticLabel);
    }, styleSpec: this);
  }
}
