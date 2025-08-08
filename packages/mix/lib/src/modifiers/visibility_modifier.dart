import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';

/// A modifier that wraps a widget with the [Visibility] widget.
///
/// Controls whether a child widget is visible or hidden while maintaining
/// its space in the layout.
final class VisibilityWidgetModifier
    extends WidgetModifier<VisibilityWidgetModifier>
    with Diagnosticable {
  /// Whether the child widget should be visible.
  final bool visible;
  const VisibilityWidgetModifier([bool? visible]) : visible = visible ?? true;

  /// Creates a copy of this [VisibilityWidgetModifier] with the given fields replaced.
  @override
  VisibilityWidgetModifier copyWith({bool? visible}) {
    return VisibilityWidgetModifier(visible ?? this.visible);
  }

  /// Linearly interpolates between this [VisibilityWidgetModifier] and [other].
  ///
  /// Uses a step function for [visible] property - values below 0.5 use this
  /// instance's value, otherwise uses [other]'s value.
  ///
  /// This method is typically used in animations to transition between
  /// different [VisibilityWidgetModifier] configurations.
  @override
  VisibilityWidgetModifier lerp(VisibilityWidgetModifier? other, double t) {
    if (other == null) return this;

    return VisibilityWidgetModifier(MixOps.lerpSnap(visible, other.visible, t));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('visible', visible, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [VisibilityWidgetModifier].
  @override
  List<Object?> get props => [visible];

  @override
  Widget build(Widget child) {
    return Visibility(visible: visible, child: child);
  }
}

/// Represents the attributes of a [VisibilityWidgetModifier].
///
/// This class encapsulates properties defining the visibility behavior
/// of a [VisibilityWidgetModifier].
class VisibilityWidgetModifierMix
    extends WidgetModifierMix<VisibilityWidgetModifier>
    with Diagnosticable {
  /// Whether the child widget should be visible.
  final Prop<bool>? visible;

  const VisibilityWidgetModifierMix.create({this.visible});

  VisibilityWidgetModifierMix({bool? visible})
    : this.create(visible: Prop.maybe(visible));

  /// Resolves to [VisibilityWidgetModifier] using the provided [BuildContext].
  ///
  /// ```dart
  /// final visibilityModifier = VisibilityWidgetModifierMix(...).resolve(context);
  /// ```
  @override
  VisibilityWidgetModifier resolve(BuildContext context) {
    return VisibilityWidgetModifier(visible?.resolveProp(context));
  }

  /// Merges the properties of this [VisibilityWidgetModifierMix] with [other].
  ///
  /// Properties from [other] take precedence over the corresponding properties
  /// of this instance. Returns this instance unchanged if [other] is null.
  @override
  VisibilityWidgetModifierMix merge(VisibilityWidgetModifierMix? other) {
    if (other == null) return this;

    return VisibilityWidgetModifierMix.create(
      visible: visible?.mergeProp(other.visible) ?? other.visible,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('visible', visible, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [VisibilityWidgetModifierMix].
  @override
  List<Object?> get props => [visible];
}

/// Utility class for configuring [VisibilityWidgetModifier] properties.
///
/// This class provides methods to set the visibility state of a [VisibilityWidgetModifier].
final class VisibilityWidgetModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, VisibilityWidgetModifierMix> {
  const VisibilityWidgetModifierUtility(super.builder);

  /// Sets the visibility to true.
  T on() => call(true);

  /// Sets the visibility to false.
  T off() => call(false);

  /// Creates a [VisibilityWidgetModifierMix] with the specified visibility state.
  T call(bool value) =>
      builder(VisibilityWidgetModifierMix.create(visible: Prop.value(value)));

  /// Creates a [VisibilityWidgetModifierMix] with the specified visibility token.
  T token(MixToken<bool> token) =>
      builder(VisibilityWidgetModifierMix.create(visible: Prop.token(token)));
}
