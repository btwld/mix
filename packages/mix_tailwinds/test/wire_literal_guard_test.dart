import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mix_tailwinds runtime does not import mix_schema', () {
    final runtimeFiles = [
      'lib/src/tw_parser.dart',
      'lib/src/tw_widget.dart',
      'lib/src/tw_flex_item.dart',
      'lib/src/translate/tw_translator.dart',
      'lib/src/translate/tw_accumulators.dart',
    ].map(File.new);

    for (final file in runtimeFiles) {
      expect(
        file.readAsStringSync(),
        isNot(contains('package:mix_schema/')),
        reason: file.path,
      );
    }
  });
}
