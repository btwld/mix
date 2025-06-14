// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mouse_cursor_modifier.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [MouseCursorDecoratorSpec].
mixin _$MouseCursorDecoratorSpec
    on WidgetModifierSpec<MouseCursorDecoratorSpec> {
  /// Creates a copy of this [MouseCursorDecoratorSpec] but with the given fields
  /// replaced with the new values.
  @override
  MouseCursorDecoratorSpec copyWith({
    MouseCursor? mouseCursor,
  }) {
    return MouseCursorDecoratorSpec(
      mouseCursor: mouseCursor ?? _$this.mouseCursor,
    );
  }

  /// Linearly interpolates between this [MouseCursorDecoratorSpec] and another [MouseCursorDecoratorSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [MouseCursorDecoratorSpec] is returned. When [t] is 1.0, the [other] [MouseCursorDecoratorSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [MouseCursorDecoratorSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [MouseCursorDecoratorSpec] instance.
  ///
  /// The interpolation is performed on each property of the [MouseCursorDecoratorSpec] using the appropriate
  /// interpolation method:
  /// For [mouseCursor], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [MouseCursorDecoratorSpec] is used. Otherwise, the value
  /// from the [other] [MouseCursorDecoratorSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [MouseCursorDecoratorSpec] configurations.
  @override
  MouseCursorDecoratorSpec lerp(MouseCursorDecoratorSpec? other, double t) {
    if (other == null) return _$this;

    return MouseCursorDecoratorSpec(
      mouseCursor: t < 0.5 ? _$this.mouseCursor : other.mouseCursor,
    );
  }

  /// The list of properties that constitute the state of this [MouseCursorDecoratorSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [MouseCursorDecoratorSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.mouseCursor,
      ];

  MouseCursorDecoratorSpec get _$this => this as MouseCursorDecoratorSpec;
}

/// Represents the attributes of a [MouseCursorDecoratorSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [MouseCursorDecoratorSpec].
///
/// Use this class to configure the attributes of a [MouseCursorDecoratorSpec] and pass it to
/// the [MouseCursorDecoratorSpec] constructor.
class MouseCursorDecoratorSpecAttribute
    extends WidgetModifierSpecAttribute<MouseCursorDecoratorSpec> {
  final MouseCursor? mouseCursor;

  const MouseCursorDecoratorSpecAttribute({
    this.mouseCursor,
  });

  /// Resolves to [MouseCursorDecoratorSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final mouseCursorDecoratorSpec = MouseCursorDecoratorSpecAttribute(...).resolve(mix);
  /// ```
  @override
  MouseCursorDecoratorSpec resolve(MixData mix) {
    return MouseCursorDecoratorSpec(
      mouseCursor: mouseCursor,
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
      MouseCursorDecoratorSpecAttribute? other) {
    if (other == null) return this;

    return MouseCursorDecoratorSpecAttribute(
      mouseCursor: other.mouseCursor ?? mouseCursor,
    );
  }

  /// The list of properties that constitute the state of this [MouseCursorDecoratorSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [MouseCursorDecoratorSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        mouseCursor,
      ];
}

/// A tween that interpolates between two [MouseCursorDecoratorSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [MouseCursorDecoratorSpec] specifications.
class MouseCursorDecoratorSpecTween extends Tween<MouseCursorDecoratorSpec?> {
  MouseCursorDecoratorSpecTween({
    super.begin,
    super.end,
  });

  @override
  MouseCursorDecoratorSpec lerp(double t) {
    if (begin == null && end == null) {
      return const MouseCursorDecoratorSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
