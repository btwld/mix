import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the public library does not expose fl_chart', () {
    final publicFiles = <File>[
      File('lib/mix_chart.dart'),
      ...Directory('lib/src/public')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart')),
    ];

    for (final file in publicFiles) {
      final source = file.readAsStringSync();
      expect(
        source,
        isNot(contains('package:fl_chart')),
        reason: '${file.path} leaks the renderer dependency',
      );
      expect(
        source,
        isNot(matches(RegExp(r'\bFl[A-Z]\w*'))),
        reason: '${file.path} exposes a renderer-prefixed type',
      );
    }
  });

  test('direct fl_chart imports stay inside the backend boundary', () {
    final dartFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    final rendererImports = dartFiles.where(
      (file) => file.readAsStringSync().contains('package:fl_chart'),
    );

    for (final file in rendererImports) {
      expect(
        file.path,
        startsWith('lib/src/backend/fl_chart/'),
        reason: '${file.path} crosses the renderer boundary',
      );
    }
  });

  test('consumer-facing examples and documentation use only mix_chart', () {
    final consumerFiles = <File>[
      File('README.md'),
      File('example/README.md'),
      ...Directory('example/lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart')),
      ...Directory('example/test')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart')),
    ];

    for (final file in consumerFiles) {
      final source = file.readAsStringSync();
      expect(
        source,
        isNot(contains('package:fl_chart')),
        reason: '${file.path} bypasses the Mix-owned chart API',
      );
      expect(
        source,
        isNot(contains('mix_fl_charts')),
        reason: '${file.path} still names the superseded package',
      );
    }
  });
}
