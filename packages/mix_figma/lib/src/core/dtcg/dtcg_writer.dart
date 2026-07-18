import '../json_map.dart';
import 'dtcg_document.dart';

/// Emits a DTCG tree, preserving parsed extension placement when available.
JsonMap writeDtcgDocument(DtcgDocument document) {
  final source = document.source;
  if (source != null) return _deepCopy(source) as JsonMap;

  final result = <String, Object?>{
    ...document.metadata,
    if (document.extensions.isNotEmpty) r'$extensions': document.extensions,
  };
  for (final token in document.tokens.values) {
    final segments = token.path.split('.');
    var parent = result;
    for (final segment in segments.take(segments.length - 1)) {
      parent =
          parent.putIfAbsent(segment, () => <String, Object?>{}) as JsonMap;
    }
    parent[segments.last] = <String, Object?>{
      r'$type': token.type,
      r'$value': token.value,
      r'$description': ?token.description,
      if (token.extensions.isNotEmpty) r'$extensions': token.extensions,
    };
  }

  return result;
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
