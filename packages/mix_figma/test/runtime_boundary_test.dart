import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Flutter and protocol imports stay behind the runtime boundary', () {
    final files = Directory('lib/src')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in files) {
      if (file.path.startsWith('lib/src/runtime/')) continue;
      final source = file.readAsStringSync();
      final imports = RegExp(
        r'''^import\s+['\"]([^'\"]+)['\"]''',
        multiLine: true,
      ).allMatches(source).map((match) => match.group(1)!);
      expect(
        imports.where((uri) => uri.startsWith('package:flutter')),
        isEmpty,
        reason: file.path,
      );
      expect(
        imports.where((uri) => uri.startsWith('package:mix/')),
        isEmpty,
        reason: file.path,
      );
      expect(
        imports.where((uri) => uri.startsWith('package:mix_protocol')),
        isEmpty,
        reason: file.path,
      );
    }
  });
}
