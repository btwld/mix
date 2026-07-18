import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/protocol_json/figma_variable_payload.dart';
import 'package:mix_figma/src/core/protocol_json/theme_from_figma_variables.dart';
import 'package:mix_figma/src/runtime/drift_checker.dart';

void main() {
  test('pull push pull reports zero drift for an aliased theme', () {
    final authored = <String, Object?>{
      'v': 1,
      'type': 'theme',
      'colors': {
        'color.base': '#112233',
        'color.alias': {r'$token': 'color.base'},
      },
    };
    final pushed = buildFigmaVariableWritePayload({'light': authored}).value;
    final pulled = buildProtocolThemeJsonFromFigmaVariables(
      figmaVariablesDocumentFromWritePayload(pushed),
      modeId: 'mode:light',
    ).value;

    expect(compareThemeDocuments(authored, pulled).isClean, isTrue);
  });

  test(
    'inspection diff detects alias flattening even when values resolve equal',
    () {
      final authored = <String, Object?>{
        'v': 1,
        'type': 'theme',
        'colors': {
          'color.base': '#112233',
          'color.alias': {r'$token': 'color.base'},
        },
      };
      final flattened = <String, Object?>{
        'v': 1,
        'type': 'theme',
        'colors': {'color.base': '#112233', 'color.alias': '#112233'},
      };
      final report = compareThemeDocuments(authored, flattened);

      expect(report.isClean, isFalse);
      expect(report.differences.single.path, '/colors/color.alias');
      expect(report.differences.single.message, contains('declaration'));
    },
  );
}
