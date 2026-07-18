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

/// Converts the selected Figma collection mode into a protocol theme.
FigmaThemeImportResult buildProtocolThemeJsonFromFigmaVariables(
  FigmaVariablesDocument document, {
  required String modeId,
  MixFigmaConfig config = const MixFigmaConfig(),
}) {
  final diagnostics = <MixFigmaDiagnostic>[];
  final coverage = <MixFigmaCoverageItem>[];
  final variablesById = {
    for (final variable in document.variables) variable.id: variable,
  };
  final groups = {
    'colors': {},
    'spaces': {},
    'doubles': {},
    'radii': {},
    'fontWeights': {},
  };

  final variables = document.variables.toList()
    ..sort((left, right) => left.name.compareTo(right.name));
  for (final variable in variables) {
    final itemDiagnostics = <MixFigmaDiagnostic>[];
    final collection = document.collectionFor(variable.collectionId);
    final group = switch (variable.resolvedType) {
      .color => 'colors',
      .float => _floatGroupName(
        disambiguateFloatVariable(
          variable,
          collection: collection,
          config: config,
        ),
        itemDiagnostics,
      ),
      .string || .boolean => null,
    };

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

      try {
        groups[group]![MixFigmaNameMapper.figmaToMix(
          variable.name,
        )] = _protocolVariableValue(
          variable,
          rawValue,
          group: group,
          variablesById: variablesById,
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

    diagnostics.addAll(itemDiagnostics);
    coverage.add(
      MixFigmaCoverageItem(
        id: variable.id,
        kind: 'variable',
        status: itemDiagnostics.any((item) => item.severity == .error)
            ? .unsupported
            : .supported,
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
}) {
  if (rawValue case FigmaVariableAlias(:final variableId)) {
    final target = variablesById[variableId];
    if (target == null) {
      throw FormatException('Alias target "$variableId" does not exist.');
    }

    return {
      r'$token': MixFigmaNameMapper.figmaToMix(target.name),
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
