import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/spec.dart';
import '../../specs/icon/icon_widget.dart';

/// Specification for iconography properties based on IconTheme.
///
/// Provides iconography configuration that can be applied to establish
/// default icon styling context, similar to Flutter's IconTheme widget.
/// Unlike IconWidgetSpec which extends WidgetSpec, this extends Spec directly
/// for use in contexts where widget-level metadata is not needed.
final class IconographySpec extends Spec<IconographySpec> with Diagnosticable {
  /// The size of icons in logical pixels.
  final double? size;

  /// The fill variant (0.0-1.0) for supported icon fonts.
  final double? fill;

  /// The font weight variant (100-900) for supported icon fonts.
  final double? weight;

  /// The grade variant (-25 to 200) for supported icon fonts.
  final double? grade;

  /// The optical size variant (20-48) for supported icon fonts.
  final double? opticalSize;

  /// The color to use when drawing icons.
  final Color? color;

  /// The opacity to apply to the icon.
  final double? opacity;

  /// A list of shadows to paint behind icons.
  final List<Shadow>? shadows;

  /// Whether to scale icons according to the textScaleFactor.
  final bool? applyTextScaling;

  const IconographySpec({
    this.size,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
    this.color,
    this.opacity,
    this.shadows,
    this.applyTextScaling,
  });

  /// Creates a copy of this [IconographySpec] but with the given fields
  /// replaced with the new values.
  @override
  IconographySpec copyWith({
    double? size,
    double? fill,
    double? weight,
    double? grade,
    double? opticalSize,
    Color? color,
    double? opacity,
    List<Shadow>? shadows,
    bool? applyTextScaling,
  }) {
    return IconographySpec(
      size: size ?? this.size,
      fill: fill ?? this.fill,
      weight: weight ?? this.weight,
      grade: grade ?? this.grade,
      opticalSize: opticalSize ?? this.opticalSize,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      shadows: shadows ?? this.shadows,
      applyTextScaling: applyTextScaling ?? this.applyTextScaling,
    );
  }

  /// Linearly interpolates between this [IconographySpec] and another [IconographySpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [IconographySpec] is returned. When [t] is 1.0, the [other] [IconographySpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [IconographySpec] is returned.
  ///
  /// If [other] is null, this method returns the current [IconographySpec] instance.
  ///
  /// The interpolation is performed on each property of the [IconographySpec] using the appropriate
  /// interpolation method:
  /// - [MixOps.lerp] for [size], [fill], [weight], [grade], [opticalSize], [color], [opacity], and [shadows].
  /// For [applyTextScaling], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [IconographySpec] is used. Otherwise, the value
  /// from the [other] [IconographySpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [IconographySpec] configurations.
  @override
  IconographySpec lerp(IconographySpec? other, double t) {
    if (other == null) return this;

    return IconographySpec(
      size: MixOps.lerp(size, other.size, t),
      fill: MixOps.lerp(fill, other.fill, t),
      weight: MixOps.lerp(weight, other.weight, t),
      grade: MixOps.lerp(grade, other.grade, t),
      opticalSize: MixOps.lerp(opticalSize, other.opticalSize, t),
      color: MixOps.lerp(color, other.color, t),
      opacity: MixOps.lerp(opacity, other.opacity, t),
      shadows: MixOps.lerp(shadows, other.shadows, t),
      applyTextScaling: MixOps.lerpSnap(
        applyTextScaling,
        other.applyTextScaling,
        t,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('size', size))
      ..add(DoubleProperty('fill', fill))
      ..add(DoubleProperty('weight', weight))
      ..add(DoubleProperty('grade', grade))
      ..add(DoubleProperty('opticalSize', opticalSize))
      ..add(ColorProperty('color', color))
      ..add(DoubleProperty('opacity', opacity))
      ..add(IterableProperty<Shadow>('shadows', shadows))
      ..add(
        FlagProperty(
          'applyTextScaling',
          value: applyTextScaling,
          ifTrue: 'scales with text',
        ),
      );
  }

  /// The list of properties that constitute the state of this [IconographySpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IconographySpec] instances for equality.
  @override
  List<Object?> get props => [
    size,
    fill,
    weight,
    grade,
    opticalSize,
    color,
    opacity,
    shadows,
    applyTextScaling,
  ];
}

/// Creates an [IconTheme] widget from an [IconographySpec] with [StyledIcon] as child.
IconTheme createIconographySpecWidget({
  required IconographySpec spec,
  IconData? icon,
  String? semanticLabel,
}) {
  return IconTheme(
    data: IconThemeData(
      size: spec.size,
      fill: spec.fill,
      weight: spec.weight,
      grade: spec.grade,
      opticalSize: spec.opticalSize,
      color: spec.color,
      opacity: spec.opacity,
      shadows: spec.shadows,
      applyTextScaling: spec.applyTextScaling,
    ),
    child: StyledIcon(icon: icon, semanticLabel: semanticLabel),
  );
}

/// Extension to convert [IconographySpec] directly to an [IconTheme] widget.
extension IconographySpecWidget on IconographySpec {
  IconTheme call({IconData? icon, String? semanticLabel}) {
    return createIconographySpecWidget(
      spec: this,
      icon: icon,
      semanticLabel: semanticLabel,
    );
  }
}
