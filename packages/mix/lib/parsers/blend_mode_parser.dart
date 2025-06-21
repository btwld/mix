import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for BlendMode enum following KISS principle
class BlendModeParser implements Parser<BlendMode> {
  static const instance = BlendModeParser();

  const BlendModeParser();

  @override
  Object? encode(BlendMode? value) {
    if (value == null) return null;

    return switch (value) {
      BlendMode.clear => 'clear',
      BlendMode.src => 'src',
      BlendMode.dst => 'dst',
      BlendMode.srcOver => 'srcOver',
      BlendMode.dstOver => 'dstOver',
      BlendMode.srcIn => 'srcIn',
      BlendMode.dstIn => 'dstIn',
      BlendMode.srcOut => 'srcOut',
      BlendMode.dstOut => 'dstOut',
      BlendMode.srcATop => 'srcATop',
      BlendMode.dstATop => 'dstATop',
      BlendMode.xor => 'xor',
      BlendMode.plus => 'plus',
      BlendMode.modulate => 'modulate',
      BlendMode.screen => 'screen',
      BlendMode.overlay => 'overlay',
      BlendMode.darken => 'darken',
      BlendMode.lighten => 'lighten',
      BlendMode.colorDodge => 'colorDodge',
      BlendMode.colorBurn => 'colorBurn',
      BlendMode.hardLight => 'hardLight',
      BlendMode.softLight => 'softLight',
      BlendMode.difference => 'difference',
      BlendMode.exclusion => 'exclusion',
      BlendMode.multiply => 'multiply',
      BlendMode.hue => 'hue',
      BlendMode.saturation => 'saturation',
      BlendMode.color => 'color',
      BlendMode.luminosity => 'luminosity',
    };
  }

  @override
  BlendMode? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      'clear' => BlendMode.clear,
      'src' => BlendMode.src,
      'dst' => BlendMode.dst,
      'srcOver' => BlendMode.srcOver,
      'dstOver' => BlendMode.dstOver,
      'srcIn' => BlendMode.srcIn,
      'dstIn' => BlendMode.dstIn,
      'srcOut' => BlendMode.srcOut,
      'dstOut' => BlendMode.dstOut,
      'srcATop' => BlendMode.srcATop,
      'dstATop' => BlendMode.dstATop,
      'xor' => BlendMode.xor,
      'plus' => BlendMode.plus,
      'modulate' => BlendMode.modulate,
      'screen' => BlendMode.screen,
      'overlay' => BlendMode.overlay,
      'darken' => BlendMode.darken,
      'lighten' => BlendMode.lighten,
      'colorDodge' => BlendMode.colorDodge,
      'colorBurn' => BlendMode.colorBurn,
      'hardLight' => BlendMode.hardLight,
      'softLight' => BlendMode.softLight,
      'difference' => BlendMode.difference,
      'exclusion' => BlendMode.exclusion,
      'multiply' => BlendMode.multiply,
      'hue' => BlendMode.hue,
      'saturation' => BlendMode.saturation,
      'color' => BlendMode.color,
      'luminosity' => BlendMode.luminosity,
      _ => null,
    };
  }
}
