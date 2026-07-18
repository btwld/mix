import '../json_map.dart';

/// Stable local-to-Figma identity map kept outside protocol documents.
final class MixFigmaLock {
  final Map<String, String> collectionIds;

  final Map<String, String> variableIds;

  final Map<String, String> styleIds;
  final Map<String, String> componentIds;
  const MixFigmaLock({
    this.collectionIds = const {},
    this.variableIds = const {},
    this.styleIds = const {},
    this.componentIds = const {},
  });

  factory MixFigmaLock.fromJson(JsonMap json) {
    if (json['schema'] != 'mix_figma/lock/v1') {
      throw const FormatException('Unsupported mix_figma lock schema.');
    }

    return MixFigmaLock(
      collectionIds: _stringMap(json['collections'], path: '/collections'),
      variableIds: _stringMap(json['variables'], path: '/variables'),
      styleIds: _stringMap(json['styles'], path: '/styles'),
      componentIds: _stringMap(json['components'], path: '/components'),
    );
  }

  JsonMap toJson() => {
    'schema': 'mix_figma/lock/v1',
    'collections': collectionIds,
    'variables': variableIds,
    'styles': styleIds,
    'components': componentIds,
  };
}

Map<String, String> _stringMap(Object? value, {required String path}) {
  if (value == null) return const {};
  final object = jsonObject(value, path: path);

  return Map.unmodifiable({
    for (final entry in object.entries)
      entry.key: jsonString(entry.value, path: '$path/${entry.key}'),
  });
}
