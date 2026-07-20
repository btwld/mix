import '../diagnostics/mix_figma_coverage_report.dart';
import '../diagnostics/mix_figma_diagnostic.dart';
import '../figma/figma_variables_document.dart';
import '../json_map.dart';
import '../mapping/float_disambiguation.dart';
import '../mapping/mix_figma_config.dart';
import '../mapping/name_mapper.dart';

/// Theme import result including exhaustive source coverage.
final class FigmaThemeImportResult {
  final JsonMap value;

  final MixFigmaCoverageReport coverage;
  final List<MixFigmaDiagnostic> diagnostics;
  FigmaThemeImportResult({
    required this.value,
    required this.coverage,
    required Iterable<MixFigmaDiagnostic> diagnostics,
  }) : diagnostics = List.unmodifiable(diagnostics);
}

/// Assigns deterministic protocol names to variables across all collections.
///
/// Figma permits different collections to contain the same variable name,
/// while a Mix theme requires names to be unique within each token group.
/// Duplicate names are prefixed with a sanitized collection namespace so
/// aliases keep pointing at the correct source variable.
Map<String, String> buildProtocolVariableNameMap(
  FigmaVariablesDocument document,
) {
  final variablesByBaseName = <String, List<FigmaVariable>>{};
  for (final variable in document.variables) {
    try {
      final name = MixFigmaNameMapper.figmaToMix(variable.name);
      variablesByBaseName.putIfAbsent(name, () => []).add(variable);
    } on FormatException {
      // The import result reports invalid names with source-specific context.
    }
  }

  final result = <String, String>{};
  final usedNames = <String>{};
  final baseNames = variablesByBaseName.keys.toList()..sort();
  for (final baseName in baseNames) {
    final variables = variablesByBaseName[baseName]!;
    if (variables.length == 1) {
      result[variables.single.id] = baseName;
      usedNames.add(baseName);
    }
  }
  for (final baseName in baseNames) {
    final variables = variablesByBaseName[baseName]!;
    if (variables.length == 1) continue;
    variables.sort((left, right) {
      final leftCollection = document.collectionFor(left.collectionId);
      final rightCollection = document.collectionFor(right.collectionId);
      final collectionCompare = leftCollection.name.compareTo(
        rightCollection.name,
      );
      if (collectionCompare != 0) return collectionCompare;
      final idCompare = leftCollection.id.compareTo(rightCollection.id);

      return idCompare != 0 ? idCompare : left.id.compareTo(right.id);
    });
    for (final variable in variables) {
      final namespace = _collectionNamespace(
        document.collectionFor(variable.collectionId).name,
      );
      var suffix = 1;
      var candidate = _namespacedName(namespace, baseName, suffix);
      while (usedNames.contains(candidate)) {
        candidate = _namespacedName(namespace, baseName, ++suffix);
      }
      result[variable.id] = candidate;
      usedNames.add(candidate);
    }
  }

  return Map.unmodifiable(result);
}

/// Converts the selected Figma collection mode into a protocol theme.
FigmaThemeImportResult buildProtocolThemeJsonFromFigmaVariables(
  FigmaVariablesDocument document, {
  required String modeId,
  String? collectionId,
  MixFigmaConfig config = const MixFigmaConfig(),
  Map<String, String> protocolNamesByVariableId = const {},
}) {
  final diagnostics = <MixFigmaDiagnostic>[];
  final coverage = <MixFigmaCoverageItem>[];
  final variablesById = {
    for (final variable in document.variables) variable.id: variable,
  };
  final groupsByVariableId = <String, String?>{};
  final groupDiagnosticsByVariableId = <String, List<MixFigmaDiagnostic>>{};
  for (final variable in document.variables) {
    final groupDiagnostics = <MixFigmaDiagnostic>[];
    groupsByVariableId[variable.id] = _protocolGroup(
      variable,
      collection: document.collectionFor(variable.collectionId),
      config: config,
      diagnostics: groupDiagnostics,
    );
    groupDiagnosticsByVariableId[variable.id] = groupDiagnostics;
  }
  final groups = {
    'colors': {},
    'spaces': {},
    'doubles': {},
    'radii': {},
    'fontWeights': {},
  };

  final variables =
      document.variables
          .where(
            (variable) =>
                collectionId == null || variable.collectionId == collectionId,
          )
          .toList()
        ..sort((left, right) => left.name.compareTo(right.name));
  for (final variable in variables) {
    final itemDiagnostics = <MixFigmaDiagnostic>[
      ...?groupDiagnosticsByVariableId[variable.id],
    ];
    final group = groupsByVariableId[variable.id];

    if (group == null) {
      itemDiagnostics.add(
        MixFigmaDiagnostic(
          code: 'unsupported_variable_type',
          severity: .warning,
          path: '/variables/${variable.id}',
          message:
              '${variable.resolvedType.name.toUpperCase()} variable '
              '"${variable.name}" has no Mix protocol token kind.',
        ),
      );
      diagnostics.addAll(itemDiagnostics);
      coverage.add(
        MixFigmaCoverageItem(
          id: variable.id,
          kind: 'variable',
          status: .unsupported,
          nativeFidelity: .unsupported,
          roundTripFidelity: .unsupported,
          diagnostics: itemDiagnostics,
        ),
      );
      continue;
    }

    if (!variable.valuesByMode.containsKey(modeId)) {
      itemDiagnostics.add(
        MixFigmaDiagnostic(
          code: 'missing_mode_value',
          severity: .error,
          path: '/variables/${variable.id}/valuesByMode/$modeId',
          message: 'Variable has no value for mode "$modeId".',
        ),
      );
    } else {
      final rawValue = variable.valuesByMode[modeId];

      final aliasTarget = rawValue is FigmaVariableAlias
          ? variablesById[rawValue.variableId]
          : null;
      final targetGroup = aliasTarget == null
          ? null
          : groupsByVariableId[aliasTarget.id];
      if (aliasTarget != null && targetGroup != group) {
        itemDiagnostics.add(
          MixFigmaDiagnostic(
            code: 'cross_group_alias',
            severity: .error,
            path: '/variables/${variable.id}/valuesByMode/$modeId',
            message:
                'Alias from $group token "${variable.name}" targets '
                '${targetGroup ?? 'an unsupported'} token '
                '"${aliasTarget.name}".',
          ),
        );
      } else {
        try {
          final baseName = MixFigmaNameMapper.figmaToMix(variable.name);
          final protocolName =
              protocolNamesByVariableId[variable.id] ?? baseName;
          if (protocolName != baseName) {
            itemDiagnostics.add(
              MixFigmaDiagnostic(
                code: 'duplicate_variable_name_namespaced',
                severity: .info,
                path: '/variables/${variable.id}/name',
                message:
                    'Duplicate Figma variable name "${variable.name}" was '
                    'imported as "$protocolName".',
              ),
            );
          }
          groups[group]![protocolName] = _protocolVariableValue(
            variable,
            rawValue,
            group: group,
            variablesById: variablesById,
            protocolNamesByVariableId: protocolNamesByVariableId,
          );
        } on FormatException catch (error) {
          itemDiagnostics.add(
            MixFigmaDiagnostic(
              code: 'invalid_variable_value',
              severity: .error,
              path: '/variables/${variable.id}/valuesByMode/$modeId',
              message: error.message,
            ),
          );
        }
      }
    }

    diagnostics.addAll(itemDiagnostics);
    final hasError = itemDiagnostics.any((item) => item.severity == .error);
    final wasNamespaced = itemDiagnostics.any(
      (item) => item.code == 'duplicate_variable_name_namespaced',
    );
    final wasNormalized = itemDiagnostics.any(
      (item) => item.code == 'ambiguous_float_variable',
    );
    coverage.add(
      MixFigmaCoverageItem(
        id: variable.id,
        kind: 'variable',
        status: hasError ? .unsupported : .supported,
        nativeFidelity: hasError
            ? .error
            : (wasNamespaced || wasNormalized ? .normalized : .exact),
        roundTripFidelity: hasError
            ? .error
            : (wasNamespaced ? .normalized : .exact),
        diagnostics: itemDiagnostics,
      ),
    );
  }

  return FigmaThemeImportResult(
    value: {
      'v': 1,
      'type': 'theme',
      for (final entry in groups.entries)
        if (entry.value.isNotEmpty) entry.key: entry.value,
    },
    coverage: MixFigmaCoverageReport(items: coverage),
    diagnostics: diagnostics,
  );
}

String? _protocolGroup(
  FigmaVariable variable, {
  required FigmaVariableCollection collection,
  required MixFigmaConfig config,
  required List<MixFigmaDiagnostic> diagnostics,
}) => switch (variable.resolvedType) {
  .color => 'colors',
  .float => _floatGroupName(
    disambiguateFloatVariable(variable, collection: collection, config: config),
    diagnostics,
  ),
  .string || .boolean => null,
};

String _floatGroupName(
  FloatDisambiguationResult result,
  List<MixFigmaDiagnostic> diagnostics,
) {
  diagnostics.addAll(result.diagnostics);

  return result.group.name;
}

Object _protocolVariableValue(
  FigmaVariable variable,
  Object? rawValue, {
  required String group,
  required Map<String, FigmaVariable> variablesById,
  required Map<String, String> protocolNamesByVariableId,
}) {
  if (rawValue case FigmaVariableAlias(:final variableId)) {
    final target = variablesById[variableId];
    if (target == null) {
      throw FormatException('Alias target "$variableId" does not exist.');
    }

    return {
      r'$token':
          protocolNamesByVariableId[target.id] ??
          MixFigmaNameMapper.figmaToMix(target.name),
      if (group == 'spaces') 'kind': 'space',
      if (group == 'doubles') 'kind': 'double',
    };
  }

  return switch (group) {
    'colors' => _figmaColor(rawValue),
    'fontWeights' => _fontWeight(rawValue),
    'spaces' ||
    'doubles' ||
    'radii' when rawValue is num && rawValue.isFinite => rawValue,
    _ => throw FormatException(
      'Value for ${variable.name} does not match $group.',
    ),
  };
}

String _collectionNamespace(String name) {
  final dotted = name
      .split('/')
      .map((segment) => segment.trim())
      .where((segment) => segment.isNotEmpty)
      .join('.');
  var namespace = dotted
      .replaceAll(RegExp(r'[^A-Za-z0-9_.-]+'), '-')
      .replaceAll(RegExp('-+'), '-')
      .replaceAll(RegExp(r'^[.-]+|[.-]+$'), '');
  if (namespace.isEmpty) namespace = 'collection';
  if (namespace.length > 48) namespace = namespace.substring(0, 48);

  return namespace;
}

String _namespacedName(String namespace, String baseName, int suffix) {
  final tail = suffix == 1 ? '' : '.$suffix';
  final maxBodyLength = 128 - tail.length;
  final fullName = '$namespace.$baseName';
  final body = fullName.length <= maxBodyLength
      ? fullName
      : fullName.substring(0, maxBodyLength);

  return '$body$tail';
}

String _fontWeight(Object? value) {
  if (value is num && value >= 100 && value <= 900) {
    return 'w${(value / 100).round() * 100}';
  }

  throw const FormatException('Font weight must be between 100 and 900.');
}

String _figmaColor(Object? value) {
  if (value is String &&
      RegExp(r'^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$').hasMatch(value)) {
    return value.toUpperCase();
  }
  final color = value is Map ? value.cast<String, Object?>() : null;
  if (color == null ||
      color['r'] is! num ||
      color['g'] is! num ||
      color['b'] is! num) {
    throw const FormatException('Expected an RGBA Figma color.');
  }
  final alpha = color['a'] is num ? color['a']! as num : 1;
  int byte(num component) => (component * 255).round().clamp(0, 255);
  final rgb = [color['r'], color['g'], color['b']]
      .map((component) => byte(component! as num))
      .map((item) => item.toRadixString(16).padLeft(2, '0'))
      .join();
  final alphaHex = byte(alpha).toRadixString(16).padLeft(2, '0');

  return '#${alphaHex == 'ff' ? '' : alphaHex}$rgb'.toUpperCase();
}
