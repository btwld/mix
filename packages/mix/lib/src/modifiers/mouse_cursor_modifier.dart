// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/material.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

class MouseCursorDecorator extends Modifier<MouseCursorDecorator> {
  final MouseCursor? mouseCursor;

  const MouseCursorDecorator({this.mouseCursor});

  /// Creates a copy of this [MouseCursorDecorator] but with the given fields
  /// replaced with the new values.
  @override
  MouseCursorDecorator copyWith({MouseCursor? mouseCursor}) {
    return MouseCursorDecorator(mouseCursor: mouseCursor ?? this.mouseCursor);
  }

  /// Linearly interpolates between this [MouseCursorDecorator] and another [MouseCursorDecorator] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [MouseCursorDecorator] is returned. When [t] is 1.0, the [other] [MouseCursorDecorator] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [MouseCursorDecorator] is returned.
  ///
  /// If [other] is null, this method returns the current [MouseCursorDecorator] instance.
  ///
  /// The interpolation is performed on each property of the [MouseCursorDecorator] using the appropriate
  /// interpolation method:
  /// For [mouseCursor], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [MouseCursorDecorator] is used. Otherwise, the value
  /// from the [other] [MouseCursorDecorator] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [MouseCursorDecorator] configurations.
  @override
  MouseCursorDecorator lerp(MouseCursorDecorator? other, double t) {
    if (other == null) return this;

    return MouseCursorDecorator(
      mouseCursor: t < 0.5 ? mouseCursor : other.mouseCursor,
    );
  }

  /// The list of properties that constitute the state of this [MouseCursorDecorator].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [MouseCursorDecorator] instances for equality.
  @override
  List<Object?> get props => [mouseCursor];

  @override
  Widget build(Widget child) {
    return MouseRegion(cursor: mouseCursor ?? MouseCursor.defer, child: child);
  }
}

/// Represents the attributes of a [MouseCursorDecorator].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [MouseCursorDecorator].
///
/// Use this class to configure the attributes of a [MouseCursorDecorator] and pass it to
/// the [MouseCursorDecorator] constructor.
class MouseCursorDecoratorSpecAttribute
    extends ModifierAttribute<MouseCursorDecorator> {
  final Prop<MouseCursor>? mouseCursor;

  const MouseCursorDecoratorSpecAttribute({this.mouseCursor});

  MouseCursorDecoratorSpecAttribute.only({MouseCursor? mouseCursor})
    : this(mouseCursor: Prop.maybe(mouseCursor));

  /// Resolves to [MouseCursorDecorator] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final mouseCursorDecoratorSpec = MouseCursorDecoratorSpecAttribute(...).resolve(mix);
  /// ```
  @override
  MouseCursorDecorator resolve(BuildContext context) {
    return MouseCursorDecorator(
      mouseCursor: MixHelpers.resolve(context, mouseCursor),
    );
  }

  /// Merges the properties of this [MouseCursorDecoratorSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [MouseCursorDecoratorSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  MouseCursorDecoratorSpecAttribute merge(
    MouseCursorDecoratorSpecAttribute? other,
  ) {
    if (other == null) return this;

    return MouseCursorDecoratorSpecAttribute(
      mouseCursor: MixHelpers.merge(mouseCursor, other.mouseCursor),
    );
  }

  /// The list of properties that constitute the state of this [MouseCursorDecoratorSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [MouseCursorDecoratorSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [mouseCursor];
}

class MouseCursorModifierUtility<T extends SpecStyle<Object?>>
    extends MixUtility<T, MouseCursorDecoratorSpecAttribute> {
  const MouseCursorModifierUtility(super.builder);
  T call(MouseCursor? mouseCursor) {
    return builder(
      MouseCursorDecoratorSpecAttribute(mouseCursor: Prop.maybe(mouseCursor)),
    );
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
