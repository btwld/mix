import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds/mix_winds.dart';
import 'package:mix_winds/src/theme/data/default_theme.g.dart';
import 'package:mix_winds/src/translate/tw_presets.dart';

void main() {
  final snapshot = _readSnapshot();

  test('generated Tailwind theme maps exactly match the pinned snapshot', () {
    expect(twDefaultSpacing, _doubles(snapshot, 'spacing'));
    expect(twDefaultRadii, _doubles(snapshot, 'radii'));
    expect(twDefaultBorderWidths, _doubles(snapshot, 'borderWidths'));
    expect(twDefaultBreakpoints, _doubles(snapshot, 'breakpoints'));
    expect(twDefaultFontSizes, _doubles(snapshot, 'fontSizes'));
    expect(twDefaultLineHeights, _doubles(snapshot, 'fontLineHeights'));
    expect(twDefaultColors, _colors(snapshot));
    expect(twDefaultDurations, _ints(snapshot, 'durations'));
    expect(twDefaultDelays, _ints(snapshot, 'delays'));
    expect(twDefaultScales, _doubles(snapshot, 'scales'));
    expect(twDefaultRotations, _doubles(snapshot, 'rotations'));
    expect(twDefaultBlurs, _doubles(snapshot, 'blurs'));
    expect(twDefaultLeading, _doubles(snapshot, 'leading'));
    expect(twDefaultTracking, _doubles(snapshot, 'tracking'));
  });

  test('standard config exposes only canonical Tailwind defaults', () {
    final config = TwConfig.standard();

    expect(config.colors, hasLength(289));
    expect(config.colorOf('blue-500'), const Color(0xFF2B7FFF));
    expect(config.colorOf('red-500'), const Color(0xFFFB2C36));
    expect(config.colorOf('emerald-500'), const Color(0xFF00BC7D));
    expect(config.colorOf('transparent'), Colors.transparent);

    expect(config.colors, isNot(contains('brand-500')));
    expect(config.space, isNot(contains('card')));
    expect(config.radii, isNot(contains('card')));
    expect(config.breakpoints, isNot(contains('3xl')));
    expect(kTailwindBoxShadowPresets, isNot(contains('shadow-card')));
  });
}

Map<String, dynamic> _readSnapshot() {
  final file = File('tool/tailwind_theme_snapshot.json');
  if (!file.existsSync()) {
    throw StateError('Missing pinned Tailwind theme snapshot: ${file.path}');
  }

  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  final meta = json['meta']! as Map<String, dynamic>;
  if (meta['tailwindVersion'] != '4.3.1') {
    throw StateError(
      'Expected Tailwind 4.3.1, found ${meta['tailwindVersion']}.',
    );
  }
  return json;
}

Map<String, dynamic> _namespace(Map<String, dynamic> snapshot, String name) {
  final namespaces = snapshot['namespaces']! as Map<String, dynamic>;
  return namespaces[name]! as Map<String, dynamic>;
}

Map<String, double> _doubles(Map<String, dynamic> snapshot, String name) =>
    _namespace(
      snapshot,
      name,
    ).map((key, value) => MapEntry(key, (value as num).toDouble()));

Map<String, int> _ints(Map<String, dynamic> snapshot, String name) =>
    _namespace(
      snapshot,
      name,
    ).map((key, value) => MapEntry(key, (value as num).toInt()));

Map<String, Color> _colors(Map<String, dynamic> snapshot) => _namespace(
  snapshot,
  'colors',
).map((key, value) => MapEntry(key, _colorFromCssHex(value as String)));

Color _colorFromCssHex(String hex) {
  final digits = hex.substring(1);
  if (digits.length == 6) {
    return Color(0xFF000000 | int.parse(digits, radix: 16));
  }
  if (digits.length == 8) {
    final rgba = int.parse(digits, radix: 16);
    return Color(((rgba & 0xFF) << 24) | (rgba >> 8));
  }
  throw FormatException('Expected #RRGGBB or #RRGGBBAA, got $hex.');
}
