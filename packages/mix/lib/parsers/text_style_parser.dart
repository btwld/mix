import 'package:flutter/material.dart';

import 'base/parser_base.dart';
import 'color_parser.dart';

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
      fontWeight: _decodeFontWeight(map['fontWeight']),
      fontStyle: _decodeFontStyle(map.getString('fontStyle')),
      letterSpacing: map.getDouble('letterSpacing'),
      wordSpacing: map.getDouble('wordSpacing'),
      height: map.getDouble('height'),
      leadingDistribution:
          _decodeTextLeadingDistribution(map.getString('leadingDistribution')),
      shadows: map
          .getList('shadows')
          ?.map(_decodeShadow)
          .whereType<Shadow>()
          .toList(),
      decoration: _decodeTextDecoration(map['decoration']),
      decorationColor: ColorParser.instance.decode(map['decorationColor']),
      decorationStyle:
          _decodeTextDecorationStyle(map.getString('decorationStyle')),
      decorationThickness: map.getDouble('decorationThickness'),
      fontFamily: map.getString('fontFamily'),
      fontFamilyFallback: map.getList('fontFamilyFallback')?.cast(),
      overflow: _decodeTextOverflow(map.getString('overflow')),
    );
  }

  Object _encodeFontWeight(FontWeight weight) {
    return switch (weight) {
      FontWeight.w100 => 100,
      FontWeight.w200 => 200,
      FontWeight.w300 => 300,
      FontWeight.w400 => 400,
      FontWeight.w500 => 500,
      FontWeight.w600 => 600,
      FontWeight.w700 => 700,
      FontWeight.w800 => 800,
      FontWeight.w900 => 900,
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

  Object _encodeTextDecoration(TextDecoration decoration) {
    if (decoration == TextDecoration.none) return 'none';
    if (decoration == TextDecoration.underline) return 'underline';
    if (decoration == TextDecoration.overline) return 'overline';
    if (decoration == TextDecoration.lineThrough) return 'lineThrough';

    // Handle combined decorations
    final decorations = <String>[];
    if (decoration.contains(TextDecoration.underline)) {
      decorations.add('underline');
    }
    if (decoration.contains(TextDecoration.overline)) {
      decorations.add('overline');
    }
    if (decoration.contains(TextDecoration.lineThrough)) {
      decorations.add('lineThrough');
    }

    return decorations.isEmpty ? 'none' : decorations;
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

  TextDecorationStyle? _decodeTextDecorationStyle(String? value) {
    return switch (value) {
      'solid' => TextDecorationStyle.solid,
      'double' => TextDecorationStyle.double,
      'dotted' => TextDecorationStyle.dotted,
      'dashed' => TextDecorationStyle.dashed,
      'wavy' => TextDecorationStyle.wavy,
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

  TextOverflow? _decodeTextOverflow(String? value) {
    return switch (value) {
      'clip' => TextOverflow.clip,
      'fade' => TextOverflow.fade,
      'ellipsis' => TextOverflow.ellipsis,
      'visible' => TextOverflow.visible,
      _ => null,
    };
  }

  Map<String, Object?> _encodeShadow(Shadow shadow) {
    return {
      'color': ColorParser.instance.encode(shadow.color),
      'offset': [shadow.offset.dx, shadow.offset.dy],
      'blurRadius': shadow.blurRadius,
    };
  }

  Shadow? _decodeShadow(Object? value) {
    if (value is! Map<String, Object?>) return null;

    final map = value;
    final offset = map.getList('offset');

    return Shadow(
      color: ColorParser.instance.decode(map['color']) ?? Colors.black,
      offset: offset != null && offset.length >= 2
          ? Offset((offset[0] as num).toDouble(), (offset[1] as num).toDouble())
          : Offset.zero,
      blurRadius: map.getDouble('blurRadius') ?? 0.0,
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
      map['fontWeight'] = _encodeFontWeight(value.fontWeight!);
    }
    if (value.fontStyle != null) {
      map['fontStyle'] = value.fontStyle!.name;
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
      map['decorationStyle'] = value.decorationStyle!.name;
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
      map['leadingDistribution'] = value.leadingDistribution!.name;
    }
    if (value.overflow != null) {
      map['overflow'] = value.overflow!.name;
    }

    return map.isEmpty ? null : map;
  }

  @override
  TextStyle? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      // Just a color
      _ when ColorParser.instance.decode(json) != null =>
        TextStyle(color: ColorParser.instance.decode(json)),

      // Just a size
      num size => TextStyle(fontSize: size.toDouble()),

      // Full map
      Map<String, Object?> map => _decodeFromMap(map),
      _ => null,
    };
  }
}
