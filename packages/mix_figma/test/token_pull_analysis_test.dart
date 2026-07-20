import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/figma/figma_styles_parser.dart';
import 'package:mix_figma/src/core/figma/figma_variables_parser.dart';
import 'package:mix_figma/src/core/sync/sync_plan.dart';
import 'package:mix_figma/src/core/sync/token_pull_analysis.dart';

void main() {
  test('token pull analysis previews files and reaches a fixed point', () {
    final variables = parseFigmaVariablesDocument(
      _json('test/fixtures/figma_variables/primitives.json'),
    );
    final styles = parseFigmaStylesDocument(
      _json('test/fixtures/style_docs/figma_styles.json'),
    );
    final first = analyzeTokenPull(
      variables: variables,
      styles: styles,
      currentThemes: const {},
    );

    expect(first.artifacts.themes.keys, {'dark', 'light'});
    expect(
      first.plan.operations
          .where((item) => item.action == MixFigmaSyncAction.create)
          .map((item) => item.name),
      {'dark.theme.json', 'light.theme.json'},
    );
    expect(first.artifacts.coverage, hasLength(3));

    final fixedPoint = analyzeTokenPull(
      variables: variables,
      styles: styles,
      currentThemes: first.artifacts.themes,
    );
    expect(
      fixedPoint.plan.operations.every(
        (item) => item.action == MixFigmaSyncAction.unchanged,
      ),
      isTrue,
    );

    final withStaleFile = analyzeTokenPull(
      variables: variables,
      styles: styles,
      currentThemes: {
        ...first.artifacts.themes,
        'legacy': const {'v': 1, 'type': 'theme'},
      },
    );
    final deletion = withStaleFile.plan.operations.singleWhere(
      (item) => item.action == MixFigmaSyncAction.delete,
    );
    expect(deletion.name, 'legacy.theme.json');
    expect(deletion.destructive, isTrue);
    expect(
      withStaleFile.plan.operationsForApply(allowDeletes: false),
      isNot(contains(deletion)),
    );
  });

  test('mode-invariant diagnostics are reported once per source issue', () {
    final result = analyzeTokenPull(
      variables: parseFigmaVariablesDocument(
        _json('test/fixtures/figma_variables/primitives.json'),
      ),
      styles: parseFigmaStylesDocument(
        _json('test/fixtures/style_docs/figma_styles.json'),
      ),
      currentThemes: const {},
    );

    final diagnosticKeys = result.artifacts.diagnostics
        .map(
          (item) =>
              '${item.severity.name}|${item.code}|${item.path}|${item.message}',
        )
        .toList();

    expect(diagnosticKeys.toSet(), hasLength(diagnosticKeys.length));
    expect(
      result.artifacts.diagnostics
          .where((item) => item.code == 'unsupported_variable_type')
          .map((item) => item.path),
      hasLength(1),
    );
    expect(result.plan.diagnostics, result.artifacts.diagnostics);
  });
}

Map<String, Object?> _json(String path) =>
    (jsonDecode(File(path).readAsStringSync())! as Map).cast();
