import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/diagnostics/mix_figma_diagnostic.dart';
import 'package:mix_figma/src/core/figma/figma_node_document.dart';
import 'package:mix_figma/src/core/sync/selection_pull_analysis.dart';
import 'package:mix_figma/src/core/sync/sync_plan.dart';

void main() {
  test(
    'selection import plans named style files and reaches a fixed point',
    () {
      final button = _node('test/fixtures/style_docs/button.node.json');
      final card = _node('test/fixtures/style_docs/card.node.json');
      final initial = analyzeSelectionPull(
        selection: [button, card],
        currentStyles: const {
          'keep': {'v': 1, 'type': 'box'},
        },
      );

      expect(initial.plan.resource, MixFigmaSyncResource.selection);
      expect(initial.artifacts.styles.keys, {'button-surface', 'card'});
      expect(
        initial.plan.operations
            .where((item) => item.action == .create)
            .map((item) => item.ref),
        {'button-surface', 'card'},
      );
      expect(
        initial.plan.operations
            .singleWhere((item) => item.ref == 'keep')
            .action,
        MixFigmaSyncAction.skip,
      );

      final readBack = analyzeSelectionPull(
        selection: [button, card],
        currentStyles: {
          ...initial.artifacts.styles,
          'keep': const {'v': 1, 'type': 'box'},
        },
      );
      expect(
        readBack.plan.operations.where(
          (item) => item.action != .unchanged && item.action != .skip,
        ),
        isEmpty,
      );
    },
  );

  test('mapper diagnostics replace duplicate reader diagnostics', () {
    final source = <String, Object?>{
      'id': 'node:inner-shadow',
      'name': 'Inner shadow',
      'type': 'RECTANGLE',
      'effects': [
        {'type': 'INNER_SHADOW', 'visible': true},
      ],
      'children': <Object?>[],
    };
    final analysis = analyzeSelectionPull(
      selection: [
        MixFigmaSelectionInput(
          source: source,
          node: parseFigmaNodeDocument({
            'schema': 'mix_figma/figma-nodes/v1',
            'root': source,
          }).root,
        ),
      ],
      currentStyles: const {},
      diagnostics: const [
        MixFigmaDiagnostic(
          code: 'unsupported_inner_shadow',
          severity: .warning,
          path: 'selection.0',
          message: 'Reader diagnostic.',
        ),
      ],
    );

    expect(
      analysis.artifacts.diagnostics.where(
        (item) => item.code == 'unsupported_inner_shadow',
      ),
      hasLength(1),
    );
  });
}

MixFigmaSelectionInput _node(String path) {
  final json = (jsonDecode(File(path).readAsStringSync())! as Map)
      .cast<String, Object?>();
  final root = (json['root']! as Map).cast<String, Object?>();

  return MixFigmaSelectionInput(
    source: root,
    node: parseFigmaNodeDocument(json).root,
  );
}
