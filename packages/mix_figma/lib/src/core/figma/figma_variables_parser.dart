import '../json_map.dart';
import 'figma_variables_document.dart';

/// Parses the values-bearing variable payload emitted by the plugin.
FigmaVariablesDocument parseFigmaVariablesDocument(JsonMap json) {
  final schema = json['schema'];
  if (schema != null && schema != 'mix_figma/figma-variables/v1') {
    throw FormatException('Unsupported Figma variables schema "$schema".');
  }
  final collections = <FigmaVariableCollection>[];
  final rawCollections = jsonList(json['collections'], path: '/collections');
  for (final (index, raw) in rawCollections.indexed) {
    final value = jsonObject(raw, path: '/collections/$index');
    final modes = <FigmaVariableMode>[];
    final rawModes = jsonList(
      value['modes'],
      path: '/collections/$index/modes',
    );
    for (final (modeIndex, rawMode) in rawModes.indexed) {
      final mode = jsonObject(
        rawMode,
        path: '/collections/$index/modes/$modeIndex',
      );
      modes.add(
        FigmaVariableMode(
          id: jsonString(
            mode['id'] ?? mode['modeId'],
            path: '/collections/$index/modes/$modeIndex/id',
          ),
          name: jsonString(
            mode['name'],
            path: '/collections/$index/modes/$modeIndex/name',
          ),
        ),
      );
    }
    collections.add(
      FigmaVariableCollection(
        key: value['key'] is String ? value['key']! as String : '',
        id: jsonString(value['id'], path: '/collections/$index/id'),
        name: jsonString(value['name'], path: '/collections/$index/name'),
        defaultModeId: jsonString(
          value['defaultModeId'],
          path: '/collections/$index/defaultModeId',
        ),
        modes: modes,
        pluginData: _stringMap(
          value['pluginData'],
          path: '/collections/$index/pluginData',
        ),
        hiddenFromPublishing: value['hiddenFromPublishing'] == true,
        remote: value['remote'] == true,
      ),
    );
  }

  final variables = <FigmaVariable>[];
  final rawVariables = jsonList(json['variables'], path: '/variables');
  for (final (index, raw) in rawVariables.indexed) {
    final value = jsonObject(raw, path: '/variables/$index');
    final rawValues = jsonObject(
      value['valuesByMode'],
      path: '/variables/$index/valuesByMode',
    );
    final valuesByMode = <String, Object?>{};
    for (final entry in rawValues.entries) {
      final modeValue = entry.value;
      if (modeValue is Map && modeValue['type'] == 'VARIABLE_ALIAS') {
        final alias = jsonObject(
          modeValue,
          path: '/variables/$index/valuesByMode/${entry.key}',
        );
        valuesByMode[entry.key] = FigmaVariableAlias(
          jsonString(
            alias['id'],
            path: '/variables/$index/valuesByMode/${entry.key}/id',
          ),
        );
      } else {
        valuesByMode[entry.key] = modeValue;
      }
    }
    variables.add(
      FigmaVariable(
        id: jsonString(value['id'], path: '/variables/$index/id'),
        name: jsonString(value['name'], path: '/variables/$index/name'),
        collectionId: jsonString(
          value['collectionId'] ?? value['variableCollectionId'],
          path: '/variables/$index/collectionId',
        ),
        resolvedType: _variableType(
          jsonString(
            value['resolvedType'],
            path: '/variables/$index/resolvedType',
          ),
        ),
        valuesByMode: valuesByMode,
        scopes: _stringList(value['scopes'], path: '/variables/$index/scopes'),
        codeSyntax: _stringMap(
          value['codeSyntax'],
          path: '/variables/$index/codeSyntax',
        ),
        pluginData: _stringMap(
          value['pluginData'],
          path: '/variables/$index/pluginData',
        ),
        description: value['description'] is String
            ? value['description']! as String
            : '',
        remote: value['remote'] == true,
      ),
    );
  }

  final collectionIds = collections.map((item) => item.id).toSet();
  for (final variable in variables) {
    if (!collectionIds.contains(variable.collectionId)) {
      throw FormatException(
        'Variable ${variable.id} references unknown collection '
        '${variable.collectionId}.',
      );
    }
  }

  return FigmaVariablesDocument(collections: collections, variables: variables);
}

FigmaVariableType _variableType(String value) {
  return switch (value.toUpperCase()) {
    'COLOR' => .color,
    'FLOAT' => .float,
    'STRING' => .string,
    'BOOLEAN' => .boolean,
    _ => throw FormatException('Unknown Figma variable type "$value".'),
  };
}

List<String> _stringList(Object? value, {required String path}) {
  if (value == null) return const [];

  return jsonList(
    value,
    path: path,
  ).map((item) => jsonString(item, path: path)).toList(growable: false);
}

Map<String, String> _stringMap(Object? value, {required String path}) {
  if (value == null) return const {};
  final object = jsonObject(value, path: path);

  return {
    for (final entry in object.entries)
      entry.key: jsonString(entry.value, path: '$path/${entry.key}'),
  };
}
