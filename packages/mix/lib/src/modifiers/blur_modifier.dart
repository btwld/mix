import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/widget_modifier.dart';

/// Modifier that applies a Gaussian blur filter to its child.
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

/// Mix class for applying blur modifications.
class BlurModifierMix extends ModifierMix<BlurModifier> with Diagnosticable {
  final Prop<double>? sigma;

  const BlurModifierMix.create({this.sigma});

  BlurModifierMix({double? sigma}) : this.create(sigma: Prop.maybe(sigma));

  @override
  BlurModifier resolve(BuildContext context) {
    return BlurModifier(sigma?.resolveProp(context));
  }

  @override
  BlurModifierMix merge(BlurModifierMix? other) {
    if (other == null) return this;

    return BlurModifierMix.create(sigma: MixOps.merge(sigma, other.sigma));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('sigma', sigma));
  }

  @override
  List<Object?> get props => [sigma];
}
