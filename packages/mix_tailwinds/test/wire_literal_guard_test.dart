import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mix_tailwinds does not import mix_schema internals', () {
    final sourceFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in sourceFiles) {
      expect(
        file.readAsStringSync(),
        isNot(contains(['package:mix_schema', 'src'].join('/'))),
        reason: file.path,
      );
    }
  });
}
