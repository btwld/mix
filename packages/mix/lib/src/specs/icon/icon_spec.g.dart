// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon_spec.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [IconSpec].
mixin _$IconSpec on Spec<IconSpec> {
  static IconSpec from(MixData mix) {
    return mix.attributeOf<IconSpecAttribute>()?.resolve(mix) ??
        const IconSpec();
  }

  /// {@template icon_spec_of}
  /// Retrieves the [IconSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [IconSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [IconSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final iconSpec = IconSpec.of(context);
  /// ```
  /// {@endtemplate}
  static IconSpec of(BuildContext context) {
    return ComputedStyle.specOf<IconSpec>(context) ?? const IconSpec();
  }

  /// Creates a copy of this [IconSpec] but with the given fields
  /// replaced with the new values.
  @override
  IconSpec copyWith({
    Color? color,
    double? size,
    double? weight,
    double? grade,
    double? opticalSize,
    List<Shadow>? shadows,
    TextDirection? textDirection,
    bool? applyTextScaling,
    double? fill,
    AnimatedData? animated,
    WidgetModifiersConfig? modifiers,
  }) {
    return IconSpec(
      color: color ?? _$this.color,
      size: size ?? _$this.size,
      weight: weight ?? _$this.weight,
      grade: grade ?? _$this.grade,
      opticalSize: opticalSize ?? _$this.opticalSize,
      shadows: shadows ?? _$this.shadows,
      textDirection: textDirection ?? _$this.textDirection,
      applyTextScaling: applyTextScaling ?? _$this.applyTextScaling,
      fill: fill ?? _$this.fill,
      animated: animated ?? _$this.animated,
      modifiers: modifiers ?? _$this.modifiers,
    );
  }

  /// Linearly interpolates between this [IconSpec] and another [IconSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [IconSpec] is returned. When [t] is 1.0, the [other] [IconSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [IconSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [IconSpec] instance.
  ///
  /// The interpolation is performed on each property of the [IconSpec] using the appropriate
  /// interpolation method:
  /// - [Color.lerp] for [color].
  /// - [MixHelpers.lerpDouble] for [size] and [weight] and [grade] and [opticalSize] and [fill].
  /// - [MixHelpers.lerpShadowList] for [shadows].
  /// For [textDirection] and [applyTextScaling] and [animated] and [modifiers], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [IconSpec] is used. Otherwise, the value
  /// from the [other] [IconSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [IconSpec] configurations.
  @override
  IconSpec lerp(IconSpec? other, double t) {
    if (other == null) return _$this;

    return IconSpec(
      color: Color.lerp(_$this.color, other.color, t),
      size: MixHelpers.lerpDouble(_$this.size, other.size, t),
      weight: MixHelpers.lerpDouble(_$this.weight, other.weight, t),
      grade: MixHelpers.lerpDouble(_$this.grade, other.grade, t),
      opticalSize:
          MixHelpers.lerpDouble(_$this.opticalSize, other.opticalSize, t),
      shadows: MixHelpers.lerpShadowList(_$this.shadows, other.shadows, t),
      textDirection: t < 0.5 ? _$this.textDirection : other.textDirection,
      applyTextScaling:
          t < 0.5 ? _$this.applyTextScaling : other.applyTextScaling,
      fill: MixHelpers.lerpDouble(_$this.fill, other.fill, t),
      animated: _$this.animated ?? other.animated,
      modifiers: other.modifiers,
    );
  }

  /// The list of properties that constitute the state of this [IconSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IconSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.color,
        _$this.size,
        _$this.weight,
        _$this.grade,
        _$this.opticalSize,
        _$this.shadows,
        _$this.textDirection,
        _$this.applyTextScaling,
        _$this.fill,
        _$this.animated,
        _$this.modifiers,
      ];

  IconSpec get _$this => this as IconSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
        .add(DiagnosticsProperty('color', _$this.color, defaultValue: null));
    properties
        .add(DiagnosticsProperty('size', _$this.size, defaultValue: null));
    properties
        .add(DiagnosticsProperty('weight', _$this.weight, defaultValue: null));
    properties
        .add(DiagnosticsProperty('grade', _$this.grade, defaultValue: null));
    properties.add(DiagnosticsProperty('opticalSize', _$this.opticalSize,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('shadows', _$this.shadows, defaultValue: null));
    properties.add(DiagnosticsProperty('textDirection', _$this.textDirection,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'applyTextScaling', _$this.applyTextScaling,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty('fill', _$this.fill, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
  }
}

/// Represents the attributes of a [IconSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [IconSpec].
///
/// Use this class to configure the attributes of a [IconSpec] and pass it to
/// the [IconSpec] constructor.
class IconSpecAttribute extends SpecAttribute<IconSpec> with Diagnosticable {
  final ColorDto? color;
  final double? size;
  final double? weight;
  final double? grade;
  final double? opticalSize;
  final List<ShadowDto>? shadows;
  final TextDirection? textDirection;
  final bool? applyTextScaling;
  final double? fill;

  const IconSpecAttribute({
    this.color,
    this.size,
    this.weight,
    this.grade,
    this.opticalSize,
    this.shadows,
    this.textDirection,
    this.applyTextScaling,
    this.fill,
    super.animated,
    super.modifiers,
  });

  /// Resolves to [IconSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final iconSpec = IconSpecAttribute(...).resolve(mix);
  /// ```
  @override
  IconSpec resolve(MixData mix) {
    return IconSpec(
      color: color?.resolve(mix),
      size: size,
      weight: weight,
      grade: grade,
      opticalSize: opticalSize,
      shadows: shadows?.map((e) => e.resolve(mix)).toList(),
      textDirection: textDirection,
      applyTextScaling: applyTextScaling,
      fill: fill,
      animated: animated?.resolve(mix) ?? mix.animation,
      modifiers: modifiers?.resolve(mix),
    );
  }

  /// Merges the properties of this [IconSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [IconSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  IconSpecAttribute merge(IconSpecAttribute? other) {
    if (other == null) return this;

    return IconSpecAttribute(
      color: color?.merge(other.color) ?? other.color,
      size: other.size ?? size,
      weight: other.weight ?? weight,
      grade: other.grade ?? grade,
      opticalSize: other.opticalSize ?? opticalSize,
      shadows: MixHelpers.mergeList(shadows, other.shadows),
      textDirection: other.textDirection ?? textDirection,
      applyTextScaling: other.applyTextScaling ?? applyTextScaling,
      fill: other.fill ?? fill,
      animated: animated?.merge(other.animated) ?? other.animated,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
    );
  }

  /// The list of properties that constitute the state of this [IconSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IconSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        color,
        size,
        weight,
        grade,
        opticalSize,
        shadows,
        textDirection,
        applyTextScaling,
        fill,
        animated,
        modifiers,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('color', color, defaultValue: null));
    properties.add(DiagnosticsProperty('size', size, defaultValue: null));
    properties.add(DiagnosticsProperty('weight', weight, defaultValue: null));
    properties.add(DiagnosticsProperty('grade', grade, defaultValue: null));
    properties.add(
        DiagnosticsProperty('opticalSize', opticalSize, defaultValue: null));
    properties.add(DiagnosticsProperty('shadows', shadows, defaultValue: null));
    properties.add(DiagnosticsProperty('textDirection', textDirection,
        defaultValue: null));
    properties.add(DiagnosticsProperty('applyTextScaling', applyTextScaling,
        defaultValue: null));
    properties.add(DiagnosticsProperty('fill', fill, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
  }
}

/// Utility class for configuring [IconSpec] properties.
///
/// This class provides methods to set individual properties of a [IconSpec].
/// Use the methods of this class to configure specific properties of a [IconSpec].
class IconSpecUtility<T extends StyleElement>
    extends SpecUtility<T, IconSpecAttribute> {
  /// Utility for defining [IconSpecAttribute.color]
  late final color = ColorUtility((v) => only(color: v));

  /// Utility for defining [IconSpecAttribute.size]
  late final size = DoubleUtility((v) => only(size: v));

  /// Utility for defining [IconSpecAttribute.weight]
  late final weight = DoubleUtility((v) => only(weight: v));

  /// Utility for defining [IconSpecAttribute.grade]
  late final grade = DoubleUtility((v) => only(grade: v));

  /// Utility for defining [IconSpecAttribute.opticalSize]
  late final opticalSize = DoubleUtility((v) => only(opticalSize: v));

  /// Utility for defining [IconSpecAttribute.shadows]
  late final shadows = ShadowListUtility((v) => only(shadows: v));

  /// Utility for defining [IconSpecAttribute.textDirection]
  late final textDirection =
      TextDirectionUtility((v) => only(textDirection: v));

  /// Utility for defining [IconSpecAttribute.applyTextScaling]
  late final applyTextScaling = BoolUtility((v) => only(applyTextScaling: v));

  /// Utility for defining [IconSpecAttribute.fill]
  late final fill = DoubleUtility((v) => only(fill: v));

  /// Utility for defining [IconSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  /// Utility for defining [IconSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  IconSpecUtility(
    super.builder, {
    @Deprecated(
      'mutable parameter is no longer used. All SpecUtilities are now mutable by default.',
    )
    super.mutable,
  });

  @Deprecated(
    'Use "this" instead of "chain" for method chaining. '
    'The chain getter will be removed in a future version.',
  )
  IconSpecUtility<T> get chain => IconSpecUtility(attributeBuilder);

  static IconSpecUtility<IconSpecAttribute> get self =>
      IconSpecUtility((v) => v);

  /// Returns a new [IconSpecAttribute] with the specified properties.
  @override
  T only({
    ColorDto? color,
    double? size,
    double? weight,
    double? grade,
    double? opticalSize,
    List<ShadowDto>? shadows,
    TextDirection? textDirection,
    bool? applyTextScaling,
    double? fill,
    AnimatedDataDto? animated,
    WidgetModifiersConfigDto? modifiers,
  }) {
    return builder(IconSpecAttribute(
      color: color,
      size: size,
      weight: weight,
      grade: grade,
      opticalSize: opticalSize,
      shadows: shadows,
      textDirection: textDirection,
      applyTextScaling: applyTextScaling,
      fill: fill,
      animated: animated,
      modifiers: modifiers,
    ));
  }
}

/// A concrete implementation of [IconSpecUtility] for creating styling configurations.
///
/// This class provides a convenient way to define styling properties and is designed
/// for direct usage in styling contexts.
class StyleIcon extends IconSpecUtility<IconSpecAttribute> {
  StyleIcon() : super((v) => v);
}

/// A tween that interpolates between two [IconSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [IconSpec] specifications.
class IconSpecTween extends Tween<IconSpec?> {
  IconSpecTween({
    super.begin,
    super.end,
  });

  @override
  IconSpec lerp(double t) {
    if (begin == null && end == null) {
      return const IconSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
