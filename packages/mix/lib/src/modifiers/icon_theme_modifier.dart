import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../properties/painting/shadow_mix.dart';

/// Modifier that applies icon theme data to its descendants.
///
/// Wraps the child in an [IconTheme] widget with the specified theme data.
final class IconThemeModifier extends WidgetModifier<IconThemeModifier>
    with Diagnosticable {
  final IconThemeData data;

  const IconThemeModifier({this.data = const IconThemeData()});

  @override
  IconThemeModifier copyWith({IconThemeData? data}) {
    return IconThemeModifier(data: data ?? this.data);
  }

  @override
  IconThemeModifier lerp(IconThemeModifier? other, double t) {
    if (other == null) return this;

    return IconThemeModifier(data: MixOps.lerp(data, other.data, t) ?? data);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('data', data));
  }

  /// The list of properties that constitute the state of this [IconThemeModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IconThemeModifier] instances for equality.
  @override
  List<Object?> get props => [data];

  @override
  Widget build(Widget child) {
    return IconTheme(data: data, child: child);
  }
}

/// Represents the attributes of a [IconThemeModifier].
///
/// This class encapsulates properties defining the default icon theme
/// properties that will be applied to descendant [Icon] widgets.
///
/// Use this class to configure the attributes of a [IconThemeModifier] and pass it to
/// the [IconThemeModifier] constructor.
class IconThemeModifierMix extends WidgetModifierMix<IconThemeModifier> {
  final Prop<Color>? color;
  final Prop<double>? size;
  final Prop<double>? fill;
  final Prop<double>? weight;
  final Prop<double>? grade;
  final Prop<double>? opticalSize;
  final Prop<double>? opacity;
  final List<Prop<Shadow>>? shadows;
  final Prop<bool>? applyTextScaling;

  const IconThemeModifierMix.create({
    this.color,
    this.size,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
    this.opacity,
    this.shadows,
    this.applyTextScaling,
  }) : super();

  IconThemeModifierMix({
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
         shadows: shadows?.map(Prop.mix).toList(),
         applyTextScaling: Prop.maybe(applyTextScaling),
       );

  /// Resolves to [IconThemeModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final iconThemeModifier = IconThemeModifierMix(...).resolve(context);
  /// ```
  @override
  IconThemeModifier resolve(BuildContext context) {
    return IconThemeModifier(
      data: IconThemeData(
        size: MixOps.resolve(context, size),
        fill: MixOps.resolve(context, fill),
        weight: MixOps.resolve(context, weight),
        grade: MixOps.resolve(context, grade),
        opticalSize: MixOps.resolve(context, opticalSize),
        color: MixOps.resolve(context, color),
        opacity: MixOps.resolve(context, opacity),
        shadows: MixOps.resolveList(context, shadows),
        applyTextScaling: MixOps.resolve(context, applyTextScaling),
      ),
    );
  }

  /// Merges the properties of this [IconThemeModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [IconThemeModifierMix] with the properties of [other] taking precedence over
  /// the properties of this instance.
  ///
  /// This method is typically used when combining or overriding icon theme modifier attributes.
  @override
  IconThemeModifierMix merge(IconThemeModifierMix? other) {
    if (other == null) return this;

    return IconThemeModifierMix.create(
      color: MixOps.merge(color, other.color),
      size: MixOps.merge(size, other.size),
      fill: MixOps.merge(fill, other.fill),
      weight: MixOps.merge(weight, other.weight),
      grade: MixOps.merge(grade, other.grade),
      opticalSize: MixOps.merge(opticalSize, other.opticalSize),
      opacity: MixOps.merge(opacity, other.opacity),
      shadows: MixOps.mergeList(shadows, other.shadows),
      applyTextScaling: MixOps.merge(applyTextScaling, other.applyTextScaling),
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

/// Utility class for configuring [IconThemeModifier] properties.
///
/// This class provides methods to set individual properties of a [IconThemeModifier].
/// Use the methods of this class to configure specific properties of a [IconThemeModifier].
final class IconThemeModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, IconThemeModifierMix> {
  const IconThemeModifierUtility(super.utilityBuilder);

  /// Creates an [IconThemeModifierMix] with the specified properties.
  T call({
    Color? color,
    double? size,
    double? fill,
    double? weight,
    double? grade,
    double? opticalSize,
    double? opacity,
    List<ShadowMix>? shadows,
    bool? applyTextScaling,
  }) {
    return utilityBuilder(
      IconThemeModifierMix(
        color: color,
        size: size,
        fill: fill,
        weight: weight,
        grade: grade,
        opticalSize: opticalSize,
        opacity: opacity,
        shadows: shadows,
        applyTextScaling: applyTextScaling,
      ),
    );
  }

  /// Sets the default icon color.
  T color(Color color) => call(color: color);

  /// Sets the default icon size.
  T size(double size) => call(size: size);

  /// Sets the default icon fill.
  T fill(double fill) => call(fill: fill);

  /// Sets the default icon weight.
  T weight(double weight) => call(weight: weight);

  /// Sets the default icon grade.
  T grade(double grade) => call(grade: grade);

  /// Sets the default icon optical size.
  T opticalSize(double opticalSize) => call(opticalSize: opticalSize);

  /// Sets the default icon opacity.
  T opacity(double opacity) => call(opacity: opacity);

  /// Sets the default icon shadows.
  T shadows(List<ShadowMix> shadows) => call(shadows: shadows);

  /// Sets the default icon text scaling behavior.
  T applyTextScaling(bool applyTextScaling) =>
      call(applyTextScaling: applyTextScaling);
}
