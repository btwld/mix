import '../json_map.dart';
import 'dtcg_document.dart';

/// Parses a DTCG 2025.10 or Tokens Studio-compatible token tree.
DtcgDocument parseDtcgDocument(JsonMap json) {
  final tokens = <String, DtcgToken>{};
  final rootExtensions = json['\$extensions'] == null
      ? <String, Object?>{}
      : jsonObject(json['\$extensions'], path: r'/$extensions');
  final metadata = <String, Object?>{
    for (final entry in json.entries)
      if (entry.key.startsWith(r'$') &&
          entry.key != r'$extensions' &&
          entry.key != r'$type')
        entry.key: entry.value,
  };

  void visit(
    JsonMap node,
    List<String> path,
    String? inheritedType,
    _DtcgSyntax? inheritedSyntax,
  ) {
    final typeKey = node.containsKey(r'$type')
        ? r'$type'
        : node['type'] is String
        ? 'type'
        : null;
    final localType = typeKey == null ? null : node[typeKey];
    if (localType != null && localType is! String) {
      throw FormatException(
        'Expected a string at /${[...path, typeKey].join('/')}.',
      );
    }
    final type = localType as String? ?? inheritedType;
    final _DtcgSyntax? syntax = switch (typeKey) {
      r'$type' => .dtcg,
      'type' => .tokensStudio,
      _ => inheritedSyntax,
    };
    final valueKey = node.containsKey(r'$value')
        ? r'$value'
        : syntax == .tokensStudio && node.containsKey('value')
        ? 'value'
        : null;
    if (valueKey != null) {
      if (path.isEmpty) {
        throw const FormatException('A root DTCG token needs a name.');
      }
      if (type == null || type.isEmpty) {
        throw FormatException('Token ${path.join('.')} has no type.');
      }
      final tokenPath = path.join('.');
      final extensionsKey = node.containsKey(r'$extensions')
          ? r'$extensions'
          : syntax == .tokensStudio && node.containsKey('extensions')
          ? 'extensions'
          : null;
      final extensions = extensionsKey == null
          ? <String, Object?>{}
          : jsonObject(
              node[extensionsKey],
              path: '/${[...path, extensionsKey].join('/')}',
            );
      tokens[tokenPath] = DtcgToken(
        path: tokenPath,
        type: type,
        value: node[valueKey],
        description: _description(node, syntax),
        extensions: extensions,
      );

      return;
    }

    for (final entry in node.entries) {
      if (entry.key.startsWith(r'$') ||
          syntax == .tokensStudio && _isLegacyMetadata(entry.key)) {
        continue;
      }
      visit(
        jsonObject(entry.value, path: '/${[...path, entry.key].join('/')}'),
        [...path, entry.key],
        type,
        syntax,
      );
    }
  }

  visit(json, const [], null, null);

  return DtcgDocument(
    tokens: tokens,
    extensions: rootExtensions,
    metadata: metadata,
    source: _deepCopy(json) as JsonMap,
  );
}

String? _description(JsonMap node, _DtcgSyntax? syntax) {
  final value = node.containsKey(r'$description')
      ? node[r'$description']
      : syntax == .tokensStudio
      ? node['description']
      : null;

  return value is String ? value : null;
}

bool _isLegacyMetadata(String key) {
  return switch (key) {
    'type' || 'value' || 'description' || 'extensions' => true,
    _ => false,
  };
}

enum _DtcgSyntax { dtcg, tokensStudio }

Object? _deepCopy(Object? value) {
  return switch (value) {
    Map() => <String, Object?>{
      for (final entry in value.entries)
        entry.key as String: _deepCopy(entry.value),
    },
    List() => value.map(_deepCopy).toList(),
    _ => value,
  };
}
