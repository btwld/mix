import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('schema exporter check succeeds against committed artifacts', () async {
    final result = await Process.run('dart', [
      'run',
      'tool/export_schemas.dart',
      '--check',
    ]);

    expect(result.exitCode, 0, reason: '${result.stdout}\n${result.stderr}');
  });
}
