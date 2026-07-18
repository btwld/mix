import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/figma/figma_variables_document.dart';
import 'package:mix_figma/src/core/figma/figma_variables_parser.dart';
import 'package:mix_figma/src/core/protocol_json/theme_from_figma_variables.dart';

void main() {
  test('parses values, aliases, scopes, and code syntax', () {
    final document = parseFigmaVariablesDocument(_fixture());

    expect(document.collections.single.modes, hasLength(2));
    expect(document.variables, hasLength(8));
    expect(
      document.variables[1].valuesByMode['mode-light'],
      isA<FigmaVariableAlias>().having(
        (alias) => alias.variableId,
        'variableId',
        'color-primary',
      ),
    );
    expect(document.variables[3].codeSyntax['WEB'], startsWith('mix://'));
  });

  test('builds per-mode primitive theme docs with exhaustive coverage', () {
    final document = parseFigmaVariablesDocument(_fixture());
    final result = buildProtocolThemeJsonFromFigmaVariables(
      document,
      modeId: 'mode-light',
    );

    expect(result.value, {
      'v': 1,
      'type': 'theme',
      'colors': {
        'color.brand.accent': {r'$token': 'color.brand.primary'},
        'color.brand.primary': '#336699',
      },
      'spaces': {'space.stack.sm': 8},
      'doubles': {'number.ambiguous': 2, 'opacity.disabled': 0.64},
      'radii': {'radius.card': 12},
      'fontWeights': {'weight.strong': 'w700'},
    });
    expect(result.coverage.items, hasLength(8));
    expect(result.coverage.supportedCount, 7);
    expect(result.coverage.unsupportedCount, 1);
    expect(
      result.diagnostics.map((diagnostic) => diagnostic.code),
      containsAll(['ambiguous_float_variable', 'unsupported_variable_type']),
    );
  });
}

Map<String, Object?> _fixture() =>
    jsonDecode(
          File(
            'test/fixtures/figma_variables/primitives.json',
          ).readAsStringSync(),
        )
        as Map<String, Object?>;
