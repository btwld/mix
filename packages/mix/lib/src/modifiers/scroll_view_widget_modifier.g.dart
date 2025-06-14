// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scroll_view_widget_modifier.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [ScrollViewModifierSpec].
mixin _$ScrollViewModifierSpec on WidgetModifierSpec<ScrollViewModifierSpec> {
  /// Creates a copy of this [ScrollViewModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  ScrollViewModifierSpec copyWith({
    Axis? scrollDirection,
    bool? reverse,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    Clip? clipBehavior,
  }) {
    return ScrollViewModifierSpec(
      scrollDirection: scrollDirection ?? _$this.scrollDirection,
      reverse: reverse ?? _$this.reverse,
      padding: padding ?? _$this.padding,
      physics: physics ?? _$this.physics,
      clipBehavior: clipBehavior ?? _$this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [ScrollViewModifierSpec] and another [ScrollViewModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ScrollViewModifierSpec] is returned. When [t] is 1.0, the [other] [ScrollViewModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ScrollViewModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ScrollViewModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ScrollViewModifierSpec] using the appropriate
  /// interpolation method:
  /// - [EdgeInsetsGeometry.lerp] for [padding].
  /// For [scrollDirection] and [reverse] and [physics] and [clipBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ScrollViewModifierSpec] is used. Otherwise, the value
  /// from the [other] [ScrollViewModifierSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ScrollViewModifierSpec] configurations.
  @override
  ScrollViewModifierSpec lerp(ScrollViewModifierSpec? other, double t) {
    if (other == null) return _$this;

    return ScrollViewModifierSpec(
      scrollDirection: t < 0.5 ? _$this.scrollDirection : other.scrollDirection,
      reverse: t < 0.5 ? _$this.reverse : other.reverse,
      padding: EdgeInsetsGeometry.lerp(_$this.padding, other.padding, t),
      physics: t < 0.5 ? _$this.physics : other.physics,
      clipBehavior: t < 0.5 ? _$this.clipBehavior : other.clipBehavior,
    );
  }

  /// The list of properties that constitute the state of this [ScrollViewModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ScrollViewModifierSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.scrollDirection,
        _$this.reverse,
        _$this.padding,
        _$this.physics,
        _$this.clipBehavior,
      ];

  ScrollViewModifierSpec get _$this => this as ScrollViewModifierSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty(
        'scrollDirection', _$this.scrollDirection,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('reverse', _$this.reverse, defaultValue: null));
    properties.add(
        DiagnosticsProperty('padding', _$this.padding, defaultValue: null));
    properties.add(
        DiagnosticsProperty('physics', _$this.physics, defaultValue: null));
    properties.add(DiagnosticsProperty('clipBehavior', _$this.clipBehavior,
        defaultValue: null));
  }
}

/// Represents the attributes of a [ScrollViewModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ScrollViewModifierSpec].
///
/// Use this class to configure the attributes of a [ScrollViewModifierSpec] and pass it to
/// the [ScrollViewModifierSpec] constructor.
class ScrollViewModifierSpecAttribute
    extends WidgetModifierSpecAttribute<ScrollViewModifierSpec>
    with Diagnosticable {
  final Axis? scrollDirection;
  final bool? reverse;
  final EdgeInsetsGeometryDto? padding;
  final ScrollPhysics? physics;
  final Clip? clipBehavior;

  const ScrollViewModifierSpecAttribute({
    this.scrollDirection,
    this.reverse,
    this.padding,
    this.physics,
    this.clipBehavior,
  });

  /// Resolves to [ScrollViewModifierSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final scrollViewModifierSpec = ScrollViewModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  ScrollViewModifierSpec resolve(MixData mix) {
    return ScrollViewModifierSpec(
      scrollDirection: scrollDirection,
      reverse: reverse,
      padding: padding?.resolve(mix),
      physics: physics,
      clipBehavior: clipBehavior,
    );
  }

  /// Merges the properties of this [ScrollViewModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ScrollViewModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ScrollViewModifierSpecAttribute merge(
      ScrollViewModifierSpecAttribute? other) {
    if (other == null) return this;

    return ScrollViewModifierSpecAttribute(
      scrollDirection: other.scrollDirection ?? scrollDirection,
      reverse: other.reverse ?? reverse,
      padding: EdgeInsetsGeometryDto.tryToMerge(padding, other.padding),
      physics: other.physics ?? physics,
      clipBehavior: other.clipBehavior ?? clipBehavior,
    );
  }

  /// The list of properties that constitute the state of this [ScrollViewModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ScrollViewModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        scrollDirection,
        reverse,
        padding,
        physics,
        clipBehavior,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('scrollDirection', scrollDirection,
        defaultValue: null));
    properties.add(DiagnosticsProperty('reverse', reverse, defaultValue: null));
    properties.add(DiagnosticsProperty('padding', padding, defaultValue: null));
    properties.add(DiagnosticsProperty('physics', physics, defaultValue: null));
    properties.add(
        DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null));
  }
}

/// A tween that interpolates between two [ScrollViewModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [ScrollViewModifierSpec] specifications.
class ScrollViewModifierSpecTween extends Tween<ScrollViewModifierSpec?> {
  ScrollViewModifierSpecTween({
    super.begin,
    super.end,
  });

  @override
  ScrollViewModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return ScrollViewModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
