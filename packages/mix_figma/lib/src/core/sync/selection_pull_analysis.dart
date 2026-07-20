import '../diagnostics/mix_figma_diagnostic.dart';
import '../figma/figma_node_document.dart';
import '../json_map.dart';
import '../protocol_json/style_from_figma_node.dart';
import 'sync_plan.dart';

/// One normalized selected node plus its source snapshot for stale detection.
final class MixFigmaSelectionInput {
  final JsonMap source;
  final FigmaNode node;
  MixFigmaSelectionInput({required JsonMap source, required this.node})
    : source = Map.unmodifiable(source);
}

/// Style documents and diagnostics produced by a selection import.
final class MixFigmaSelectionPullArtifacts {
  final Map<String, JsonMap> styles;
  final List<MixFigmaDiagnostic> diagnostics;
  MixFigmaSelectionPullArtifacts({
    required Map<String, JsonMap> styles,
    required Iterable<MixFigmaDiagnostic> diagnostics,
  }) : styles = Map.unmodifiable({
         for (final entry in styles.entries)
           entry.key: Map<String, Object?>.unmodifiable(entry.value),
       }),
       diagnostics = List.unmodifiable(diagnostics);

  JsonMap toJson() => {
    'version': 1,
    'styles': {for (final entry in styles.entries) entry.key: entry.value},
    'diagnostics': diagnostics.map((item) => item.toJson()).toList(),
  };
}

/// Deterministic Analyze result for importing a Figma selection as style files.
final class MixFigmaSelectionPullAnalysis {
  final MixFigmaSelectionPullArtifacts artifacts;
  final MixFigmaSyncPlan plan;
  const MixFigmaSelectionPullAnalysis({
    required this.artifacts,
    required this.plan,
  });
}

MixFigmaSelectionPullAnalysis analyzeSelectionPull({
  required Iterable<MixFigmaSelectionInput> selection,
  required Map<String, JsonMap> currentStyles,
  Iterable<MixFigmaDiagnostic> diagnostics = const [],
}) {
  final inputs = selection.toList(growable: false);
  final sourceDiagnostics = diagnostics.toList(growable: false);
  final mappingDiagnostics = <MixFigmaDiagnostic>[];
  final styles = <String, JsonMap>{};
  final names = <String, String>{};
  final usedRefs = <String>{};
  for (final input in inputs) {
    final result = buildProtocolStyleJsonFromNode(input.node);
    mappingDiagnostics.addAll(result.diagnostics);
    final base = _slug(input.node.name);
    var ref = base;
    var suffix = 2;
    while (!usedRefs.add(ref)) {
      ref = '$base-${suffix++}';
    }
    styles[ref] = result.value;
    names[ref] = input.node.name;
  }
  final operations = <MixFigmaSyncOperation>[];
  for (final entry in styles.entries) {
    final current = currentStyles[entry.key];
    final action = current == null
        ? MixFigmaSyncAction.create
        : (mixFigmaFingerprint(current) == mixFigmaFingerprint(entry.value)
              ? MixFigmaSyncAction.unchanged
              : MixFigmaSyncAction.update);
    operations.add(
      MixFigmaSyncOperation(
        action: action,
        kind: 'styleFile',
        ref: entry.key,
        name: names[entry.key]!,
        path: '/styles/${entry.key}.style.json',
        changes: switch (action) {
          .create => const ['styleFile'],
          .update => const ['content'],
          .rename || .delete || .unchanged || .skip => const [],
        },
      ),
    );
  }
  for (final entry in currentStyles.entries.where(
    (entry) => !styles.containsKey(entry.key),
  )) {
    final path = '/styles/${entry.key}.style.json';
    operations.add(
      MixFigmaSyncOperation(
        action: .skip,
        kind: 'styleFile',
        ref: entry.key,
        sourceId: entry.key,
        name: entry.key,
        path: path,
        diagnostics: [
          MixFigmaDiagnostic(
            code: 'unmanaged_local_file_preserved',
            severity: .info,
            path: path,
            message: 'Existing local style file "${entry.key}" is preserved.',
          ),
        ],
      ),
    );
  }
  final mappingCodes = mappingDiagnostics.map((item) => item.code).toSet();
  final mergedDiagnostics = <MixFigmaDiagnostic>[
    for (final diagnostic in sourceDiagnostics)
      if (!mappingCodes.contains(diagnostic.code)) diagnostic,
    ...mappingDiagnostics,
  ];
  final artifacts = MixFigmaSelectionPullArtifacts(
    styles: styles,
    diagnostics: mergedDiagnostics,
  );
  final plan = MixFigmaSyncPlan.create(
    direction: .figmaToMix,
    resource: .selection,
    current: {
      'selection': inputs.map((item) => item.source).toList(),
      'styles': currentStyles,
    },
    desired: artifacts.toJson(),
    operations: operations,
    diagnostics: mergedDiagnostics,
  );

  return MixFigmaSelectionPullAnalysis(artifacts: artifacts, plan: plan);
}

String _slug(String value) {
  final slug = value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp('[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');

  return slug.isEmpty ? 'selection' : slug;
}
