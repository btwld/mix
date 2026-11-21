import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart_protocol/mix_chart_protocol.dart';
import 'package:mix_protocol/testing.dart';

import 'schema_fixtures/chart_schema_cases.dart';

/// Keeps `schema/` current: the composed chart style schema plus the
/// documents that pin its acceptance boundary and the declared v1 wire.
///
/// Regenerate with `flutter test --update-goldens test/schema_fixtures_test.dart`
/// (or `melos run schema:fixtures`). The Ajv check in
/// `packages/mix_protocol/tool/schema-check` validates the checked-in files.
void main() {
  test('checked-in schema and fixtures are current', () {
    final protocol = mixChartProtocol;
    final accept = <SchemaFixtureCase>[
      for (final (index, style) in populatedChartStyles().indexed)
        SchemaFixtureCase(
          'populated ${style.runtimeType} $index',
          switch (protocol.encodeStyle(style)) {
            MixProtocolSuccess<JsonMap>(:final value) => value,
            MixProtocolFailure<JsonMap>(:final errors) => fail('$errors'),
          },
        ),
      for (final (branch, fields, valid) in chartFieldCases)
        if (valid)
          SchemaFixtureCase(
            '$branch ${fields.keys.single} accepted: ${fields.values.single}',
            chartFieldPayload(branch, fields),
          ),
    ];
    final reject = <SchemaFixtureCase>[
      for (final (branch, fields, valid) in chartFieldCases)
        if (!valid)
          SchemaFixtureCase(
            '$branch ${fields.keys.single} rejected: ${fields.values.single}',
            chartFieldPayload(branch, fields),
          ),
    ];

    final stale = _syncFixtureFiles(
      Directory('schema'),
      renderSchemaFixtures([
        SchemaFixtureSuite(
          name: 'style',
          schema: protocol.exportStyleJsonSchema(),
          accept: accept,
          reject: reject,
        ),
      ]),
    );

    expect(
      stale,
      isEmpty,
      reason:
          'Run `flutter test --update-goldens test/schema_fixtures_test.dart` '
          'in packages/mix_chart_protocol and commit the result.',
    );
  });
}

/// Writes or checks the rendered files under [root] and returns stale paths.
List<String> _syncFixtureFiles(Directory root, Map<String, String> files) {
  final stale = <String>[];
  for (final entry in files.entries) {
    final file = File('${root.path}/${entry.key}');
    if (autoUpdateGoldenFiles) {
      file
        ..createSync(recursive: true)
        ..writeAsStringSync(entry.value);
    } else if (!file.existsSync()) {
      stale.add('${entry.key} is missing');
    } else if (file.readAsStringSync() != entry.value) {
      stale.add('${entry.key} is stale');
    }
  }

  return stale;
}
