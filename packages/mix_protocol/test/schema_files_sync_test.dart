import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_protocol/mix_protocol.dart';

/// Keeps the committed JSON Schema files in `schema/` in sync with the
/// runtime schema export so non-Dart tooling (editors, CI validators,
/// TypeScript codegen for design-tool plugins) can consume the contract
/// without running Dart.
///
/// Regenerate with:
///
/// ```bash
/// melos run schema:export
/// ```
void main() {
  const encoder = JsonEncoder.withIndent('  ');
  final exports = <String, JsonMap Function()>{
    'schema/style.schema.json': mixProtocol.exportStyleJsonSchema,
    'schema/theme.schema.json': mixProtocol.exportThemeJsonSchema,
  };

  for (final entry in exports.entries) {
    test('${entry.key} matches the runtime schema export', () {
      final file = File(entry.key);
      final expected = '${encoder.convert(entry.value())}\n';

      if (autoUpdateGoldenFiles) {
        file
          ..createSync(recursive: true)
          ..writeAsStringSync(expected);
        return;
      }

      expect(
        file.existsSync(),
        isTrue,
        reason:
            '${entry.key} is missing. Run `melos run schema:export` and '
            'commit the result.',
      );
      expect(
        file.readAsStringSync(),
        expected,
        reason:
            '${entry.key} is stale. Run `melos run schema:export` and '
            'commit the result.',
      );
    });
  }
}
