import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import '../painting/shadow_mix.dart';
import 'iconography_spec.dart';

/// Mix class for configuring [IconographySpec] properties.
///
/// Encapsulates iconography properties with support for proper Mix framework integration.
/// Based on Flutter's IconTheme properties but designed to work with Mix's
/// token system, merging, and resolution pipeline.
final class IconographyMix extends Mix<IconographySpec> with Diagnosticable {
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
  IconographyMix({
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

  /// Create constructor with `Prop<T>` types for internal use
  const IconographyMix.create({
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
  IconographyMix.value(IconographySpec spec)
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
  factory IconographyMix.size(double value) {
    return IconographyMix(size: value);
  }

  /// Fill factory
  factory IconographyMix.fill(double value) {
    return IconographyMix(fill: value);
  }

  /// Weight factory
  factory IconographyMix.weight(double value) {
    return IconographyMix(weight: value);
  }

  /// Grade factory
  factory IconographyMix.grade(double value) {
    return IconographyMix(grade: value);
  }

  /// Optical size factory
  factory IconographyMix.opticalSize(double value) {
    return IconographyMix(opticalSize: value);
  }

  /// Color factory
  factory IconographyMix.color(Color value) {
    return IconographyMix(color: value);
  }

  /// Opacity factory
  factory IconographyMix.opacity(double value) {
    return IconographyMix(opacity: value);
  }

  /// Shadows factory
  factory IconographyMix.shadows(List<ShadowMix> value) {
    return IconographyMix(shadows: value);
  }

  /// Apply text scaling factory
  factory IconographyMix.applyTextScaling(bool value) {
    return IconographyMix(applyTextScaling: value);
  }

  // Common shortcuts

  /// Small size factory (16.0)
  factory IconographyMix.small() {
    return IconographyMix.size(16.0);
  }

  /// Medium size factory (24.0)
  factory IconographyMix.medium() {
    return IconographyMix.size(24.0);
  }

  /// Large size factory (32.0)
  factory IconographyMix.large() {
    return IconographyMix.size(32.0);
  }

  /// Constructor that accepts a nullable [IconographySpec] value.
  ///
  /// Returns null if the input is null, otherwise uses [IconographyMix.value].
  static IconographyMix? maybeValue(IconographySpec? spec) {
    return spec != null ? IconographyMix.value(spec) : null;
  }

  // Chainable instance methods

  /// Returns a copy with the specified size.
  IconographyMix size(double value) {
    return merge(IconographyMix.size(value));
  }

  /// Returns a copy with the specified fill.
  IconographyMix fill(double value) {
    return merge(IconographyMix.fill(value));
  }

  /// Returns a copy with the specified weight.
  IconographyMix weight(double value) {
    return merge(IconographyMix.weight(value));
  }

  /// Returns a copy with the specified grade.
  IconographyMix grade(double value) {
    return merge(IconographyMix.grade(value));
  }

  /// Returns a copy with the specified optical size.
  IconographyMix opticalSize(double value) {
    return merge(IconographyMix.opticalSize(value));
  }

  /// Returns a copy with the specified color.
  IconographyMix color(Color value) {
    return merge(IconographyMix.color(value));
  }

  /// Returns a copy with the specified opacity.
  IconographyMix opacity(double value) {
    return merge(IconographyMix.opacity(value));
  }

  /// Returns a copy with the specified shadows.
  IconographyMix shadows(List<ShadowMix> value) {
    return merge(IconographyMix.shadows(value));
  }

  /// Returns a copy with the specified apply text scaling.
  IconographyMix applyTextScaling(bool value) {
    return merge(IconographyMix.applyTextScaling(value));
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

  /// Merges the properties of this [IconographyMix] with the properties of [other].
  @override
  IconographyMix merge(IconographyMix? other) {
    if (other == null) return this;

    return IconographyMix.create(
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