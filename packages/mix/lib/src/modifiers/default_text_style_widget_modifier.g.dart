// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_text_style_widget_modifier.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [DefaultTextStyleModifierSpec].
mixin _$DefaultTextStyleModifierSpec
    on WidgetModifierSpec<DefaultTextStyleModifierSpec> {
  /// Creates a copy of this [DefaultTextStyleModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  DefaultTextStyleModifierSpec copyWith({
    TextStyle? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) {
    return DefaultTextStyleModifierSpec(
      style: style ?? _$this.style,
      textAlign: textAlign ?? _$this.textAlign,
      softWrap: softWrap ?? _$this.softWrap,
      overflow: overflow ?? _$this.overflow,
      maxLines: maxLines ?? _$this.maxLines,
      textWidthBasis: textWidthBasis ?? _$this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? _$this.textHeightBehavior,
    );
  }

  /// Linearly interpolates between this [DefaultTextStyleModifierSpec] and another [DefaultTextStyleModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [DefaultTextStyleModifierSpec] is returned. When [t] is 1.0, the [other] [DefaultTextStyleModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [DefaultTextStyleModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [DefaultTextStyleModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [DefaultTextStyleModifierSpec] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpTextStyle] for [style].
  /// For [textAlign] and [softWrap] and [overflow] and [maxLines] and [textWidthBasis] and [textHeightBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [DefaultTextStyleModifierSpec] is used. Otherwise, the value
  /// from the [other] [DefaultTextStyleModifierSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [DefaultTextStyleModifierSpec] configurations.
  @override
  DefaultTextStyleModifierSpec lerp(
      DefaultTextStyleModifierSpec? other, double t) {
    if (other == null) return _$this;

    return DefaultTextStyleModifierSpec(
      style: MixHelpers.lerpTextStyle(_$this.style, other.style, t),
      textAlign: t < 0.5 ? _$this.textAlign : other.textAlign,
      softWrap: t < 0.5 ? _$this.softWrap : other.softWrap,
      overflow: t < 0.5 ? _$this.overflow : other.overflow,
      maxLines: t < 0.5 ? _$this.maxLines : other.maxLines,
      textWidthBasis: t < 0.5 ? _$this.textWidthBasis : other.textWidthBasis,
      textHeightBehavior:
          t < 0.5 ? _$this.textHeightBehavior : other.textHeightBehavior,
    );
  }

  /// The list of properties that constitute the state of this [DefaultTextStyleModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [DefaultTextStyleModifierSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.style,
        _$this.textAlign,
        _$this.softWrap,
        _$this.overflow,
        _$this.maxLines,
        _$this.textWidthBasis,
        _$this.textHeightBehavior,
      ];

  DefaultTextStyleModifierSpec get _$this =>
      this as DefaultTextStyleModifierSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
        .add(DiagnosticsProperty('style', _$this.style, defaultValue: null));
    properties.add(
        DiagnosticsProperty('textAlign', _$this.textAlign, defaultValue: null));
    properties.add(
        DiagnosticsProperty('softWrap', _$this.softWrap, defaultValue: null));
    properties.add(
        DiagnosticsProperty('overflow', _$this.overflow, defaultValue: null));
    properties.add(
        DiagnosticsProperty('maxLines', _$this.maxLines, defaultValue: null));
    properties.add(DiagnosticsProperty('textWidthBasis', _$this.textWidthBasis,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'textHeightBehavior', _$this.textHeightBehavior,
        defaultValue: null));
  }
}

/// Represents the attributes of a [DefaultTextStyleModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [DefaultTextStyleModifierSpec].
///
/// Use this class to configure the attributes of a [DefaultTextStyleModifierSpec] and pass it to
/// the [DefaultTextStyleModifierSpec] constructor.
class DefaultTextStyleModifierSpecAttribute
    extends WidgetModifierSpecAttribute<DefaultTextStyleModifierSpec>
    with Diagnosticable {
  final TextStyleDto? style;
  final TextAlign? textAlign;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehaviorDto? textHeightBehavior;

  const DefaultTextStyleModifierSpecAttribute({
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  /// Resolves to [DefaultTextStyleModifierSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final defaultTextStyleModifierSpec = DefaultTextStyleModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  DefaultTextStyleModifierSpec resolve(MixData mix) {
    return DefaultTextStyleModifierSpec(
      style: style?.resolve(mix),
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior?.resolve(mix),
    );
  }

  /// Merges the properties of this [DefaultTextStyleModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [DefaultTextStyleModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  DefaultTextStyleModifierSpecAttribute merge(
      DefaultTextStyleModifierSpecAttribute? other) {
    if (other == null) return this;

    return DefaultTextStyleModifierSpecAttribute(
      style: style?.merge(other.style) ?? other.style,
      textAlign: other.textAlign ?? textAlign,
      softWrap: other.softWrap ?? softWrap,
      overflow: other.overflow ?? overflow,
      maxLines: other.maxLines ?? maxLines,
      textWidthBasis: other.textWidthBasis ?? textWidthBasis,
      textHeightBehavior: textHeightBehavior?.merge(other.textHeightBehavior) ??
          other.textHeightBehavior,
    );
  }

  /// The list of properties that constitute the state of this [DefaultTextStyleModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [DefaultTextStyleModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        style,
        textAlign,
        softWrap,
        overflow,
        maxLines,
        textWidthBasis,
        textHeightBehavior,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('style', style, defaultValue: null));
    properties
        .add(DiagnosticsProperty('textAlign', textAlign, defaultValue: null));
    properties
        .add(DiagnosticsProperty('softWrap', softWrap, defaultValue: null));
    properties
        .add(DiagnosticsProperty('overflow', overflow, defaultValue: null));
    properties
        .add(DiagnosticsProperty('maxLines', maxLines, defaultValue: null));
    properties.add(DiagnosticsProperty('textWidthBasis', textWidthBasis,
        defaultValue: null));
    properties.add(DiagnosticsProperty('textHeightBehavior', textHeightBehavior,
        defaultValue: null));
  }
}

/// A tween that interpolates between two [DefaultTextStyleModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [DefaultTextStyleModifierSpec] specifications.
class DefaultTextStyleModifierSpecTween
    extends Tween<DefaultTextStyleModifierSpec?> {
  DefaultTextStyleModifierSpecTween({
    super.begin,
    super.end,
  });

  @override
  DefaultTextStyleModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const DefaultTextStyleModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
