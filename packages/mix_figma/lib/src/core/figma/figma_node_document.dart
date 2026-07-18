import '../json_map.dart';

/// A normalized Figma scene node with JSON-safe plugin values.
final class FigmaNode {
  final JsonMap fields;

  final List<FigmaNode> children;
  FigmaNode({required JsonMap fields, required Iterable<FigmaNode> children})
    : fields = Map.unmodifiable(fields),
      children = List.unmodifiable(children);

  String get id => fields['id']! as String;
  String get name => fields['name']! as String;
  String get type => fields['type']! as String;
  String get layoutMode =>
      fields['layoutMode'] is String ? fields['layoutMode']! as String : 'NONE';

  JsonMap get boundVariables => fields['boundVariables'] is Map
      ? (fields['boundVariables']! as Map).cast()
      : const {};
}

/// Selected Figma node document emitted by the plugin.
final class FigmaNodeDocument {
  final FigmaNode root;

  const FigmaNodeDocument({required this.root});
}

/// Parses one normalized selection tree.
FigmaNodeDocument parseFigmaNodeDocument(JsonMap json) {
  final schema = json['schema'];
  if (schema != null && schema != 'mix_figma/figma-nodes/v1') {
    throw FormatException('Unsupported Figma node schema "$schema".');
  }

  return FigmaNodeDocument(
    root: _parseNode(jsonObject(json['root'], path: '/root'), path: '/root'),
  );
}

FigmaNode _parseNode(JsonMap json, {required String path}) {
  jsonString(json['id'], path: '$path/id');
  jsonString(json['name'], path: '$path/name');
  jsonString(json['type'], path: '$path/type');
  final rawChildren = json['children'] == null
      ? const <Object?>[]
      : jsonList(json['children'], path: '$path/children');

  return FigmaNode(
    fields: {
      for (final entry in json.entries)
        if (entry.key != 'children') entry.key: entry.value,
    },
    children: [
      for (final (index, child) in rawChildren.indexed)
        _parseNode(
          jsonObject(child, path: '$path/children/$index'),
          path: '$path/children/$index',
        ),
    ],
  );
}
