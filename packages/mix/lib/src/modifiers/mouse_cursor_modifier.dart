import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

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

class MouseCursorModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, MouseCursorModifierMix> {
  const MouseCursorModifierUtility(super.utilityBuilder);
  T call(MouseCursor? mouseCursor) {
    return utilityBuilder(MouseCursorModifierMix(mouseCursor: mouseCursor));
  }

  T defer() => call(.defer);
  T uncontrolled() => call(.uncontrolled);

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
