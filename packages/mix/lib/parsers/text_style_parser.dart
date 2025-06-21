import 'package:flutter/material.dart';

import 'parsers.dart';

/// Parser for TextStyle following KISS principle
class TextStyleParser extends Parser<TextStyle> {
  static const instance = TextStyleParser();

  const TextStyleParser();

  TextStyle _decodeFromMap(Map<String, Object?> map) {
    return TextStyle(
      color: ColorParser.instance.decode(map['color']),
      fontSize: map.getDouble('fontSize'),
      fontWeight: FontWeightParser.instance.decode(map['fontWeight']),
      fontStyle:
          MixParsers.get<FontStyle>()?.decode(map.getString('fontStyle')),
      letterSpacing: map.getDouble('letterSpacing'),
      wordSpacing: map.getDouble('wordSpacing'),
      height: map.getDouble('height'),
      leadingDistribution: MixParsers.get<TextLeadingDistribution>()
          ?.decode(map.getString('leadingDistribution')),
      shadows: map.getListOf('shadows', _decodeShadow),
      decoration: _decodeTextDecoration(map['decoration']),
      decorationColor: ColorParser.instance.decode(map['decorationColor']),
      decorationStyle: MixParsers.get<TextDecorationStyle>()
          ?.decode(map.getString('decorationStyle')),
      decorationThickness: map.getDouble('decorationThickness'),
      fontFamily: map.getString('fontFamily'),
      fontFamilyFallback: map.getList('fontFamilyFallback')?.cast(),
      overflow:
          MixParsers.get<TextOverflow>()?.decode(map.getString('overflow')),
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

  TextStyle? _tryColorShortcut(Object? json) {
    final color = ColorParser.instance.decode(json);

    return color != null ? TextStyle(color: color) : null;
  }

  @override
  Object? encode(TextStyle? value) {
    if (value == null) return null;

    // Always use consistent map format
    // Build minimal map with only non-null values
    final builder = MapBuilder()
      ..addIfNotNull('color', value.color, ColorParser.instance.encode)
      ..addIfNotNull('fontSize', value.fontSize)
      ..addIfNotNull(
        'fontWeight',
        value.fontWeight,
        FontWeightParser.instance.encode,
      )
      ..addIfNotNull(
        'fontStyle',
        value.fontStyle,
        MixParsers.get<FontStyle>()?.encode,
      )
      ..addIfNotNull('letterSpacing', value.letterSpacing)
      ..addIfNotNull('wordSpacing', value.wordSpacing)
      ..addIfNotNull('height', value.height)
      ..addIfNotNull('decoration', value.decoration, _encodeTextDecoration)
      ..addIfNotNull(
        'decorationColor',
        value.decorationColor,
        ColorParser.instance.encode,
      )
      ..addIfNotNull(
        'decorationStyle',
        value.decorationStyle,
        MixParsers.get<TextDecorationStyle>()?.encode,
      )
      ..addIfNotNull('decorationThickness', value.decorationThickness)
      ..addIfNotNull('fontFamily', value.fontFamily);

    // Handle special cases with custom logic
    if (value.fontFamilyFallback != null &&
        value.fontFamilyFallback!.isNotEmpty) {
      builder.add('fontFamilyFallback', value.fontFamilyFallback);
    }
    if (value.shadows != null && value.shadows!.isNotEmpty) {
      builder.add('shadows', value.shadows!.map(_encodeShadow).toList());
    }

    builder
      ..addIfNotNull(
        'leadingDistribution',
        value.leadingDistribution,
        MixParsers.get<TextLeadingDistribution>()?.encode,
      )
      ..addIfNotNull(
        'overflow',
        value.overflow,
        MixParsers.get<TextOverflow>()?.encode,
      );

    return builder.isEmpty ? null : builder.build();
  }

  @override
  TextStyle? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      // Map format (primary)
      Map<String, Object?> textStyleMap => _decodeFromMap(textStyleMap),

      // Legacy support for backward compatibility
      num size => TextStyle(fontSize: size.toDouble()),
      _ => _tryColorShortcut(json),
    };
  }
}
