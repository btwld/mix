import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';

/// Modifier that applies a mouse cursor to its child.
///
/// Wraps the child in a [MouseRegion] widget with the specified cursor.
class MouseCursorModifier extends WidgetModifier<MouseCursorModifier>
    with Diagnosticable {
  final MouseCursor? mouseCursor;

  const MouseCursorModifier({this.mouseCursor});

  @override
  MouseCursorModifier copyWith({MouseCursor? mouseCursor}) {
    return MouseCursorModifier(mouseCursor: mouseCursor ?? this.mouseCursor);
  }

  @override
  MouseCursorModifier lerp(MouseCursorModifier? other, double t) {
    if (other == null) return this;

    return MouseCursorModifier(
      mouseCursor: MixOps.lerpSnap(mouseCursor, other.mouseCursor, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('mouseCursor', mouseCursor));
  }

  @override
  List<Object?> get props => [mouseCursor];

  @override
  Widget build(Widget child) {
    return MouseRegion(cursor: mouseCursor ?? .defer, child: child);
  }
}

/// Represents the attributes of a [MouseCursorModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [MouseCursorModifier].
///
/// Use this class to configure the attributes of a [MouseCursorModifier] and pass it to
/// the [MouseCursorModifier] constructor.
class MouseCursorModifierMix extends ModifierMix<MouseCursorModifier>
    with Diagnosticable {
  final Prop<MouseCursor>? mouseCursor;

  const MouseCursorModifierMix.create({this.mouseCursor});

  MouseCursorModifierMix({MouseCursor? mouseCursor})
    : this.create(mouseCursor: Prop.maybe(mouseCursor));

  /// Resolves to [MouseCursorModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final mouseCursorModifier = MouseCursorModifierMix(...).resolve(context);
  /// ```
  @override
  MouseCursorModifier resolve(BuildContext context) {
    return MouseCursorModifier(
      mouseCursor: MixOps.resolve(context, mouseCursor),
    );
  }

  /// Merges the properties of this [MouseCursorModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [MouseCursorModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  MouseCursorModifierMix merge(MouseCursorModifierMix? other) {
    if (other == null) return this;

    return MouseCursorModifierMix.create(
      mouseCursor: MixOps.merge(mouseCursor, other.mouseCursor),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('mouseCursor', mouseCursor));
  }

  /// The list of properties that constitute the state of this [MouseCursorModifierMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [MouseCursorModifierMix] instances for equality.
  @override
  List<Object?> get props => [mouseCursor];
}
