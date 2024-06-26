// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strut_style_dto.dart';

// **************************************************************************
// MixableDtoGenerator
// **************************************************************************

base mixin _$StrutStyleDto on Dto<StrutStyle> {
  /// Resolves to [StrutStyle] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final strutStyle = StrutStyleDto(...).resolve(mix);
  /// ```
  @override
  StrutStyle resolve(MixData mix) {
    return StrutStyle(
      fontFamily: _$this.fontFamily ?? defaultValue.fontFamily,
      fontFamilyFallback:
          _$this.fontFamilyFallback ?? defaultValue.fontFamilyFallback,
      fontSize: _$this.fontSize ?? defaultValue.fontSize,
      fontWeight: _$this.fontWeight ?? defaultValue.fontWeight,
      fontStyle: _$this.fontStyle ?? defaultValue.fontStyle,
      height: _$this.height ?? defaultValue.height,
      leading: _$this.leading ?? defaultValue.leading,
      forceStrutHeight:
          _$this.forceStrutHeight ?? defaultValue.forceStrutHeight,
    );
  }

  /// Merges the properties of this [StrutStyleDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [StrutStyleDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  StrutStyleDto merge(StrutStyleDto? other) {
    if (other == null) return _$this;

    return StrutStyleDto(
      fontFamily: other.fontFamily ?? _$this.fontFamily,
      fontFamilyFallback: MixHelpers.mergeList(
          _$this.fontFamilyFallback, other.fontFamilyFallback),
      fontSize: other.fontSize ?? _$this.fontSize,
      fontWeight: other.fontWeight ?? _$this.fontWeight,
      fontStyle: other.fontStyle ?? _$this.fontStyle,
      height: other.height ?? _$this.height,
      leading: other.leading ?? _$this.leading,
      forceStrutHeight: other.forceStrutHeight ?? _$this.forceStrutHeight,
    );
  }

  /// The list of properties that constitute the state of this [StrutStyleDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [StrutStyleDto] instances for equality.
  @override
  List<Object?> get props => [
        _$this.fontFamily,
        _$this.fontFamilyFallback,
        _$this.fontSize,
        _$this.fontWeight,
        _$this.fontStyle,
        _$this.height,
        _$this.leading,
        _$this.forceStrutHeight,
      ];

  StrutStyleDto get _$this => this as StrutStyleDto;
}

/// Utility class for configuring [StrutStyleDto] properties.
///
/// This class provides methods to set individual properties of a [StrutStyleDto].
/// Use the methods of this class to configure specific properties of a [StrutStyleDto].
final class StrutStyleUtility<T extends Attribute>
    extends DtoUtility<T, StrutStyleDto, StrutStyle> {
  /// Utility for defining [StrutStyleDto.fontFamily]
  late final fontFamily = FontFamilyUtility((v) => only(fontFamily: v));

  /// Utility for defining [StrutStyleDto.fontFamilyFallback]
  late final fontFamilyFallback =
      ListUtility<T, String>((v) => only(fontFamilyFallback: v));

  /// Utility for defining [StrutStyleDto.fontSize]
  late final fontSize = FontSizeUtility((v) => only(fontSize: v));

  /// Utility for defining [StrutStyleDto.fontWeight]
  late final fontWeight = FontWeightUtility((v) => only(fontWeight: v));

  /// Utility for defining [StrutStyleDto.fontStyle]
  late final fontStyle = FontStyleUtility((v) => only(fontStyle: v));

  /// Utility for defining [StrutStyleDto.height]
  late final height = DoubleUtility((v) => only(height: v));

  /// Utility for defining [StrutStyleDto.leading]
  late final leading = DoubleUtility((v) => only(leading: v));

  /// Utility for defining [StrutStyleDto.forceStrutHeight]
  late final forceStrutHeight = BoolUtility((v) => only(forceStrutHeight: v));

  StrutStyleUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  /// Returns a new [StrutStyleDto] with the specified properties.
  @override
  T only({
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? height,
    double? leading,
    bool? forceStrutHeight,
  }) {
    return builder(StrutStyleDto(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: height,
      leading: leading,
      forceStrutHeight: forceStrutHeight,
    ));
  }

  T call({
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? height,
    double? leading,
    bool? forceStrutHeight,
  }) {
    return only(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: height,
      leading: leading,
      forceStrutHeight: forceStrutHeight,
    );
  }
}

extension StrutStyleMixExt on StrutStyle {
  StrutStyleDto toDto() {
    return StrutStyleDto(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: height,
      leading: leading,
      forceStrutHeight: forceStrutHeight,
    );
  }
}

extension ListStrutStyleMixExt on List<StrutStyle> {
  List<StrutStyleDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}
