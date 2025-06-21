import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for StrutStyle following KISS principle
class StrutStyleParser implements Parser<StrutStyle> {
  static const instance = StrutStyleParser();

  const StrutStyleParser();

  bool _isJustHeight(StrutStyle style) {
    return style.height != null &&
        style.fontFamily == null &&
        (style.fontFamilyFallback == null ||
            style.fontFamilyFallback!.isEmpty) &&
        style.fontSize == null &&
        style.leadingDistribution == null &&
        style.leading == null &&
        style.fontWeight == null &&
        style.fontStyle == null &&
        style.forceStrutHeight == null &&
        style.debugLabel == null;
  }

  StrutStyle _decodeFromMap(Map<String, Object?> map) {
    return StrutStyle(
      fontFamily: map['fontFamily'] as String?,
      fontFamilyFallback: (map['fontFamilyFallback'] as List<Object?>?)?.cast(),
      fontSize: (map['fontSize'] as num?)?.toDouble(),
      height: (map['height'] as num?)?.toDouble(),
      leadingDistribution:
          _decodeTextLeadingDistribution(map['leadingDistribution'] as String?),
      leading: (map['leading'] as num?)?.toDouble(),
      fontWeight: _decodeFontWeight(map['fontWeight']),
      fontStyle: _decodeFontStyle(map['fontStyle'] as String?),
      forceStrutHeight: map['forceStrutHeight'] as bool?,
      debugLabel: map['debugLabel'] as String?,
    );
  }

  Object _encodeFontWeight(FontWeight weight) {
    return switch (weight) {
      FontWeight.w100 => 'thin',
      FontWeight.w200 => 'extraLight',
      FontWeight.w300 => 'light',
      FontWeight.w400 => 'normal',
      FontWeight.w500 => 'medium',
      FontWeight.w600 => 'semiBold',
      FontWeight.w700 => 'bold',
      FontWeight.w800 => 'extraBold',
      FontWeight.w900 => 'black',
      _ => weight.value,
    };
  }

  FontWeight? _decodeFontWeight(Object? value) {
    if (value == null) return null;

    return switch (value) {
      'thin' || 100 => FontWeight.w100,
      'extraLight' || 200 => FontWeight.w200,
      'light' || 300 => FontWeight.w300,
      'normal' || 'regular' || 400 => FontWeight.w400,
      'medium' || 500 => FontWeight.w500,
      'semiBold' || 600 => FontWeight.w600,
      'bold' || 700 => FontWeight.w700,
      'extraBold' || 800 => FontWeight.w800,
      'black' || 900 => FontWeight.w900,
      num n => FontWeight.values.firstWhere(
          (w) => w.value == n.toInt(),
          orElse: () => FontWeight.normal,
        ),
      _ => null,
    };
  }

  FontStyle? _decodeFontStyle(String? value) {
    return switch (value) {
      'italic' => FontStyle.italic,
      'normal' => FontStyle.normal,
      _ => null,
    };
  }

  TextLeadingDistribution? _decodeTextLeadingDistribution(String? value) {
    return switch (value) {
      'proportional' => TextLeadingDistribution.proportional,
      'even' => TextLeadingDistribution.even,
      _ => null,
    };
  }

  @override
  Object? encode(StrutStyle? value) {
    if (value == null) return null;

    // Check if it's just a height value
    if (_isJustHeight(value)) {
      return value.height;
    }

    // Build minimal map with only non-null values
    final map = <String, Object?>{};

    if (value.fontFamily != null) {
      map['fontFamily'] = value.fontFamily;
    }
    if (value.fontFamilyFallback != null &&
        value.fontFamilyFallback!.isNotEmpty) {
      map['fontFamilyFallback'] = value.fontFamilyFallback;
    }
    if (value.fontSize != null) {
      map['fontSize'] = value.fontSize;
    }
    if (value.height != null) {
      map['height'] = value.height;
    }
    if (value.leadingDistribution != null) {
      map['leadingDistribution'] = value.leadingDistribution!.name;
    }
    if (value.leading != null) {
      map['leading'] = value.leading;
    }
    if (value.fontWeight != null) {
      map['fontWeight'] = _encodeFontWeight(value.fontWeight!);
    }
    if (value.fontStyle != null) {
      map['fontStyle'] = value.fontStyle!.name;
    }
    if (value.forceStrutHeight != null) {
      map['forceStrutHeight'] = value.forceStrutHeight;
    }
    if (value.debugLabel != null) {
      map['debugLabel'] = value.debugLabel;
    }

    return map.isEmpty ? null : map;
  }

  @override
  StrutStyle? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      // Just a height value
      num height => StrutStyle(height: height.toDouble()),

      // Full map
      Map<String, Object?> map => _decodeFromMap(map),
      _ => null,
    };
  }
}
