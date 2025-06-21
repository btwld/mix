import 'package:flutter/material.dart';

import '../../src/specs/icon/icon_spec.dart';
import '../base/parser_base.dart';
import '../color_parser.dart';
import '../curve_parser.dart';
import '../duration_parser.dart';
import '../shadow/shadow_parser.dart';

/// Parser for IconSpec values
class IconSpecParser extends Parser<IconSpec> {
  static const instance = IconSpecParser();

  const IconSpecParser();

  TextDirection? _decodeTextDirection(Object? value) {
    if (value is! String) return null;

    return TextDirection.values.where((e) => e.name == value).firstOrNull;
  }

  List<Shadow>? _decodeShadows(Object? value) {
    if (value is! List) return null;

    const shadowParser = ShadowParser();

    final shadows = <Shadow>[];
    for (final item in value) {
      final shadow = shadowParser.decode(item);
      if (shadow != null) {
        shadows.add(shadow);
      }
    }

    return shadows.isEmpty ? null : shadows;
  }

  @override
  Object? encode(IconSpec? value) {
    if (value == null) return null;

    final builder = MapBuilder()
      ..addIfNotNull('color', value.color, const ColorParser().encode)
      ..addIfNotNull('size', value.size)
      ..addIfNotNull('weight', value.weight)
      ..addIfNotNull('grade', value.grade)
      ..addIfNotNull('opticalSize', value.opticalSize)
      ..addIfNotNull('textDirection', value.textDirection?.name)
      ..addIfNotNull('applyTextScaling', value.applyTextScaling)
      ..addIfNotNull('fill', value.fill);

    // Handle shadows list
    if (value.shadows != null && value.shadows!.isNotEmpty) {
      final shadowsData = value.shadows!
          .map((shadow) => const ShadowParser().encode(shadow))
          .where((encoded) => encoded != null)
          .toList();

      if (shadowsData.isNotEmpty) {
        builder.add('shadows', shadowsData);
      }
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
  IconSpec? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      Map<String, Object?> map => IconSpec(
          color: const ColorParser().decode(map['color']),
          size: map.getDouble('size'),
          weight: map.getDouble('weight'),
          grade: map.getDouble('grade'),
          opticalSize: map.getDouble('opticalSize'),
          shadows: _decodeShadows(map['shadows']),
          textDirection: _decodeTextDirection(map['textDirection']),
          applyTextScaling: map['applyTextScaling'] as bool?,
          fill: map.getDouble('fill'),
          // Note: modifiers and animated would need proper DTO parsers for full support
        ),
      _ => null,
    };
  }
}
