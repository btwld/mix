import 'package:flutter/material.dart';

import 'parsers.dart';

/// Parser for TextStyle following KISS principle
class TextStyleParser implements Parser<TextStyle> {
  static const instance = TextStyleParser();

  const TextStyleParser();

  bool _isJustColor(TextStyle style) {
    return style.color != null &&
        style.fontSize == null &&
        style.fontWeight == null &&
        style.fontStyle == null &&
        style.letterSpacing == null &&
        style.wordSpacing == null &&
        style.height == null &&
        style.decoration == null &&
        style.decorationColor == null &&
        style.decorationStyle == null &&
        style.decorationThickness == null &&
        style.fontFamily == null &&
        (style.fontFamilyFallback == null ||
            style.fontFamilyFallback!.isEmpty) &&
        (style.shadows == null || style.shadows!.isEmpty) &&
        style.leadingDistribution == null &&
        style.overflow == null;
  }

  bool _isJustSize(TextStyle style) {
    return style.fontSize != null &&
        style.color == null &&
        style.fontWeight == null &&
        style.fontStyle == null &&
        style.letterSpacing == null &&
        style.wordSpacing == null &&
        style.height == null &&
        style.decoration == null &&
        style.decorationColor == null &&
        style.decorationStyle == null &&
        style.decorationThickness == null &&
        style.fontFamily == null &&
        (style.fontFamilyFallback == null ||
            style.fontFamilyFallback!.isEmpty) &&
        (style.shadows == null || style.shadows!.isEmpty) &&
        style.leadingDistribution == null &&
        style.overflow == null;
  }

  TextStyle _decodeFromMap(Map<String, Object?> map) {
    return TextStyle(
      color: ColorParser.instance.decode(map['color']),
      fontSize: map.getDouble('fontSize'),
      fontWeight: FontWeightParser.instance.decode(map['fontWeight']),
      fontStyle: MixParsers.get<FontStyle>()?.decode(map.getString('fontStyle')),
      letterSpacing: map.getDouble('letterSpacing'),
      wordSpacing: map.getDouble('wordSpacing'),
      height: map.getDouble('height'),
      leadingDistribution: MixParsers.get<TextLeadingDistribution>()
          ?.decode(map.getString('leadingDistribution')),
      shadows: map
          .getList('shadows')
          ?.map(_decodeShadow)
          .whereType<Shadow>()
          .toList(),
      decoration: _decodeTextDecoration(map['decoration']),
      decorationColor: ColorParser.instance.decode(map['decorationColor']),
      decorationStyle: MixParsers.get<TextDecorationStyle>()
          ?.decode(map.getString('decorationStyle')),
      decorationThickness: map.getDouble('decorationThickness'),
      fontFamily: map.getString('fontFamily'),
      fontFamilyFallback: map.getList('fontFamilyFallback')?.cast(),
      overflow: MixParsers.get<TextOverflow>()?.decode(map.getString('overflow')),
    );
  }

  Object _encodeTextDecoration(TextDecoration decoration) {
    // Handle simple cases first
    return switch (decoration) {
      TextDecoration.none => 'none',
      TextDecoration.underline => 'underline',
      TextDecoration.overline => 'overline',
      TextDecoration.lineThrough => 'lineThrough',
      _ => _encodeCombinedDecorations(decoration),
    };
  }

  Object _encodeCombinedDecorations(TextDecoration decoration) {
    final decorationNames = <String>[];

    if (decoration.contains(TextDecoration.underline)) {
      decorationNames.add('underline');
    }
    if (decoration.contains(TextDecoration.overline)) {
      decorationNames.add('overline');
    }
    if (decoration.contains(TextDecoration.lineThrough)) {
      decorationNames.add('lineThrough');
    }

    return decorationNames.isEmpty ? 'none' : decorationNames;
  }

  TextDecoration? _decodeTextDecoration(Object? value) {
    if (value == null) return null;

    return switch (value) {
      'none' => TextDecoration.none,
      'underline' => TextDecoration.underline,
      'overline' => TextDecoration.overline,
      'lineThrough' => TextDecoration.lineThrough,
      List<Object?> list => TextDecoration.combine(
          list
              .map((e) => _decodeTextDecoration(e))
              .whereType<TextDecoration>()
              .toList(),
        ),
      _ => null,
    };
  }

  Map<String, Object?> _encodeShadow(Shadow shadow) {
    return {
      'color': ColorParser.instance.encode(shadow.color),
      'offset': OffsetParser.instance.encode(shadow.offset),
      'blurRadius': shadow.blurRadius,
    };
  }

  Shadow? _decodeShadow(Object? value) {
    if (value is! Map<String, Object?>) return null;

    final shadowMap = value;

    return Shadow(
      color: ColorParser.instance.decode(shadowMap['color']) ?? Colors.black,
      offset: OffsetParser.instance.decode(shadowMap['offset']) ?? Offset.zero,
      blurRadius: shadowMap.getDouble('blurRadius') ?? 0.0,
    );
  }

  @override
  Object? encode(TextStyle? value) {
    if (value == null) return null;

    // Check if it's just a color - simplest case
    if (_isJustColor(value)) {
      return ColorParser.instance.encode(value.color);
    }

    // Check if it's just a size
    if (_isJustSize(value)) {
      return value.fontSize;
    }

    // Build minimal map with only non-null values
    final map = <String, Object?>{};

    if (value.color != null) {
      map['color'] = ColorParser.instance.encode(value.color);
    }
    if (value.fontSize != null) {
      map['fontSize'] = value.fontSize;
    }
    if (value.fontWeight != null) {
      map['fontWeight'] = FontWeightParser.instance.encode(value.fontWeight!);
    }
    if (value.fontStyle != null) {
      map['fontStyle'] = MixParsers.get<FontStyle>()?.encode(value.fontStyle!);
    }
    if (value.letterSpacing != null) {
      map['letterSpacing'] = value.letterSpacing;
    }
    if (value.wordSpacing != null) {
      map['wordSpacing'] = value.wordSpacing;
    }
    if (value.height != null) {
      map['height'] = value.height;
    }
    if (value.decoration != null) {
      map['decoration'] = _encodeTextDecoration(value.decoration!);
    }
    if (value.decorationColor != null) {
      map['decorationColor'] =
          ColorParser.instance.encode(value.decorationColor);
    }
    if (value.decorationStyle != null) {
      map['decorationStyle'] =
          MixParsers.get<TextDecorationStyle>()?.encode(value.decorationStyle!);
    }
    if (value.decorationThickness != null) {
      map['decorationThickness'] = value.decorationThickness;
    }
    if (value.fontFamily != null) {
      map['fontFamily'] = value.fontFamily;
    }
    if (value.fontFamilyFallback != null &&
        value.fontFamilyFallback!.isNotEmpty) {
      map['fontFamilyFallback'] = value.fontFamilyFallback;
    }
    if (value.shadows != null && value.shadows!.isNotEmpty) {
      map['shadows'] = value.shadows!.map(_encodeShadow).toList();
    }
    if (value.leadingDistribution != null) {
      map['leadingDistribution'] =
          MixParsers.get<TextLeadingDistribution>()?.encode(value.leadingDistribution!);
    }
    if (value.overflow != null) {
      map['overflow'] = MixParsers.get<TextOverflow>()?.encode(value.overflow!);
    }

    return map.isEmpty ? null : map;
  }

  @override
  TextStyle? decode(Object? json) {
    if (json == null) return null;

    // Try color parsing first to avoid double calls
    final color = ColorParser.instance.decode(json);
    if (color != null) {
      return TextStyle(color: color);
    }

    return switch (json) {
      // Just a size
      num size => TextStyle(fontSize: size.toDouble()),

      // Full map
      Map<String, Object?> textStyleMap => _decodeFromMap(textStyleMap),
      _ => null,
    };
  }
}
