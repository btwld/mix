import '../diagnostics/mix_figma_diagnostic.dart';
import '../figma/figma_variables_document.dart';
import '../figma/figma_variables_parser.dart';
import '../identity/mix_figma_lock.dart';
import '../json_map.dart';
import '../mapping/mapping_result.dart';
import '../mapping/name_mapper.dart';

const _primitiveGroups = [
  'colors',
  'spaces',
  'doubles',
  'radii',
  'fontWeights',
];

/// Builds the neutral payload consumed by the plugin variable writer.
MixFigmaMappingResult<JsonMap> buildFigmaVariableWritePayload(
  Map<String, JsonMap> themes, {
  String collectionName = 'Mix Tokens',
  MixFigmaLock lock = const MixFigmaLock(),
}) {
  if (themes.isEmpty) throw ArgumentError('At least one mode is required.');
  final diagnostics = <MixFigmaDiagnostic>[];
  final keys = <String>{};
  for (final theme in themes.values) {
    if (theme['v'] != 1 || theme['type'] != 'theme') {
      throw const FormatException('Expected v1 protocol theme documents.');
    }
    for (final group in _primitiveGroups) {
      keys.addAll(_group(theme, group).keys.map((name) => '$group/$name'));
    }
    for (final group in ['textStyles', 'shadows', 'boxShadows', 'borders']) {
      if (_group(theme, group).isNotEmpty) {
        diagnostics.add(
          MixFigmaDiagnostic(
            code: 'composite_token_uses_style_payload',
            severity: .info,
            path: '/$group',
            message: '$group tokens are emitted through Figma styles.',
          ),
        );
      }
    }
  }
  final orderedKeys = keys.toList()..sort();
  final ids = {
    for (final key in orderedKeys) key: lock.variableIds[key] ?? 'mix:$key',
  };
  final modes = themes.keys.toList()..sort();
  final collectionRef = collectionName;
  final collectionId =
      lock.collectionIds[collectionName] ?? 'mix:collection/$collectionName';
  final variables = <Object?>[];
  for (final key in orderedKeys) {
    final separator = key.indexOf('/');
    final group = key.substring(0, separator);
    final name = key.substring(separator + 1);
    final valuesByMode = <String, Object?>{};
    for (final mode in modes) {
      final values = _group(themes[mode]!, group);
      if (!values.containsKey(name)) {
        diagnostics.add(
          MixFigmaDiagnostic(
            code: 'missing_mode_token',
            severity: .error,
            path: '/$mode/$group/$name',
            message: 'Token is not declared in every exported mode.',
          ),
        );
        continue;
      }
      valuesByMode['mode:$mode'] = _figmaValue(
        values[name],
        group: group,
        ids: ids,
      );
    }
    variables.add({
      'id': ids[key],
      'key': key,
      'ref': key,
      if (lock.variableIds[key] case final String sourceId)
        'sourceId': sourceId,
      'name': MixFigmaNameMapper.mixToFigma(name),
      'collectionId': collectionId,
      'collectionRef': collectionRef,
      'resolvedType': group == 'colors' ? 'COLOR' : 'FLOAT',
      'valuesByMode': valuesByMode,
      'scopes': _scopes(group),
      'codeSyntax': {'WEB': 'mix://$group/$name'},
      'pluginData': {'mix.key': key, 'mix.group': group},
      'identity': {
        'id': key,
        'kind': 'token',
        'protocolVersion': 1,
        'tokenGroup': group,
      },
      'description': '',
      'remote': false,
    });
  }

  return MixFigmaMappingResult(
    value: {
      'version': 1,
      'schema': 'mix_figma/variable-write/v1',
      'collection': {
        'id': collectionId,
        'name': collectionName,
        'defaultModeId': 'mode:${modes.first}',
        'modes': [
          for (final mode in modes) {'id': 'mode:$mode', 'name': mode},
        ],
      },
      'collections': [
        {
          'ref': collectionRef,
          if (lock.collectionIds[collectionName] case final String sourceId)
            'sourceId': sourceId,
          'name': collectionName,
          'modes': [
            for (final mode in modes) {'ref': 'mode:$mode', 'name': mode},
          ],
          'identity': {
            'id': collectionName,
            'kind': 'collection',
            'protocolVersion': 1,
          },
        },
      ],
      'variables': variables,
    },
    diagnostics: diagnostics,
  );
}

/// Materializes a plugin write payload as a read payload for fixed-point tests.
FigmaVariablesDocument figmaVariablesDocumentFromWritePayload(JsonMap payload) {
  if (payload['schema'] != 'mix_figma/variable-write/v1') {
    throw const FormatException('Expected a variable write payload.');
  }

  return parseFigmaVariablesDocument({
    'schema': 'mix_figma/figma-variables/v1',
    'collections': [payload['collection']],
    'variables': payload['variables'],
  });
}

JsonMap _group(JsonMap theme, String group) {
  final value = theme[group];
  if (value == null) return {};
  if (value is! Map) throw FormatException('$group must be an object.');

  return value.cast();
}

Object _figmaValue(
  Object? value, {
  required String group,
  required Map<String, String> ids,
}) {
  if (value is Map && value[r'$token'] is String) {
    final target = '$group/${value[r'$token']}';
    final id = ids[target];
    if (id == null) throw FormatException('Alias target $target is missing.');

    return {'type': 'VARIABLE_ALIAS', 'id': id, 'ref': target};
  }

  return switch (group) {
    'colors' => _rgba(value),
    'fontWeights' => int.parse((value! as String).substring(1)),
    _ when value is num => value,
    _ => throw FormatException(
      'Unsupported $group value ${value ?? '<null>'}.',
    ),
  };
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

List<String> _scopes(String group) => switch (group) {
  'spaces' => const ['GAP'],
  'radii' => const ['CORNER_RADIUS'],
  'fontWeights' => const ['FONT_WEIGHT'],
  _ => const ['ALL_SCOPES'],
};
