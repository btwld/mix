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

  test('bridge serves plugin pull/push/node/component contracts', () async {
    final temporary = Directory.systemTemp.createTempSync('mix_figma_server_');
    addTearDown(() => temporary.deleteSync(recursive: true));
    final themes = Directory('${temporary.path}/themes')..createSync();
    final components = Directory('${temporary.path}/components')..createSync();
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
    );
    final server = await bridge.start();
    addTearDown(() => server.close(force: true));
    final client = HttpClient();
    addTearDown(client.close);
    final base = Uri.parse('http://127.0.0.1:${server.port}');

    final health = await _request(client, base.resolve('/health'));
    expect(health, containsPair('status', 'ok'));

    final pull = await _request(
      client,
      base.resolve('/pull/tokens'),
      method: 'POST',
      body: {
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
              'variableIds': ['variable:1'],
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
          ],
        },
        'styles': {
          'version': 1,
          'textStyles': <Object?>[],
          'effectStyles': <Object?>[],
          'paintStyles': <Object?>[],
        },
      },
    );
    expect(pull['themes'], contains('light'));
    expect(File('${themes.path}/light.theme.json').existsSync(), isTrue);

    final push = await _request(client, base.resolve('/push/tokens'));
    expect((push['variables']! as Map)['version'], 1);
    expect((push['styles']! as Map)['version'], 1);

    final nodes = await _request(
      client,
      base.resolve('/pull/nodes'),
      method: 'POST',
      body: {
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
              'properties': {'layoutMode': 'HORIZONTAL', 'itemSpacing': 8},
            },
          ],
        },
      },
    );
    expect((nodes['styles']! as List).single, containsPair('type', 'flex_box'));

    final component = await _request(
      client,
      base.resolve('/push/components/fixture'),
    );
    expect(component['version'], 1);
    expect(component['variants'], hasLength(2));
  });
}

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
