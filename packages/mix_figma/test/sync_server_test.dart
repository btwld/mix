import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/protocol_json/figma_variable_payload.dart';

import '../tool/bridge_server.dart';

void main() {
  test('bridge session token rejects unauthorized browser requests', () async {
    final bridge = MixFigmaBridgeServer(port: 0, authToken: 'test-token');
    final server = await bridge.start();
    final base = Uri.parse('http://127.0.0.1:${server.port}');
    try {
      final unauthorized = await _request(base, '/webhooks/figma', {
        'event_type': 'PING',
      });
      expect(unauthorized.statusCode, HttpStatus.unauthorized);

      final authorized = await _request(base, '/webhooks/figma', {
        'event_type': 'PING',
      }, authToken: 'test-token');
      expect(authorized.statusCode, HttpStatus.ok);
      expect(authorized.body['status'], 'ignored');
    } finally {
      await server.close(force: true);
    }
  });

  test(
    'token pull follows plan, safe apply, and read-back verification',
    () async {
      final root = Directory.systemTemp.createTempSync('mix_figma_sync_test_');
      final themes = Directory('${root.path}/themes')..createSync();
      final reports = Directory('${root.path}/reports');
      File(
        '${themes.path}/legacy.theme.json',
      ).writeAsStringSync(jsonEncode({'v': 1, 'type': 'theme'}));
      File('${themes.path}/keep.txt').writeAsStringSync('preserve me');
      final variables = _fixture(
        'test/fixtures/figma_variables/primitives.json',
      );
      final styles = _fixture('test/fixtures/style_docs/figma_styles.json');
      final snapshot = {'variables': variables, 'styles': styles};
      final bridge = MixFigmaBridgeServer(
        port: 0,
        themeDirectory: themes.path,
        reportDirectory: reports.path,
      );
      final server = await bridge.start();
      final base = Uri.parse('http://127.0.0.1:${server.port}');
      try {
        final planned = await _request(base, '/sync/plan', {
          'version': 1,
          'direction': 'figmaToMix',
          'resource': 'tokens',
          'current': snapshot,
        });
        expect(planned.statusCode, HttpStatus.ok);
        final plan = planned.body['plan']! as Map;
        final operations = (plan['operations']! as List).cast<Map>();
        expect(
          operations.singleWhere(
            (item) => item['name'] == 'legacy.theme.json',
          )['action'],
          'delete',
        );
        expect(File('${themes.path}/light.theme.json').existsSync(), isFalse);

        final applied = await _request(base, '/sync/apply', {
          'planId': plan['id'],
          'allowDeletes': false,
          'current': snapshot,
        });
        expect(applied.statusCode, HttpStatus.ok);
        expect(applied.body['status'], 'applied');
        expect(File('${themes.path}/light.theme.json').existsSync(), isTrue);
        expect(File('${themes.path}/dark.theme.json').existsSync(), isTrue);
        expect(File('${themes.path}/legacy.theme.json').existsSync(), isTrue);
        expect(
          File('${themes.path}/keep.txt').readAsStringSync(),
          'preserve me',
        );

        final verified = await _request(base, '/sync/verify', {
          'planId': plan['id'],
        });
        expect(verified.statusCode, HttpStatus.ok);
        expect(verified.body['status'], 'verifiedWithRetainedItems');
        expect(File('${reports.path}/${plan['id']}.json').existsSync(), isTrue);
      } finally {
        await server.close(force: true);
        root.deleteSync(recursive: true);
      }
    },
  );

  test('token push writes its lock only after verified read-back', () async {
    final root = Directory.systemTemp.createTempSync('mix_figma_sync_test_');
    final themes = Directory('${root.path}/themes')..createSync();
    final reports = Directory('${root.path}/reports');
    final lock = File('${themes.path}/mix_figma.lock.json');
    for (final mode in ['light', 'dark']) {
      File('${themes.path}/$mode.theme.json').writeAsStringSync(
        jsonEncode(_fixture('test/fixtures/theme_docs/$mode.theme.json')),
      );
    }
    final emptySnapshot = <String, Object?>{
      'variables': {
        'schema': 'mix_figma/figma-variables/v1',
        'collections': <Object?>[],
        'variables': <Object?>[],
      },
      'styles': _emptyStylesSnapshot,
    };
    final bridge = MixFigmaBridgeServer(
      port: 0,
      themeDirectory: themes.path,
      reportDirectory: reports.path,
    );
    final server = await bridge.start();
    final base = Uri.parse('http://127.0.0.1:${server.port}');
    try {
      final planned = await _request(base, '/sync/plan', {
        'version': 1,
        'direction': 'mixToFigma',
        'resource': 'tokens',
        'current': emptySnapshot,
      });
      expect(planned.statusCode, HttpStatus.ok);
      final plan = planned.body['plan']! as Map;

      final applied = await _request(base, '/sync/apply', {
        'planId': plan['id'],
        'allowDeletes': false,
        'current': emptySnapshot,
      });
      expect(applied.statusCode, HttpStatus.ok);
      expect(applied.body['status'], 'approved');
      expect(lock.existsSync(), isFalse);

      final payload = (applied.body['payload']! as Map).cast<String, Object?>();
      final variablePayload = (payload['variables']! as Map)
          .cast<String, Object?>();
      final stylePayload = (payload['styles']! as Map).cast<String, Object?>();
      final observedSnapshot = <String, Object?>{
        'variables': figmaVariablesDocumentFromWritePayload(
          variablePayload,
        ).toJson(),
        'styles': _stylesSnapshot(stylePayload),
      };
      final writeResult = _tokenWriteResult(observedSnapshot);

      final readBackPlan = await _request(base, '/sync/plan', {
        'version': 1,
        'direction': 'mixToFigma',
        'resource': 'tokens',
        'current': observedSnapshot,
      });
      final readBackOperations =
          ((readBackPlan.body['plan']! as Map)['operations']! as List)
              .cast<Map>()
              .where(
                (item) =>
                    item['action'] != 'unchanged' && item['action'] != 'skip',
              )
              .toList();
      expect(readBackOperations, isEmpty, reason: '$readBackOperations');

      final rejectedIdentity = await _request(base, '/sync/verify', {
        'planId': plan['id'],
        'current': observedSnapshot,
        'writeResult': {
          ...writeResult,
          'variables': {
            ...(writeResult['variables']! as Map),
            'collections': {'Mix Tokens': 'VariableCollection:wrong'},
          },
        },
      });
      expect(rejectedIdentity.statusCode, HttpStatus.unprocessableEntity);
      expect(rejectedIdentity.body['status'], 'failed');
      expect(lock.existsSync(), isFalse);

      final verified = await _request(base, '/sync/verify', {
        'planId': plan['id'],
        'current': observedSnapshot,
        'writeResult': writeResult,
      });
      expect(verified.statusCode, HttpStatus.ok, reason: '${verified.body}');
      expect(verified.body['status'], 'verified');
      expect(lock.existsSync(), isTrue);
      final lockJson = _fixture(lock.path);
      expect(lockJson['schema'], 'mix_figma/lock/v2');
      expect(
        ((lockJson['modes']! as Map)['Mix Tokens']! as Map)['mode:light'],
        ((writeResult['variables']! as Map)['modes']!
            as Map)['Mix Tokens']['mode:light'],
      );
      expect(File('${reports.path}/${plan['id']}.json').existsSync(), isTrue);
    } finally {
      await server.close(force: true);
      root.deleteSync(recursive: true);
    }
  });

  test('apply rejects a stale plan before either side is mutated', () async {
    final root = Directory.systemTemp.createTempSync('mix_figma_sync_test_');
    final themes = Directory('${root.path}/themes')..createSync();
    final reports = Directory('${root.path}/reports');
    final lock = File('${themes.path}/mix_figma.lock.json');
    File('${themes.path}/light.theme.json').writeAsStringSync(
      jsonEncode(_fixture('test/fixtures/theme_docs/light.theme.json')),
    );
    final initial = <String, Object?>{
      'variables': {
        'schema': 'mix_figma/figma-variables/v1',
        'collections': <Object?>[],
        'variables': <Object?>[],
      },
      'styles': _emptyStylesSnapshot,
    };
    final changed = <String, Object?>{
      'variables': {
        'schema': 'mix_figma/figma-variables/v1',
        'collections': [
          {
            'id': 'VariableCollection:user',
            'key': 'user-key',
            'name': 'User collection',
            'defaultModeId': 'mode:user',
            'modes': [
              {'id': 'mode:user', 'name': 'Default'},
            ],
            'remote': false,
          },
        ],
        'variables': <Object?>[],
      },
      'styles': _emptyStylesSnapshot,
    };
    final bridge = MixFigmaBridgeServer(
      port: 0,
      themeDirectory: themes.path,
      reportDirectory: reports.path,
    );
    final server = await bridge.start();
    final base = Uri.parse('http://127.0.0.1:${server.port}');
    try {
      final planned = await _request(base, '/sync/plan', {
        'version': 1,
        'direction': 'mixToFigma',
        'resource': 'tokens',
        'current': initial,
      });
      final plan = planned.body['plan']! as Map;

      final applied = await _request(base, '/sync/apply', {
        'planId': plan['id'],
        'allowDeletes': true,
        'current': changed,
      });

      expect(applied.statusCode, HttpStatus.conflict);
      expect(applied.body['error'], contains('stale'));
      expect(lock.existsSync(), isFalse);
      expect(reports.existsSync(), isFalse);
    } finally {
      await server.close(force: true);
      root.deleteSync(recursive: true);
    }
  });

  test('a failed local Apply cannot be verified as an applied plan', () async {
    final root = Directory.systemTemp.createTempSync('mix_figma_sync_test_');
    final themes = File('${root.path}/themes')
      ..writeAsStringSync('not a directory');
    final reports = Directory('${root.path}/reports');
    final snapshot = <String, Object?>{
      'variables': _fixture('test/fixtures/figma_variables/primitives.json'),
      'styles': _fixture('test/fixtures/style_docs/figma_styles.json'),
    };
    final bridge = MixFigmaBridgeServer(
      port: 0,
      themeDirectory: themes.path,
      reportDirectory: reports.path,
    );
    final server = await bridge.start();
    final base = Uri.parse('http://127.0.0.1:${server.port}');
    try {
      final planned = await _request(base, '/sync/plan', {
        'version': 1,
        'direction': 'figmaToMix',
        'resource': 'tokens',
        'current': snapshot,
      });
      final plan = planned.body['plan']! as Map;

      final applied = await _request(base, '/sync/apply', {
        'planId': plan['id'],
        'allowDeletes': false,
        'current': snapshot,
      });
      expect(applied.statusCode, isNot(HttpStatus.ok));

      final verified = await _request(base, '/sync/verify', {
        'planId': plan['id'],
      });
      expect(verified.statusCode, HttpStatus.conflict);
      expect(verified.body['error'], contains('not applied'));
      expect(reports.existsSync(), isFalse);
    } finally {
      await server.close(force: true);
      root.deleteSync(recursive: true);
    }
  });

  test(
    'a partial local installation is rolled back before Apply fails',
    () async {
      final root = Directory.systemTemp.createTempSync('mix_figma_sync_test_');
      final themes = Directory('${root.path}/themes')..createSync();
      final reports = Directory('${root.path}/reports');
      final variables = _fixture(
        'test/fixtures/figma_variables/primitives.json',
      );
      final styles = _fixture('test/fixtures/style_docs/figma_styles.json');
      final snapshot = {'variables': variables, 'styles': styles};
      final bridge = MixFigmaBridgeServer(
        port: 0,
        themeDirectory: themes.path,
        reportDirectory: reports.path,
      );
      final server = await bridge.start();
      final base = Uri.parse('http://127.0.0.1:${server.port}');
      try {
        final planned = await _request(base, '/sync/plan', {
          'version': 1,
          'direction': 'figmaToMix',
          'resource': 'tokens',
          'current': snapshot,
        });
        final plan = planned.body['plan']! as Map;
        final fileWrites = (plan['operations']! as List)
            .cast<Map>()
            .where(
              (item) =>
                  item['action'] == 'create' || item['action'] == 'update',
            )
            .toList();
        expect(fileWrites.length, greaterThanOrEqualTo(2));

        final blockedRef = fileWrites.last['ref']! as String;
        final blockedTarget = Directory('${themes.path}/$blockedRef.theme.json')
          ..createSync();

        final applied = await _request(base, '/sync/apply', {
          'planId': plan['id'],
          'allowDeletes': false,
          'current': snapshot,
        });

        expect(applied.statusCode, isNot(HttpStatus.ok));
        for (final operation in fileWrites.take(fileWrites.length - 1)) {
          expect(
            File('${themes.path}/${operation['ref']}.theme.json').existsSync(),
            isFalse,
          );
        }
        expect(blockedTarget.existsSync(), isTrue);
        expect(
          root.listSync().where(
            (entry) =>
                entry.path.contains('/.mix_figma_stage_') ||
                entry.path.contains('/.mix_figma_backup_'),
          ),
          isEmpty,
        );
        expect(reports.existsSync(), isFalse);

        final verified = await _request(base, '/sync/verify', {
          'planId': plan['id'],
        });
        expect(verified.statusCode, HttpStatus.conflict);
        expect(verified.body['error'], contains('not applied'));
      } finally {
        await server.close(force: true);
        root.deleteSync(recursive: true);
      }
    },
  );

  test('unverified legacy lock endpoints are permanently disabled', () async {
    final root = Directory.systemTemp.createTempSync('mix_figma_sync_test_');
    final themes = Directory('${root.path}/themes')..createSync();
    final lock = File('${themes.path}/mix_figma.lock.json');
    final bridge = MixFigmaBridgeServer(port: 0, themeDirectory: themes.path);
    final server = await bridge.start();
    final base = Uri.parse('http://127.0.0.1:${server.port}');
    try {
      for (final path in ['/lock/tokens', '/lock/components/button']) {
        final response = await _request(base, path, {
          'result': <String, Object?>{},
        });
        expect(response.statusCode, HttpStatus.gone);
        expect(response.body['error'], contains('/sync/verify'));
      }
      expect(lock.existsSync(), isFalse);
    } finally {
      await server.close(force: true);
      root.deleteSync(recursive: true);
    }
  });

  test('failed token read-back never writes the lock', () async {
    final root = Directory.systemTemp.createTempSync('mix_figma_sync_test_');
    final themes = Directory('${root.path}/themes')..createSync();
    final reports = Directory('${root.path}/reports');
    final lock = File('${themes.path}/mix_figma.lock.json');
    File('${themes.path}/light.theme.json').writeAsStringSync(
      jsonEncode(_fixture('test/fixtures/theme_docs/light.theme.json')),
    );
    final emptySnapshot = <String, Object?>{
      'variables': {
        'schema': 'mix_figma/figma-variables/v1',
        'collections': <Object?>[],
        'variables': <Object?>[],
      },
      'styles': _emptyStylesSnapshot,
    };
    final bridge = MixFigmaBridgeServer(
      port: 0,
      themeDirectory: themes.path,
      reportDirectory: reports.path,
    );
    final server = await bridge.start();
    final base = Uri.parse('http://127.0.0.1:${server.port}');
    try {
      final planned = await _request(base, '/sync/plan', {
        'version': 1,
        'direction': 'mixToFigma',
        'resource': 'tokens',
        'current': emptySnapshot,
      });
      final plan = planned.body['plan']! as Map;
      final applied = await _request(base, '/sync/apply', {
        'planId': plan['id'],
        'allowDeletes': false,
        'current': emptySnapshot,
      });
      expect(applied.statusCode, HttpStatus.ok);

      final verified = await _request(base, '/sync/verify', {
        'planId': plan['id'],
        'current': emptySnapshot,
        'writeResult': {
          'variables': {
            'collections': <String, String>{},
            'modes': <String, Object?>{},
            'variables': <String, String>{},
          },
          'styles': {
            'textStyles': <String, String>{},
            'effectStyles': <String, String>{},
            'paintStyles': <String, String>{},
          },
        },
      });

      expect(verified.statusCode, HttpStatus.unprocessableEntity);
      expect(verified.body['status'], 'failed');
      expect(verified.body['remainingMutations'], greaterThan(0));
      expect(lock.existsSync(), isFalse);
      expect(File('${reports.path}/${plan['id']}.json').existsSync(), isTrue);
    } finally {
      await server.close(force: true);
      root.deleteSync(recursive: true);
    }
  });

  test(
    'a verified read-back does not advance the lock without its report',
    () async {
      final root = Directory.systemTemp.createTempSync('mix_figma_sync_test_');
      final themes = Directory('${root.path}/themes')..createSync();
      File('${themes.path}/light.theme.json').writeAsStringSync(
        jsonEncode(_fixture('test/fixtures/theme_docs/light.theme.json')),
      );
      final reports = File('${root.path}/reports')
        ..writeAsStringSync('not a directory');
      final lock = File('${themes.path}/mix_figma.lock.json');
      final emptySnapshot = <String, Object?>{
        'variables': {
          'schema': 'mix_figma/figma-variables/v1',
          'collections': <Object?>[],
          'variables': <Object?>[],
        },
        'styles': _emptyStylesSnapshot,
      };
      final bridge = MixFigmaBridgeServer(
        port: 0,
        themeDirectory: themes.path,
        reportDirectory: reports.path,
      );
      final server = await bridge.start();
      final base = Uri.parse('http://127.0.0.1:${server.port}');
      try {
        final planned = await _request(base, '/sync/plan', {
          'version': 1,
          'direction': 'mixToFigma',
          'resource': 'tokens',
          'current': emptySnapshot,
        });
        final plan = planned.body['plan']! as Map;
        final applied = await _request(base, '/sync/apply', {
          'planId': plan['id'],
          'allowDeletes': false,
          'current': emptySnapshot,
        });
        final payload = (applied.body['payload']! as Map)
            .cast<String, Object?>();
        final variablePayload = (payload['variables']! as Map)
            .cast<String, Object?>();
        final stylePayload = (payload['styles']! as Map)
            .cast<String, Object?>();
        final observedSnapshot = <String, Object?>{
          'variables': figmaVariablesDocumentFromWritePayload(
            variablePayload,
          ).toJson(),
          'styles': _stylesSnapshot(stylePayload),
        };

        final verified = await _request(base, '/sync/verify', {
          'planId': plan['id'],
          'current': observedSnapshot,
          'writeResult': _tokenWriteResult(observedSnapshot),
        });

        expect(verified.statusCode, isNot(HttpStatus.ok));
        expect(lock.existsSync(), isFalse);
      } finally {
        await server.close(force: true);
        root.deleteSync(recursive: true);
      }
    },
  );

  test('selection import plans, stages, and verifies style files', () async {
    final root = Directory.systemTemp.createTempSync('mix_figma_sync_test_');
    final themes = Directory('${root.path}/themes')..createSync();
    final styles = Directory('${root.path}/styles')..createSync();
    final reports = Directory('${root.path}/reports');
    File('${styles.path}/keep.txt').writeAsStringSync('preserve me');
    final selection = <String, Object?>{
      'nodes': {
        'version': 1,
        'pageId': 'page:1',
        'pageName': 'Page',
        'diagnostics': <Object?>[],
        'selection': [_selectionSnapshot('button.node.json')],
      },
      'variables': {
        'version': 1,
        'collections': <Object?>[],
        'variables': <Object?>[],
      },
    };
    final bridge = MixFigmaBridgeServer(
      port: 0,
      themeDirectory: themes.path,
      styleDirectory: styles.path,
      reportDirectory: reports.path,
    );
    final server = await bridge.start();
    final base = Uri.parse('http://127.0.0.1:${server.port}');
    try {
      final planned = await _request(base, '/sync/plan', {
        'version': 1,
        'direction': 'figmaToMix',
        'resource': 'selection',
        'current': selection,
      });
      expect(planned.statusCode, HttpStatus.ok);
      final plan = planned.body['plan']! as Map;
      expect(((plan['operations']! as List).single as Map)['action'], 'create');
      expect(
        File('${styles.path}/button-surface.style.json').existsSync(),
        isFalse,
      );

      final applied = await _request(base, '/sync/apply', {
        'planId': plan['id'],
        'allowDeletes': false,
        'current': selection,
      });
      expect(applied.statusCode, HttpStatus.ok);
      expect(
        File('${styles.path}/button-surface.style.json').existsSync(),
        isTrue,
      );
      expect(File('${styles.path}/keep.txt').readAsStringSync(), 'preserve me');

      final verified = await _request(base, '/sync/verify', {
        'planId': plan['id'],
      });
      expect(verified.statusCode, HttpStatus.ok);
      expect(verified.body['status'], 'verified');
      expect(File('${reports.path}/${plan['id']}.json').existsSync(), isTrue);
    } finally {
      await server.close(force: true);
      root.deleteSync(recursive: true);
    }
  });

  test('component export updates its lock only after read-back', () async {
    final root = Directory.systemTemp.createTempSync('mix_figma_sync_test_');
    final themes = Directory('${root.path}/themes')..createSync();
    final components = Directory('${root.path}/components')..createSync();
    final reports = Directory('${root.path}/reports');
    File('${components.path}/fixture.component.json').writeAsBytesSync(
      File(
        '../mix_component_contract/test/fixtures/component_v2.component.json',
      ).readAsBytesSync(),
    );
    final lock = File('${themes.path}/mix_figma.lock.json');
    final current = <String, Object?>{'componentSet': null};
    final bridge = MixFigmaBridgeServer(
      port: 0,
      themeDirectory: themes.path,
      componentDirectory: components.path,
      reportDirectory: reports.path,
    );
    final server = await bridge.start();
    final base = Uri.parse('http://127.0.0.1:${server.port}');
    try {
      final planned = await _request(base, '/sync/plan', {
        'version': 1,
        'direction': 'mixToFigma',
        'resource': 'component',
        'componentId': 'fixture',
        'current': current,
      });
      expect(planned.statusCode, HttpStatus.ok);
      final plan = planned.body['plan']! as Map;

      final applied = await _request(base, '/sync/apply', {
        'planId': plan['id'],
        'allowDeletes': false,
        'current': current,
      });
      expect(applied.statusCode, HttpStatus.ok);
      expect(lock.existsSync(), isFalse);
      final payload = (applied.body['payload']! as Map).cast<String, Object?>();
      final variants = (payload['variants']! as List).cast<Map>();
      final observed = <String, Object?>{
        'componentSet': {
          'id': 'ComponentSet:1',
          'name': payload['name'],
          'pluginData': payload['pluginData'],
          'variants': [
            for (final (index, variant) in variants.indexed)
              {
                'id': 'Component:${index + 1}',
                'name': _variantName((variant['properties']! as Map).cast()),
                'pluginData': ((variant['root']! as Map)['pluginData']! as Map)
                    .cast(),
              },
          ],
        },
      };
      final verified = await _request(base, '/sync/verify', {
        'planId': plan['id'],
        'current': observed,
        'writeResult': {
          'componentSetId': 'ComponentSet:1',
          'variants': {
            for (final (index, variant) in variants.indexed)
              variant['ref']! as String: 'Component:${index + 1}',
          },
          'diagnostics': <Object?>[],
        },
      });

      expect(verified.statusCode, HttpStatus.ok, reason: '${verified.body}');
      expect(verified.body['status'], 'verified');
      expect(
        (_fixture(lock.path)['components']! as Map)['fixture'],
        'ComponentSet:1',
      );
      expect(File('${reports.path}/${plan['id']}.json').existsSync(), isTrue);
    } finally {
      await server.close(force: true);
      root.deleteSync(recursive: true);
    }
  });

  test(
    'component apply only forwards a source id proven by read-back',
    () async {
      final root = Directory.systemTemp.createTempSync('mix_figma_sync_test_');
      final themes = Directory('${root.path}/themes')..createSync();
      final components = Directory('${root.path}/components')..createSync();
      File('${components.path}/fixture.component.json').writeAsBytesSync(
        File(
          '../mix_component_contract/test/fixtures/component_v2.component.json',
        ).readAsBytesSync(),
      );
      File('${themes.path}/mix_figma.lock.json').writeAsStringSync(
        jsonEncode({
          'schema': 'mix_figma/lock/v2',
          'collections': <String, String>{},
          'modes': <String, Object?>{},
          'variables': <String, String>{},
          'styles': <String, String>{},
          'components': {'fixture': 'ComponentSet:stale'},
        }),
      );
      final bridge = MixFigmaBridgeServer(
        port: 0,
        themeDirectory: themes.path,
        componentDirectory: components.path,
        reportDirectory: '${root.path}/reports',
      );
      final server = await bridge.start();
      final base = Uri.parse('http://127.0.0.1:${server.port}');
      try {
        final missingCurrent = <String, Object?>{'componentSet': null};
        final createPlan = await _request(base, '/sync/plan', {
          'version': 1,
          'direction': 'mixToFigma',
          'resource': 'component',
          'componentId': 'fixture',
          'current': missingCurrent,
        });
        final createApply = await _request(base, '/sync/apply', {
          'planId': (createPlan.body['plan']! as Map)['id'],
          'allowDeletes': false,
          'current': missingCurrent,
        });
        final createPayload = (createApply.body['payload']! as Map)
            .cast<String, Object?>();
        expect(createPayload.containsKey('sourceId'), isFalse);

        final liveCurrent = <String, Object?>{
          'componentSet': {
            'id': 'ComponentSet:live',
            'name': 'Fixture',
            'pluginData': {'mix_figma.id': 'fixture'},
            'variants': <Object?>[],
          },
        };
        final updatePlan = await _request(base, '/sync/plan', {
          'version': 1,
          'direction': 'mixToFigma',
          'resource': 'component',
          'componentId': 'fixture',
          'current': liveCurrent,
        });
        final updateApply = await _request(base, '/sync/apply', {
          'planId': (updatePlan.body['plan']! as Map)['id'],
          'allowDeletes': false,
          'current': liveCurrent,
        });
        final updatePayload = (updateApply.body['payload']! as Map)
            .cast<String, Object?>();
        expect(updatePayload['sourceId'], 'ComponentSet:live');
      } finally {
        await server.close(force: true);
        root.deleteSync(recursive: true);
      }
    },
  );
}

const _emptyStylesSnapshot = <String, Object?>{
  'version': 1,
  'textStyles': <Object?>[],
  'effectStyles': <Object?>[],
  'paintStyles': <Object?>[],
};

Map<String, Object?> _stylesSnapshot(Map<String, Object?> payload) => {
  'version': 1,
  'textStyles': [
    for (final style in payload['textStyles']! as List)
      _styleSnapshot(style as Map),
  ],
  'effectStyles': [
    for (final style in payload['effectStyles']! as List)
      _styleSnapshot(style as Map),
  ],
  'paintStyles': [
    for (final style in payload['paintStyles']! as List)
      _styleSnapshot(style as Map),
  ],
};

Map<String, Object?> _tokenWriteResult(Map<String, Object?> snapshot) {
  final variables = (snapshot['variables']! as Map).cast<String, Object?>();
  final collections = (variables['collections']! as List).cast<Map>();
  final variableItems = (variables['variables']! as List).cast<Map>();
  final styles = (snapshot['styles']! as Map).cast<String, Object?>();

  String identity(Map item) {
    final pluginData = (item['pluginData']! as Map).cast<String, Object?>();
    final value = pluginData['mix_figma.id'] ?? pluginData['mix.key'];
    if (value is! String) throw StateError('Fixture resource has no identity.');

    return value;
  }

  Map<String, String> styleIds(String key) => {
    for (final style in (styles[key]! as List).cast<Map>())
      identity(style): style['id']! as String,
  };

  return {
    'variables': {
      'collections': {
        for (final collection in collections)
          identity(collection): collection['id']! as String,
      },
      'modes': {
        for (final collection in collections)
          identity(collection): {
            for (final mode in (collection['modes']! as List).cast<Map>())
              mode['id']! as String: mode['id']! as String,
          },
      },
      'variables': {
        for (final variable in variableItems)
          identity(variable): variable['id']! as String,
      },
    },
    'styles': {
      'textStyles': styleIds('textStyles'),
      'effectStyles': styleIds('effectStyles'),
      'paintStyles': styleIds('paintStyles'),
    },
  };
}

Map<String, Object?> _styleSnapshot(Map style) => {
  ...style.cast<String, Object?>(),
  'id': style['sourceId'] ?? style['ref'],
  'key': style['ref'],
  'remote': false,
};

Map<String, Object?> _selectionSnapshot(String filename) {
  final fixture = _fixture('test/fixtures/style_docs/$filename');
  final root = (fixture['root']! as Map).cast<String, Object?>();

  return _pluginNodeSnapshot(root);
}

Map<String, Object?> _pluginNodeSnapshot(Map<String, Object?> node) => {
  'id': node['id'],
  'name': node['name'],
  'type': node['type'],
  'pluginData': node['pluginData'] ?? <String, Object?>{},
  'properties': {
    for (final entry in node.entries)
      if (!{'id', 'name', 'type', 'pluginData', 'children'}.contains(entry.key))
        entry.key: entry.value,
  },
  if (node['children'] is List)
    'children': [
      for (final child in node['children']! as List)
        _pluginNodeSnapshot((child! as Map).cast()),
    ],
};

String _variantName(Map<String, Object?> properties) {
  final entries = properties.entries.toList()
    ..sort((left, right) => left.key.compareTo(right.key));
  if (entries.isEmpty) return 'Variant=Default';

  return entries
      .map(
        (entry) =>
            '${entry.key}=${entry.value is bool ? (entry.value == true ? 'True' : 'False') : entry.value}',
      )
      .join(', ');
}

Map<String, Object?> _fixture(String path) =>
    (jsonDecode(File(path).readAsStringSync())! as Map).cast();

Future<({int statusCode, Map<String, Object?> body})> _request(
  Uri base,
  String path,
  Map<String, Object?> body, {
  String? authToken,
}) async {
  final client = HttpClient();
  try {
    final request = await client.postUrl(base.resolve(path));
    request.headers.contentType = ContentType.json;
    if (authToken != null) {
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $authToken');
    }
    request.write(jsonEncode(body));
    final response = await request.close();
    final decoded = jsonDecode(await utf8.decoder.bind(response).join());
    final responseBody = (decoded! as Map).cast<String, Object?>();

    return (statusCode: response.statusCode, body: responseBody);
  } finally {
    client.close(force: true);
  }
}
