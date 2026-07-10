import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mix_tailwinds runtime does not import mix_protocol', () {
    final runtimeFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .toList(growable: false);

    expect(runtimeFiles, isNotEmpty);

    for (final file in runtimeFiles) {
      expect(
        file.readAsStringSync(),
        isNot(contains('package:mix_protocol/')),
        reason: file.path,
      );
    }
  });
}
