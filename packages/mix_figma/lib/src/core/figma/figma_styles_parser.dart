import '../json_map.dart';
import 'figma_styles_document.dart';

/// Parses local text/effect/paint styles including their concrete values.
FigmaStylesDocument parseFigmaStylesDocument(JsonMap json) {
  final schema = json['schema'];
  if (schema != null && schema != 'mix_figma/figma-styles/v1') {
    throw FormatException('Unsupported Figma styles schema "$schema".');
  }
  final rawStyles = json['styles'] ?? _pluginStyles(json);
  final styles = <FigmaStyle>[];
  for (final (index, raw) in jsonList(rawStyles, path: '/styles').indexed) {
    final item = jsonObject(raw, path: '/styles/$index');
    styles.add(
      FigmaStyle(
        key: jsonString(item['key'], path: '/styles/$index/key'),
        id: jsonString(item['id'], path: '/styles/$index/id'),
        name: jsonString(item['name'], path: '/styles/$index/name'),
        type: switch (jsonString(
          item['styleType'],
          path: '/styles/$index/styleType',
        ).toUpperCase()) {
          'TEXT' => .text,
          'EFFECT' => .effect,
          'PAINT' => .paint,
          final value => throw FormatException(
            'Unsupported Figma style type "$value".',
          ),
        },
        value: jsonObject(item['value'], path: '/styles/$index/value'),
        pluginData: item['pluginData'] == null
            ? const {}
            : jsonObject(item['pluginData'], path: '/styles/$index/pluginData'),
        description: item['description'] is String
            ? item['description']! as String
            : '',
        remote: item['remote'] == true,
      ),
    );
  }

  return FigmaStylesDocument(styles: styles);
}

List<Object?> _pluginStyles(JsonMap json) => [
  for (final entry in _pluginStyleList(json, 'textStyles'))
    {
      ...entry,
      'styleType': 'TEXT',
      'value': {
        if (_fontName(entry)['family'] case final String family)
          'fontFamily': family,
        'fontStyle': _fontStyle(_fontName(entry)['style']),
        'fontWeight': _fontWeight(_fontName(entry)['style']),
        for (final key in [
          'fontSize',
          'fontWeight',
          'letterSpacing',
          'lineHeight',
          'leadingTrim',
          'paragraphIndent',
          'paragraphSpacing',
          'listSpacing',
          'hangingPunctuation',
          'hangingList',
          'textCase',
          'textDecoration',
          'boundVariables',
        ])
          if (entry.containsKey(key)) key: entry[key],
      },
    },
  for (final entry in _pluginStyleList(json, 'effectStyles'))
    {
      ...entry,
      'styleType': 'EFFECT',
      'value': {
        'effects': entry['effects'],
        if (entry.containsKey('boundVariables'))
          'boundVariables': entry['boundVariables'],
      },
    },
  for (final entry in _pluginStyleList(json, 'paintStyles'))
    {
      ...entry,
      'styleType': 'PAINT',
      'value': {
        'paints': entry['paints'],
        if (entry.containsKey('boundVariables'))
          'boundVariables': entry['boundVariables'],
      },
    },
];

JsonMap _fontName(JsonMap entry) =>
    entry['fontName'] is Map ? (entry['fontName']! as Map).cast() : const {};

String _fontStyle(Object? style) =>
    style is String && style.toLowerCase().contains('italic')
    ? 'italic'
    : 'normal';

int _fontWeight(Object? style) {
  final value = style is String ? style.toLowerCase() : '';
  if (value.contains('thin')) return 100;
  if (value.contains('extra light')) return 200;
  if (value.contains('light')) return 300;
  if (value.contains('medium')) return 500;
  if (value.contains('semi bold')) return 600;
  if (value.contains('extra bold')) return 800;
  if (value.contains('black')) return 900;
  if (value.contains('bold')) return 700;

  return 400;
}

List<JsonMap> _pluginStyleList(JsonMap json, String key) {
  final value = json[key];
  if (value == null) return const [];

  return jsonList(
    value,
    path: '/$key',
  ).map((item) => jsonObject(item, path: '/$key')).toList(growable: false);
}
