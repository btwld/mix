import '../json_map.dart';

/// One source fixture and its observable conformance expectations.
final class MixFigmaConformanceCase {
  final String id;
  final String kind;
  final String source;
  final JsonMap expected;
  MixFigmaConformanceCase({
    required this.id,
    required this.kind,
    required this.source,
    required JsonMap expected,
  }) : expected = Map.unmodifiable(expected);
}

/// Shared fixture inventory used by Dart, TypeScript, and the live runbook.
final class MixFigmaConformanceManifest {
  final List<MixFigmaConformanceCase> cases;
  MixFigmaConformanceManifest({
    required Iterable<MixFigmaConformanceCase> cases,
  }) : cases = List.unmodifiable(cases);
}

MixFigmaConformanceManifest parseMixFigmaConformanceManifest(JsonMap json) {
  if (json['schema'] != 'mix_figma/conformance/v1') {
    throw const FormatException('Unsupported Mix Figma conformance schema.');
  }
  final cases = <MixFigmaConformanceCase>[];
  final ids = <String>{};
  final rawCases = jsonList(json['cases'], path: '/cases');
  for (final (index, raw) in rawCases.indexed) {
    final item = jsonObject(raw, path: '/cases/$index');
    final id = jsonString(item['id'], path: '/cases/$index/id');
    if (!ids.add(id)) {
      throw FormatException('Duplicate conformance case id "$id".');
    }
    final kind = jsonString(item['kind'], path: '/cases/$index/kind');
    if (!const {
      'variables',
      'styles',
      'selection',
      'component',
    }.contains(kind)) {
      throw FormatException('Unsupported conformance case kind "$kind".');
    }
    final source = jsonString(item['source'], path: '/cases/$index/source');
    if (source.isEmpty || Uri.file(source).isAbsolute) {
      throw FormatException(
        'Conformance source must be a relative path: "$source".',
      );
    }
    cases.add(
      MixFigmaConformanceCase(
        id: id,
        kind: kind,
        source: source,
        expected: jsonObject(item['expected'], path: '/cases/$index/expected'),
      ),
    );
  }
  if (cases.isEmpty) {
    throw const FormatException('Conformance manifest must contain cases.');
  }

  return MixFigmaConformanceManifest(cases: cases);
}
