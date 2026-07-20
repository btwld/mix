import '../diagnostics/mix_figma_diagnostic.dart';
import '../figma/figma_styles_document.dart';
import '../figma/figma_variables_document.dart';
import '../json_map.dart';
import '../mapping/mix_figma_config.dart';
import '../protocol_json/theme_from_figma_styles.dart';
import '../protocol_json/theme_from_figma_variables.dart';
import 'sync_plan.dart';

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

/// Materialized Figma-to-Mix token artifacts before any file is written.
final class MixFigmaTokenPullArtifacts {
  final Map<String, JsonMap> themes;
  final List<JsonMap> coverage;
  final List<MixFigmaDiagnostic> diagnostics;
  final Map<String, JsonMap> styleFragments;
  MixFigmaTokenPullArtifacts({
    required Map<String, JsonMap> themes,
    required Iterable<JsonMap> coverage,
    required Iterable<MixFigmaDiagnostic> diagnostics,
    required Map<String, JsonMap> styleFragments,
  }) : themes = Map.unmodifiable(themes),
       coverage = List.unmodifiable(coverage),
       diagnostics = List.unmodifiable(diagnostics),
       styleFragments = Map.unmodifiable(styleFragments);

  JsonMap toJson() => {
    'version': 1,
    'themes': themes,
    'coverage': coverage,
    'diagnostics': diagnostics.map((item) => item.toJson()).toList(),
    'styleFragments': styleFragments,
  };
}

final class MixFigmaTokenPullAnalysis {
  final MixFigmaSyncPlan plan;
  final MixFigmaTokenPullArtifacts artifacts;
  const MixFigmaTokenPullAnalysis({
    required this.plan,
    required this.artifacts,
  });

  JsonMap toJson() => {'plan': plan.toJson(), 'artifacts': artifacts.toJson()};
}

/// Builds all output in memory and previews file changes without mutating disk.
MixFigmaTokenPullAnalysis analyzeTokenPull({
  required FigmaVariablesDocument variables,
  required FigmaStylesDocument styles,
  required Map<String, JsonMap> currentThemes,
  MixFigmaConfig config = const MixFigmaConfig(),
}) {
  final protocolNamesByVariableId = buildProtocolVariableNameMap(variables);
  final styleResult = buildProtocolThemeJsonFromFigmaStyles(styles);
  final primitiveThemes = <String, JsonMap>{};
  final invariantPrimitiveThemes = <JsonMap>[];
  final hasVariantCollections = variables.collections.any(
    (collection) => collection.modes.length > 1,
  );
  final diagnostics = <MixFigmaDiagnostic>[...styleResult.diagnostics];
  final coverage = [styleResult.coverage.toJson()];
  for (final collection in variables.collections) {
    for (final mode in collection.modes) {
      final variableResult = buildProtocolThemeJsonFromFigmaVariables(
        variables,
        modeId: mode.id,
        collectionId: collection.id,
        config: config,
        protocolNamesByVariableId: protocolNamesByVariableId,
      );
      if (hasVariantCollections && collection.modes.length == 1) {
        invariantPrimitiveThemes.add(variableResult.value);
      } else {
        final name = _safeName(mode.name.toLowerCase());
        primitiveThemes[name] = _mergeVariableThemes(
          primitiveThemes[name],
          variableResult.value,
          modeName: name,
        );
      }
      diagnostics.addAll(variableResult.diagnostics);
      coverage.add(variableResult.coverage.toJson());
    }
  }
  for (final entry in primitiveThemes.entries.toList()) {
    var theme = entry.value;
    for (final invariantTheme in invariantPrimitiveThemes) {
      theme = _mergeVariableThemes(theme, invariantTheme, modeName: entry.key);
    }
    primitiveThemes[entry.key] = theme;
  }
  final themes = <String, JsonMap>{
    for (final entry in primitiveThemes.entries)
      entry.key: _mergeTheme(entry.value, styleResult.value),
  };
  final uniqueDiagnostics = _deduplicateDiagnostics(diagnostics);
  final operations = <MixFigmaSyncOperation>[];
  final desiredNames = themes.keys.toSet();
  for (final name in desiredNames) {
    final current = currentThemes[name];
    operations.add(
      MixFigmaSyncOperation(
        action: current == null
            ? .create
            : (mixFigmaFingerprint(current) == mixFigmaFingerprint(themes[name])
                  ? .unchanged
                  : .update),
        kind: 'themeFile',
        ref: name,
        name: '$name.theme.json',
        path: '/themes/$name',
        changes: current == null
            ? const ['file']
            : (mixFigmaFingerprint(current) == mixFigmaFingerprint(themes[name])
                  ? const []
                  : const ['content']),
      ),
    );
  }
  for (final name in currentThemes.keys.where(
    (item) => !desiredNames.contains(item),
  )) {
    operations.add(
      MixFigmaSyncOperation(
        action: .delete,
        kind: 'themeFile',
        ref: name,
        name: '$name.theme.json',
        path: '/themes/$name',
        destructive: true,
        changes: const ['delete'],
      ),
    );
  }
  final plan = MixFigmaSyncPlan.create(
    direction: .figmaToMix,
    resource: .tokens,
    current: currentThemes,
    desired: themes,
    operations: operations,
    diagnostics: uniqueDiagnostics,
  );
  final artifacts = MixFigmaTokenPullArtifacts(
    themes: themes,
    coverage: coverage,
    diagnostics: plan.diagnostics,
    styleFragments: styleResult.styleFragments,
  );

  return MixFigmaTokenPullAnalysis(plan: plan, artifacts: artifacts);
}

JsonMap _mergeTheme(JsonMap primitives, JsonMap composites) => {
  'v': 1,
  'type': 'theme',
  for (final group in _themeGroups)
    if (_mergedGroup(primitives[group], composites[group]).isNotEmpty)
      group: _mergedGroup(primitives[group], composites[group]),
};

JsonMap _mergeVariableThemes(
  JsonMap? existing,
  JsonMap incoming, {
  required String modeName,
}) {
  if (existing == null) return incoming;

  return {
    'v': 1,
    'type': 'theme',
    for (final group in _themeGroups)
      if (_mergedVariableGroup(
        existing[group],
        incoming[group],
        group: group,
        modeName: modeName,
      ).isNotEmpty)
        group: _mergedVariableGroup(
          existing[group],
          incoming[group],
          group: group,
          modeName: modeName,
        ),
  };
}

JsonMap _mergedVariableGroup(
  Object? left,
  Object? right, {
  required String group,
  required String modeName,
}) {
  final leftValues = left is Map
      ? left.cast<String, Object?>()
      : const <String, Object?>{};
  final rightValues = right is Map
      ? right.cast<String, Object?>()
      : const <String, Object?>{};
  final duplicates = leftValues.keys.toSet().intersection(
    rightValues.keys.toSet(),
  );
  if (duplicates.isNotEmpty) {
    final names = duplicates.toList()..sort();
    throw FormatException(
      'Mode "$modeName" contains duplicate $group tokens across collections: '
      '${names.join(', ')}.',
    );
  }

  return {...leftValues, ...rightValues};
}

JsonMap _mergedGroup(Object? left, Object? right) => {
  if (left is Map) ...left.cast<String, Object?>(),
  if (right is Map) ...right.cast<String, Object?>(),
};

String _safeName(String value) {
  var result = value
      .replaceAll(RegExp(r'[^a-z0-9_.-]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  if (result.endsWith('-mode') && result.length > '-mode'.length) {
    result = result.substring(0, result.length - '-mode'.length);
  }
  if (result.isEmpty) throw const FormatException('Mode name is empty.');

  return result;
}

List<MixFigmaDiagnostic> _deduplicateDiagnostics(
  Iterable<MixFigmaDiagnostic> diagnostics,
) {
  final seen = <(MixFigmaDiagnosticSeverity, String, String, String)>{};

  return [
    for (final diagnostic in diagnostics)
      if (seen.add((
        diagnostic.severity,
        diagnostic.code,
        diagnostic.path,
        diagnostic.message,
      )))
        diagnostic,
  ];
}
