import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/runtime/drift_checker.dart';

void main() {
  const expectedPath = String.fromEnvironment('MIX_FIGMA_EXPECTED');
  const actualPath = String.fromEnvironment('MIX_FIGMA_ACTUAL');
  const kind = String.fromEnvironment('MIX_FIGMA_KIND');

  test('authored protocol documents are valid and drift-free', () {
    expect(expectedPath, isNotEmpty);
    expect(actualPath, isNotEmpty);
    final expected = jsonDecode(File(expectedPath).readAsStringSync());
    final actual = jsonDecode(File(actualPath).readAsStringSync());
    final report = kind == 'style'
        ? compareStyleDocuments(expected, actual)
        : compareThemeDocuments(expected, actual);
    expect(report.isClean, isTrue, reason: jsonEncode(report.toJson()));
  });
}
