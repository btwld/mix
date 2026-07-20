import '../json_map.dart';

/// Stable local-to-Figma identity map kept outside protocol documents.
final class MixFigmaLock {
  /// An empty lock suitable for optional payload-builder defaults.
  static const empty = MixFigmaLock._empty();

  final Map<String, String> _collectionIds;

  final Map<String, Map<String, String>> _modeIds;

  final Map<String, String> _variableIds;

  final Map<String, String> _styleIds;
  final Map<String, String> _componentIds;
  MixFigmaLock({
    Map<String, String> collectionIds = const {},
    Map<String, Map<String, String>> modeIds = const {},
    Map<String, String> variableIds = const {},
    Map<String, String> styleIds = const {},
    Map<String, String> componentIds = const {},
  }) : _collectionIds = Map.unmodifiable(Map.of(collectionIds)),
       _modeIds = _immutableNestedMap(modeIds),
       _variableIds = Map.unmodifiable(Map.of(variableIds)),
       _styleIds = Map.unmodifiable(Map.of(styleIds)),
       _componentIds = Map.unmodifiable(Map.of(componentIds));

  const MixFigmaLock._empty()
    : _collectionIds = const {},
      _modeIds = const {},
      _variableIds = const {},
      _styleIds = const {},
      _componentIds = const {};

  factory MixFigmaLock.fromJson(JsonMap json) {
    final schema = json['schema'];
    if (schema != 'mix_figma/lock/v1' && schema != 'mix_figma/lock/v2') {
      throw const FormatException('Unsupported mix_figma lock schema.');
    }

    return MixFigmaLock(
      collectionIds: _stringMap(json['collections'], path: '/collections'),
      modeIds: schema == 'mix_figma/lock/v2'
          ? _nestedStringMap(json['modes'], path: '/modes')
          : const {},
      variableIds: _stringMap(json['variables'], path: '/variables'),
      styleIds: _stringMap(json['styles'], path: '/styles'),
      componentIds: _stringMap(json['components'], path: '/components'),
    );
  }

  /// Figma variable collection IDs keyed by stable local collection reference.
  Map<String, String> get collectionIds => _collectionIds;

  /// Figma mode IDs keyed first by collection reference, then mode reference.
  Map<String, Map<String, String>> get modeIds => _modeIds;

  /// Figma variable IDs keyed by stable local variable reference.
  Map<String, String> get variableIds => _variableIds;

  /// Figma style IDs keyed by stable local style reference.
  Map<String, String> get styleIds => _styleIds;

  /// Figma component set IDs keyed by stable local component reference.
  Map<String, String> get componentIds => _componentIds;

  /// Returns a copy with replacement maps, without exposing mutable state.
  MixFigmaLock copyWith({
    Map<String, String>? collectionIds,
    Map<String, Map<String, String>>? modeIds,
    Map<String, String>? variableIds,
    Map<String, String>? styleIds,
    Map<String, String>? componentIds,
  }) => .new(
    collectionIds: {...(collectionIds ?? _collectionIds)},
    modeIds: {...(modeIds ?? _modeIds)},
    variableIds: {...(variableIds ?? _variableIds)},
    styleIds: {...(styleIds ?? _styleIds)},
    componentIds: {...(componentIds ?? _componentIds)},
  );

  /// Merges the result returned by the plugin's `write-tokens` operation.
  ///
  MixFigmaLock mergeTokenWriteResult(JsonMap result) {
    final variables = jsonObject(result['variables'], path: '/variables');
    final styles = jsonObject(result['styles'], path: '/styles');
    final collections = _requiredStringMap(
      variables['collections'],
      path: '/variables/collections',
    );
    final modes = _nestedStringMap(
      variables['modes'],
      path: '/variables/modes',
      isRequired: true,
    );
    final variablesByRef = _requiredStringMap(
      variables['variables'],
      path: '/variables/variables',
    );
    final textStyles = _requiredStringMap(
      styles['textStyles'],
      path: '/styles/textStyles',
    );
    final effectStyles = _requiredStringMap(
      styles['effectStyles'],
      path: '/styles/effectStyles',
    );
    final paintStyles = _requiredStringMap(
      styles['paintStyles'],
      path: '/styles/paintStyles',
    );

    return MixFigmaLock(
      collectionIds: {..._collectionIds, ...collections},
      modeIds: {
        ..._modeIds,
        for (final entry in modes.entries)
          entry.key: {...?_modeIds[entry.key], ...entry.value},
      },
      variableIds: {..._variableIds, ...variablesByRef},
      styleIds: {..._styleIds, ...textStyles, ...effectStyles, ...paintStyles},
      componentIds: {..._componentIds},
    );
  }

  /// Merges the result returned by the plugin's `write-component-set` operation.
  MixFigmaLock mergeComponentWriteResult(String componentRef, JsonMap result) {
    if (componentRef.isEmpty) {
      throw ArgumentError.value(
        componentRef,
        'componentRef',
        'Must not be empty.',
      );
    }

    return MixFigmaLock(
      collectionIds: {..._collectionIds},
      modeIds: {..._modeIds},
      variableIds: {..._variableIds},
      styleIds: {..._styleIds},
      componentIds: {
        ..._componentIds,
        componentRef: jsonString(
          result['componentSetId'],
          path: '/componentSetId',
        ),
      },
    );
  }

  JsonMap toJson() => {
    'schema': 'mix_figma/lock/v2',
    'collections': {..._collectionIds},
    'modes': {
      for (final entry in _modeIds.entries) entry.key: {...entry.value},
    },
    'variables': {..._variableIds},
    'styles': {..._styleIds},
    'components': {..._componentIds},
  };
}

Map<String, Map<String, String>> _immutableNestedMap(
  Map<String, Map<String, String>> value,
) => .unmodifiable({
  for (final entry in value.entries)
    entry.key: Map<String, String>.unmodifiable(entry.value),
});

Map<String, String> _stringMap(Object? value, {required String path}) {
  if (value == null) return const {};
  final object = jsonObject(value, path: path);

  return Map.unmodifiable({
    for (final entry in object.entries)
      entry.key: jsonString(entry.value, path: '$path/${entry.key}'),
  });
}

Map<String, String> _requiredStringMap(Object? value, {required String path}) {
  if (value == null) throw FormatException('Expected an object at $path.');

  return _stringMap(value, path: path);
}

Map<String, Map<String, String>> _nestedStringMap(
  Object? value, {
  required String path,
  bool isRequired = false,
}) {
  if (value == null && !isRequired) return const {};
  if (value == null) throw FormatException('Expected an object at $path.');
  final object = jsonObject(value, path: path);
  final result = <String, Map<String, String>>{
    for (final entry in object.entries)
      entry.key: _requiredStringMap(entry.value, path: '$path/${entry.key}'),
  };

  return _immutableNestedMap(result);
}
