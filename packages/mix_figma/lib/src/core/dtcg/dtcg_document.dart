import '../json_map.dart';

/// One flattened DTCG token.
final class DtcgToken {
  final String path;

  final String type;
  final Object? value;
  final String? description;
  final JsonMap extensions;
  DtcgToken({
    required this.path,
    required this.type,
    required this.value,
    this.description,
    JsonMap extensions = const {},
  }) : extensions = Map.unmodifiable(extensions);

  String? get mixGroup {
    final extension = extensions['com.btwld.mix'];
    if (extension is! Map) return null;
    final group = extension['group'];

    return group is String ? group : null;
  }
}

/// Flattened DTCG document plus source metadata for lossless re-emission.
final class DtcgDocument {
  final Map<String, DtcgToken> tokens;

  final JsonMap extensions;
  final JsonMap metadata;
  final JsonMap? source;
  DtcgDocument({
    required Map<String, DtcgToken> tokens,
    JsonMap extensions = const {},
    JsonMap metadata = const {},
    JsonMap? source,
  }) : tokens = Map.unmodifiable(tokens),
       extensions = Map.unmodifiable(extensions),
       metadata = Map.unmodifiable(metadata),
       source = source == null ? null : Map.unmodifiable(source);
}
