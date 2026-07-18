import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('library remains pure Dart and independent of Mix runtime packages', () {
    final files = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in files) {
      final source = file.readAsStringSync();
      expect(source, isNot(contains("'dart:ui'")), reason: file.path);
      expect(source, isNot(contains('package:flutter')), reason: file.path);
      expect(source, isNot(contains('package:mix/')), reason: file.path);
      expect(
        source,
        isNot(contains('package:mix_protocol')),
        reason: file.path,
      );
    }
  });
}
