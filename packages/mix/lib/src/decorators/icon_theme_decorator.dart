import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../core/widget_decorator.dart';
import '../properties/painting/shadow_mix.dart';

/// A decorator that wraps a widget with the [IconTheme] widget.
///
/// The [IconTheme] widget is used to provide default icon properties to descendant
/// [Icon] widgets. This modifier allows setting default color, size, opacity, and
/// other icon properties that will be inherited by child icons.
final class IconThemeWidgetDecorator
    extends WidgetDecorator<IconThemeWidgetDecorator>
    with Diagnosticable {
  final IconThemeData data;

  const IconThemeWidgetDecorator({required this.data});

  /// Creates a copy of this [IconThemeWidgetDecorator] but with the given fields
  /// replaced with the new values.
  @override
  IconThemeWidgetDecorator copyWith({IconThemeData? data}) {
    return IconThemeWidgetDecorator(data: data ?? this.data);
  }

  /// Linearly interpolates between this [IconThemeWidgetDecorator] and [other].
  ///
  /// The interpolation is performed on each property individually using the
  /// appropriate lerp function for that property type.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [IconThemeWidgetDecorator] configurations.
  @override
  IconThemeWidgetDecorator lerp(IconThemeWidgetDecorator? other, double t) {
    if (other == null) return this;

    return IconThemeWidgetDecorator(
      data: IconThemeData.lerp(data, other.data, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('data', data));
  }

  /// The list of properties that constitute the state of this [IconThemeWidgetDecorator].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IconThemeWidgetDecorator] instances for equality.
  @override
  List<Object?> get props => [data];

  @override
  Widget build(Widget child) {
    return IconTheme(data: data, child: child);
  }
}

/// Represents the attributes of a [IconThemeWidgetDecorator].
///
/// This class encapsulates properties defining the default icon theme
/// properties that will be applied to descendant [Icon] widgets.
///
/// Use this class to configure the attributes of a [IconThemeWidgetDecorator] and pass it to
/// the [IconThemeWidgetDecorator] constructor.
class IconThemeWidgetDecoratorMix
    extends WidgetDecoratorMix<IconThemeWidgetDecorator> {
  final Prop<Color>? color;
  final Prop<double>? size;
  final Prop<double>? fill;
  final Prop<double>? weight;
  final Prop<double>? grade;
  final Prop<double>? opticalSize;
  final Prop<double>? opacity;
  final List<MixProp<Shadow>>? shadows;
  final Prop<bool>? applyTextScaling;

  const IconThemeWidgetDecoratorMix.raw({
    this.color,
    this.size,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
    this.opacity,
    this.shadows,
    this.applyTextScaling,
  });

  IconThemeWidgetDecoratorMix({
    Color? color,
    double? size,
    double? fill,
    double? weight,
    double? grade,
    double? opticalSize,
    double? opacity,
    List<ShadowMix>? shadows,
    bool? applyTextScaling,
  }) : this.raw(
         color: Prop.maybe(color),
         size: Prop.maybe(size),
         fill: Prop.maybe(fill),
         weight: Prop.maybe(weight),
         grade: Prop.maybe(grade),
         opticalSize: Prop.maybe(opticalSize),
         opacity: Prop.maybe(opacity),
         shadows: shadows?.map(MixProp.new).toList(),
         applyTextScaling: Prop.maybe(applyTextScaling),
       );

  /// Resolves to [IconThemeWidgetDecorator] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final iconThemeModifier = IconThemeWidgetDecoratorMix(...).resolve(context);
  /// ```
  @override
  IconThemeWidgetDecorator resolve(BuildContext context) {
    return IconThemeWidgetDecorator(
      data: IconThemeData(
        size: MixHelpers.resolve(context, size),
        fill: MixHelpers.resolve(context, fill),
        weight: MixHelpers.resolve(context, weight),
        grade: MixHelpers.resolve(context, grade),
        opticalSize: MixHelpers.resolve(context, opticalSize),
        color: MixHelpers.resolve(context, color),
        opacity: MixHelpers.resolve(context, opacity),
        shadows: MixHelpers.resolveList(context, shadows),
        applyTextScaling: MixHelpers.resolve(context, applyTextScaling),
      ),
    );
  }

  /// Merges the properties of this [IconThemeWidgetDecoratorMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [IconThemeWidgetDecoratorMix] with the properties of [other] taking precedence over
  /// the properties of this instance.
  ///
  /// This method is typically used when combining or overriding icon theme modifier attributes.
  @override
  IconThemeWidgetDecoratorMix merge(IconThemeWidgetDecoratorMix? other) {
    if (other == null) return this;

    return IconThemeWidgetDecoratorMix.raw(
      color: color.tryMerge(other.color),
      size: size.tryMerge(other.size),
      fill: fill.tryMerge(other.fill),
      weight: weight.tryMerge(other.weight),
      grade: grade.tryMerge(other.grade),
      opticalSize: opticalSize.tryMerge(other.opticalSize),
      opacity: opacity.tryMerge(other.opacity),
      shadows: shadows.tryMerge(other.shadows),
      applyTextScaling: applyTextScaling.tryMerge(other.applyTextScaling),
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

/// Utility class for configuring [IconThemeWidgetDecorator] properties.
///
/// This class provides methods to set individual properties of a [IconThemeWidgetDecorator].
/// Use the methods of this class to configure specific properties of a [IconThemeWidgetDecorator].
final class IconThemeWidgetDecoratorUtility<T extends Style<Object?>>
    extends MixUtility<T, IconThemeWidgetDecoratorMix> {
  const IconThemeWidgetDecoratorUtility(super.builder);

  /// Creates an [IconThemeWidgetDecoratorMix] with the specified properties.
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
    return builder(
      IconThemeWidgetDecoratorMix(
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
