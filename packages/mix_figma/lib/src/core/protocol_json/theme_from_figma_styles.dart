import 'dart:convert';

import '../diagnostics/mix_figma_coverage_report.dart';
import '../diagnostics/mix_figma_diagnostic.dart';
import '../figma/figma_styles_document.dart';
import '../json_map.dart';
import '../mapping/name_mapper.dart';

/// Composite token import plus reusable style fragments.
final class FigmaStylesImportResult {
  final JsonMap value;

  final Map<String, JsonMap> styleFragments;
  final MixFigmaCoverageReport coverage;
  final List<MixFigmaDiagnostic> diagnostics;
  FigmaStylesImportResult({
    required this.value,
    required Map<String, JsonMap> styleFragments,
    required this.coverage,
    required Iterable<MixFigmaDiagnostic> diagnostics,
  }) : styleFragments = Map.unmodifiable(styleFragments),
       diagnostics = List.unmodifiable(diagnostics);
}

/// Maps local Figma styles to composite theme tokens and style fragments.
FigmaStylesImportResult buildProtocolThemeJsonFromFigmaStyles(
  FigmaStylesDocument document,
) {
  final textStyles = <String, Object?>{};
  final shadows = <String, Object?>{};
  final boxShadows = <String, Object?>{};
  final colors = <String, Object?>{};
  final fragments = <String, JsonMap>{};
  final diagnostics = <MixFigmaDiagnostic>[];
  final coverage = <MixFigmaCoverageItem>[];
  final styles = document.styles.toList()
    ..sort((left, right) => left.name.compareTo(right.name));

  for (final style in styles) {
    final itemDiagnostics = <MixFigmaDiagnostic>[];
    var supported = true;
    var nativeFidelity = MixFigmaFidelity.exact;
    var roundTripFidelity = MixFigmaFidelity.exact;
    try {
      final name = MixFigmaNameMapper.figmaToMix(style.name);
      switch (style.type) {
        case .text:
          textStyles[name] = _textStyle(style, itemDiagnostics);
          if (itemDiagnostics.isNotEmpty) {
            nativeFidelity = .normalized;
            roundTripFidelity = .normalized;
          }
        case .effect:
          final mapped = _effects(style, itemDiagnostics);
          if (mapped.isEmpty) {
            supported = false;
            nativeFidelity = .unsupported;
            roundTripFidelity = .unsupported;
          } else if (style.pluginData['mix.group'] == 'shadows') {
            shadows[name] = mapped;
          } else {
            boxShadows[name] = mapped;
          }
          if (mapped.isNotEmpty && itemDiagnostics.isNotEmpty) {
            nativeFidelity = .lossy;
            roundTripFidelity = .lossy;
          }
        case .paint:
          final paints = _objects(style.value['paints'], path: style.name);
          final visible = paints.where(_isVisible).toList();
          if (visible.length != 1) {
            throw const FormatException(
              'Paint style must contain one visible paint.',
            );
          }
          final paint = visible.single;
          if (paint['type'] == 'SOLID') {
            colors[name] = _color(
              paint['color'],
              opacity: paint['opacity'] is num ? paint['opacity']! as num : 1,
            );
            nativeFidelity = .normalized;
            roundTripFidelity = .lossy;
            itemDiagnostics.add(
              MixFigmaDiagnostic(
                code: 'paint_style_normalized_to_color_token',
                severity: .warning,
                path: '/styles/${style.id}',
                message:
                    'The solid paint value is preserved, but a later export '
                    'creates a Figma variable instead of the original paint style.',
              ),
            );
          } else if (paint['type'] == 'GRADIENT_LINEAR') {
            fragments[name] = _gradientFragment(paint);
            nativeFidelity = .normalized;
            roundTripFidelity = .unsupported;
            itemDiagnostics.add(
              MixFigmaDiagnostic(
                code: 'gradient_style_fragment_not_exportable',
                severity: .warning,
                path: '/styles/${style.id}',
                message:
                    'The gradient is imported as a style fragment, but style '
                    'fragment export to a Figma paint style is not supported.',
              ),
            );
          } else {
            itemDiagnostics.add(
              MixFigmaDiagnostic(
                code: 'unsupported_paint_style',
                severity: .warning,
                path: '/styles/${style.id}',
                message:
                    'Paint type ${paint['type'] ?? '<missing>'} has no supported mapping.',
              ),
            );
            supported = false;
            nativeFidelity = .unsupported;
            roundTripFidelity = .unsupported;
          }
      }
    } on FormatException catch (error) {
      itemDiagnostics.add(
        MixFigmaDiagnostic(
          code: 'invalid_style_value',
          severity: .error,
          path: '/styles/${style.id}',
          message: error.message,
        ),
      );
      supported = false;
      nativeFidelity = .error;
      roundTripFidelity = .error;
    }

    diagnostics.addAll(itemDiagnostics);
    coverage.add(
      MixFigmaCoverageItem(
        id: style.id,
        kind: 'style',
        status: supported ? .supported : .unsupported,
        nativeFidelity: nativeFidelity,
        roundTripFidelity: roundTripFidelity,
        diagnostics: itemDiagnostics,
      ),
    );
  }

  return FigmaStylesImportResult(
    value: {
      'v': 1,
      'type': 'theme',
      if (colors.isNotEmpty) 'colors': colors,
      if (textStyles.isNotEmpty) 'textStyles': textStyles,
      if (shadows.isNotEmpty) 'shadows': shadows,
      if (boxShadows.isNotEmpty) 'boxShadows': boxShadows,
    },
    styleFragments: fragments,
    coverage: MixFigmaCoverageReport(items: coverage),
    diagnostics: diagnostics,
  );
}

JsonMap _textStyle(FigmaStyle style, List<MixFigmaDiagnostic> diagnostics) {
  final authored = _authoredValue(style);
  if (authored is Map) return authored.cast();
  final value = style.value;
  final fontSize = value['fontSize'];
  if (fontSize is! num) throw const FormatException('fontSize is required.');
  final lineHeight = value['lineHeight'] is Map
      ? (value['lineHeight']! as Map).cast<String, Object?>()
      : null;
  num? height;
  if (lineHeight != null) {
    final number = lineHeight['value'];
    height = switch (lineHeight['unit']) {
      'PERCENT' when number is num => number / 100,
      'PIXELS' when number is num => number / fontSize,
      'AUTO' => null,
      _ => throw const FormatException('Unsupported lineHeight value.'),
    };
    if (lineHeight['unit'] == 'PIXELS') {
      diagnostics.add(
        MixFigmaDiagnostic(
          code: 'line_height_pixels_normalized',
          severity: .warning,
          path: '/styles/${style.id}/value/lineHeight',
          message: 'Pixel line height was normalized by fontSize.',
        ),
      );
    }
  }
  final spacing = value['letterSpacing'] is Map
      ? (value['letterSpacing']! as Map).cast<String, Object?>()
      : null;

  return {
    if (value['fontFamily'] is String) 'fontFamily': value['fontFamily'],
    'fontSize': fontSize,
    if (value['fontWeight'] is num)
      'fontWeight': 'w${((value['fontWeight']! as num) / 100).round() * 100}',
    if (value['fontStyle'] is String) 'fontStyle': value['fontStyle'],
    'height': ?height,
    if (spacing?['value'] is num) 'letterSpacing': spacing!['value'],
  };
}

List<Object?> _effects(FigmaStyle style, List<MixFigmaDiagnostic> diagnostics) {
  final authored = _authoredValue(style);
  if (authored is List) return authored.cast();
  final effects = _objects(style.value['effects'], path: style.name);
  final mapped = <Object?>[];
  for (final effect in effects.where(_isVisible)) {
    if (effect['type'] == 'INNER_SHADOW') {
      diagnostics.add(
        MixFigmaDiagnostic(
          code: 'unsupported_inner_shadow',
          severity: .warning,
          path: '/styles/${style.id}/value/effects',
          message: 'Flutter BoxShadow has no inset shadow equivalent.',
        ),
      );
      continue;
    }
    if (effect['type'] != 'DROP_SHADOW') {
      diagnostics.add(
        MixFigmaDiagnostic(
          code: 'unsupported_effect_style_value',
          severity: .warning,
          path: '/styles/${style.id}/value/effects',
          message:
              'Effect type ${effect['type'] ?? '<missing>'} has no Mix shadow equivalent.',
        ),
      );
      continue;
    }
    final offset = effect['offset'] is Map
        ? (effect['offset']! as Map).cast<String, Object?>()
        : const <String, Object?>{};
    mapped.add({
      'color': _color(effect['color']),
      'offset': {'x': offset['x'] ?? 0, 'y': offset['y'] ?? 0},
      'blurRadius': effect['radius'] ?? 0,
      if (effect['spread'] != null) 'spreadRadius': effect['spread'],
    });
  }

  return mapped;
}

bool _isVisible(JsonMap item) => item['visible'] != false;

Object? _authoredValue(FigmaStyle style) {
  final source = style.pluginData['mix.protocol.value'];
  if (source is! String) return null;

  return jsonDecode(source);
}

JsonMap _gradientFragment(JsonMap paint) {
  final stops = _objects(paint['gradientStops'], path: 'gradientStops');

  return {
    'v': 1,
    'type': 'box',
    'decoration': {
      'gradient': {
        'kind': 'linear',
        'colors': stops.map((stop) => _color(stop['color'])).toList(),
        'stops': stops.map((stop) => stop['position']).toList(),
      },
    },
  };
}

List<JsonMap> _objects(Object? value, {required String path}) {
  if (value is! List) throw FormatException('Expected list at $path.');

  return value
      .map((item) => (item! as Map).cast<String, Object?>())
      .toList(growable: false);
}

String _color(Object? value, {num opacity = 1}) {
  if (value is String &&
      RegExp(r'^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$').hasMatch(value)) {
    if (opacity < 1 && value.length == 7) {
      final alpha = (opacity * 255).round().toRadixString(16).padLeft(2, '0');

      return '#$alpha${value.substring(1)}'.toUpperCase();
    }

    return value.toUpperCase();
  }
  final color = value is Map ? value.cast<String, Object?>() : null;
  if (color == null ||
      color['r'] is! num ||
      color['g'] is! num ||
      color['b'] is! num) {
    throw const FormatException('Expected a Figma color.');
  }
  final alpha = color['a'] is num ? color['a']! as num : opacity;
  int byte(num component) => (component * 255).round().clamp(0, 255);
  final rgb = [color['r'], color['g'], color['b']]
      .map((component) => byte(component! as num))
      .map((item) => item.toRadixString(16).padLeft(2, '0'))
      .join();
  final alphaHex = byte(alpha).toRadixString(16).padLeft(2, '0');

  return '#${alphaHex == 'ff' ? '' : alphaHex}$rgb'.toUpperCase();
}
