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

  void visit(JsonMap node, List<String> path, String? inheritedType) {
    final localType = node[r'$type'];
    if (localType != null && localType is! String) {
      throw FormatException(
        'Expected a string at /${[...path, r'$type'].join('/')}.',
      );
    }
    final type = localType as String? ?? inheritedType;
    if (node.containsKey(r'$value')) {
      if (path.isEmpty) {
        throw const FormatException('A root DTCG token needs a name.');
      }
      if (type == null || type.isEmpty) {
        throw FormatException('Token ${path.join('.')} has no \$type.');
      }
      final tokenPath = path.join('.');
      final extensions = node[r'$extensions'] == null
          ? <String, Object?>{}
          : jsonObject(
              node[r'$extensions'],
              path: '/${[...path, r'$extensions'].join('/')}',
            );
      tokens[tokenPath] = DtcgToken(
        path: tokenPath,
        type: type,
        value: node[r'$value'],
        description: node[r'$description'] is String
            ? node[r'$description']! as String
            : null,
        extensions: extensions,
      );

      return;
    }

    for (final entry in node.entries) {
      if (entry.key.startsWith(r'$')) continue;
      visit(
        jsonObject(entry.value, path: '/${[...path, entry.key].join('/')}'),
        [...path, entry.key],
        type,
      );
    }
  }

  visit(json, const [], json[r'$type'] as String?);

  return DtcgDocument(
    tokens: tokens,
    extensions: rootExtensions,
    metadata: metadata,
    source: _deepCopy(json) as JsonMap,
  );
}

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
