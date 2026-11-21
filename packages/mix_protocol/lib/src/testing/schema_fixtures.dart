import 'dart:convert';

import '../contract/json_map.dart';

/// One JSON document that an exported schema must accept or reject.
final class SchemaFixtureCase {
  final String name;

  final JsonMap payload;
  const SchemaFixtureCase(this.name, this.payload);
}

/// One exported schema and the documents that pin its acceptance boundary.
///
/// [schema] is written beside the fixtures when present. A suite that
/// validates against another package's schema leaves it null and points
/// [schemaPath] at that file relative to the fixture root.
final class SchemaFixtureSuite {
  final String name;

  final JsonMap? schema;
  final String schemaPath;
  final List<SchemaFixtureCase> accept;
  final List<SchemaFixtureCase> reject;

  SchemaFixtureSuite({
    required this.name,
    this.schema,
    String? schemaPath,
    required this.accept,
    required this.reject,
  }) : schemaPath = schemaPath ?? '$name.schema.json' {
    if (schema == null && this.schemaPath == '$name.schema.json') {
      throw ArgumentError.value(
        schemaPath,
        'schemaPath',
        'A suite without its own schema must name the schema it validates.',
      );
    }
    for (final (label, cases) in [('accept', accept), ('reject', reject)]) {
      final names = <String>{};
      for (final fixture in cases) {
        if (!names.add(fixture.name)) {
          throw ArgumentError('Duplicate $label fixture "${fixture.name}".');
        }
      }
    }
  }

  static JsonMap _fixtureJson(SchemaFixtureCase fixture) => {
    'name': fixture.name,
    'payload': fixture.payload,
  };

  String get fixturesPath => 'fixtures/$name.json';

  JsonMap get manifestEntry => {
    'name': name,
    'schema': schemaPath,
    'fixtures': fixturesPath,
  };

  JsonMap get fixturesDocument => {
    'accept': [for (final fixture in accept) _fixtureJson(fixture)],
    'reject': [for (final fixture in reject) _fixtureJson(fixture)],
  };
}

/// Renders a package's `schema/` directory as relative path to contents.
///
/// The directory holds `manifest.json`, one `<name>.schema.json` per suite
/// that owns a schema, and `fixtures/<name>.json` with the accept and reject
/// documents. External validators such as Ajv read these files directly.
///
/// This stays free of `dart:io` so the testing library imports on every
/// platform; a golden test writes or compares the returned files.
Map<String, String> renderSchemaFixtures(List<SchemaFixtureSuite> suites) => {
  'manifest.json': _pretty({
    'suites': [for (final suite in suites) suite.manifestEntry],
  }),
  for (final suite in suites)
    if (suite.schema case final schema?) suite.schemaPath: _pretty(schema),
  for (final suite in suites)
    suite.fixturesPath: _pretty(suite.fixturesDocument),
};

String _pretty(Object? json) =>
    '${const JsonEncoder.withIndent('  ').convert(json)}\n';
