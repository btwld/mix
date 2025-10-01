import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import 'shadow_mix.dart';

/// Mix representation of [IconThemeData].
///
/// Comprehensive text styling with tokens.
class IconThemeDataMix extends Mix<IconThemeData> {
  final Prop<Color>? $color;
  final Prop<double>? $size;
  final Prop<double>? $fill;
  final Prop<double>? $weight;
  final Prop<double>? $grade;
  final Prop<double>? $opticalSize;
  final Prop<double>? $opacity;
  final Prop<List<Shadow>>? $shadows;
  final Prop<bool>? $applyTextScaling;

  const IconThemeDataMix.create({
    Prop<Color>? color,
    Prop<double>? size,
    Prop<double>? fill,
    Prop<double>? weight,
    Prop<double>? grade,
    Prop<double>? opticalSize,
    Prop<double>? opacity,
    Prop<List<Shadow>>? shadows,
    Prop<bool>? applyTextScaling,
  }) : $color = color,
       $size = size,
       $fill = fill,
       $weight = weight,
       $grade = grade,
       $opticalSize = opticalSize,
       $opacity = opacity,
       $shadows = shadows,
       $applyTextScaling = applyTextScaling;

  IconThemeDataMix({
    Color? color,
    double? size,
    double? fill,
    double? weight,
    double? grade,
    double? opticalSize,
    double? opacity,
    List<ShadowMix>? shadows,
    bool? applyTextScaling,
  }) : this.create(
         color: Prop.maybe(color),
         size: Prop.maybe(size),
         fill: Prop.maybe(fill),
         weight: Prop.maybe(weight),
         grade: Prop.maybe(grade),
         opticalSize: Prop.maybe(opticalSize),
         opacity: Prop.maybe(opacity),
         shadows: shadows != null ? Prop.mix(ShadowListMix(shadows)) : null,
         applyTextScaling: Prop.maybe(applyTextScaling),
       );

  /// Sets icon color (method style)
  IconThemeDataMix color(Color value) {
    return merge(IconThemeDataMix(color: value));
  }

  /// Sets icon size (method style)
  IconThemeDataMix size(double value) {
    return merge(IconThemeDataMix(size: value));
  }

  /// Sets icon fill (method style)
  IconThemeDataMix fill(double value) {
    return merge(IconThemeDataMix(fill: value));
  }

  /// Sets icon weight (method style)
  IconThemeDataMix weight(double value) {
    return merge(IconThemeDataMix(weight: value));
  }

  /// Sets icon grade (method style)
  IconThemeDataMix grade(double value) {
    return merge(IconThemeDataMix(grade: value));
  }

  /// Sets icon optical size (method style)
  IconThemeDataMix opticalSize(double value) {
    return merge(IconThemeDataMix(opticalSize: value));
  }

  /// Sets icon opacity (method style)
  IconThemeDataMix opacity(double value) {
    return merge(IconThemeDataMix(opacity: value));
  }

  /// Sets icon shadows (method style)
  IconThemeDataMix shadows(List<ShadowMix> value) {
    return merge(IconThemeDataMix(shadows: value));
  }

  /// Sets applyTextScaling (method style)
  IconThemeDataMix applyTextScaling(bool value) {
    return merge(IconThemeDataMix(applyTextScaling: value));
  }

  /// Resolves to [IconThemeData] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final iconThemeData = IconThemeDataMix(...).resolve(context);
  /// ```
  @override
  IconThemeData resolve(BuildContext context) {
    return IconThemeData(
      size: MixOps.resolve(context, $size),
      fill: MixOps.resolve(context, $fill),
      weight: MixOps.resolve(context, $weight),
      grade: MixOps.resolve(context, $grade),
      opticalSize: MixOps.resolve(context, $opticalSize),
      color: MixOps.resolve(context, $color),
      opacity: MixOps.resolve(context, $opacity),
      shadows: MixOps.resolve(context, $shadows),
      applyTextScaling: MixOps.resolve(context, $applyTextScaling),
    );
  }

  /// Merges the properties of this [IconThemeDataMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [IconThemeDataMix] with the properties of [other] taking precedence over
  /// the properties of this instance.
  ///
  /// This method is typically used when combining or overriding icon theme data attributes.
  @override
  IconThemeDataMix merge(IconThemeDataMix? other) {
    if (other == null) return this;

    return IconThemeDataMix.create(
      color: MixOps.merge($color, other.$color),
      size: MixOps.merge($size, other.$size),
      fill: MixOps.merge($fill, other.$fill),
      weight: MixOps.merge($weight, other.$weight),
      grade: MixOps.merge($grade, other.$grade),
      opticalSize: MixOps.merge($opticalSize, other.$opticalSize),
      opacity: MixOps.merge($opacity, other.$opacity),
      shadows: MixOps.merge($shadows, other.$shadows),
      applyTextScaling: MixOps.merge(
        $applyTextScaling,
        other.$applyTextScaling,
      ),
    );
  }

  @override
  List<Object?> get props => [
    color,
    size,
    fill,
    weight,
    grade,
    opticalSize,
    opacity,
    shadows,
    applyTextScaling,
  ];
}
