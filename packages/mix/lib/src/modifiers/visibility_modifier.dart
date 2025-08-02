import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';

/// A modifier that wraps a widget with the [Visibility] widget.
///
/// Controls whether a child widget is visible or hidden while maintaining
/// its space in the layout.
final class VisibilityModifier extends Modifier<VisibilityModifier>
    with Diagnosticable {
  /// Whether the child widget should be visible.
  final bool visible;
  const VisibilityModifier([bool? visible]) : visible = visible ?? true;

  /// Creates a copy of this [VisibilityModifier] with the given fields replaced.
  @override
  VisibilityModifier copyWith({bool? visible}) {
    return VisibilityModifier(visible ?? this.visible);
  }

  /// Linearly interpolates between this [VisibilityModifier] and [other].
  ///
  /// Uses a step function for [visible] property - values below 0.5 use this
  /// instance's value, otherwise uses [other]'s value.
  ///
  /// This method is typically used in animations to transition between
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
  @override
  List<Object?> get props => [visible];

  @override
  Widget build(Widget child) {
    return Visibility(visible: visible, child: child);
  }
}

/// Represents the attributes of a [VisibilityModifier].
///
/// This class encapsulates properties defining the visibility behavior
/// of a [VisibilityModifier].
class VisibilityModifierAttribute extends ModifierAttribute<VisibilityModifier>
    with Diagnosticable {
  /// Whether the child widget should be visible.
  final Prop<bool>? visible;

  const VisibilityModifierAttribute.raw({this.visible});

  VisibilityModifierAttribute({bool? visible})
    : this.raw(visible: Prop.maybe(visible));

  /// Resolves to [VisibilityModifier] using the provided [BuildContext].
  ///
  /// ```dart
  /// final visibilityModifier = VisibilityModifierAttribute(...).resolve(context);
  /// ```
  @override
  VisibilityModifier resolve(BuildContext context) {
    return VisibilityModifier(visible?.resolve(context));
  }

  /// Merges the properties of this [VisibilityModifierAttribute] with [other].
  ///
  /// Properties from [other] take precedence over the corresponding properties
  /// of this instance. Returns this instance unchanged if [other] is null.
  @override
  VisibilityModifierAttribute merge(VisibilityModifierAttribute? other) {
    if (other == null) return this;

    return VisibilityModifierAttribute.raw(
      visible: visible?.merge(other.visible) ?? other.visible,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('visible', visible, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [VisibilityModifierAttribute].
  @override
  List<Object?> get props => [visible];
}

/// Utility class for configuring [VisibilityModifier] properties.
///
/// This class provides methods to set the visibility state of a [VisibilityModifier].
final class VisibilityModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, VisibilityModifierAttribute> {
  const VisibilityModifierUtility(super.builder);

  /// Sets the visibility to true.
  T on() => call(true);

  /// Sets the visibility to false.
  T off() => call(false);

  /// Creates a [VisibilityModifierAttribute] with the specified visibility state.
  T call(bool value) =>
      builder(VisibilityModifierAttribute.raw(visible: Prop(value)));

  /// Creates a [VisibilityModifierAttribute] with the specified visibility token.
  T token(MixToken<bool> token) =>
      builder(VisibilityModifierAttribute.raw(visible: Prop.token(token)));
}
