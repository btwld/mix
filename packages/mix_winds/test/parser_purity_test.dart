import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parser directory stays Flutter and Mix free', () {
    final files = Directory('lib/src/parser')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in files) {
      final source = file.readAsStringSync();
      expect(source, isNot(contains("package:flutter")), reason: file.path);
      expect(source, isNot(contains("package:mix/")), reason: file.path);
    }
  });
}
