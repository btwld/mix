import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../core/widget_modifier.dart';
import '../properties/painting/icon_theme_mix.dart';
import '../properties/painting/shadow_mix.dart';

/// Modifier that applies icon theme data to its descendants.
///
/// Wraps the child in an [IconTheme] widget with the specified theme data.
final class IconThemeModifier extends WidgetModifier<IconThemeModifier>
    with Diagnosticable {
  final IconThemeData? data;

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
    return IconTheme(data: data ?? const IconThemeData(), child: child);
  }
}

/// Represents the attributes of a [IconThemeModifier].
///
/// This class encapsulates properties defining the default icon theme
/// properties that will be applied to descendant [Icon] widgets.
///
/// Use this class to configure the attributes of a [IconThemeModifier] and pass it to
/// the [IconThemeModifier] constructor.
class IconThemeModifierMix extends ModifierMix<IconThemeModifier> {
  final IconThemeDataMix? data;

  const IconThemeModifierMix.create({this.data});

  IconThemeModifierMix({IconThemeDataMix? data}) : this.create(data: data);

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
    return IconThemeModifier(data: data?.resolve(context));
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

    return IconThemeModifierMix.create(data: data?.merge(other.data));
  }

  @override
  List<Object?> get props => [data];
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
        data: IconThemeDataMix(
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
