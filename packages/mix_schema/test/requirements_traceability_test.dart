import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'requirements traceability has rule-ID-named tests for R-1 through R-12',
    () {
      final testText = Directory('test')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('_test.dart'))
          .map((file) => file.readAsStringSync())
          .join('\n');

      for (var id = 1; id <= 12; id++) {
        expect(
          testText,
          contains('R-$id'),
          reason: 'Missing R-$id test marker.',
        );
      }
    },
  );
}
