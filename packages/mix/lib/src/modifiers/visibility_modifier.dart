// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';

final class VisibilityModifier extends Modifier<VisibilityModifier>
    with Diagnosticable {
  final bool visible;
  const VisibilityModifier([bool? visible]) : visible = visible ?? true;

  /// Creates a copy of this [VisibilityModifier] but with the given fields
  /// replaced with the new values.
  @override
  VisibilityModifier copyWith({bool? visible}) {
    return VisibilityModifier(visible ?? this.visible);
  }

  /// Linearly interpolates between this [VisibilityModifier] and another [VisibilityModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [VisibilityModifier] is returned. When [t] is 1.0, the [other] [VisibilityModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [VisibilityModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [VisibilityModifier] instance.
  ///
  /// The interpolation is performed on each property of the [VisibilityModifier] using the appropriate
  /// interpolation method:
  /// For [visible], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [VisibilityModifier] is used. Otherwise, the value
  /// from the [other] [VisibilityModifier] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [VisibilityModifier] configurations.
  @override
  VisibilityModifier lerp(VisibilityModifier? other, double t) {
    if (other == null) return this;

    return VisibilityModifier(t < 0.5 ? visible : other.visible);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('visible', visible, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [VisibilityModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [VisibilityModifier] instances for equality.
  @override
  List<Object?> get props => [visible];

  @override
  Widget build(Widget child) {
    return Visibility(visible: visible, child: child);
  }
}

/// Represents the attributes of a [VisibilityModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [VisibilityModifier].
///
/// Use this class to configure the attributes of a [VisibilityModifier] and pass it to
/// the [VisibilityModifier] constructor.
class VisibilityModifierAttribute extends ModifierAttribute<VisibilityModifier>
    with Diagnosticable {
  final Prop<bool>? visible;

  const VisibilityModifierAttribute({this.visible});

  VisibilityModifierAttribute.only({bool? visible})
    : this(visible: Prop.maybe(visible));

  /// Resolves to [VisibilityModifier] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final visibilityModifierSpec = VisibilityModifierAttribute(...).resolve(mix);
  /// ```
  @override
  VisibilityModifier resolve(BuildContext context) {
    return VisibilityModifier(visible?.resolve(context));
  }

  /// Merges the properties of this [VisibilityModifierAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [VisibilityModifierAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  VisibilityModifierAttribute merge(VisibilityModifierAttribute? other) {
    if (other == null) return this;

    return VisibilityModifierAttribute(
      visible: visible?.merge(other.visible) ?? other.visible,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('visible', visible, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [VisibilityModifierAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [VisibilityModifierAttribute] instances for equality.
  @override
  List<Object?> get props => [visible];
}

final class VisibilityModifierUtility<T extends SpecStyle<Object?>>
    extends MixUtility<T, VisibilityModifierAttribute> {
  const VisibilityModifierUtility(super.builder);
  T on() => call(true);
  T off() => call(false);

  T call(bool value) =>
      builder(VisibilityModifierAttribute(visible: Prop(value)));

  T token(MixToken<bool> token) =>
      builder(VisibilityModifierAttribute(visible: Prop.token(token)));
}
