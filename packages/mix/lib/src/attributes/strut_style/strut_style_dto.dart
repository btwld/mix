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
      fontFamily: Mixable.maybeValue(fontFamily),
      fontFamilyFallback: fontFamilyFallback?.map(Mixable.value).toList(),
      fontSize: Mixable.maybeValue(fontSize),
      fontWeight: Mixable.maybeValue(fontWeight),
      fontStyle: Mixable.maybeValue(fontStyle),
      height: Mixable.maybeValue(height),
      leading: Mixable.maybeValue(leading),
      forceStrutHeight: Mixable.maybeValue(forceStrutHeight),
    );
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
  final Mixable<String>? fontFamily;
  final List<Mixable<String>>? fontFamilyFallback;
  final Mixable<double>? fontSize;
  final Mixable<FontWeight>? fontWeight;
  final Mixable<FontStyle>? fontStyle;
  final Mixable<double>? height;
  final Mixable<double>? leading;
  final Mixable<bool>? forceStrutHeight;

  const ValueStrutStyleDto({
    this.fontFamily,
    this.fontFamilyFallback,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.height,
    this.leading,
    this.forceStrutHeight,
  }) : super._();

  factory ValueStrutStyleDto.value(StrutStyle strutStyle) {
    return ValueStrutStyleDto(
      fontFamily: Mixable.maybeValue(strutStyle.fontFamily),
      fontFamilyFallback: strutStyle.fontFamilyFallback
          ?.map(Mixable.value)
          .toList(),
      fontSize: Mixable.maybeValue(strutStyle.fontSize),
      fontWeight: Mixable.maybeValue(strutStyle.fontWeight),
      fontStyle: Mixable.maybeValue(strutStyle.fontStyle),
      height: Mixable.maybeValue(strutStyle.height),
      leading: Mixable.maybeValue(strutStyle.leading),
      forceStrutHeight: Mixable.maybeValue(strutStyle.forceStrutHeight),
    );
  }

  ValueStrutStyleDto _mergeWith(ValueStrutStyleDto other) {
    return ValueStrutStyleDto(
      fontFamily: fontFamily?.merge(other.fontFamily) ?? other.fontFamily,
      fontFamilyFallback: other.fontFamilyFallback ?? fontFamilyFallback,
      fontSize: fontSize?.merge(other.fontSize) ?? other.fontSize,
      fontWeight: fontWeight?.merge(other.fontWeight) ?? other.fontWeight,
      fontStyle: fontStyle?.merge(other.fontStyle) ?? other.fontStyle,
      height: height?.merge(other.height) ?? other.height,
      leading: leading?.merge(other.leading) ?? other.leading,
      forceStrutHeight:
          forceStrutHeight?.merge(other.forceStrutHeight) ??
          other.forceStrutHeight,
    );
  }

  @override
  StrutStyle resolve(MixContext mix) {
    return StrutStyle(
      fontFamily: fontFamily?.resolve(mix),
      fontFamilyFallback: fontFamilyFallback
          ?.map((f) => f.resolve(mix))
          .toList(),
      fontSize: fontSize?.resolve(mix),
      height: height?.resolve(mix),
      leading: leading?.resolve(mix),
      fontWeight: fontWeight?.resolve(mix),
      fontStyle: fontStyle?.resolve(mix),
      forceStrutHeight: forceStrutHeight?.resolve(mix),
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
extension StrutStyleExt on StrutStyle {
  StrutStyleDto toDto() => StrutStyleDto.value(this);
}
