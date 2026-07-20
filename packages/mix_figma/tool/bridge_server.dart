import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:mix_component_contract/mix_component_contract.dart';
import 'package:mix_figma/src/core/diagnostics/mix_figma_diagnostic.dart';
import 'package:mix_figma/src/core/figma/figma_node_document.dart';
import 'package:mix_figma/src/core/figma/figma_styles_parser.dart';
import 'package:mix_figma/src/core/figma/figma_variables_document.dart';
import 'package:mix_figma/src/core/figma/figma_variables_parser.dart';
import 'package:mix_figma/src/core/identity/mix_figma_lock.dart';
import 'package:mix_figma/src/core/json_map.dart';
import 'package:mix_figma/src/core/mapping/mix_figma_config.dart';
import 'package:mix_figma/src/core/protocol_json/component_set_payload.dart';
import 'package:mix_figma/src/core/protocol_json/figma_style_payloads.dart';
import 'package:mix_figma/src/core/protocol_json/figma_variable_payload.dart';
import 'package:mix_figma/src/core/protocol_json/theme_from_figma_variables.dart';
import 'package:mix_figma/src/core/sync/sync_plan.dart';
import 'package:mix_figma/src/core/sync/sync_verification.dart';
import 'package:mix_figma/src/core/sync/component_sync_planner.dart';
import 'package:mix_figma/src/core/sync/selection_pull_analysis.dart';
import 'package:mix_figma/src/core/sync/token_pull_analysis.dart';
import 'package:mix_figma/src/core/sync/token_sync_planner.dart';

/// Localhost transport used by the Figma plugin development loop.
final class MixFigmaBridgeServer {
  final String host;

  final int port;
  final String themeDirectory;
  final String styleDirectory;
  final String componentDirectory;
  final String reportDirectory;
  final String? lockPath;
  final String? configPath;
  final String? authToken;
  final bool validateByDefault;
  final Map<String, _PreparedSync> _prepared = {};
  MixFigmaBridgeServer({
    this.host = '127.0.0.1',
    this.port = 8787,
    this.themeDirectory = '../../design/tokens',
    this.styleDirectory = '../../design/styles',
    this.componentDirectory = '../../design/components',
    this.reportDirectory = '../../design/figma-reports',
    this.lockPath,
    this.configPath,
    this.authToken,
    this.validateByDefault = false,
  });

  Future<void> _handle(HttpRequest request) async {
    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.noContent;
      _cors(request.response);
      await request.response.close();

      return;
    }
    if (!_isAuthorized(request)) {
      await _respond(request.response, {
        'error': 'Missing or invalid Mix Figma bridge session token.',
      }, statusCode: HttpStatus.unauthorized);

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
    if (request.method == 'POST' && path == '/sync/plan') {
      await _syncPlan(request);

      return;
    }
    if (request.method == 'POST' && path == '/sync/apply') {
      await _syncApply(request);

      return;
    }
    if (request.method == 'POST' && path == '/sync/verify') {
      await _syncVerify(request);

      return;
    }
    if (request.method == 'POST' && path == '/lock/tokens') {
      await _rejectUnverifiedLockWrite(request);

      return;
    }
    if (request.method == 'POST' && path.startsWith('/lock/components/')) {
      await _rejectUnverifiedLockWrite(request);

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

  Future<void> _syncPlan(HttpRequest request) async {
    final body = await _body(request);
    if (body['version'] != 1) {
      throw const FormatException('Sync requests require version 1.');
    }
    final direction = body['direction'];
    final resource = body['resource'];
    final snapshot = _object(body['current'], path: '/current');
    final prepared = switch ((direction, resource)) {
      ('figmaToMix', 'tokens') => _prepareTokenPull(snapshot),
      ('mixToFigma', 'tokens') => _prepareTokenPush(snapshot),
      ('figmaToMix', 'selection') => _prepareSelectionPull(snapshot),
      ('mixToFigma', 'component') => _prepareComponentPush(
        snapshot,
        jsonString(body['componentId'], path: '/componentId'),
      ),
      _ => throw const FormatException(
        'Unsupported sync direction and resource combination.',
      ),
    };
    _remember(prepared);
    await _respond(request.response, prepared.previewJson());
  }

  Future<void> _syncApply(HttpRequest request) async {
    final body = await _body(request);
    final planId = jsonString(body['planId'], path: '/planId');
    final prepared = _prepared[planId];
    if (prepared == null) {
      throw const BridgeHttpException(
        HttpStatus.conflict,
        'Sync plan is missing or expired. Analyze again.',
      );
    }
    final snapshot = _object(body['current'], path: '/current');
    final refreshed = _refresh(prepared, snapshot);
    if (refreshed.plan.id != prepared.plan.id) {
      throw const BridgeHttpException(
        HttpStatus.conflict,
        'Sync plan is stale. Analyze the current state again.',
      );
    }
    final allowDeletes = body['allowDeletes'] == true;
    if (prepared.plan.hasErrors) {
      throw const BridgeHttpException(
        HttpStatus.unprocessableEntity,
        'The sync plan contains errors and cannot be applied.',
      );
    }
    prepared.allowDeletes = allowDeletes;
    if (prepared.plan.resource == .tokens &&
        prepared.plan.direction == .figmaToMix) {
      final pull = refreshed.pullAnalysis!;
      if (_shouldValidate(request)) {
        for (final theme in pull.artifacts.themes.values) {
          await _validateDocument(theme, kind: 'theme');
        }
      }
      _applyThemeFiles(pull, allowDeletes: allowDeletes);
      prepared.applied = true;
      await _respond(request.response, {
        'status': 'applied',
        'plan': prepared.plan.toJson(),
        'appliedOperations': prepared.plan
            .operationsForApply(allowDeletes: allowDeletes)
            .map((item) => item.toJson())
            .toList(),
      });

      return;
    }
    if (prepared.plan.resource == .selection) {
      final selection = refreshed.selectionAnalysis!;
      if (_shouldValidate(request)) {
        for (final style in selection.artifacts.styles.values) {
          await _validateDocument(style, kind: 'style');
        }
      }
      _applyManagedFiles(
        directoryPath: styleDirectory,
        extension: '.style.json',
        desired: selection.artifacts.styles,
        plan: selection.plan,
        allowDeletes: allowDeletes,
      );
      prepared.applied = true;
      await _respond(request.response, {
        'status': 'applied',
        'plan': prepared.plan.toJson(),
        'appliedOperations': prepared.plan
            .operationsForApply(allowDeletes: allowDeletes)
            .map((item) => item.toJson())
            .toList(),
      });

      return;
    }
    prepared.applied = true;
    await _respond(request.response, {
      'status': 'approved',
      'plan': prepared.plan.toJson(),
      'payload': refreshed.pushPayload,
      'allowDeletes': allowDeletes,
      'appliedOperations': prepared.plan
          .operationsForApply(allowDeletes: allowDeletes)
          .map((item) => item.toJson())
          .toList(),
    });
  }

  Future<void> _syncVerify(HttpRequest request) async {
    final body = await _body(request);
    final planId = jsonString(body['planId'], path: '/planId');
    final prepared = _prepared[planId];
    if (prepared == null || !prepared.applied) {
      throw const BridgeHttpException(
        HttpStatus.conflict,
        'Sync plan was not applied or has expired.',
      );
    }
    final current = prepared.plan.direction == .figmaToMix
        ? prepared.snapshot
        : _object(body['current'], path: '/current');
    final observed = _refresh(prepared, current);
    final writeResult = prepared.plan.direction == .mixToFigma
        ? _object(body['writeResult'], path: '/writeResult')
        : null;
    final report = verifyMixFigmaSync(
      approvedPlan: prepared.plan,
      observedPlan: observed.plan,
      allowDeletes: prepared.allowDeletes,
      additionalDiagnostics: writeResult == null
          ? const []
          : _writeResultDiagnostics(prepared, current, writeResult),
    );
    _persistReport(report);
    if (report.isVerified &&
        prepared.plan.direction == .mixToFigma &&
        prepared.plan.resource == .tokens) {
      final existingLock = _readLock(_lockPath);
      _writeLock(
        _lockPath,
        _tokenLockFromVerifiedReadback(existingLock, current, writeResult!),
      );
    } else if (report.isVerified && prepared.plan.resource == .component) {
      _writeLock(
        _lockPath,
        _readLock(
          _lockPath,
        ).mergeComponentWriteResult(prepared.componentRef!, writeResult!),
      );
    }
    await _respond(
      request.response,
      report.toJson(),
      statusCode: report.isVerified
          ? HttpStatus.ok
          : HttpStatus.unprocessableEntity,
    );
  }

  _PreparedSync _prepareTokenPull(JsonMap snapshot) {
    final variables = parseFigmaVariablesDocument(
      _object(snapshot['variables'], path: '/current/variables'),
    );
    final styles = parseFigmaStylesDocument(
      snapshot['styles'] == null
          ? _emptyStyles
          : _object(snapshot['styles'], path: '/current/styles'),
    );
    final analysis = analyzeTokenPull(
      variables: variables,
      styles: styles,
      currentThemes: _readThemesIfExists(themeDirectory),
      config: _config,
    );

    return _PreparedSync(
      plan: analysis.plan,
      snapshot: snapshot,
      pullAnalysis: analysis,
    );
  }

  _PreparedSync _prepareTokenPush(JsonMap snapshot) {
    final variables = parseFigmaVariablesDocument(
      _object(snapshot['variables'], path: '/current/variables'),
    );
    final styles = parseFigmaStylesDocument(
      snapshot['styles'] == null
          ? _emptyStyles
          : _object(snapshot['styles'], path: '/current/styles'),
    );
    final themes = _readThemes(themeDirectory);
    final firstMode = themes.keys.toList()..sort();
    final lock = _readLock(_lockPath);
    final variablePayload = buildFigmaVariableWritePayload(themes, lock: lock);
    final stylePayload = buildFigmaStylePayloads(
      themes[firstMode.first]!,
      lock: lock,
    );
    final diagnostics = [
      ...variablePayload.diagnostics,
      ...stylePayload.diagnostics,
    ];
    final plan = buildTokenPushSyncPlan(
      currentVariables: variables,
      currentStyles: styles,
      desiredVariables: variablePayload.value,
      desiredStyles: stylePayload.value,
      lock: lock,
      diagnostics: diagnostics,
    );

    return _PreparedSync(
      plan: plan,
      snapshot: snapshot,
      pushPayload: {
        'variables': variablePayload.value,
        'styles': stylePayload.value,
        'diagnostics': diagnostics.map((item) => item.toJson()).toList(),
      },
    );
  }

  _PreparedSync _prepareSelectionPull(JsonMap snapshot) {
    final document = _object(snapshot['nodes'] ?? snapshot, path: '/nodes');
    final selection = _list(document['selection'], path: '/nodes/selection');
    final bindings = snapshot['variables'] == null
        ? const <String, JsonMap>{}
        : _variableBindings(
            parseFigmaVariablesDocument(
              _object(snapshot['variables'], path: '/variables'),
            ),
          );
    final inputs = <MixFigmaSelectionInput>[];
    for (final (index, value) in selection.indexed) {
      final source = _object(value, path: '/nodes/selection/$index');
      final root = _snapshotToNode(source, bindings);
      inputs.add(
        MixFigmaSelectionInput(
          source: source,
          node: parseFigmaNodeDocument({
            'schema': 'mix_figma/figma-nodes/v1',
            'root': root,
          }).root,
        ),
      );
    }
    final analysis = analyzeSelectionPull(
      selection: inputs,
      currentStyles: _readProtocolFilesIfExists(
        styleDirectory,
        extension: '.style.json',
      ),
      diagnostics: [
        for (final (index, value)
            in (_listOrNull(document['diagnostics']) ?? const <Object?>[])
                .indexed)
          _parseDiagnostic(
            _object(value, path: '/nodes/diagnostics/$index'),
            path: '/nodes/diagnostics/$index',
          ),
      ],
    );

    return _PreparedSync(
      plan: analysis.plan,
      snapshot: snapshot,
      selectionAnalysis: analysis,
    );
  }

  _PreparedSync _prepareComponentPush(JsonMap snapshot, String componentId) {
    final component = _componentPayload(componentId);
    final currentSet = snapshot['componentSet'] is Map
        ? (snapshot['componentSet']! as Map).cast<String, Object?>()
        : null;
    final currentPluginData = currentSet?['pluginData'] is Map
        ? (currentSet!['pluginData']! as Map).cast<String, Object?>()
        : const <String, Object?>{};
    final componentRef = jsonString(component.payload['ref'], path: '/ref');
    final verifiedSourceId =
        currentSet != null && _syncIdentity(currentPluginData) == componentRef
        ? jsonString(currentSet['id'], path: '/current/componentSet/id')
        : null;
    final desiredPayload = <String, Object?>{...component.payload}
      ..remove('sourceId');
    final writePayload = <String, Object?>{...desiredPayload};
    if (verifiedSourceId != null) writePayload['sourceId'] = verifiedSourceId;
    final plan = buildComponentPushSyncPlan(
      current: snapshot,
      desired: desiredPayload,
      diagnostics: component.diagnostics,
    );

    return _PreparedSync(
      plan: plan,
      snapshot: snapshot,
      pushPayload: writePayload,
      componentId: componentId,
      componentRef: componentRef,
    );
  }

  ({JsonMap payload, List<MixFigmaDiagnostic> diagnostics}) _componentPayload(
    String id,
  ) {
    if (!RegExp(r'^[A-Za-z0-9_.-]+$').hasMatch(id)) {
      throw const FormatException('Invalid component id.');
    }
    final path = '$componentDirectory/$id.component.json';
    final bytes = File(path).readAsBytesSync();
    final component = parsePortableComponentDocument(
      Uint8List.fromList(bytes),
      path: path,
    );
    final result = buildComponentSetPayload(
      component,
      lock: _readLock(_lockPath),
    );

    return (
      payload: addComponentSyncMetadata(result.value),
      diagnostics: result.diagnostics,
    );
  }

  _PreparedSync _refresh(_PreparedSync prepared, JsonMap snapshot) {
    return switch ((prepared.plan.direction, prepared.plan.resource)) {
      (.figmaToMix, .tokens) => _prepareTokenPull(snapshot),
      (.mixToFigma, .tokens) => _prepareTokenPush(snapshot),
      (.figmaToMix, .selection) => _prepareSelectionPull(snapshot),
      (.mixToFigma, .component) => _prepareComponentPush(
        snapshot,
        prepared.componentId!,
      ),
      _ => throw const FormatException('Unsupported prepared sync operation.'),
    };
  }

  void _remember(_PreparedSync value) {
    if (_prepared.length >= 20) _prepared.remove(_prepared.keys.first);
    _prepared[value.plan.id] = value;
  }

  void _persistReport(MixFigmaSyncVerificationReport report) {
    final directory = Directory(reportDirectory)..createSync(recursive: true);
    _writeJsonSafely(
      '${directory.path}/${report.planId}.json',
      report.toJson(),
    );
  }

  void _applyThemeFiles(
    MixFigmaTokenPullAnalysis analysis, {
    required bool allowDeletes,
  }) => _applyManagedFiles(
    directoryPath: themeDirectory,
    extension: '.theme.json',
    desired: analysis.artifacts.themes,
    plan: analysis.plan,
    allowDeletes: allowDeletes,
  );

  void _applyManagedFiles({
    required String directoryPath,
    required String extension,
    required Map<String, JsonMap> desired,
    required MixFigmaSyncPlan plan,
    required bool allowDeletes,
  }) {
    final output = Directory(directoryPath)..createSync(recursive: true);
    final suffix = DateTime.now().microsecondsSinceEpoch;
    final staging = Directory('${output.parent.path}/.mix_figma_stage_$suffix')
      ..createSync();
    final backup = Directory('${output.parent.path}/.mix_figma_backup_$suffix')
      ..createSync();
    final installed = <String>[];
    final backedUp = <String, String>{};
    try {
      final applied = plan.operationsForApply(allowDeletes: allowDeletes);
      for (final operation in applied.where(
        (item) => item.action == .create || item.action == .update,
      )) {
        _validateFileRef(operation.ref);
        final document = desired[operation.ref];
        if (document == null) {
          throw StateError('Missing desired artifact for ${operation.ref}.');
        }
        File(
          '${staging.path}/${operation.ref}$extension',
        ).writeAsStringSync(_json(document));
      }
      for (final operation in applied) {
        if (operation.action == .create ||
            operation.action == .update ||
            operation.action == .delete) {
          _validateFileRef(operation.ref);
        }
        final target = File('${output.path}/${operation.ref}$extension');
        if (operation.action == .create || operation.action == .update) {
          if (target.existsSync()) {
            final previous = '${backup.path}/${operation.ref}$extension';
            target.renameSync(previous);
            backedUp[target.path] = previous;
          }
          File(
            '${staging.path}/${operation.ref}$extension',
          ).renameSync(target.path);
          installed.add(target.path);
        } else if (operation.action == .delete && target.existsSync()) {
          final previous = '${backup.path}/${operation.ref}$extension';
          target.renameSync(previous);
          backedUp[target.path] = previous;
        }
      }
    } on Object {
      for (final path in installed.reversed) {
        final file = File(path);
        if (file.existsSync()) file.deleteSync();
      }
      for (final entry in backedUp.entries) {
        final previous = File(entry.value);
        if (previous.existsSync()) previous.renameSync(entry.key);
      }
      rethrow;
    } finally {
      if (staging.existsSync()) staging.deleteSync(recursive: true);
      if (backup.existsSync()) backup.deleteSync(recursive: true);
    }
  }

  Future<void> _rejectUnverifiedLockWrite(HttpRequest request) =>
      _respond(request.response, {
        'error':
            'Direct lock writes are disabled. Complete read-back through '
            'POST /sync/verify so identity state is recorded only after '
            'verification succeeds.',
      }, statusCode: HttpStatus.gone);

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

  bool _isAuthorized(HttpRequest request) {
    final expected = authToken;
    if (expected == null) return true;

    return request.headers.value(HttpHeaders.authorizationHeader) ==
        'Bearer $expected';
  }

  void _serveRequest(HttpRequest request) {
    unawaited(_handleSafely(request));
  }

  Future<void> _handleSafely(HttpRequest request) async {
    try {
      await _handle(request);
    } on BridgeHttpException catch (error) {
      await _respond(request.response, {
        'error': error.message,
      }, statusCode: error.statusCode);
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

  String get _lockPath => lockPath ?? '$themeDirectory/mix_figma.lock.json';

  MixFigmaConfig get _config {
    final path = configPath;
    if (path == null) return const MixFigmaConfig();
    final file = File(path);
    if (!file.existsSync()) {
      throw FormatException('Missing Mix Figma config: $path');
    }

    return MixFigmaConfig.fromYaml(file.readAsStringSync());
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

  final authToken = arguments.contains('--auth-token')
      ? value('--auth-token', '')
      : createMixFigmaBridgeToken();
  if (authToken.isEmpty) {
    throw const FormatException('--auth-token must not be empty.');
  }
  final bridge = MixFigmaBridgeServer(
    host: value('--host', '127.0.0.1'),
    port: int.parse(value('--port', '8787')),
    themeDirectory: value('--theme-dir', '../../design/tokens'),
    styleDirectory: value('--style-dir', '../../design/styles'),
    componentDirectory: value('--component-dir', '../../design/components'),
    reportDirectory: value('--report-dir', '../../design/figma-reports'),
    configPath: arguments.contains('--config') ? value('--config', '') : null,
    authToken: authToken,
    validateByDefault: arguments.contains('--validate'),
  );
  final server = await bridge.start();
  stdout.writeln(
    'Mix Figma bridge listening on http://${server.address.host}:${server.port}',
  );
  stdout.writeln('Session token: $authToken');
  stdout.writeln(
    'Paste this token into the Mix Figma plugin before connecting.',
  );
  await ProcessSignal.sigint.watch().first;
  await server.close(force: true);
}

JsonMap _snapshotToNode(
  JsonMap snapshot, [
  Map<String, JsonMap> bindings = const {},
]) {
  final rawProperties = snapshot['properties'] is Map
      ? (snapshot['properties']! as Map).cast<String, Object?>()
      : const <String, Object?>{};
  final properties = <String, Object?>{
    ...rawProperties,
    if (rawProperties['boundVariables'] case final Map rawBoundVariables)
      'boundVariables': _bindNodeVariables(rawBoundVariables, bindings),
  };
  final children = _listOrNull(snapshot['children']) ?? const <Object?>[];

  return {
    'id': snapshot['id'],
    'name': snapshot['name'],
    'type': snapshot['type'],
    if (snapshot['pluginData'] is Map) 'pluginData': snapshot['pluginData'],
    ...properties,
    if (snapshot['opacity'] != null) 'opacity': snapshot['opacity'],
    'children': [
      for (final child in children)
        _snapshotToNode((child! as Map).cast(), bindings),
    ],
  };
}

Map<String, JsonMap> _variableBindings(FigmaVariablesDocument document) {
  final protocolNamesByVariableId = buildProtocolVariableNameMap(document);

  return {
    for (final variable in document.variables)
      variable.id: {
        'name': protocolNamesByVariableId[variable.id] ?? variable.name,
        if (_variableGroup(variable) case final String group) 'kind': group,
      },
  };
}

String? _variableGroup(FigmaVariable variable) {
  final stamped = variable.pluginData['mix.group'];
  if (stamped != null) return stamped;
  final syntax = variable.codeSyntax['WEB'];
  if (syntax == null || !syntax.startsWith('mix://')) return null;
  final slash = syntax.indexOf('/', 'mix://'.length);

  return slash < 0 ? null : syntax.substring('mix://'.length, slash);
}

JsonMap _bindNodeVariables(Map raw, Map<String, JsonMap> bindings) => {
  for (final entry in raw.entries)
    if (entry.key is String)
      entry.key as String: _bindNodeVariableValue(entry.value, bindings),
};

Object? _bindNodeVariableValue(Object? value, Map<String, JsonMap> bindings) {
  if (value is Map && value['type'] == 'VARIABLE_ALIAS') {
    final id = value['id'];
    if (id is String) return bindings[id] ?? value.cast<String, Object?>();
  }
  if (value is List && value.length == 1) {
    return _bindNodeVariableValue(value.single, bindings);
  }

  return value;
}

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

Map<String, JsonMap> _readThemesIfExists(String path) {
  final directory = Directory(path);
  if (!directory.existsSync()) return const {};
  final files =
      directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.theme.json'))
          .toList()
        ..sort((left, right) => left.path.compareTo(right.path));

  return {
    for (final file in files)
      file.uri.pathSegments.last.replaceFirst('.theme.json', ''): _decodeObject(
        file.readAsStringSync(),
        path: file.path,
      ),
  };
}

Map<String, JsonMap> _readProtocolFilesIfExists(
  String path, {
  required String extension,
}) {
  final directory = Directory(path);
  if (!directory.existsSync()) return const {};
  final files =
      directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith(extension))
          .toList()
        ..sort((left, right) => left.path.compareTo(right.path));

  return {
    for (final file in files)
      file.uri.pathSegments.last.substring(
        0,
        file.uri.pathSegments.last.length - extension.length,
      ): _decodeObject(
        file.readAsStringSync(),
        path: file.path,
      ),
  };
}

MixFigmaDiagnostic _parseDiagnostic(JsonMap value, {required String path}) {
  final severity = jsonString(value['severity'], path: '$path/severity');

  return MixFigmaDiagnostic(
    code: jsonString(value['code'], path: '$path/code'),
    severity: switch (severity) {
      'error' => .error,
      'warning' => .warning,
      'info' => .info,
      _ => throw FormatException('Unknown diagnostic severity "$severity".'),
    },
    path: jsonString(value['path'], path: '$path/path'),
    message: jsonString(value['message'], path: '$path/message'),
  );
}

void _validateFileRef(String value) {
  if (value.isEmpty ||
      value == '.' ||
      value == '..' ||
      !RegExp(r'^[A-Za-z0-9][A-Za-z0-9_.-]*$').hasMatch(value)) {
    throw FormatException('Unsafe local artifact reference "$value".');
  }
}

List<MixFigmaDiagnostic> _writeResultDiagnostics(
  _PreparedSync prepared,
  JsonMap current,
  JsonMap result,
) => switch (prepared.plan.resource) {
  .tokens => _tokenWriteResultDiagnostics(prepared, current, result),
  .component => _componentWriteResultDiagnostics(prepared, current, result),
  .selection => const [],
};

List<MixFigmaDiagnostic> _tokenWriteResultDiagnostics(
  _PreparedSync prepared,
  JsonMap current,
  JsonMap result,
) {
  final diagnostics = <MixFigmaDiagnostic>[];
  final desired = prepared.pushPayload!;
  final desiredVariables = _object(
    desired['variables'],
    path: '/payload/variables',
  );
  final desiredStyles = _object(desired['styles'], path: '/payload/styles');
  final resultVariables = _object(
    result['variables'],
    path: '/writeResult/variables',
  );
  final resultStyles = _object(result['styles'], path: '/writeResult/styles');
  final currentVariables = parseFigmaVariablesDocument(
    _object(current['variables'], path: '/current/variables'),
  );
  final currentStyles = parseFigmaStylesDocument(
    current['styles'] == null
        ? _emptyStyles
        : _object(current['styles'], path: '/current/styles'),
  );

  final desiredCollections = _jsonObjects(
    desiredVariables['collections'],
    path: '/payload/variables/collections',
  );
  final collectionsByIdentity = {
    for (final collection in currentVariables.collections)
      if (_syncIdentity(collection.pluginData) case final String identity)
        identity: collection,
  };
  _validateIdentityResult(
    diagnostics: diagnostics,
    kind: 'variable collection',
    path: '/writeResult/variables/collections',
    expectedRefs: desiredCollections.map(
      (item) => jsonString(item['ref'], path: '/payload/variables/ref'),
    ),
    result: _stringResultMap(
      resultVariables['collections'],
      path: '/writeResult/variables/collections',
    ),
    observed: {
      for (final entry in collectionsByIdentity.entries)
        entry.key: entry.value.id,
    },
  );

  final modeResults = _object(
    resultVariables['modes'],
    path: '/writeResult/variables/modes',
  );
  _validateResultKeys(
    diagnostics: diagnostics,
    kind: 'variable collection mode map',
    path: '/writeResult/variables/modes',
    expected: desiredCollections
        .map((item) => jsonString(item['ref'], path: '/payload/variables/ref'))
        .toSet(),
    actual: modeResults.keys.toSet(),
  );
  for (final collectionPayload in desiredCollections) {
    final collectionRef = jsonString(
      collectionPayload['ref'],
      path: '/payload/variables/collections/ref',
    );
    final desiredModes = _jsonObjects(
      collectionPayload['modes'],
      path: '/payload/variables/collections/$collectionRef/modes',
    );
    final returnedModes = modeResults[collectionRef] == null
        ? const <String, String>{}
        : _stringResultMap(
            modeResults[collectionRef],
            path: '/writeResult/variables/modes/$collectionRef',
          );
    final expectedModeRefs = desiredModes
        .map(
          (item) => _requiredStringField(
            item,
            'ref',
            path: '/payload/variables/collections/$collectionRef/modes/ref',
          ),
        )
        .toSet();
    _validateResultKeys(
      diagnostics: diagnostics,
      kind: 'mode',
      path: '/writeResult/variables/modes/$collectionRef',
      expected: expectedModeRefs,
      actual: returnedModes.keys.toSet(),
    );
    final observedCollection = collectionsByIdentity[collectionRef];
    for (final modePayload in desiredModes) {
      final modeRef = jsonString(
        modePayload['ref'],
        path: '/payload/variables/collections/$collectionRef/modes/ref',
      );
      final modeName = jsonString(
        modePayload['name'],
        path:
            '/payload/variables/collections/$collectionRef/modes/$modeRef/name',
      );
      final returnedId = returnedModes[modeRef];
      final matches = observedCollection?.modes.any(
        (mode) => mode.id == returnedId && mode.name == modeName,
      );
      if (returnedId == null || matches != true) {
        diagnostics.add(
          _writeResultMismatch(
            path: '/writeResult/variables/modes/$collectionRef/$modeRef',
            message:
                'Returned mode id does not match the verified Figma mode "$modeName".',
          ),
        );
      }
    }
  }

  final desiredVariableItems = _jsonObjects(
    desiredVariables['variables'],
    path: '/payload/variables/variables',
  );
  _validateIdentityResult(
    diagnostics: diagnostics,
    kind: 'variable',
    path: '/writeResult/variables/variables',
    expectedRefs: desiredVariableItems.map(
      (item) => jsonString(item['ref'], path: '/payload/variables/ref'),
    ),
    result: _stringResultMap(
      resultVariables['variables'],
      path: '/writeResult/variables/variables',
    ),
    observed: {
      for (final variable in currentVariables.variables)
        if (_syncIdentity(variable.pluginData) case final String identity)
          identity: variable.id,
    },
  );

  final observedStyles = {
    'textStyles': <String, String>{},
    'effectStyles': <String, String>{},
    'paintStyles': <String, String>{},
  };
  for (final style in currentStyles.styles) {
    final identity = _syncIdentity(style.pluginData);
    if (identity == null) continue;
    final key = switch (style.type.name) {
      'text' => 'textStyles',
      'effect' => 'effectStyles',
      'paint' => 'paintStyles',
      _ => throw StateError('Unsupported Figma style type ${style.type.name}.'),
    };
    observedStyles[key]![identity] = style.id;
  }
  for (final key in ['textStyles', 'effectStyles', 'paintStyles']) {
    final desiredItems = _jsonObjects(
      desiredStyles[key] ?? const <Object?>[],
      path: '/payload/styles/$key',
    );
    _validateIdentityResult(
      diagnostics: diagnostics,
      kind: key,
      path: '/writeResult/styles/$key',
      expectedRefs: desiredItems.map(
        (item) =>
            _requiredStringField(item, 'ref', path: '/payload/styles/$key/ref'),
      ),
      result: _stringResultMap(
        resultStyles[key],
        path: '/writeResult/styles/$key',
      ),
      observed: observedStyles[key]!,
    );
  }

  return diagnostics;
}

List<MixFigmaDiagnostic> _componentWriteResultDiagnostics(
  _PreparedSync prepared,
  JsonMap current,
  JsonMap result,
) {
  final diagnostics = <MixFigmaDiagnostic>[];
  final componentRef = prepared.componentRef!;
  final currentSet = current['componentSet'] is Map
      ? (current['componentSet']! as Map).cast<String, Object?>()
      : null;
  final returnedSetId = jsonString(
    result['componentSetId'],
    path: '/writeResult/componentSetId',
  );
  final observedSetId = currentSet?['id'];
  final observedIdentity = currentSet == null
      ? null
      : _syncIdentity(
          currentSet['pluginData'] is Map
              ? (currentSet['pluginData']! as Map).cast()
              : const {},
        );
  if (observedSetId != returnedSetId || observedIdentity != componentRef) {
    diagnostics.add(
      _writeResultMismatch(
        path: '/writeResult/componentSetId',
        message:
            'Returned component-set id does not match the verified Figma component set.',
      ),
    );
  }

  final desiredVariants = _jsonObjects(
    prepared.pushPayload!['variants'],
    path: '/payload/variants',
  );
  final observedVariants = <String, String>{};
  final rawCurrentVariants = currentSet?['variants'];
  if (rawCurrentVariants is List) {
    for (final raw in rawCurrentVariants) {
      final variant = _object(raw, path: '/current/componentSet/variants');
      final pluginData = variant['pluginData'] is Map
          ? (variant['pluginData']! as Map).cast<String, Object?>()
          : const <String, Object?>{};
      final identity = _syncIdentity(pluginData);
      if (identity != null && identity.startsWith('$componentRef.')) {
        observedVariants[identity.substring(
          componentRef.length + 1,
        )] = jsonString(
          variant['id'],
          path: '/current/componentSet/variants/id',
        );
      }
    }
  }
  _validateIdentityResult(
    diagnostics: diagnostics,
    kind: 'component variant',
    path: '/writeResult/variants',
    expectedRefs: desiredVariants.map(
      (item) => jsonString(item['ref'], path: '/payload/variants/ref'),
    ),
    result: _stringResultMap(result['variants'], path: '/writeResult/variants'),
    observed: observedVariants,
  );
  final rawResultDiagnostics = result['diagnostics'];
  for (final (index, raw) in _list(
    rawResultDiagnostics,
    path: '/writeResult/diagnostics',
  ).indexed) {
    final diagnostic = _parseDiagnostic(
      _object(raw, path: '/writeResult/diagnostics/$index'),
      path: '/writeResult/diagnostics/$index',
    );
    if (diagnostic.severity == .error) diagnostics.add(diagnostic);
  }

  return diagnostics;
}

MixFigmaLock _tokenLockFromVerifiedReadback(
  MixFigmaLock existing,
  JsonMap current,
  JsonMap writeResult,
) {
  final variables = parseFigmaVariablesDocument(
    _object(current['variables'], path: '/current/variables'),
  );
  final styles = parseFigmaStylesDocument(
    current['styles'] == null
        ? _emptyStyles
        : _object(current['styles'], path: '/current/styles'),
  );
  final resultVariables = _object(
    writeResult['variables'],
    path: '/writeResult/variables',
  );
  final returnedModes = _object(
    resultVariables['modes'],
    path: '/writeResult/variables/modes',
  );
  final collectionsByRef = {
    for (final collection in variables.collections)
      if (_syncIdentity(collection.pluginData) case final String identity)
        identity: collection,
  };
  final modeIds = <String, Map<String, String>>{};
  for (final entry in collectionsByRef.entries) {
    final liveIds = entry.value.modes.map((mode) => mode.id).toSet();
    final retained = <String, String>{
      for (final old
          in existing.modeIds[entry.key]?.entries ??
              const <MapEntry<String, String>>[])
        if (liveIds.contains(old.value)) old.key: old.value,
    };
    final returned = returnedModes[entry.key] == null
        ? const <String, String>{}
        : _stringResultMap(
            returnedModes[entry.key],
            path: '/writeResult/variables/modes/${entry.key}',
          );
    modeIds[entry.key] = {...retained, ...returned};
  }

  return MixFigmaLock(
    collectionIds: {
      for (final entry in collectionsByRef.entries) entry.key: entry.value.id,
    },
    modeIds: modeIds,
    variableIds: {
      for (final variable in variables.variables)
        if (_syncIdentity(variable.pluginData) case final String identity)
          identity: variable.id,
    },
    styleIds: {
      for (final style in styles.styles)
        if (_syncIdentity(style.pluginData) case final String identity)
          identity: style.id,
    },
    componentIds: existing.componentIds,
  );
}

void _validateIdentityResult({
  required List<MixFigmaDiagnostic> diagnostics,
  required String kind,
  required String path,
  required Iterable<String> expectedRefs,
  required Map<String, String> result,
  required Map<String, String> observed,
}) {
  final expected = expectedRefs.toSet();
  _validateResultKeys(
    diagnostics: diagnostics,
    kind: kind,
    path: path,
    expected: expected,
    actual: result.keys.toSet(),
  );
  final ordered = expected.toList()..sort();
  for (final ref in ordered) {
    if (result[ref] != observed[ref]) {
      diagnostics.add(
        _writeResultMismatch(
          path: '$path/$ref',
          message:
              'Returned $kind id for "$ref" does not match the verified Figma resource.',
        ),
      );
    }
  }
}

void _validateResultKeys({
  required List<MixFigmaDiagnostic> diagnostics,
  required String kind,
  required String path,
  required Set<String> expected,
  required Set<String> actual,
}) {
  if (expected.length == actual.length && expected.containsAll(actual)) return;
  final missing = expected.difference(actual).toList()..sort();
  final extra = actual.difference(expected).toList()..sort();
  diagnostics.add(
    _writeResultMismatch(
      path: path,
      message:
          'Returned $kind identities differ from the approved payload '
          '(missing: ${missing.join(', ')}, extra: ${extra.join(', ')}).',
    ),
  );
}

MixFigmaDiagnostic _writeResultMismatch({
  required String path,
  required String message,
}) => .new(
  code: 'sync_write_result_mismatch',
  severity: .error,
  path: path,
  message: message,
);

String? _syncIdentity(Map<String, Object?> pluginData) {
  final value = pluginData['mix_figma.id'] ?? pluginData['mix.key'];

  return value is String && value.isNotEmpty ? value : null;
}

List<JsonMap> _jsonObjects(Object? value, {required String path}) => _list(
  value,
  path: path,
).indexed.map((entry) => _object(entry.$2, path: '$path/${entry.$1}')).toList();

Map<String, String> _stringResultMap(Object? value, {required String path}) {
  final object = _object(value, path: path);

  return {
    for (final entry in object.entries)
      entry.key: jsonString(entry.value, path: '$path/${entry.key}'),
  };
}

MixFigmaLock _readLock(String path) {
  final file = File(path);
  if (!file.existsSync()) return .empty;

  return MixFigmaLock.fromJson(
    _decodeObject(file.readAsStringSync(), path: file.path),
  );
}

void _writeLock(String path, MixFigmaLock lock) {
  _writeJsonSafely(path, lock.toJson());
}

void _writeJsonSafely(String path, JsonMap value) {
  final target = File(path);
  target.parent.createSync(recursive: true);
  final suffix = '$pid-${DateTime.now().microsecondsSinceEpoch}';
  final temporary = File('$path.tmp-$suffix');
  final backup = File('$path.backup-$suffix');
  temporary.writeAsStringSync(_json(value), flush: true);
  try {
    if (target.existsSync()) target.renameSync(backup.path);
    try {
      temporary.renameSync(target.path);
    } on Object {
      if (backup.existsSync()) backup.renameSync(target.path);
      rethrow;
    }
    if (backup.existsSync()) backup.deleteSync();
  } finally {
    if (temporary.existsSync()) temporary.deleteSync();
    if (backup.existsSync() && target.existsSync()) backup.deleteSync();
  }
}

Future<JsonMap> _body(HttpRequest request) async => _decodeObject(
  await utf8.decoder.bind(request).join(),
  path: request.uri.path,
);

String _requiredStringField(
  JsonMap object,
  String field, {
  required String path,
}) => jsonString(object[field], path: path);

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
    ..set('Access-Control-Allow-Headers', 'authorization, content-type')
    ..set('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
}

String createMixFigmaBridgeToken() {
  final random = Random.secure();
  final bytes = List.generate(32, (_) => random.nextInt(256));

  return base64UrlEncode(bytes).replaceAll('=', '');
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

const JsonMap _emptyStyles = {
  'version': 1,
  'textStyles': <Object?>[],
  'effectStyles': <Object?>[],
  'paintStyles': <Object?>[],
};

final class _PreparedSync {
  final MixFigmaSyncPlan plan;
  final JsonMap snapshot;
  final MixFigmaTokenPullAnalysis? pullAnalysis;
  final MixFigmaSelectionPullAnalysis? selectionAnalysis;
  final JsonMap? pushPayload;
  final String? componentId;
  final String? componentRef;
  bool allowDeletes = false;
  bool applied = false;
  _PreparedSync({
    required this.plan,
    required this.snapshot,
    this.pullAnalysis,
    this.selectionAnalysis,
    this.pushPayload,
    this.componentId,
    this.componentRef,
  });

  JsonMap previewJson() => {
    'plan': plan.toJson(),
    if (pullAnalysis != null) 'artifacts': pullAnalysis!.artifacts.toJson(),
    if (selectionAnalysis != null)
      'artifacts': selectionAnalysis!.artifacts.toJson(),
    'payload': ?pushPayload,
  };
}

final class BridgeHttpException implements Exception {
  final int statusCode;
  final String message;
  const BridgeHttpException(this.statusCode, this.message);

  @override
  String toString() => message;
}
