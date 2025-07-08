// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../internal/diagnostic_properties_builder_ext.dart';

/// A Data transfer object that represents a [StrutStyle] value.
/// Can be either a direct value or a token reference.
@immutable
sealed class StrutStyleDto extends Mixable<StrutStyle> with Diagnosticable {
  const StrutStyleDto._();

  factory StrutStyleDto.value(StrutStyle value) = ValueStrutStyleDto.value;
  const factory StrutStyleDto.token(MixableToken<StrutStyle> token) =
      TokenStrutStyleDto;
  const factory StrutStyleDto.composite(List<StrutStyleDto> items) =
      _CompositeStrutStyleDto;

  factory StrutStyleDto({
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? height,
    double? leading,
    bool? forceStrutHeight,
  }) {
    return ValueStrutStyleDto(
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

  // Factory from StrutStyle
  factory StrutStyleDto.from(StrutStyle style) {
    return StrutStyleDto(
      fontFamily: style.fontFamily,
      fontFamilyFallback: style.fontFamilyFallback,
      fontSize: style.fontSize,
      fontWeight: style.fontWeight,
      fontStyle: style.fontStyle,
      height: style.height,
      leading: style.leading,
      forceStrutHeight: style.forceStrutHeight,
    );
  }

  /// Creates a StrutStyleDto from a nullable StrutStyle value
  /// Returns null if the value is null, otherwise uses StrutStyleDto.from
  static StrutStyleDto? maybeFrom(StrutStyle? value) {
    return value != null ? StrutStyleDto.from(value) : null;
  }

  // Merges this StrutStyleDto with another one
  @override
  StrutStyleDto merge(StrutStyleDto? other) {
    if (other == null) return this;

    return switch ((this, other)) {
      (ValueStrutStyleDto a, ValueStrutStyleDto b) => a._mergeWith(b),
      (_CompositeStrutStyleDto(:var items), _) => StrutStyleDto.composite([
        ...items,
        other,
      ]),
      (_, _CompositeStrutStyleDto()) => other,
      _ => StrutStyleDto.composite([this, other]),
    };
  }
}

final class ValueStrutStyleDto extends StrutStyleDto {
  final MixableProperty<String> fontFamily;
  final MixableProperty<List<String>> fontFamilyFallback;
  final MixableProperty<double> fontSize;
  final MixableProperty<FontWeight> fontWeight;
  final MixableProperty<FontStyle> fontStyle;
  final MixableProperty<double> height;
  final MixableProperty<double> leading;
  final MixableProperty<bool> forceStrutHeight;

  factory ValueStrutStyleDto({
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? height,
    double? leading,
    bool? forceStrutHeight,
  }) {
    return ValueStrutStyleDto.raw(
      fontFamily: MixableProperty.prop(fontFamily),
      fontFamilyFallback: MixableProperty.prop(fontFamilyFallback),
      fontSize: MixableProperty.prop(fontSize),
      fontWeight: MixableProperty.prop(fontWeight),
      fontStyle: MixableProperty.prop(fontStyle),
      height: MixableProperty.prop(height),
      leading: MixableProperty.prop(leading),
      forceStrutHeight: MixableProperty.prop(forceStrutHeight),
    );
  }

  const ValueStrutStyleDto.raw({
    required this.fontFamily,
    required this.fontFamilyFallback,
    required this.fontSize,
    required this.fontWeight,
    required this.fontStyle,
    required this.height,
    required this.leading,
    required this.forceStrutHeight,
  }) : super._();

  factory ValueStrutStyleDto.value(StrutStyle strutStyle) {
    return ValueStrutStyleDto(
      fontFamily: strutStyle.fontFamily,
      fontFamilyFallback: strutStyle.fontFamilyFallback,
      fontSize: strutStyle.fontSize,
      fontWeight: strutStyle.fontWeight,
      fontStyle: strutStyle.fontStyle,
      height: strutStyle.height,
      leading: strutStyle.leading,
      forceStrutHeight: strutStyle.forceStrutHeight,
    );
  }

  ValueStrutStyleDto _mergeWith(ValueStrutStyleDto other) {
    return ValueStrutStyleDto.raw(
      fontFamily: fontFamily.merge(other.fontFamily),
      fontFamilyFallback: fontFamilyFallback.merge(other.fontFamilyFallback),
      fontSize: fontSize.merge(other.fontSize),
      fontWeight: fontWeight.merge(other.fontWeight),
      fontStyle: fontStyle.merge(other.fontStyle),
      height: height.merge(other.height),
      leading: leading.merge(other.leading),
      forceStrutHeight: forceStrutHeight.merge(other.forceStrutHeight),
    );
  }

  @override
  StrutStyle resolve(MixContext mix) {
    return StrutStyle(
      fontFamily: fontFamily.resolve(mix),
      fontFamilyFallback: fontFamilyFallback.resolve(mix),
      fontSize: fontSize.resolve(mix),
      height: height.resolve(mix),
      leading: leading.resolve(mix),
      fontWeight: fontWeight.resolve(mix),
      fontStyle: fontStyle.resolve(mix),
      forceStrutHeight: forceStrutHeight.resolve(mix),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.addUsingDefault('fontFamily', fontFamily);
    properties.addUsingDefault('fontFamilyFallback', fontFamilyFallback);
    properties.addUsingDefault('fontSize', fontSize);
    properties.addUsingDefault('fontWeight', fontWeight);
    properties.addUsingDefault('fontStyle', fontStyle);
    properties.addUsingDefault('height', height);
    properties.addUsingDefault('leading', leading);
    properties.addUsingDefault('forceStrutHeight', forceStrutHeight);
  }

  @override
  List<Object?> get props => [
    fontFamily,
    fontFamilyFallback,
    fontSize,
    fontWeight,
    fontStyle,
    height,
    leading,
    forceStrutHeight,
  ];
}

final class TokenStrutStyleDto extends StrutStyleDto {
  final MixableToken<StrutStyle> token;

  const TokenStrutStyleDto(this.token) : super._();

  @override
  StrutStyle resolve(MixContext mix) {
    return mix.scope.getToken(token, mix.context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('token', token.name));
  }

  @override
  List<Object?> get props => [token];
}

@immutable
class _CompositeStrutStyleDto extends StrutStyleDto {
  final List<StrutStyleDto> items;

  const _CompositeStrutStyleDto(this.items) : super._();

  @override
  StrutStyle resolve(MixContext mix) {
    if (items.isEmpty) return const StrutStyle();

    // Process all items as DTOs
    ValueStrutStyleDto? mergedDto;

    for (final item in items) {
      final currentDto = switch (item) {
        ValueStrutStyleDto() => item,
        TokenStrutStyleDto() => ValueStrutStyleDto.value(item.resolve(mix)),
        _CompositeStrutStyleDto() => ValueStrutStyleDto.value(
          item.resolve(mix),
        ),
      };

      // Merge with accumulated result
      mergedDto = mergedDto?._mergeWith(currentDto) ?? currentDto;
    }

    // Final resolution
    return mergedDto?.resolve(mix) ?? const StrutStyle();
  }

  @override
  List<Object?> get props => [items];
}

// Extension for easy conversion
