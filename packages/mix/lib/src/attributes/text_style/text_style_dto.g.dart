// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_style_dto.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides DTO functionality for [TextStyleData].
mixin _$TextStyleData on Mixable<TextStyle> {
  /// Resolves to [TextStyle] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final textStyle = TextStyleData(...).resolve(mix);
  /// ```
  @override
  TextStyle resolve(MixData mix) {
    return TextStyle(
      background: _$this.background,
      backgroundColor: _$this.backgroundColor?.resolve(mix),
      color: _$this.color?.resolve(mix),
      debugLabel: _$this.debugLabel,
      decoration: _$this.decoration,
      decorationColor: _$this.decorationColor?.resolve(mix),
      decorationStyle: _$this.decorationStyle,
      decorationThickness: _$this.decorationThickness,
      fontFamily: _$this.fontFamily,
      fontFamilyFallback: _$this.fontFamilyFallback,
      fontVariations: _$this.fontVariations,
      fontFeatures: _$this.fontFeatures,
      fontSize: _$this.fontSize,
      fontStyle: _$this.fontStyle,
      fontWeight: _$this.fontWeight,
      foreground: _$this.foreground,
      height: _$this.height,
      letterSpacing: _$this.letterSpacing,
      shadows: _$this.shadows?.map((e) => e.resolve(mix)).toList(),
      textBaseline: _$this.textBaseline,
      wordSpacing: _$this.wordSpacing,
    );
  }

  /// Merges the properties of this [TextStyleData] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [TextStyleData] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  TextStyleData merge(TextStyleData? other) {
    if (other == null) return _$this;

    return TextStyleData(
      background: other.background ?? _$this.background,
      backgroundColor: _$this.backgroundColor?.merge(other.backgroundColor) ??
          other.backgroundColor,
      color: _$this.color?.merge(other.color) ?? other.color,
      debugLabel: other.debugLabel ?? _$this.debugLabel,
      decoration: other.decoration ?? _$this.decoration,
      decorationColor: _$this.decorationColor?.merge(other.decorationColor) ??
          other.decorationColor,
      decorationStyle: other.decorationStyle ?? _$this.decorationStyle,
      decorationThickness:
          other.decorationThickness ?? _$this.decorationThickness,
      fontFamily: other.fontFamily ?? _$this.fontFamily,
      fontFamilyFallback: MixHelpers.mergeList(
          _$this.fontFamilyFallback, other.fontFamilyFallback),
      fontVariations:
          MixHelpers.mergeList(_$this.fontVariations, other.fontVariations),
      fontFeatures:
          MixHelpers.mergeList(_$this.fontFeatures, other.fontFeatures),
      fontSize: other.fontSize ?? _$this.fontSize,
      fontStyle: other.fontStyle ?? _$this.fontStyle,
      fontWeight: other.fontWeight ?? _$this.fontWeight,
      foreground: other.foreground ?? _$this.foreground,
      height: other.height ?? _$this.height,
      letterSpacing: other.letterSpacing ?? _$this.letterSpacing,
      shadows: MixHelpers.mergeList(_$this.shadows, other.shadows),
      textBaseline: other.textBaseline ?? _$this.textBaseline,
      wordSpacing: other.wordSpacing ?? _$this.wordSpacing,
    );
  }

  /// The list of properties that constitute the state of this [TextStyleData].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TextStyleData] instances for equality.
  @override
  List<Object?> get props => [
        _$this.background,
        _$this.backgroundColor,
        _$this.color,
        _$this.debugLabel,
        _$this.decoration,
        _$this.decorationColor,
        _$this.decorationStyle,
        _$this.decorationThickness,
        _$this.fontFamily,
        _$this.fontFamilyFallback,
        _$this.fontVariations,
        _$this.fontFeatures,
        _$this.fontSize,
        _$this.fontStyle,
        _$this.fontWeight,
        _$this.foreground,
        _$this.height,
        _$this.letterSpacing,
        _$this.shadows,
        _$this.textBaseline,
        _$this.wordSpacing,
      ];

  /// Returns this instance as a [TextStyleData].
  TextStyleData get _$this => this as TextStyleData;
}

/// A mixin that provides DTO functionality for [TextStyleDto].
mixin _$TextStyleDto on Mixable<TextStyle> {
  /// Merges the properties of this [TextStyleDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [TextStyleDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  TextStyleDto merge(TextStyleDto? other) {
    if (other == null) return _$this;

    return TextStyleDto._(
      value: [..._$this.value, ...other.value],
    );
  }

  /// The list of properties that constitute the state of this [TextStyleDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TextStyleDto] instances for equality.
  @override
  List<Object?> get props => [
        _$this.value,
      ];

  /// Returns this instance as a [TextStyleDto].
  TextStyleDto get _$this => this as TextStyleDto;
}
