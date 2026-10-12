import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_protocol/mix_protocol.dart';
import 'package:mix_protocol/testing.dart';
import 'package:mix_winds/mix_winds.dart';

import 'protocol_ledger_cases.dart';

/// Keeps `schema/fixtures/style.json` current: one encoded document per
/// supported ledger family and per variant root, all of which the core
/// Protocol schema must accept.
///
/// Regenerate with `flutter test --update-goldens test/schema_fixtures_test.dart`
/// (or `melos run schema:fixtures`). The Ajv check in
/// `packages/mix_protocol/tool/schema-check` validates the checked-in
/// documents against `packages/mix_protocol/schema/style.schema.json`.
void main() {
  test('checked-in Protocol fixtures are current', () {
    final parser = TwParser();
    JsonMap encode(Object style, String label) =>
        switch (mixProtocol.encodeStyle(style)) {
          MixProtocolSuccess<JsonMap>(:final value) => value,
          MixProtocolFailure<JsonMap>(:final errors) => fail('$label: $errors'),
        };

    final accept = <SchemaFixtureCase>[
      for (final entry in ledgerUtilityCases)
        SchemaFixtureCase(
          '${entry.kind.name}/${entry.root}',
          encode(
            compileLedgerCase(parser, entry.target, entry.classes).styler,
            entry.classes,
          ),
        ),
      for (final variant in ledgerVariantRoots)
        for (final target in LedgerTarget.values)
          SchemaFixtureCase(
            '$variant/${target.name}',
            encode(
              compileLedgerCase(
                parser,
                target,
                ledgerVariantClasses(variant, target),
              ).styler,
              '$variant/${target.name}',
            ),
          ),
    ];

    final stale = _syncFixtureFiles(
      Directory('schema'),
      renderSchemaFixtures([
        SchemaFixtureSuite(
          name: 'style',
          schemaPath: '../../mix_protocol/schema/style.schema.json',
          accept: accept,
          reject: const [],
        ),
      ]),
    );

    expect(
      stale,
      isEmpty,
      reason:
          'Run `flutter test --update-goldens test/schema_fixtures_test.dart` '
          'in packages/mix_winds and commit the result.',
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
