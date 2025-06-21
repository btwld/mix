import 'package:flutter/material.dart';

import '../../src/specs/box/box_spec.dart';
import '../parsers.dart';

/// Parser for BoxSpec values
class BoxSpecParser extends Parser<BoxSpec> {
  static const instance = BoxSpecParser();

  const BoxSpecParser();

  Clip? _decodeClip(Object? value) {
    if (value is! String) return null;

    return Clip.values.where((e) => e.name == value).firstOrNull;
  }

  @override
  Object? encode(BoxSpec? value) {
    if (value == null) return null;

    final builder = MapBuilder()
      ..addIfNotNull('alignment', value.alignment, MixParsers.encode)
      ..addIfNotNull('padding', value.padding, MixParsers.encode)
      ..addIfNotNull('margin', value.margin, MixParsers.encode)
      ..addIfNotNull('constraints', value.constraints, MixParsers.encode)
      ..addIfNotNull('decoration', value.decoration, MixParsers.encode)
      ..addIfNotNull(
        'foregroundDecoration',
        value.foregroundDecoration,
        MixParsers.encode,
      )
      ..addIfNotNull('transform', value.transform, MixParsers.encode)
      ..addIfNotNull(
        'transformAlignment',
        value.transformAlignment,
        MixParsers.encode,
      )
      ..addIfNotNull('clipBehavior', value.clipBehavior?.name)
      ..addIfNotNull('width', value.width)
      ..addIfNotNull('height', value.height);

    // Handle modifiers if present
    if (value.modifiers != null) {
      // For now, store as string representation
      // TODO: Use WidgetModifiersConfigParser when imports are working
      builder.add('modifiers', value.modifiers?.toString());
    }

    // Handle animation if present
    if (value.animated != null) {
      // For now, store duration and curve separately
      // TODO: Use AnimatedDataParser when imports are working
      final animatedBuilder = MapBuilder()
        ..addIfNotNull(
          'duration',
          value.animated!.duration,
          MixParsers.encode,
        )
        ..addIfNotNull('curve', value.animated!.curve, MixParsers.encode);

      if (!animatedBuilder.isEmpty) {
        builder.add('animated', animatedBuilder.build());
      }
    }

    return builder.isEmpty ? null : builder.build();
  }

  @override
  BoxSpec? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      Map<String, Object?> map => BoxSpec(
          alignment: MixParsers.decode(map['alignment']),
          padding: MixParsers.decode<EdgeInsets>(map['padding']),
          margin: MixParsers.decode<EdgeInsets>(map['margin']),
          constraints: MixParsers.decode(map['constraints']),
          decoration: MixParsers.decode(map['decoration']),
          foregroundDecoration: MixParsers.decode(map['foregroundDecoration']),
          transform: MixParsers.decode(map['transform']),
          transformAlignment: MixParsers.decode(map['transformAlignment']),
          clipBehavior: _decodeClip(map['clipBehavior']),
          width: map.getDouble('width'),
          height: map.getDouble('height'),
          // Note: modifiers and animated would need proper DTO parsers for full support
        ),
      _ => null,
    };
  }
}
