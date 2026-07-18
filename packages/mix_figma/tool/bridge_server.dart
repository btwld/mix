import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mix_component_contract/mix_component_contract.dart';
import 'package:mix_figma/src/core/figma/figma_node_document.dart';
import 'package:mix_figma/src/core/figma/figma_styles_parser.dart';
import 'package:mix_figma/src/core/figma/figma_variables_parser.dart';
import 'package:mix_figma/src/core/json_map.dart';
import 'package:mix_figma/src/core/protocol_json/component_set_payload.dart';
import 'package:mix_figma/src/core/protocol_json/figma_style_payloads.dart';
import 'package:mix_figma/src/core/protocol_json/figma_variable_payload.dart';
import 'package:mix_figma/src/core/protocol_json/style_from_figma_node.dart';
import 'package:mix_figma/src/core/protocol_json/theme_from_figma_styles.dart';
import 'package:mix_figma/src/core/protocol_json/theme_from_figma_variables.dart';

const _themeGroups = [
  'colors',
  'spaces',
  'doubles',
  'radii',
  'textStyles',
  'shadows',
  'boxShadows',
  'borders',
  'fontWeights',
  'breakpoints',
  'durations',
];

/// Localhost transport used by the Figma plugin development loop.
final class MixFigmaBridgeServer {
  final String host;

  final int port;
  final String themeDirectory;
  final String componentDirectory;
  final bool validateByDefault;
  const MixFigmaBridgeServer({
    this.host = '127.0.0.1',
    this.port = 8787,
    this.themeDirectory = '../../design/tokens',
    this.componentDirectory = '../../design/components',
    this.validateByDefault = false,
  });

  Future<void> _handle(HttpRequest request) async {
    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.noContent;
      _cors(request.response);
      await request.response.close();

      return;
    }
    final path = request.uri.path;
    if (request.method == 'GET' && path == '/health') {
      await _respond(request.response, {
        'status': 'ok',
        'version': 1,
        'validation': validateByDefault ? 'flutter-test' : 'on-demand',
      });

      return;
    }
    if (request.method == 'POST' && path == '/pull/tokens') {
      await _pullTokens(request);

      return;
    }
    if (request.method == 'GET' && path == '/push/tokens') {
      await _pushTokens(request);

      return;
    }
    if (request.method == 'POST' && path == '/pull/nodes') {
      await _pullNodes(request);

      return;
    }
    if (request.method == 'GET' && path.startsWith('/push/components/')) {
      await _pushComponent(request);

      return;
    }
    if (request.method == 'POST' && path == '/webhooks/figma') {
      await _webhook(request);

      return;
    }
    await _respond(request.response, {
      'error': 'Unknown bridge endpoint.',
    }, statusCode: HttpStatus.notFound);
  }

  Future<void> _pullTokens(HttpRequest request) async {
    final body = await _body(request);
    final variablesJson = _object(body['variables'], path: '/variables');
    final stylesJson = body['styles'] == null
        ? <String, Object?>{
            'version': 1,
            'textStyles': <Object?>[],
            'effectStyles': <Object?>[],
            'paintStyles': <Object?>[],
          }
        : _object(body['styles'], path: '/styles');
    final variables = parseFigmaVariablesDocument(variablesJson);
    final styleResult = buildProtocolThemeJsonFromFigmaStyles(
      parseFigmaStylesDocument(stylesJson),
    );
    final output = Directory(themeDirectory)..createSync(recursive: true);
    final themes = <String, JsonMap>{};
    final diagnostics = <Object?>[
      ...styleResult.diagnostics.map((item) => item.toJson()),
    ];
    final coverage = <Object?>[styleResult.coverage.toJson()];
    for (final collection in variables.collections) {
      for (final mode in collection.modes) {
        final variableResult = buildProtocolThemeJsonFromFigmaVariables(
          variables,
          modeId: mode.id,
        );
        final name = _safeName(mode.name.toLowerCase());
        final theme = _mergeTheme(variableResult.value, styleResult.value);
        if (_shouldValidate(request)) {
          await _validateDocument(theme, kind: 'theme');
        }
        File('${output.path}/$name.theme.json').writeAsStringSync(_json(theme));
        themes[name] = theme;
        diagnostics.addAll(
          variableResult.diagnostics.map((item) => item.toJson()),
        );
        coverage.add(variableResult.coverage.toJson());
      }
    }
    await _respond(request.response, {
      'version': 1,
      'themes': themes,
      'coverage': coverage,
      'diagnostics': diagnostics,
      'styleFragments': styleResult.styleFragments,
    });
  }

  Future<void> _pushTokens(HttpRequest request) async {
    final themes = _readThemes(themeDirectory);
    final firstMode = themes.keys.toList()..sort();
    final variables = buildFigmaVariableWritePayload(themes);
    final styles = buildFigmaStylePayloads(themes[firstMode.first]!);
    await _respond(request.response, {
      'variables': variables.value,
      'styles': styles.value,
      'diagnostics': [
        ...variables.diagnostics.map((item) => item.toJson()),
        ...styles.diagnostics.map((item) => item.toJson()),
      ],
    });
  }

  Future<void> _pullNodes(HttpRequest request) async {
    final body = await _body(request);
    final document = _object(body['nodes'] ?? body, path: '/nodes');
    final selection = _list(document['selection'], path: '/nodes/selection');
    final styles = <Object?>[];
    final diagnostics = <Object?>[...?_listOrNull(document['diagnostics'])];
    for (final (index, value) in selection.indexed) {
      final root = _snapshotToNode(
        _object(value, path: '/nodes/selection/$index'),
      );
      final result = buildProtocolStyleJsonFromNode(
        parseFigmaNodeDocument({
          'schema': 'mix_figma/figma-nodes/v1',
          'root': root,
        }).root,
      );
      if (_shouldValidate(request)) {
        await _validateDocument(result.value, kind: 'style');
      }
      styles.add(result.value);
      diagnostics.addAll(result.diagnostics.map((item) => item.toJson()));
    }
    await _respond(request.response, {
      'version': 1,
      'styles': styles,
      'diagnostics': diagnostics,
    });
  }

  Future<void> _pushComponent(HttpRequest request) async {
    final encoded = request.uri.path.substring('/push/components/'.length);
    final id = Uri.decodeComponent(encoded);
    if (!RegExp(r'^[A-Za-z0-9_.-]+$').hasMatch(id)) {
      throw const FormatException('Invalid component id.');
    }
    final path = '$componentDirectory/$id.component.json';
    final bytes = File(path).readAsBytesSync();
    final component = parsePortableComponentDocument(
      Uint8List.fromList(bytes),
      path: path,
    );
    await _respond(request.response, buildComponentSetPayload(component).value);
  }

  Future<void> _webhook(HttpRequest request) async {
    final body = await _body(request);
    final eventType = body['event_type'] ?? body['eventType'];
    await _respond(request.response, {
      'status': eventType == 'LIBRARY_PUBLISH' ? 'accepted' : 'ignored',
      'eventType': eventType,
      'changedVariables': body['variable_changes'] ?? const <Object?>[],
    });
  }

  bool _shouldValidate(HttpRequest request) =>
      validateByDefault || request.uri.queryParameters['validate'] == 'true';

  void _serveRequest(HttpRequest request) {
    unawaited(_handleSafely(request));
  }

  Future<void> _handleSafely(HttpRequest request) async {
    try {
      await _handle(request);
    } on FormatException catch (error) {
      await _respond(request.response, {
        'error': error.message,
      }, statusCode: HttpStatus.badRequest);
    } on FileSystemException catch (error) {
      await _respond(request.response, {
        'error': error.message,
      }, statusCode: HttpStatus.notFound);
    } on Object catch (error, stackTrace) {
      stderr.writeln('$error\n$stackTrace');
      await _respond(request.response, {
        'error': error.toString(),
      }, statusCode: HttpStatus.internalServerError);
    }
  }

  Future<HttpServer> start() async {
    final server = await HttpServer.bind(host, port);
    // Closing HttpServer terminates its request subscription.
    // ignore: avoid-unassigned-stream-subscriptions
    server.listen(_serveRequest);

    return server;
  }
}

Future<void> main(List<String> arguments) async {
  String value(String name, String fallback) {
    final index = arguments.indexOf(name);

    return index < 0 ? fallback : arguments[index + 1];
  }

  final bridge = MixFigmaBridgeServer(
    host: value('--host', '127.0.0.1'),
    port: int.parse(value('--port', '8787')),
    themeDirectory: value('--theme-dir', '../../design/tokens'),
    componentDirectory: value('--component-dir', '../../design/components'),
    validateByDefault: arguments.contains('--validate'),
  );
  final server = await bridge.start();
  stdout.writeln(
    'Mix Figma bridge listening on http://${server.address.host}:${server.port}',
  );
  await ProcessSignal.sigint.watch().first;
  await server.close(force: true);
}

JsonMap _snapshotToNode(JsonMap snapshot) {
  final properties = snapshot['properties'] is Map
      ? (snapshot['properties']! as Map).cast<String, Object?>()
      : const <String, Object?>{};
  final children = _listOrNull(snapshot['children']) ?? const <Object?>[];

  return {
    'id': snapshot['id'],
    'name': snapshot['name'],
    'type': snapshot['type'],
    ...properties,
    if (snapshot['opacity'] != null) 'opacity': snapshot['opacity'],
    'children': [
      for (final child in children) _snapshotToNode((child! as Map).cast()),
    ],
  };
}

JsonMap _mergeTheme(JsonMap primitives, JsonMap composites) => {
  'v': 1,
  'type': 'theme',
  for (final group in _themeGroups)
    if (_mergedGroup(primitives[group], composites[group]).isNotEmpty)
      group: _mergedGroup(primitives[group], composites[group]),
};

JsonMap _mergedGroup(Object? left, Object? right) => {
  if (left is Map) ...left.cast<String, Object?>(),
  if (right is Map) ...right.cast<String, Object?>(),
};

Map<String, JsonMap> _readThemes(String path) {
  final directory = Directory(path);
  if (!directory.existsSync()) {
    throw FormatException('Missing theme directory: $path');
  }
  final files =
      directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.theme.json'))
          .toList()
        ..sort((left, right) => left.path.compareTo(right.path));
  if (files.isEmpty) throw FormatException('No theme documents in $path.');

  return {
    for (final file in files)
      file.uri.pathSegments.last.replaceFirst('.theme.json', ''): _decodeObject(
        file.readAsStringSync(),
        path: file.path,
      ),
  };
}

Future<JsonMap> _body(HttpRequest request) async => _decodeObject(
  await utf8.decoder.bind(request).join(),
  path: request.uri.path,
);

JsonMap _decodeObject(String source, {required String path}) {
  final value = jsonDecode(source);

  return _object(value, path: path);
}

JsonMap _object(Object? value, {required String path}) {
  if (value is! Map) throw FormatException('Expected an object at $path.');

  return value.cast();
}

List<Object?> _list(Object? value, {required String path}) {
  if (value is! List) throw FormatException('Expected an array at $path.');

  return value.cast();
}

List<Object?>? _listOrNull(Object? value) =>
    value is List ? value.cast() : null;

String _safeName(String value) {
  final result = value.replaceAll(RegExp(r'[^a-z0-9_.-]+'), '-');
  if (result.isEmpty) throw const FormatException('Mode name is empty.');

  return result;
}

String _json(Object value) =>
    '${const JsonEncoder.withIndent('  ').convert(value)}\n';

Future<void> _respond(
  HttpResponse response,
  Object value, {
  int statusCode = HttpStatus.ok,
}) async {
  response.statusCode = statusCode;
  response.headers.contentType = .json;
  _cors(response);
  response.write(jsonEncode(value));
  await response.close();
}

void _cors(HttpResponse response) {
  response.headers
    ..set('Access-Control-Allow-Origin', '*')
    ..set('Access-Control-Allow-Headers', 'content-type')
    ..set('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
}

Future<void> _validateDocument(JsonMap document, {required String kind}) async {
  final temporary = File(
    '${Directory.systemTemp.path}/mix_figma_validate_${DateTime.now().microsecondsSinceEpoch}.json',
  );
  try {
    temporary.writeAsStringSync(jsonEncode(document));
    final result = await Process.run('flutter', [
      'test',
      '--no-pub',
      'tool/protocol_check_harness_test.dart',
      '--dart-define=MIX_FIGMA_EXPECTED=${temporary.path}',
      '--dart-define=MIX_FIGMA_ACTUAL=${temporary.path}',
      '--dart-define=MIX_FIGMA_KIND=$kind',
    ]);
    if (result.exitCode != 0) {
      throw FormatException(
        'Protocol validation failed: ${result.stdout}${result.stderr}',
      );
    }
  } finally {
    if (temporary.existsSync()) temporary.deleteSync();
  }
}
