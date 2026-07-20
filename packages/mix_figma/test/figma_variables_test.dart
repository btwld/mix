import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/diagnostics/mix_figma_coverage_report.dart';
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

  test('retains collection identity metadata needed for safe sync', () {
    final fixture = _fixture();
    final collection = (fixture['collections']! as List).single as Map;
    collection['key'] = 'collection-key';
    collection['hiddenFromPublishing'] = true;
    collection['pluginData'] = {'mix_figma.id': 'Mix Tokens'};

    final parsed = parseFigmaVariablesDocument(fixture).collections.single;

    expect(parsed.key, 'collection-key');
    expect(parsed.hiddenFromPublishing, isTrue);
    expect(parsed.pluginData, {'mix_figma.id': 'Mix Tokens'});
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

  test('rejects aliases across inferred protocol token groups', () {
    final document = parseFigmaVariablesDocument({
      'version': 1,
      'collections': [
        {
          'id': 'collection-core',
          'key': 'core',
          'name': 'Core',
          'defaultModeId': 'mode-light',
          'modes': [
            {'modeId': 'mode-light', 'name': 'Light'},
          ],
          'remote': false,
          'hiddenFromPublishing': false,
          'variableIds': ['double-base', 'space-alias'],
          'pluginData': <String, Object?>{},
        },
      ],
      'variables': [
        _variable(
          id: 'double-base',
          name: 'opacity/base',
          value: 0.5,
          scopes: ['OPACITY'],
        ),
        _variable(
          id: 'space-alias',
          name: 'space/alias',
          value: {'type': 'VARIABLE_ALIAS', 'id': 'double-base'},
          scopes: ['GAP'],
        ),
      ],
    });

    final result = buildProtocolThemeJsonFromFigmaVariables(
      document,
      modeId: 'mode-light',
    );

    expect(
      result.diagnostics.map((diagnostic) => diagnostic.code),
      contains('cross_group_alias'),
    );
    expect((result.value['spaces'] as Map?)?['space.alias'], isNull);
    expect(
      result.coverage.items
          .singleWhere((item) => item.id == 'space-alias')
          .status,
      MixFigmaCoverageStatus.unsupported,
    );
  });
}

Map<String, Object?> _variable({
  required String id,
  required String name,
  required Object value,
  required List<String> scopes,
}) => {
  'id': id,
  'key': id,
  'name': name,
  'description': '',
  'variableCollectionId': 'collection-core',
  'resolvedType': 'FLOAT',
  'valuesByMode': {'mode-light': value},
  'scopes': scopes,
  'codeSyntax': <String, Object?>{},
  'remote': false,
  'hiddenFromPublishing': false,
  'pluginData': <String, Object?>{},
};

Map<String, Object?> _fixture() =>
    jsonDecode(
          File(
            'test/fixtures/figma_variables/primitives.json',
          ).readAsStringSync(),
        )
        as Map<String, Object?>;
