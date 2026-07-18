import 'dart:convert';

import '../diagnostics/mix_figma_diagnostic.dart';
import '../figma/figma_styles_document.dart';
import '../figma/figma_styles_parser.dart';
import '../identity/mix_figma_lock.dart';
import '../json_map.dart';
import '../mapping/mapping_result.dart';
import '../mapping/name_mapper.dart';

/// Routes composite theme tokens to Figma text/effect style write payloads.
MixFigmaMappingResult<JsonMap> buildFigmaStylePayloads(
  JsonMap theme, {
  MixFigmaLock lock = const MixFigmaLock(),
}) {
  final diagnostics = <MixFigmaDiagnostic>[];
  final styles = <Object?>[];
  final textStyles = <Object?>[];
  final effectStyles = <Object?>[];
  for (final entry in _group(theme, 'textStyles').entries) {
    final key = 'textStyles/${entry.key}';
    final value = _textStyle(entry.value);
    styles.add({
      'id': lock.styleIds[key] ?? 'mix:$key',
      'key': key,
      'name': MixFigmaNameMapper.mixToFigma(entry.key),
      'styleType': 'TEXT',
      'value': value,
      'pluginData': _pluginData(key, 'textStyles', entry.value),
    });
    textStyles.add({
      'ref': key,
      if (lock.styleIds[key] case final String sourceId) 'sourceId': sourceId,
      'name': MixFigmaNameMapper.mixToFigma(entry.key),
      ..._pluginTextStyle(value),
      'pluginData': _pluginData(key, 'textStyles', entry.value),
      'identity': {'id': key, 'kind': 'textStyle', 'protocolVersion': 1},
    });
  }
  for (final group in ['shadows', 'boxShadows']) {
    for (final entry in _group(theme, group).entries) {
      final key = '$group/${entry.key}';
      final effects = _effects(entry.value);
      styles.add({
        'id': lock.styleIds[key] ?? 'mix:$key',
        'key': key,
        'name': MixFigmaNameMapper.mixToFigma(entry.key),
        'styleType': 'EFFECT',
        'value': {'effects': effects},
        'pluginData': _pluginData(key, group, entry.value),
      });
      effectStyles.add({
        'ref': key,
        if (lock.styleIds[key] case final String sourceId) 'sourceId': sourceId,
        'name': MixFigmaNameMapper.mixToFigma(entry.key),
        'effects': effects,
        'pluginData': _pluginData(key, group, entry.value),
        'identity': {'id': key, 'kind': 'effectStyle', 'protocolVersion': 1},
      });
    }
  }
  for (final entry in _group(theme, 'borders').entries) {
    diagnostics.add(
      MixFigmaDiagnostic(
        code: 'unsupported_border_style_export',
        severity: .warning,
        path: '/borders/${entry.key}',
        message: 'Figma has no style type that preserves border width.',
      ),
    );
  }

  return MixFigmaMappingResult(
    value: {
      'version': 1,
      'schema': 'mix_figma/style-write/v1',
      'styles': styles,
      'textStyles': textStyles,
      'effectStyles': effectStyles,
      'paintStyles': <Object?>[],
    },
    diagnostics: diagnostics,
  );
}

JsonMap _pluginData(String key, String group, Object? value) => {
  'mix.key': key,
  'mix.group': group,
  'mix.protocol.value': jsonEncode(value),
};

/// Materializes a plugin style write payload as a read document for fixed-point
/// checks. Figma-assigned ids are represented by stable refs when no lock id is
/// available.
FigmaStylesDocument figmaStylesDocumentFromWritePayload(JsonMap payload) {
  if (payload['schema'] != 'mix_figma/style-write/v1') {
    throw const FormatException('Expected a style write payload.');
  }

  JsonMap readStyle(Object? value, String kind) {
    final style = (value! as Map).cast<String, Object?>();

    return {
      ...style,
      'id': style['sourceId'] ?? style['ref'],
      'key': style['ref'],
      'kind': kind,
      'remote': false,
    };
  }

  return parseFigmaStylesDocument({
    'version': 1,
    'textStyles': [
      for (final style in payload['textStyles']! as List)
        readStyle(style, 'TEXT'),
    ],
    'effectStyles': [
      for (final style in payload['effectStyles']! as List)
        readStyle(style, 'EFFECT'),
    ],
    'paintStyles': [
      for (final style in (payload['paintStyles'] as List?) ?? const [])
        readStyle(style, 'PAINT'),
    ],
  });
}

JsonMap _pluginTextStyle(JsonMap value) {
  final family = value['fontFamily'];
  final weight = value['fontWeight'];
  final fontStyle = value['fontStyle'];

  return {
    if (family is String)
      'fontName': {
        'family': family,
        'style': _fontStyleName(weight, fontStyle),
      },
    if (value['fontSize'] != null) 'fontSize': value['fontSize'],
    if (value['letterSpacing'] != null)
      'letterSpacing': {'unit': 'PIXELS', 'value': value['letterSpacing']},
    if (value['lineHeight'] != null) 'lineHeight': value['lineHeight'],
  };
}

String _fontStyleName(Object? weight, Object? fontStyle) {
  final italic = fontStyle == 'italic';
  final numeric = weight is num ? weight.round() : 400;
  final label = switch (numeric) {
    <= 100 => 'Thin',
    <= 200 => 'Extra Light',
    <= 300 => 'Light',
    <= 400 => 'Regular',
    <= 500 => 'Medium',
    <= 600 => 'Semi Bold',
    <= 700 => 'Bold',
    <= 800 => 'Extra Bold',
    _ => 'Black',
  };

  return italic ? '$label Italic' : label;
}

JsonMap _group(JsonMap theme, String group) {
  final value = theme[group];
  if (value == null) return {};

  return (value as Map).cast();
}

JsonMap _textStyle(Object? value) {
  final style = (value! as Map).cast<String, Object?>();
  final height = style['height'];

  return {
    if (style['fontFamily'] != null) 'fontFamily': style['fontFamily'],
    if (style['fontSize'] != null) 'fontSize': style['fontSize'],
    if (style['fontWeight'] is String)
      'fontWeight': int.parse((style['fontWeight']! as String).substring(1)),
    if (style['fontStyle'] != null) 'fontStyle': style['fontStyle'],
    if (height is num) 'lineHeight': {'unit': 'PERCENT', 'value': height * 100},
    if (style['letterSpacing'] != null)
      'letterSpacing': {'unit': 'PIXELS', 'value': style['letterSpacing']},
  };
}

List<Object?> _effects(Object? value) {
  return (value! as List)
      .map((item) {
        final shadow = (item! as Map).cast<String, Object?>();
        final offset = (shadow['offset']! as Map).cast<String, Object?>();

        return <String, Object?>{
          'type': 'DROP_SHADOW',
          'color': _rgba(shadow['color']),
          'offset': offset,
          'radius': shadow['blurRadius'],
          if (shadow['spreadRadius'] != null) 'spread': shadow['spreadRadius'],
          'visible': true,
        };
      })
      .toList(growable: false);
}

JsonMap _rgba(Object? value) {
  if (value is! String ||
      !RegExp(r'^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$').hasMatch(value)) {
    throw const FormatException('Expected protocol hex color.');
  }
  final hex = value.substring(1);
  final hasAlpha = hex.length == 8;
  final offset = hasAlpha ? 2 : 0;
  double channel(int start) =>
      int.parse(hex.substring(offset + start, offset + start + 2), radix: 16) /
      255;

  return {
    'r': channel(0),
    'g': channel(2),
    'b': channel(4),
    'a': hasAlpha ? int.parse(hex.substring(0, 2), radix: 16) / 255 : 1.0,
  };
}
