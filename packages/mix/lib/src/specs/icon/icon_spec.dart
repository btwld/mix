import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/spec.dart';

/// Specification for icon styling properties.
///
/// Provides comprehensive icon styling including color, size, weight, optical properties,
/// text direction, scaling behavior, and shadow effects.
final class IconSpec extends Spec<IconSpec> with Diagnosticable {
  final Color? color;
  final double? size;
  final double? weight;
  final double? grade;
  final double? opticalSize;
  final TextDirection? textDirection;
  final bool? applyTextScaling;
  final List<Shadow>? shadows;
  final double? fill;
  final String? semanticsLabel;
  final BlendMode? blendMode;
  final IconData? icon;

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
    this.semanticsLabel,
    this.blendMode,
    this.icon,
  });

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty('color', color, defaultValue: null));
    properties.add(DiagnosticsProperty('size', size, defaultValue: null));
    properties.add(DiagnosticsProperty('weight', weight, defaultValue: null));
    properties.add(DiagnosticsProperty('grade', grade, defaultValue: null));
    properties.add(
      DiagnosticsProperty('opticalSize', opticalSize, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('shadows', shadows, defaultValue: null));
    properties.add(
      DiagnosticsProperty('textDirection', textDirection, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'applyTextScaling',
        applyTextScaling,
        defaultValue: null,
      ),
    );
    properties.add(DiagnosticsProperty('fill', fill, defaultValue: null));
    properties.add(
      DiagnosticsProperty('semanticsLabel', semanticsLabel, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('blendMode', blendMode, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('icon', icon, defaultValue: null));
  }

  @override
  IconSpec copyWith({
    Color? color,
    double? size,
    double? weight,
    double? grade,
    double? opticalSize,
    List<Shadow>? shadows,
    TextDirection? textDirection,
    bool? applyTextScaling,
    double? fill,
    String? semanticsLabel,
    BlendMode? blendMode,
    IconData? icon,
  }) {
    return IconSpec(
      color: color ?? this.color,
      size: size ?? this.size,
      weight: weight ?? this.weight,
      grade: grade ?? this.grade,
      opticalSize: opticalSize ?? this.opticalSize,
      shadows: shadows ?? this.shadows,
      textDirection: textDirection ?? this.textDirection,
      applyTextScaling: applyTextScaling ?? this.applyTextScaling,
      fill: fill ?? this.fill,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      blendMode: blendMode ?? this.blendMode,
      icon: icon ?? this.icon,
    );
  }

  @override
  IconSpec lerp(IconSpec? other, double t) {
    if (other == null) return this;

    return IconSpec(
      color: MixOps.lerp(color, other.color, t),
      size: MixOps.lerp(size, other.size, t),
      weight: MixOps.lerp(weight, other.weight, t),
      grade: MixOps.lerp(grade, other.grade, t),
      opticalSize: MixOps.lerp(opticalSize, other.opticalSize, t),
      shadows: MixOps.lerp(shadows, other.shadows, t),
      textDirection: MixOps.lerp(textDirection, other.textDirection, t),
      applyTextScaling: MixOps.lerp(
        applyTextScaling,
        other.applyTextScaling,
        t,
      ),
      fill: MixOps.lerp(fill, other.fill, t),
      semanticsLabel: MixOps.lerp(semanticsLabel, other.semanticsLabel, t),
      blendMode: MixOps.lerp(blendMode, other.blendMode, t),
      icon: MixOps.lerp(icon, other.icon, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  List<Object?> get props => [
    color,
    size,
    weight,
    grade,
    opticalSize,
    shadows,
    textDirection,
    applyTextScaling,
    fill,
    semanticsLabel,
    blendMode,
    icon,
  ];
}
