import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_protocol/mix_protocol.dart';
import 'package:mix_protocol/testing.dart';

import 'schema_fixtures/core_schema_cases.dart';

/// Keeps `schema/` current: the exported style and theme schemas plus the
/// documents that pin their acceptance boundary.
///
/// Regenerate with `flutter test --update-goldens test/schema_fixtures_test.dart`
/// (or `melos run schema:fixtures`). The Ajv check in `tool/schema-check`
/// validates the checked-in files independently of Ack.
void main() {
  final suites = [
    SchemaFixtureSuite(
      name: 'style',
      schema: mixProtocol.exportStyleJsonSchema(),
      accept: styleAcceptCases,
      reject: styleRejectCases,
    ),
    SchemaFixtureSuite(
      name: 'theme',
      schema: mixProtocol.exportThemeJsonSchema(),
      accept: themeAcceptCases,
      reject: themeRejectCases,
    ),
  ];

  test('checked-in schema and fixtures are current', () {
    final stale = _syncFixtureFiles(
      Directory('schema'),
      renderSchemaFixtures(suites),
    );

    expect(
      stale,
      isEmpty,
      reason:
          'Run `flutter test --update-goldens test/schema_fixtures_test.dart` '
          'in packages/mix_protocol and commit the result.',
    );
  });

  test('exported style schema is a Draft 7 document', () {
    final schema = mixProtocol.exportStyleJsonSchema();

    expect(schema[r'$schema'], 'http://json-schema.org/draft-07/schema#');
    expect(schema['x-mix-protocol-contract'], 'mix_protocol');
    expect(schema['x-mix-protocol-format-version'], mixProtocolFormatVersion);
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
