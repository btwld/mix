// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spinner.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [SpinnerSpec].
mixin _$SpinnerSpec on Spec<SpinnerSpec> {
  static SpinnerSpec from(MixData mix) {
    return mix.attributeOf<SpinnerSpecAttribute>()?.resolve(mix) ??
        const SpinnerSpec();
  }

  /// {@template spinner_spec_of}
  /// Retrieves the [SpinnerSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [SpinnerSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [SpinnerSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final spinnerSpec = SpinnerSpec.of(context);
  /// ```
  /// {@endtemplate}
  static SpinnerSpec of(BuildContext context) {
    return _$SpinnerSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [SpinnerSpec] but with the given fields
  /// replaced with the new values.
  @override
  SpinnerSpec copyWith({
    double? size,
    double? strokeWidth,
    Color? color,
    Duration? duration,
    SpinnerTypeStyle? style,
    WidgetModifiersData? modifiers,
    AnimatedData? animated,
  }) {
    return SpinnerSpec(
      size: size ?? _$this.size,
      strokeWidth: strokeWidth ?? _$this.strokeWidth,
      color: color ?? _$this.color,
      duration: duration ?? _$this.duration,
      style: style ?? _$this.style,
      modifiers: modifiers ?? _$this.modifiers,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [SpinnerSpec] and another [SpinnerSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [SpinnerSpec] is returned. When [t] is 1.0, the [other] [SpinnerSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [SpinnerSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [SpinnerSpec] instance.
  ///
  /// The interpolation is performed on each property of the [SpinnerSpec] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpDouble] for [size] and [strokeWidth].
  /// - [Color.lerp] for [color].
  /// For [duration] and [style] and [modifiers] and [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [SpinnerSpec] is used. Otherwise, the value
  /// from the [other] [SpinnerSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [SpinnerSpec] configurations.
  @override
  SpinnerSpec lerp(SpinnerSpec? other, double t) {
    if (other == null) return _$this;

    return SpinnerSpec(
      size: MixHelpers.lerpDouble(_$this.size, other.size, t)!,
      strokeWidth:
          MixHelpers.lerpDouble(_$this.strokeWidth, other.strokeWidth, t),
      color: Color.lerp(_$this.color, other.color, t)!,
      duration: t < 0.5 ? _$this.duration : other.duration,
      style: t < 0.5 ? _$this.style : other.style,
      modifiers: other.modifiers,
      animated: t < 0.5 ? _$this.animated : other.animated,
    );
  }

  /// The list of properties that constitute the state of this [SpinnerSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SpinnerSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.size,
        _$this.strokeWidth,
        _$this.color,
        _$this.duration,
        _$this.style,
        _$this.modifiers,
        _$this.animated,
      ];

  SpinnerSpec get _$this => this as SpinnerSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
        .add(DiagnosticsProperty('size', _$this.size, defaultValue: null));
    properties.add(DiagnosticsProperty('strokeWidth', _$this.strokeWidth,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty('color', _$this.color, defaultValue: null));
    properties.add(
        DiagnosticsProperty('duration', _$this.duration, defaultValue: null));
    properties
        .add(DiagnosticsProperty('style', _$this.style, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
  }
}

/// Represents the attributes of a [SpinnerSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [SpinnerSpec].
///
/// Use this class to configure the attributes of a [SpinnerSpec] and pass it to
/// the [SpinnerSpec] constructor.
class SpinnerSpecAttribute extends SpecAttribute<SpinnerSpec>
    with Diagnosticable {
  final double? size;
  final double? strokeWidth;
  final ColorDto? color;
  final Duration? duration;
  final SpinnerTypeStyle? style;

  const SpinnerSpecAttribute({
    this.size,
    this.strokeWidth,
    this.color,
    this.duration,
    this.style,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [SpinnerSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final spinnerSpec = SpinnerSpecAttribute(...).resolve(mix);
  /// ```
  @override
  SpinnerSpec resolve(MixData mix) {
    return SpinnerSpec(
      size: size,
      strokeWidth: strokeWidth,
      color: color?.resolve(mix),
      duration: duration,
      style: style,
      modifiers: modifiers?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [SpinnerSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [SpinnerSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  SpinnerSpecAttribute merge(SpinnerSpecAttribute? other) {
    if (other == null) return this;

    return SpinnerSpecAttribute(
      size: other.size ?? size,
      strokeWidth: other.strokeWidth ?? strokeWidth,
      color: color?.merge(other.color) ?? other.color,
      duration: other.duration ?? duration,
      style: other.style ?? style,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [SpinnerSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SpinnerSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        size,
        strokeWidth,
        color,
        duration,
        style,
        modifiers,
        animated,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('size', size, defaultValue: null));
    properties.add(
        DiagnosticsProperty('strokeWidth', strokeWidth, defaultValue: null));
    properties.add(DiagnosticsProperty('color', color, defaultValue: null));
    properties
        .add(DiagnosticsProperty('duration', duration, defaultValue: null));
    properties.add(DiagnosticsProperty('style', style, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
  }
}

/// Utility class for configuring [SpinnerSpec] properties.
///
/// This class provides methods to set individual properties of a [SpinnerSpec].
/// Use the methods of this class to configure specific properties of a [SpinnerSpec].
class SpinnerSpecUtility<T extends Attribute>
    extends SpecUtility<T, SpinnerSpecAttribute> {
  /// Utility for defining [SpinnerSpecAttribute.size]
  late final size = DoubleUtility((v) => only(size: v));

  /// Utility for defining [SpinnerSpecAttribute.strokeWidth]
  late final strokeWidth = DoubleUtility((v) => only(strokeWidth: v));

  /// Utility for defining [SpinnerSpecAttribute.color]
  late final color = ColorUtility((v) => only(color: v));

  /// Utility for defining [SpinnerSpecAttribute.duration]
  late final duration = DurationUtility((v) => only(duration: v));

  /// Utility for defining [SpinnerSpecAttribute.style]
  late final style = SpinnerTypeStyleUtility((v) => only(style: v));

  /// Utility for defining [SpinnerSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [SpinnerSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  SpinnerSpecUtility(super.builder, {super.mutable});

  SpinnerSpecUtility<T> get chain =>
      SpinnerSpecUtility(attributeBuilder, mutable: true);

  static SpinnerSpecUtility<SpinnerSpecAttribute> get self =>
      SpinnerSpecUtility((v) => v);

  /// Returns a new [SpinnerSpecAttribute] with the specified properties.
  @override
  T only({
    double? size,
    double? strokeWidth,
    ColorDto? color,
    Duration? duration,
    SpinnerTypeStyle? style,
    WidgetModifiersDataDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(SpinnerSpecAttribute(
      size: size,
      strokeWidth: strokeWidth,
      color: color,
      duration: duration,
      style: style,
      modifiers: modifiers,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [SpinnerSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [SpinnerSpec] specifications.
class SpinnerSpecTween extends Tween<SpinnerSpec?> {
  SpinnerSpecTween({
    super.begin,
    super.end,
  });

  @override
  SpinnerSpec lerp(double t) {
    if (begin == null && end == null) {
      return const SpinnerSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
