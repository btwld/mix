import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_protocol/mix_protocol.dart';

const _mode = String.fromEnvironment(
  'MIX_PROTOCOL_SCHEMA_EXPORT_MODE',
  defaultValue: 'check',
);

void main() {
  test('exports deterministic protocol schemas', () {
    final schemas = <String, JsonMap>{
      'schema/style.schema.json': mixProtocol.exportStyleJsonSchema(),
      'schema/theme.schema.json': mixProtocol.exportThemeJsonSchema(),
    };
    const encoder = JsonEncoder.withIndent('  ');

    for (final entry in schemas.entries) {
      final file = File(entry.key);
      final expected = '${encoder.convert(entry.value)}\n';

      if (_mode == 'write') {
        file.parent.createSync(recursive: true);
        file.writeAsStringSync(expected);
        continue;
      }

      expect(_mode, 'check', reason: 'Unsupported schema export mode.');
      expect(file.existsSync(), isTrue, reason: '${file.path} is missing.');
      expect(
        file.readAsStringSync(),
        expected,
        reason: '${file.path} is stale. Run schema export with --write.',
      );
    }
  });
}
