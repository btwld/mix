import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_component_contract/mix_component_contract.dart';
import 'package:mix_figma/src/core/figma/figma_styles_parser.dart';
import 'package:mix_figma/src/core/figma/figma_variables_parser.dart';
import 'package:mix_figma/src/core/protocol_json/component_set_payload.dart';
import 'package:mix_figma/src/core/protocol_json/figma_style_payloads.dart';
import 'package:mix_figma/src/core/protocol_json/figma_variable_payload.dart';

void main() {
  test(
    'reads the plugin variable and style DTOs without transport adapters',
    () {
      final variables = parseFigmaVariablesDocument({
        'version': 1,
        'collections': [
          {
            'id': 'collection:1',
            'name': 'Core',
            'defaultModeId': 'mode:light',
            'modes': [
              {'modeId': 'mode:light', 'name': 'Light'},
            ],
          },
        ],
        'variables': [
          {
            'id': 'variable:1',
            'name': 'color/brand',
            'variableCollectionId': 'collection:1',
            'resolvedType': 'COLOR',
            'valuesByMode': {
              'mode:light': {'r': 0.2, 'g': 0.4, 'b': 0.6, 'a': 1},
            },
            'scopes': ['ALL_FILLS'],
            'codeSyntax': {'WEB': 'mix://colors/color.brand'},
            'pluginData': <String, Object?>{},
          },
        ],
      });
      final styles = parseFigmaStylesDocument({
        'version': 1,
        'textStyles': [
          {
            'id': 'style:1',
            'key': 'style-key',
            'name': 'type/body',
            'kind': 'TEXT',
            'fontName': {'family': 'Inter', 'style': 'Regular'},
            'fontSize': 14,
            'letterSpacing': {'unit': 'PIXELS', 'value': 0},
            'lineHeight': {'unit': 'PERCENT', 'value': 140},
            'pluginData': <String, Object?>{},
          },
        ],
        'effectStyles': <Object?>[],
        'paintStyles': <Object?>[],
      });

      expect(variables.variables.single.collectionId, 'collection:1');
      expect(variables.collections.single.modes.single.id, 'mode:light');
      expect(styles.styles.single.value['fontFamily'], 'Inter');
    },
  );

  test('write builders emit the DTOs consumed by the TypeScript plugin', () {
    final theme = <String, Object?>{
      'v': 1,
      'type': 'theme',
      'colors': {
        'color.brand': '#336699',
        'color.accent': {r'$token': 'color.brand'},
      },
      'textStyles': {
        'type.body': {
          'fontFamily': 'Inter',
          'fontSize': 14,
          'fontWeight': 'w400',
        },
      },
    };
    final variables = buildFigmaVariableWritePayload({'light': theme}).value;
    final styles = buildFigmaStylePayloads(theme).value;

    expect(variables['version'], 1);
    expect(variables['collections'], isA<List<Object?>>());
    final variable = ((variables['variables']! as List).first! as Map);
    expect(variable.keys, containsAll(['ref', 'collectionRef', 'identity']));
    expect(
      ((variable['valuesByMode']! as Map).values.whereType<Map>().first)['ref'],
      'colors/color.brand',
    );
    expect(styles['version'], 1);
    expect(styles['textStyles'], hasLength(1));
    expect(styles['effectStyles'], isEmpty);
  });

  test('component payload exposes plugin variants with a nested root', () {
    final bytes = File(
      '../mix_component_contract/test/fixtures/component_v2.component.json',
    ).readAsBytesSync();
    final component = parsePortableComponentDocument(
      Uint8List.fromList(bytes),
      path: 'component_v2.component.json',
    );
    final payload = buildComponentSetPayload(component).value;

    expect(payload['version'], 1);
    expect(payload['ref'], component.id);
    final variants = (payload['variants']! as List).cast<Map>();
    expect(variants, hasLength(2));
    expect(variants.first['root'], isA<Map>());
    expect((variants.first['root']! as Map)['kind'], 'FRAME');
  });
}
