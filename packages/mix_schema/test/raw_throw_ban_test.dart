import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'typed-exception policy avoids raw string and generic exception throws',
    () {
      final lib = Directory('lib');
      final offenders = <String>[];

      for (final entity in lib.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final source = entity.readAsStringSync();
        if (RegExp('throw\\s+["\\\']').hasMatch(source) ||
            RegExp(r'throw\s+Exception\(').hasMatch(source)) {
          offenders.add(entity.path);
        }
      }

      expect(offenders, isEmpty);
    },
  );
}
