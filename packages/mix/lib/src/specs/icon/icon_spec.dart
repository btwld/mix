import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/spec.dart';

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
    );
  }

  @override
  IconSpec lerp(IconSpec? other, double t) {
    if (other == null) return this;

    return IconSpec(
      color: Color.lerp(color, other.color, t),
      size: MixHelpers.lerpDouble(size, other.size, t),
      weight: MixHelpers.lerpDouble(weight, other.weight, t),
      grade: MixHelpers.lerpDouble(grade, other.grade, t),
      opticalSize: MixHelpers.lerpDouble(opticalSize, other.opticalSize, t),
      shadows: MixHelpers.lerpShadowList(shadows, other.shadows, t),
      textDirection: t < 0.5 ? textDirection : other.textDirection,
      applyTextScaling: t < 0.5 ? applyTextScaling : other.applyTextScaling,
      fill: MixHelpers.lerpDouble(fill, other.fill, t),
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
  ];
}
