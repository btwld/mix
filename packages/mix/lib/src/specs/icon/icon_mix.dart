import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import '../../properties/painting/shadow_mix.dart';
import 'icon_spec.dart';
import 'icon_style.dart';

/// Mix class for configuring [IconSpec] properties.
///
/// Encapsulates icon properties with support for proper Mix framework integration.
/// Combines both per-icon and ambient icon styling capabilities.
final class IconMix extends Mix<IconSpec> with Diagnosticable {
  final Prop<Color>? $color;
  final Prop<double>? $size;
  final Prop<double>? $weight;
  final Prop<double>? $grade;
  final Prop<double>? $opticalSize;
  final List<Prop<Shadow>>? $shadows;
  final Prop<TextDirection>? $textDirection;
  final Prop<bool>? $applyTextScaling;
  final Prop<double>? $fill;
  final Prop<String>? $semanticsLabel;
  final Prop<double>? $opacity;
  final Prop<BlendMode>? $blendMode;
  final Prop<IconData>? $icon;

  /// Main constructor with user-friendly Mix types
  IconMix({
    Color? color,
    double? size,
    double? weight,
    double? grade,
    double? opticalSize,
    List<ShadowMix>? shadows,
    TextDirection? textDirection,
    bool? applyTextScaling,
    double? fill,
    String? semanticsLabel,
    double? opacity,
    BlendMode? blendMode,
    IconData? icon,
  }) : this.create(
         color: Prop.maybe(color),
         size: Prop.maybe(size),
         weight: Prop.maybe(weight),
         grade: Prop.maybe(grade),
         opticalSize: Prop.maybe(opticalSize),
         shadows: shadows?.map(Prop.mix).toList(),
         textDirection: Prop.maybe(textDirection),
         applyTextScaling: Prop.maybe(applyTextScaling),
         fill: Prop.maybe(fill),
         semanticsLabel: Prop.maybe(semanticsLabel),
         opacity: Prop.maybe(opacity),
         blendMode: Prop.maybe(blendMode),
         icon: Prop.maybe(icon),
       );

  /// Create constructor with `Prop<T>` types for internal use
  const IconMix.create({
    Prop<Color>? color,
    Prop<double>? size,
    Prop<double>? weight,
    Prop<double>? grade,
    Prop<double>? opticalSize,
    List<Prop<Shadow>>? shadows,
    Prop<TextDirection>? textDirection,
    Prop<bool>? applyTextScaling,
    Prop<double>? fill,
    Prop<String>? semanticsLabel,
    Prop<double>? opacity,
    Prop<BlendMode>? blendMode,
    Prop<IconData>? icon,
  }) : $color = color,
       $size = size,
       $weight = weight,
       $grade = grade,
       $opticalSize = opticalSize,
       $shadows = shadows,
       $textDirection = textDirection,
       $applyTextScaling = applyTextScaling,
       $fill = fill,
       $semanticsLabel = semanticsLabel,
       $opacity = opacity,
       $blendMode = blendMode,
       $icon = icon;

  /// Constructor that accepts an [IconSpec] value and extracts its properties.
  IconMix.value(IconSpec spec)
    : this(
        color: spec.color,
        size: spec.size,
        weight: spec.weight,
        grade: spec.grade,
        opticalSize: spec.opticalSize,
        shadows: spec.shadows?.map((s) => ShadowMix.value(s)).toList(),
        textDirection: spec.textDirection,
        applyTextScaling: spec.applyTextScaling,
        fill: spec.fill,
        semanticsLabel: spec.semanticsLabel,
        opacity: spec.opacity,
        blendMode: spec.blendMode,
        icon: spec.icon,
      );

  // Factory constructors for common use cases

  /// Color factory
  factory IconMix.color(Color value) {
    return IconMix(color: value);
  }

  /// Size factory
  factory IconMix.size(double value) {
    return IconMix(size: value);
  }

  /// Weight factory
  factory IconMix.weight(double value) {
    return IconMix(weight: value);
  }

  /// Grade factory
  factory IconMix.grade(double value) {
    return IconMix(grade: value);
  }

  /// Optical size factory
  factory IconMix.opticalSize(double value) {
    return IconMix(opticalSize: value);
  }

  /// Shadows factory
  factory IconMix.shadows(List<ShadowMix> value) {
    return IconMix(shadows: value);
  }

  /// Text direction factory
  factory IconMix.textDirection(TextDirection value) {
    return IconMix(textDirection: value);
  }

  /// Apply text scaling factory
  factory IconMix.applyTextScaling(bool value) {
    return IconMix(applyTextScaling: value);
  }

  /// Fill factory
  factory IconMix.fill(double value) {
    return IconMix(fill: value);
  }

  /// Semantics label factory
  factory IconMix.semanticsLabel(String value) {
    return IconMix(semanticsLabel: value);
  }

  /// Opacity factory
  factory IconMix.opacity(double value) {
    return IconMix(opacity: value);
  }

  /// Blend mode factory
  factory IconMix.blendMode(BlendMode value) {
    return IconMix(blendMode: value);
  }

  /// Icon data factory
  factory IconMix.icon(IconData value) {
    return IconMix(icon: value);
  }

  // Common shortcuts

  /// Small size factory (16.0)
  factory IconMix.small() {
    return IconMix.size(16.0);
  }

  /// Medium size factory (24.0)
  factory IconMix.medium() {
    return IconMix.size(24.0);
  }

  /// Large size factory (32.0)
  factory IconMix.large() {
    return IconMix.size(32.0);
  }

  /// Constructor that accepts a nullable [IconSpec] value.
  ///
  /// Returns null if the input is null, otherwise uses [IconMix.value].
  static IconMix? maybeValue(IconSpec? spec) {
    return spec != null ? IconMix.value(spec) : null;
  }

  // Chainable instance methods

  /// Returns a copy with the specified color.
  IconMix color(Color value) {
    return merge(IconMix.color(value));
  }

  /// Returns a copy with the specified size.
  IconMix size(double value) {
    return merge(IconMix.size(value));
  }

  /// Returns a copy with the specified weight.
  IconMix weight(double value) {
    return merge(IconMix.weight(value));
  }

  /// Returns a copy with the specified grade.
  IconMix grade(double value) {
    return merge(IconMix.grade(value));
  }

  /// Returns a copy with the specified optical size.
  IconMix opticalSize(double value) {
    return merge(IconMix.opticalSize(value));
  }

  /// Returns a copy with the specified shadows.
  IconMix shadows(List<ShadowMix> value) {
    return merge(IconMix.shadows(value));
  }

  /// Returns a copy with the specified text direction.
  IconMix textDirection(TextDirection value) {
    return merge(IconMix.textDirection(value));
  }

  /// Returns a copy with the specified apply text scaling.
  IconMix applyTextScaling(bool value) {
    return merge(IconMix.applyTextScaling(value));
  }

  /// Returns a copy with the specified fill.
  IconMix fill(double value) {
    return merge(IconMix.fill(value));
  }

  /// Returns a copy with the specified semantics label.
  IconMix semanticsLabel(String value) {
    return merge(IconMix.semanticsLabel(value));
  }

  /// Returns a copy with the specified opacity.
  IconMix opacity(double value) {
    return merge(IconMix.opacity(value));
  }

  /// Returns a copy with the specified blend mode.
  IconMix blendMode(BlendMode value) {
    return merge(IconMix.blendMode(value));
  }

  /// Returns a copy with the specified icon data.
  IconMix icon(IconData value) {
    return merge(IconMix.icon(value));
  }

  /// Resolves to [IconSpec] using the provided [BuildContext].
  @override
  IconSpec resolve(BuildContext context) {
    return IconSpec(
      color: MixOps.resolve(context, $color),
      size: MixOps.resolve(context, $size),
      weight: MixOps.resolve(context, $weight),
      grade: MixOps.resolve(context, $grade),
      opticalSize: MixOps.resolve(context, $opticalSize),
      shadows: MixOps.resolveList(context, $shadows),
      textDirection: MixOps.resolve(context, $textDirection),
      applyTextScaling: MixOps.resolve(context, $applyTextScaling),
      fill: MixOps.resolve(context, $fill),
      semanticsLabel: MixOps.resolve(context, $semanticsLabel),
      opacity: MixOps.resolve(context, $opacity),
      blendMode: MixOps.resolve(context, $blendMode),
      icon: MixOps.resolve(context, $icon),
    );
  }

  /// Merges the properties of this [IconMix] with the properties of [other].
  @override
  IconMix merge(IconMix? other) {
    if (other == null) return this;

    return IconMix.create(
      color: MixOps.merge($color, other.$color),
      size: MixOps.merge($size, other.$size),
      weight: MixOps.merge($weight, other.$weight),
      grade: MixOps.merge($grade, other.$grade),
      opticalSize: MixOps.merge($opticalSize, other.$opticalSize),
      shadows: MixOps.mergeList($shadows, other.$shadows),
      textDirection: MixOps.merge($textDirection, other.$textDirection),
      applyTextScaling: MixOps.merge($applyTextScaling, other.$applyTextScaling),
      fill: MixOps.merge($fill, other.$fill),
      semanticsLabel: MixOps.merge($semanticsLabel, other.$semanticsLabel),
      opacity: MixOps.merge($opacity, other.$opacity),
      blendMode: MixOps.merge($blendMode, other.$blendMode),
      icon: MixOps.merge($icon, other.$icon),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('color', $color))
      ..add(DiagnosticsProperty('size', $size))
      ..add(DiagnosticsProperty('weight', $weight))
      ..add(DiagnosticsProperty('grade', $grade))
      ..add(DiagnosticsProperty('opticalSize', $opticalSize))
      ..add(DiagnosticsProperty('shadows', $shadows))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('applyTextScaling', $applyTextScaling))
      ..add(DiagnosticsProperty('fill', $fill))
      ..add(DiagnosticsProperty('semanticsLabel', $semanticsLabel))
      ..add(DiagnosticsProperty('opacity', $opacity))
      ..add(DiagnosticsProperty('blendMode', $blendMode))
      ..add(DiagnosticsProperty('icon', $icon));
  }

  @override
  List<Object?> get props => [
    $color,
    $size,
    $weight,
    $grade,
    $opticalSize,
    $shadows,
    $textDirection,
    $applyTextScaling,
    $fill,
    $semanticsLabel,
    $opacity,
    $blendMode,
    $icon,
  ];
}

/// Extension to provide toStyle() method for IconMix
extension IconMixToStyle on IconMix {
  /// Converts this IconMix to an IconStyle
  IconStyle toStyle() => IconStyle.from(this);
}