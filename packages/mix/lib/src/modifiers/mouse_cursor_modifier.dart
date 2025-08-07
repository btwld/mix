import 'package:flutter/material.dart';

import '../core/helpers.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../core/widget_modifier.dart';

class MouseCursorModifier extends WidgetModifier<MouseCursorModifier> {
  final MouseCursor? mouseCursor;

  const MouseCursorModifier({this.mouseCursor});

  /// Creates a copy of this [MouseCursorModifier] but with the given fields
  /// replaced with the new values.
  @override
  MouseCursorModifier copyWith({MouseCursor? mouseCursor}) {
    return MouseCursorModifier(mouseCursor: mouseCursor ?? this.mouseCursor);
  }

  /// Linearly interpolates between this [MouseCursorModifier] and another [MouseCursorModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [MouseCursorModifier] is returned. When [t] is 1.0, the [other] [MouseCursorModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [MouseCursorModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [MouseCursorModifier] instance.
  ///
  /// The interpolation is performed on each property of the [MouseCursorModifier] using the appropriate
  /// interpolation method:
  /// For [mouseCursor], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [MouseCursorModifier] is used. Otherwise, the value
  /// from the [other] [MouseCursorModifier] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [MouseCursorModifier] configurations.
  @override
  MouseCursorModifier lerp(MouseCursorModifier? other, double t) {
    if (other == null) return this;

    return MouseCursorModifier(
      mouseCursor: MixOps.lerpSnap(mouseCursor, other.mouseCursor, t),
    );
  }

  /// The list of properties that constitute the state of this [MouseCursorModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [MouseCursorModifier] instances for equality.
  @override
  List<Object?> get props => [mouseCursor];

  @override
  Widget build(Widget child) {
    return MouseRegion(cursor: mouseCursor ?? MouseCursor.defer, child: child);
  }
}

/// Represents the attributes of a [MouseCursorModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [MouseCursorModifier].
///
/// Use this class to configure the attributes of a [MouseCursorModifier] and pass it to
/// the [MouseCursorModifier] constructor.
class MouseCursorModifierMix extends WidgetModifierMix<MouseCursorModifier> {
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
      mouseCursor: mouseCursor.tryMerge(other.mouseCursor),
    );
  }

  /// The list of properties that constitute the state of this [MouseCursorModifierMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [MouseCursorModifierMix] instances for equality.
  @override
  List<Object?> get props => [mouseCursor];
}

class MouseCursorWidgetModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, MouseCursorModifierMix> {
  const MouseCursorWidgetModifierUtility(super.builder);
  T call(MouseCursor? mouseCursor) {
    return builder(MouseCursorModifierMix(mouseCursor: mouseCursor));
  }

  T defer() => call(MouseCursor.defer);
  T uncontrolled() => call(MouseCursor.uncontrolled);

  T none() => call(SystemMouseCursors.none);

  T basic() => call(SystemMouseCursors.basic);

  T click() => call(SystemMouseCursors.click);

  T forbidden() => call(SystemMouseCursors.forbidden);

  T wait() => call(SystemMouseCursors.wait);

  T progress() => call(SystemMouseCursors.progress);

  T contextMenu() => call(SystemMouseCursors.contextMenu);

  T help() => call(SystemMouseCursors.help);

  T text() => call(SystemMouseCursors.text);

  T verticalText() => call(SystemMouseCursors.verticalText);

  T cell() => call(SystemMouseCursors.cell);

  T precise() => call(SystemMouseCursors.precise);

  T move() => call(SystemMouseCursors.move);

  T grab() => call(SystemMouseCursors.grab);

  T grabbing() => call(SystemMouseCursors.grabbing);

  T noDrop() => call(SystemMouseCursors.noDrop);

  T alias() => call(SystemMouseCursors.alias);

  T copy() => call(SystemMouseCursors.copy);
  T disappearing() => call(SystemMouseCursors.disappearing);

  T allScroll() => call(SystemMouseCursors.allScroll);

  T resizeLeftRight() => call(SystemMouseCursors.resizeLeftRight);

  T resizeUpDown() => call(SystemMouseCursors.resizeUpDown);

  T resizeUpLeftDownRight() => call(SystemMouseCursors.resizeUpLeftDownRight);

  T resizeUpRightDownLeft() => call(SystemMouseCursors.resizeUpRightDownLeft);

  T resizeUp() => call(SystemMouseCursors.resizeUp);

  T resizeDown() => call(SystemMouseCursors.resizeDown);

  T resizeLeft() => call(SystemMouseCursors.resizeLeft);

  T resizeRight() => call(SystemMouseCursors.resizeRight);

  T resizeUpLeft() => call(SystemMouseCursors.resizeUpLeft);

  T resizeUpRight() => call(SystemMouseCursors.resizeUpRight);

  T resizeDownLeft() => call(SystemMouseCursors.resizeDownLeft);

  T resizeDownRight() => call(SystemMouseCursors.resizeDownRight);

  T resizeColumn() => call(SystemMouseCursors.resizeColumn);

  T resizeRow() => call(SystemMouseCursors.resizeRow);

  T zoomIn() => call(SystemMouseCursors.zoomIn);

  T zoomOut() => call(SystemMouseCursors.zoomOut);
}
