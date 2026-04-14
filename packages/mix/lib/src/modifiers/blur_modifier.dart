import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/widget_modifier.dart';

part 'blur_modifier.g.dart';

/// Modifier that applies a Gaussian blur filter to its child.
@MixableModifier()
final class BlurModifier extends WidgetModifier<BlurModifier>
    with Diagnosticable {
  /// Blur sigma for X and Y axis.
  final double sigma;

  const BlurModifier([double? sigma]) : sigma = sigma ?? 0.0;

  @override
  BlurModifier copyWith({double? sigma}) {
    return BlurModifier(sigma ?? this.sigma);
  }

  @override
  BlurModifier lerp(BlurModifier? other, double t) {
    if (other == null) return this;

    return BlurModifier(MixOps.lerp(sigma, other.sigma, t)!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('sigma', sigma));
  }

  @override
  List<Object?> get props => [sigma];

  @override
  Widget build(Widget child) {
    if (sigma == 0.0) return child;

    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(
        sigmaX: sigma,
        sigmaY: sigma,
        tileMode: ui.TileMode.clamp,
      ),
      child: child,
    );
  }
}

