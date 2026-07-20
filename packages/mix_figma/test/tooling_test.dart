import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/codegen/token_source_generator.dart';

import '../tool/bridge_server.dart';

void main() {
  test('pure token generator and DTCG pull run on the standalone VM', () async {
    final temporary = Directory.systemTemp.createTempSync('mix_figma_cli_');
    addTearDown(() => temporary.deleteSync(recursive: true));
    final outputDirectory = Directory('${temporary.path}/tokens');
    final tokensOutput = '${temporary.path}/tokens.g.dart';

    final pull = await Process.run('dart', [
      'run',
      'tool/mix_figma_cli.dart',
      'pull',
      '--from',
      'dtcg',
      '--input',
      'light=test/fixtures/dtcg/light.tokens.json',
      '--input',
      'dark=test/fixtures/dtcg/dark.tokens.json',
      '--output-dir',
      outputDirectory.path,
      '--tokens-output',
      tokensOutput,
    ]);

    expect(pull.exitCode, 0, reason: '${pull.stdout}\n${pull.stderr}');
    final themes = <String, Map<String, Object?>>{
      for (final mode in ['light', 'dark'])
        mode:
            jsonDecode(
                  File(
                    '${outputDirectory.path}/$mode.theme.json',
                  ).readAsStringSync(),
                )
                as Map<String, Object?>,
    };
    expect(
      File('${outputDirectory.path}/light.theme.json').readAsStringSync(),
      File('test/fixtures/theme_docs/light.theme.json').readAsStringSync(),
    );
    expect(
      File('${outputDirectory.path}/dark.theme.json').readAsStringSync(),
      File('test/fixtures/theme_docs/dark.theme.json').readAsStringSync(),
    );
    expect(File(tokensOutput).readAsStringSync(), generateTokensSource(themes));
  });

  test('bridge merges matching modes across variable collections', () async {
    final temporary = Directory.systemTemp.createTempSync(
      'mix_figma_multi_collection_',
    );
    addTearDown(() => temporary.deleteSync(recursive: true));
    final themes = Directory('${temporary.path}/themes');
    final bridge = MixFigmaBridgeServer(
      port: 0,
      themeDirectory: themes.path,
      componentDirectory: '${temporary.path}/components',
    );
    final server = await bridge.start();
    addTearDown(() => server.close(force: true));
    final client = HttpClient();
    addTearDown(client.close);
    final base = Uri.parse('http://127.0.0.1:${server.port}');

    final preview = await _request(
      client,
      base.resolve('/sync/plan'),
      method: 'POST',
      body: {
        'version': 1,
        'direction': 'figmaToMix',
        'resource': 'tokens',
        'current': {
          'variables': {
            'version': 1,
            'collections': [
              _collection(
                id: 'collection:core',
                name: 'Core',
                modeId: 'mode:core-light',
                variableIds: ['variable:brand'],
              ),
              _collection(
                id: 'collection:semantic',
                name: 'Semantic',
                modeId: 'mode:semantic-light',
                variableIds: ['variable:radius'],
              ),
            ],
            'variables': [
              _variable(
                id: 'variable:brand',
                collectionId: 'collection:core',
                name: 'color/brand',
                resolvedType: 'COLOR',
                modeId: 'mode:core-light',
                value: {'r': 0.2, 'g': 0.4, 'b': 0.6, 'a': 1},
                scopes: ['ALL_FILLS'],
              ),
              _variable(
                id: 'variable:radius',
                collectionId: 'collection:semantic',
                name: 'radius/button',
                resolvedType: 'FLOAT',
                modeId: 'mode:semantic-light',
                value: 8,
                scopes: ['CORNER_RADIUS'],
              ),
            ],
          },
        },
      },
    );

    final artifacts = (preview['artifacts']! as Map).cast<String, Object?>();
    final light = (artifacts['themes']! as Map)['light']! as Map;
    expect(light['colors'], {'color.brand': '#336699'});
    expect(light['radii'], {'radius.button': 8});
    expect(
      (artifacts['diagnostics']! as List).cast<Map>().map(
        (item) => item['code'],
      ),
      isNot(contains('missing_mode_value')),
    );
  });

  test('bridge broadcasts one-mode primitives into semantic modes', () async {
    final temporary = Directory.systemTemp.createTempSync(
      'mix_figma_cross_collection_alias_',
    );
    addTearDown(() => temporary.deleteSync(recursive: true));
    final themes = Directory('${temporary.path}/themes')..createSync();
    final bridge = MixFigmaBridgeServer(
      port: 0,
      themeDirectory: themes.path,
      componentDirectory: '${temporary.path}/components',
    );
    final server = await bridge.start();
    addTearDown(() => server.close(force: true));
    final client = HttpClient();
    addTearDown(client.close);
    final base = Uri.parse('http://127.0.0.1:${server.port}');

    final preview = await _request(
      client,
      base.resolve('/sync/plan'),
      method: 'POST',
      body: {
        'version': 1,
        'direction': 'figmaToMix',
        'resource': 'tokens',
        'current': {
          'variables': {
            'version': 1,
            'collections': [
              {
                'id': 'collection:primitives',
                'key': 'primitives',
                'name': 'Primitives',
                'defaultModeId': 'mode:value',
                'modes': [
                  {'modeId': 'mode:value', 'name': 'Value'},
                ],
                'remote': false,
                'hiddenFromPublishing': false,
                'variableIds': ['variable:lavender', 'variable:warm'],
                'pluginData': <String, Object?>{},
              },
              {
                'id': 'collection:tailwind',
                'key': 'tailwind',
                'name': 'tw/colors',
                'defaultModeId': 'mode:tailwind',
                'modes': [
                  {'modeId': 'mode:tailwind', 'name': 'Mode 1'},
                ],
                'remote': false,
                'hiddenFromPublishing': false,
                'variableIds': ['variable:legacy-warm'],
                'pluginData': <String, Object?>{},
              },
              {
                'id': 'collection:semantic',
                'key': 'semantic',
                'name': 'Semantic',
                'defaultModeId': 'mode:light',
                'modes': [
                  {'modeId': 'mode:light', 'name': 'Light'},
                  {'modeId': 'mode:dark', 'name': 'Dark'},
                ],
                'remote': false,
                'hiddenFromPublishing': false,
                'variableIds': [
                  'variable:accent',
                  'variable:warm-accent',
                  'variable:legacy-warm-accent',
                ],
                'pluginData': <String, Object?>{},
              },
              {
                'id': 'collection:radix',
                'key': 'radix',
                'name': 'rdx/colors',
                'defaultModeId': 'mode:radix-light',
                'modes': [
                  {'modeId': 'mode:radix-light', 'name': 'light mode'},
                  {'modeId': 'mode:radix-dark', 'name': 'dark mode'},
                ],
                'remote': false,
                'hiddenFromPublishing': false,
                'variableIds': ['variable:surface'],
                'pluginData': <String, Object?>{},
              },
            ],
            'variables': [
              {
                'id': 'variable:lavender',
                'key': 'lavender',
                'name': 'lavender/500',
                'description': '',
                'variableCollectionId': 'collection:primitives',
                'resolvedType': 'COLOR',
                'valuesByMode': {
                  'mode:value': {'r': 0.65, 'g': 0.55, 'b': 0.98, 'a': 1},
                },
                'scopes': ['ALL_FILLS'],
                'codeSyntax': <String, Object?>{},
                'remote': false,
                'hiddenFromPublishing': false,
                'pluginData': <String, Object?>{},
              },
              {
                'id': 'variable:warm',
                'key': 'warm',
                'name': 'amber/500',
                'description': '',
                'variableCollectionId': 'collection:primitives',
                'resolvedType': 'COLOR',
                'valuesByMode': {
                  'mode:value': {'r': 0.96, 'g': 0.71, 'b': 0.27, 'a': 1},
                },
                'scopes': ['ALL_FILLS'],
                'codeSyntax': <String, Object?>{},
                'remote': false,
                'hiddenFromPublishing': false,
                'pluginData': <String, Object?>{},
              },
              {
                'id': 'variable:legacy-warm',
                'key': 'legacy-warm',
                'name': 'amber/500',
                'description': '',
                'variableCollectionId': 'collection:tailwind',
                'resolvedType': 'COLOR',
                'valuesByMode': {
                  'mode:tailwind': {'r': 0.96, 'g': 0.62, 'b': 0.04, 'a': 1},
                },
                'scopes': ['ALL_FILLS'],
                'codeSyntax': <String, Object?>{},
                'remote': false,
                'hiddenFromPublishing': false,
                'pluginData': <String, Object?>{},
              },
              {
                'id': 'variable:accent',
                'key': 'accent',
                'name': 'accent',
                'description': '',
                'variableCollectionId': 'collection:semantic',
                'resolvedType': 'COLOR',
                'valuesByMode': {
                  'mode:light': {
                    'type': 'VARIABLE_ALIAS',
                    'id': 'variable:lavender',
                  },
                  'mode:dark': {
                    'type': 'VARIABLE_ALIAS',
                    'id': 'variable:lavender',
                  },
                },
                'scopes': ['ALL_FILLS'],
                'codeSyntax': <String, Object?>{},
                'remote': false,
                'hiddenFromPublishing': false,
                'pluginData': <String, Object?>{},
              },
              {
                'id': 'variable:warm-accent',
                'key': 'warm-accent',
                'name': 'accent/warm',
                'description': '',
                'variableCollectionId': 'collection:semantic',
                'resolvedType': 'COLOR',
                'valuesByMode': {
                  'mode:light': {
                    'type': 'VARIABLE_ALIAS',
                    'id': 'variable:warm',
                  },
                  'mode:dark': {
                    'type': 'VARIABLE_ALIAS',
                    'id': 'variable:warm',
                  },
                },
                'scopes': ['ALL_FILLS'],
                'codeSyntax': <String, Object?>{},
                'remote': false,
                'hiddenFromPublishing': false,
                'pluginData': <String, Object?>{},
              },
              {
                'id': 'variable:legacy-warm-accent',
                'key': 'legacy-warm-accent',
                'name': 'accent/legacy-warm',
                'description': '',
                'variableCollectionId': 'collection:semantic',
                'resolvedType': 'COLOR',
                'valuesByMode': {
                  'mode:light': {
                    'type': 'VARIABLE_ALIAS',
                    'id': 'variable:legacy-warm',
                  },
                  'mode:dark': {
                    'type': 'VARIABLE_ALIAS',
                    'id': 'variable:legacy-warm',
                  },
                },
                'scopes': ['ALL_FILLS'],
                'codeSyntax': <String, Object?>{},
                'remote': false,
                'hiddenFromPublishing': false,
                'pluginData': <String, Object?>{},
              },
              {
                'id': 'variable:surface',
                'key': 'surface',
                'name': 'surface',
                'description': '',
                'variableCollectionId': 'collection:radix',
                'resolvedType': 'COLOR',
                'valuesByMode': {
                  'mode:radix-light': {'r': 1, 'g': 1, 'b': 1, 'a': 1},
                  'mode:radix-dark': {'r': 0, 'g': 0, 'b': 0, 'a': 1},
                },
                'scopes': ['ALL_FILLS'],
                'codeSyntax': <String, Object?>{},
                'remote': false,
                'hiddenFromPublishing': false,
                'pluginData': <String, Object?>{},
              },
            ],
          },
        },
      },
    );

    final artifacts = (preview['artifacts']! as Map).cast<String, Object?>();
    expect(artifacts['themes'], isNot(contains('value')));
    for (final mode in ['light', 'dark']) {
      final colors =
          ((artifacts['themes']! as Map)[mode]! as Map)['colors']! as Map;
      expect(colors['lavender.500'], '#A68CFA');
      expect(colors['accent'], {r'$token': 'lavender.500'});
      expect(colors['Primitives.amber.500'], '#F5B545');
      expect(colors['tw.colors.amber.500'], '#F59E0A');
      expect(colors['accent.warm'], {r'$token': 'Primitives.amber.500'});
      expect(colors['accent.legacy-warm'], {r'$token': 'tw.colors.amber.500'});
      expect(colors['surface'], mode == 'light' ? '#FFFFFF' : '#000000');
    }
  });

  test(
    'bridge serves transactional token, selection, and component plans',
    () async {
      final temporary = Directory.systemTemp.createTempSync(
        'mix_figma_server_',
      );
      addTearDown(() => temporary.deleteSync(recursive: true));
      final themes = Directory('${temporary.path}/themes')..createSync();
      final components = Directory('${temporary.path}/components')
        ..createSync();
      final config = File('${temporary.path}/mix_figma.yaml')
        ..writeAsStringSync('''
floatGroups:
  variables:
    variable:radius: radii
''');
      File('${themes.path}/light.theme.json').writeAsStringSync(
        File('test/fixtures/theme_docs/light.theme.json').readAsStringSync(),
      );
      File('${components.path}/fixture.component.json').writeAsBytesSync(
        File(
          '../mix_component_contract/test/fixtures/component_v2.component.json',
        ).readAsBytesSync(),
      );
      final bridge = MixFigmaBridgeServer(
        port: 0,
        themeDirectory: themes.path,
        componentDirectory: components.path,
        configPath: config.path,
      );
      final server = await bridge.start();
      addTearDown(() => server.close(force: true));
      final client = HttpClient();
      addTearDown(client.close);
      final base = Uri.parse('http://127.0.0.1:${server.port}');

      final health = await _request(client, base.resolve('/health'));
      expect(health, containsPair('status', 'ok'));

      final tokenPreview = await _request(
        client,
        base.resolve('/sync/plan'),
        method: 'POST',
        body: {
          'version': 1,
          'direction': 'figmaToMix',
          'resource': 'tokens',
          'current': {
            'variables': {
              'version': 1,
              'collections': [
                {
                  'id': 'collection:1',
                  'key': 'core',
                  'name': 'Core',
                  'defaultModeId': 'mode:light',
                  'modes': [
                    {'modeId': 'mode:light', 'name': 'Light'},
                  ],
                  'remote': false,
                  'hiddenFromPublishing': false,
                  'variableIds': ['variable:1', 'variable:radius'],
                  'pluginData': <String, Object?>{},
                },
              ],
              'variables': [
                {
                  'id': 'variable:1',
                  'key': 'brand',
                  'name': 'color/brand',
                  'description': '',
                  'variableCollectionId': 'collection:1',
                  'resolvedType': 'COLOR',
                  'valuesByMode': {
                    'mode:light': {'r': 0.2, 'g': 0.4, 'b': 0.6, 'a': 1},
                  },
                  'scopes': ['ALL_FILLS'],
                  'codeSyntax': <String, Object?>{},
                  'remote': false,
                  'hiddenFromPublishing': false,
                  'pluginData': <String, Object?>{},
                },
                {
                  'id': 'variable:radius',
                  'key': 'radius',
                  'name': 'radius/button',
                  'description': '',
                  'variableCollectionId': 'collection:1',
                  'resolvedType': 'FLOAT',
                  'valuesByMode': {'mode:light': 8},
                  'scopes': <Object?>[],
                  'codeSyntax': <String, Object?>{},
                  'remote': false,
                  'hiddenFromPublishing': false,
                  'pluginData': <String, Object?>{},
                },
              ],
            },
            'styles': {
              'version': 1,
              'styles': [
                {
                  'id': 'text-body',
                  'key': 'text-body-key',
                  'name': 'type/body',
                  'styleType': 'TEXT',
                  'value': {
                    'fontFamily': 'Inter',
                    'fontSize': 14,
                    'fontWeight': 400,
                    'lineHeight': {'unit': 'PERCENT', 'value': 140},
                  },
                },
              ],
            },
          },
        },
      );
      final pull = (tokenPreview['artifacts']! as Map).cast<String, Object?>();
      expect(pull['themes'], contains('light'));
      expect(((pull['themes']! as Map)['light']! as Map)['radii'], {
        'radius.button': 8,
      });
      final nodePreview = await _request(
        client,
        base.resolve('/sync/plan'),
        method: 'POST',
        body: {
          'version': 1,
          'direction': 'figmaToMix',
          'resource': 'selection',
          'current': {
            'nodes': {
              'version': 1,
              'pageId': 'page:1',
              'pageName': 'Page 1',
              'diagnostics': <Object?>[],
              'selection': [
                {
                  'id': 'frame:1',
                  'name': 'Card',
                  'type': 'FRAME',
                  'pluginData': <String, Object?>{},
                  'properties': {
                    'layoutMode': 'HORIZONTAL',
                    'itemSpacing': 8,
                    'boundVariables': {
                      'itemSpacing': {
                        'type': 'VARIABLE_ALIAS',
                        'id': 'variable:space',
                      },
                    },
                  },
                },
              ],
            },
            'variables': {
              'version': 1,
              'collections': [
                {
                  'id': 'collection:1',
                  'key': 'core',
                  'name': 'Core',
                  'defaultModeId': 'mode:light',
                  'modes': [
                    {'modeId': 'mode:light', 'name': 'Light'},
                  ],
                  'remote': false,
                  'hiddenFromPublishing': false,
                  'variableIds': ['variable:space'],
                  'pluginData': <String, Object?>{},
                },
                {
                  'id': 'collection:2',
                  'key': 'other',
                  'name': 'Other',
                  'defaultModeId': 'mode:other',
                  'modes': [
                    {'modeId': 'mode:other', 'name': 'Light'},
                  ],
                  'remote': false,
                  'hiddenFromPublishing': false,
                  'variableIds': ['variable:space-other'],
                  'pluginData': <String, Object?>{},
                },
              ],
              'variables': [
                {
                  'id': 'variable:space',
                  'key': 'space-sm',
                  'name': 'space/stack/sm',
                  'description': '',
                  'variableCollectionId': 'collection:1',
                  'resolvedType': 'FLOAT',
                  'valuesByMode': {'mode:light': 8},
                  'scopes': ['GAP'],
                  'codeSyntax': <String, Object?>{},
                  'remote': false,
                  'hiddenFromPublishing': false,
                  'pluginData': {'mix.group': 'spaces'},
                },
                {
                  'id': 'variable:space-other',
                  'key': 'space-sm-other',
                  'name': 'space/stack/sm',
                  'description': '',
                  'variableCollectionId': 'collection:2',
                  'resolvedType': 'FLOAT',
                  'valuesByMode': {'mode:other': 12},
                  'scopes': ['GAP'],
                  'codeSyntax': <String, Object?>{},
                  'remote': false,
                  'hiddenFromPublishing': false,
                  'pluginData': {'mix.group': 'spaces'},
                },
              ],
            },
          },
        },
      );
      final nodes = (nodePreview['artifacts']! as Map).cast<String, Object?>();
      final nodeStyle = ((nodes['styles']! as Map).values.single! as Map);
      expect(nodeStyle, containsPair('type', 'flex_box'));
      expect(nodeStyle['spacing'], {
        r'$token': 'Core.space.stack.sm',
        'kind': 'space',
      });

      final diagnosticPreview = await _request(
        client,
        base.resolve('/sync/plan'),
        method: 'POST',
        body: {
          'version': 1,
          'direction': 'figmaToMix',
          'resource': 'selection',
          'current': {
            'nodes': {
              'version': 1,
              'pageId': 'page:1',
              'pageName': 'Page 1',
              'diagnostics': [
                {
                  'code': 'unsupported_margin',
                  'severity': 'warning',
                  'path': 'selection.0',
                  'message': 'Plugin diagnostic.',
                },
                {
                  'code': 'unsupported_foreground_decoration',
                  'severity': 'warning',
                  'path': 'selection.0',
                  'message': 'Plugin diagnostic.',
                },
                {
                  'code': 'unsupported_per_edge_borders',
                  'severity': 'warning',
                  'path': 'selection.0',
                  'message': 'Plugin diagnostic.',
                },
                {
                  'code': 'unsupported_inner_shadow',
                  'severity': 'warning',
                  'path': 'selection.0',
                  'message': 'Plugin diagnostic.',
                },
                {
                  'code': 'unsupported_sweep_gradient',
                  'severity': 'warning',
                  'path': 'selection.0',
                  'message': 'Plugin diagnostic.',
                },
                {
                  'code': 'unsupported_absolute_positioned_child',
                  'severity': 'warning',
                  'path': 'selection.0.children.0',
                  'message': 'Plugin diagnostic.',
                },
              ],
              'selection': [
                {
                  'id': 'frame:diagnostics',
                  'name': 'Diagnostics',
                  'type': 'FRAME',
                  'pluginData': {
                    'mix_figma.margin': '{"left":8}',
                    'mix_figma.foregroundDecoration': '{"color":"#000000"}',
                  },
                  'properties': {
                    'strokes': [
                      {'type': 'GRADIENT_ANGULAR', 'visible': true},
                    ],
                    'strokeTopWeight': 1,
                    'strokeRightWeight': 2,
                    'strokeBottomWeight': 1,
                    'strokeLeftWeight': 2,
                    'effects': [
                      {'type': 'INNER_SHADOW', 'visible': true},
                    ],
                  },
                  'children': [
                    {
                      'id': 'absolute:child',
                      'name': 'Absolute child',
                      'type': 'RECTANGLE',
                      'pluginData': <String, Object?>{},
                      'properties': {'layoutPositioning': 'ABSOLUTE'},
                    },
                  ],
                },
              ],
            },
          },
        },
      );
      final diagnosticPull = (diagnosticPreview['artifacts']! as Map)
          .cast<String, Object?>();
      final diagnostics = (diagnosticPull['diagnostics']! as List)
          .cast<Map>()
          .map((diagnostic) => diagnostic['code'])
          .toList();
      expect(diagnostics, hasLength(6));
      expect(diagnostics.toSet(), {
        'unsupported_margin',
        'unsupported_inner_shadow',
        'unsupported_absolute_positioned_child',
        'unsupported_sweep_gradient',
        'unsupported_per_edge_borders',
        'unsupported_foreground_decoration',
      });

      final componentPreview = await _request(
        client,
        base.resolve('/sync/plan'),
        method: 'POST',
        body: {
          'version': 1,
          'direction': 'mixToFigma',
          'resource': 'component',
          'current': {'componentSet': null},
          'componentId': 'fixture',
        },
      );
      final component = (componentPreview['payload']! as Map)
          .cast<String, Object?>();
      expect(component['version'], 1);
      expect(component['variants'], hasLength(2));
    },
  );
}

Map<String, Object?> _collection({
  required String id,
  required String name,
  required String modeId,
  required List<String> variableIds,
}) => {
  'id': id,
  'key': id,
  'name': name,
  'defaultModeId': modeId,
  'modes': [
    {'modeId': modeId, 'name': 'Light'},
  ],
  'remote': false,
  'hiddenFromPublishing': false,
  'variableIds': variableIds,
  'pluginData': <String, Object?>{},
};

Map<String, Object?> _variable({
  required String id,
  required String collectionId,
  required String name,
  required String resolvedType,
  required String modeId,
  required Object value,
  required List<String> scopes,
}) => {
  'id': id,
  'key': id,
  'name': name,
  'description': '',
  'variableCollectionId': collectionId,
  'resolvedType': resolvedType,
  'valuesByMode': {modeId: value},
  'scopes': scopes,
  'codeSyntax': <String, Object?>{},
  'remote': false,
  'hiddenFromPublishing': false,
  'pluginData': <String, Object?>{},
};

Future<Map<String, Object?>> _request(
  HttpClient client,
  Uri uri, {
  String method = 'GET',
  Map<String, Object?>? body,
}) async {
  final request = await client.openUrl(method, uri);
  if (body != null) {
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(body));
  }
  final response = await request.close();
  final text = await utf8.decoder.bind(response).join();
  expect(response.statusCode, lessThan(400), reason: text);

  return (jsonDecode(text)! as Map).cast<String, Object?>();
}
