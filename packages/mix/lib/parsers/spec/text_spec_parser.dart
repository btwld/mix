import 'package:flutter/material.dart';

import '../../src/specs/text/text_spec.dart';
import '../base/parser_base.dart';
import '../curve_parser.dart';
import '../duration_parser.dart';
import '../strut_style_parser.dart';
import '../text_height_behavior_parser.dart';
import '../text_scaler_parser.dart';
import '../text_style_parser.dart';

/// Parser for TextSpec values
class TextSpecParser extends Parser<TextSpec> {
  static const instance = TextSpecParser();

  const TextSpecParser();

  TextOverflow? _decodeTextOverflow(Object? value) {
    if (value is! String) return null;

    return TextOverflow.values.where((e) => e.name == value).firstOrNull;
  }

  TextAlign? _decodeTextAlign(Object? value) {
    if (value is! String) return null;

    return TextAlign.values.where((e) => e.name == value).firstOrNull;
  }

  TextWidthBasis? _decodeTextWidthBasis(Object? value) {
    if (value is! String) return null;

    return TextWidthBasis.values.where((e) => e.name == value).firstOrNull;
  }

  TextDirection? _decodeTextDirection(Object? value) {
    if (value is! String) return null;

    return TextDirection.values.where((e) => e.name == value).firstOrNull;
  }

  @override
  Object? encode(TextSpec? value) {
    if (value == null) return null;

    final builder = MapBuilder()
      ..addIfNotNull('overflow', value.overflow?.name)
      ..addIfNotNull(
        'strutStyle',
        value.strutStyle,
        const StrutStyleParser().encode,
      )
      ..addIfNotNull('textAlign', value.textAlign?.name)
      ..addIfNotNull('maxLines', value.maxLines)
      ..addIfNotNull('textWidthBasis', value.textWidthBasis?.name)
      ..addIfNotNull(
        'textScaler',
        value.textScaler,
        const TextScalerParser().encode,
      )
      ..addIfNotNull('style', value.style, const TextStyleParser().encode)
      ..addIfNotNull('textDirection', value.textDirection?.name)
      ..addIfNotNull('softWrap', value.softWrap)
      ..addIfNotNull(
        'textHeightBehavior',
        value.textHeightBehavior,
        const TextHeightBehaviorParser().encode,
      );

    // Handle deprecated textScaleFactor
    if (value.textScaleFactor != null) {
      builder.add('textScaleFactor', value.textScaleFactor);
    }

    // Handle directive if present (text transformations)
    if (value.directive != null) {
      builder.add('directive', value.directive?.toString()); // Fallback for now
    }

    // Handle modifiers if present
    if (value.modifiers != null) {
      builder.add('modifiers', value.modifiers?.toString()); // Fallback for now
    }

    // Handle animation if present
    if (value.animated != null) {
      final animatedBuilder = MapBuilder()
        ..addIfNotNull(
          'duration',
          value.animated!.duration,
          const DurationParser().encode,
        )
        ..addIfNotNull(
          'curve',
          value.animated!.curve,
          const CurveParser().encode,
        );

      if (!animatedBuilder.isEmpty) {
        builder.add('animated', animatedBuilder.build());
      }
    }

    return builder.isEmpty ? null : builder.build();
  }

  @override
  TextSpec? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      Map<String, Object?> map => TextSpec(
          overflow: _decodeTextOverflow(map['overflow']),
          strutStyle: const StrutStyleParser().decode(map['strutStyle']),
          textAlign: _decodeTextAlign(map['textAlign']),
          textScaleFactor: map.getDouble('textScaleFactor'),
          textScaler: const TextScalerParser().decode(map['textScaler']),
          maxLines: map['maxLines'] as int?,
          style: const TextStyleParser().decode(map['style']),
          textWidthBasis: _decodeTextWidthBasis(map['textWidthBasis']),
          textHeightBehavior: const TextHeightBehaviorParser()
              .decode(map['textHeightBehavior']),
          textDirection: _decodeTextDirection(map['textDirection']),
          softWrap: map['softWrap'] as bool?,
          // Note: directive, modifiers and animated would need proper DTO parsers for full support
        ),
      _ => null,
    };
  }
}
