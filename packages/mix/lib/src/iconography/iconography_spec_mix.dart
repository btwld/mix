import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/mix_element.dart';
import '../core/prop.dart';
import '../properties/painting/shadow_mix.dart';
import 'iconography_spec.dart';

/// Mix class for configuring [IconographySpec] properties.
///
/// Encapsulates iconography properties with support for proper Mix framework integration.
/// Based on Flutter's IconTheme properties but designed to work with Mix's
/// token system, merging, and resolution pipeline.
final class IconographySpecMix extends Mix<IconographySpec> with Diagnosticable {
  final Prop<double>? $size;
  final Prop<double>? $fill;
  final Prop<double>? $weight;
  final Prop<double>? $grade;
  final Prop<double>? $opticalSize;
  final Prop<Color>? $color;
  final Prop<double>? $opacity;
  final List<Prop<Shadow>>? $shadows;
  final Prop<bool>? $applyTextScaling;

  /// Main constructor with user-friendly Mix types
  IconographySpecMix({
    double? size,
    double? fill,
    double? weight,
    double? grade,
    double? opticalSize,
    Color? color,
    double? opacity,
    List<ShadowMix>? shadows,
    bool? applyTextScaling,
  }) : this.create(
         size: Prop.maybe(size),
         fill: Prop.maybe(fill),
         weight: Prop.maybe(weight),
         grade: Prop.maybe(grade),
         opticalSize: Prop.maybe(opticalSize),
         color: Prop.maybe(color),
         opacity: Prop.maybe(opacity),
         shadows: shadows?.map(Prop.mix).toList(),
         applyTextScaling: Prop.maybe(applyTextScaling),
       );

  /// Create constructor with Prop\\<T\\> types for internal use
  const IconographySpecMix.create({
    Prop<double>? size,
    Prop<double>? fill,
    Prop<double>? weight,
    Prop<double>? grade,
    Prop<double>? opticalSize,
    Prop<Color>? color,
    Prop<double>? opacity,
    List<Prop<Shadow>>? shadows,
    Prop<bool>? applyTextScaling,
  }) : $size = size,
       $fill = fill,
       $weight = weight,
       $grade = grade,
       $opticalSize = opticalSize,
       $color = color,
       $opacity = opacity,
       $shadows = shadows,
       $applyTextScaling = applyTextScaling;

  /// Constructor that accepts an [IconographySpec] value and extracts its properties.
  IconographySpecMix.value(IconographySpec spec)
    : this(
        size: spec.size,
        fill: spec.fill,
        weight: spec.weight,
        grade: spec.grade,
        opticalSize: spec.opticalSize,
        color: spec.color,
        opacity: spec.opacity,
        shadows: spec.shadows?.map((s) => ShadowMix.value(s)).toList(),
        applyTextScaling: spec.applyTextScaling,
      );

  // Factory constructors for common use cases

  /// Size factory
  factory IconographySpecMix.size(double value) {
    return IconographySpecMix(size: value);
  }

  /// Fill factory
  factory IconographySpecMix.fill(double value) {
    return IconographySpecMix(fill: value);
  }

  /// Weight factory
  factory IconographySpecMix.weight(double value) {
    return IconographySpecMix(weight: value);
  }

  /// Grade factory
  factory IconographySpecMix.grade(double value) {
    return IconographySpecMix(grade: value);
  }

  /// Optical size factory
  factory IconographySpecMix.opticalSize(double value) {
    return IconographySpecMix(opticalSize: value);
  }

  /// Color factory
  factory IconographySpecMix.color(Color value) {
    return IconographySpecMix(color: value);
  }

  /// Opacity factory
  factory IconographySpecMix.opacity(double value) {
    return IconographySpecMix(opacity: value);
  }

  /// Shadows factory
  factory IconographySpecMix.shadows(List<ShadowMix> value) {
    return IconographySpecMix(shadows: value);
  }

  /// Apply text scaling factory
  factory IconographySpecMix.applyTextScaling(bool value) {
    return IconographySpecMix(applyTextScaling: value);
  }

  // Common shortcuts

  /// Small size factory (16.0)
  factory IconographySpecMix.small() {
    return IconographySpecMix.size(16.0);
  }

  /// Medium size factory (24.0)
  factory IconographySpecMix.medium() {
    return IconographySpecMix.size(24.0);
  }

  /// Large size factory (32.0)
  factory IconographySpecMix.large() {
    return IconographySpecMix.size(32.0);
  }

  /// Constructor that accepts a nullable [IconographySpec] value.
  ///
  /// Returns null if the input is null, otherwise uses [IconographySpecMix.value].
  static IconographySpecMix? maybeValue(IconographySpec? spec) {
    return spec != null ? IconographySpecMix.value(spec) : null;
  }

  // Chainable instance methods

  /// Returns a copy with the specified size.
  IconographySpecMix size(double value) {
    return merge(IconographySpecMix.size(value));
  }

  /// Returns a copy with the specified fill.
  IconographySpecMix fill(double value) {
    return merge(IconographySpecMix.fill(value));
  }

  /// Returns a copy with the specified weight.
  IconographySpecMix weight(double value) {
    return merge(IconographySpecMix.weight(value));
  }

  /// Returns a copy with the specified grade.
  IconographySpecMix grade(double value) {
    return merge(IconographySpecMix.grade(value));
  }

  /// Returns a copy with the specified optical size.
  IconographySpecMix opticalSize(double value) {
    return merge(IconographySpecMix.opticalSize(value));
  }

  /// Returns a copy with the specified color.
  IconographySpecMix color(Color value) {
    return merge(IconographySpecMix.color(value));
  }

  /// Returns a copy with the specified opacity.
  IconographySpecMix opacity(double value) {
    return merge(IconographySpecMix.opacity(value));
  }

  /// Returns a copy with the specified shadows.
  IconographySpecMix shadows(List<ShadowMix> value) {
    return merge(IconographySpecMix.shadows(value));
  }

  /// Returns a copy with the specified apply text scaling.
  IconographySpecMix applyTextScaling(bool value) {
    return merge(IconographySpecMix.applyTextScaling(value));
  }

  /// Resolves to [IconographySpec] using the provided [BuildContext].
  @override
  IconographySpec resolve(BuildContext context) {
    return IconographySpec(
      size: MixOps.resolve(context, $size),
      fill: MixOps.resolve(context, $fill),
      weight: MixOps.resolve(context, $weight),
      grade: MixOps.resolve(context, $grade),
      opticalSize: MixOps.resolve(context, $opticalSize),
      color: MixOps.resolve(context, $color),
      opacity: MixOps.resolve(context, $opacity),
      shadows: MixOps.resolveList(context, $shadows),
      applyTextScaling: MixOps.resolve(context, $applyTextScaling),
    );
  }

  /// Merges the properties of this [IconographySpecMix] with the properties of [other].
  @override
  IconographySpecMix merge(IconographySpecMix? other) {
    if (other == null) return this;

    return IconographySpecMix.create(
      size: MixOps.merge($size, other.$size),
      fill: MixOps.merge($fill, other.$fill),
      weight: MixOps.merge($weight, other.$weight),
      grade: MixOps.merge($grade, other.$grade),
      opticalSize: MixOps.merge($opticalSize, other.$opticalSize),
      color: MixOps.merge($color, other.$color),
      opacity: MixOps.merge($opacity, other.$opacity),
      shadows: MixOps.mergeList($shadows, other.$shadows),
      applyTextScaling: MixOps.merge($applyTextScaling, other.$applyTextScaling),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('size', $size))
      ..add(DiagnosticsProperty('fill', $fill))
      ..add(DiagnosticsProperty('weight', $weight))
      ..add(DiagnosticsProperty('grade', $grade))
      ..add(DiagnosticsProperty('opticalSize', $opticalSize))
      ..add(DiagnosticsProperty('color', $color))
      ..add(DiagnosticsProperty('opacity', $opacity))
      ..add(DiagnosticsProperty('shadows', $shadows))
      ..add(DiagnosticsProperty('applyTextScaling', $applyTextScaling));
  }

  @override
  List<Object?> get props => [
    $size,
    $fill,
    $weight,
    $grade,
    $opticalSize,
    $color,
    $opacity,
    $shadows,
    $applyTextScaling,
  ];
}