import '../diagnostics/mix_figma_diagnostic.dart';
import '../figma/figma_variables_document.dart';
import 'mix_figma_config.dart';

/// Confidence/evidence tier used to classify a Figma FLOAT variable.
enum MixFigmaMappingConfidence { stamped, scope, collection, config, fallback }

/// Result of classifying one Figma FLOAT variable.
final class FloatDisambiguationResult {
  final MixFigmaFloatGroup group;

  final MixFigmaMappingConfidence confidence;
  final String evidence;
  final List<MixFigmaDiagnostic> diagnostics;
  FloatDisambiguationResult({
    required this.group,
    required this.confidence,
    required this.evidence,
    List<MixFigmaDiagnostic> diagnostics = const [],
  }) : diagnostics = List.unmodifiable(diagnostics);
}

/// Classifies a FLOAT using stamp → scopes → collection → config → fallback.
FloatDisambiguationResult disambiguateFloatVariable(
  FigmaVariable variable, {
  required FigmaVariableCollection collection,
  MixFigmaConfig config = const MixFigmaConfig(),
}) {
  if (variable.resolvedType != .float) {
    throw ArgumentError.value(
      variable.resolvedType,
      'variable',
      'Only FLOAT variables can be disambiguated.',
    );
  }

  final stamped = _stampedGroup(variable.codeSyntax.values);
  if (stamped != null) {
    return FloatDisambiguationResult(
      group: stamped,
      confidence: .stamped,
      evidence: 'codeSyntax',
    );
  }

  final scoped = _scopeGroup(variable.scopes);
  if (scoped != null) {
    return FloatDisambiguationResult(
      group: scoped,
      confidence: .scope,
      evidence: variable.scopes.join(','),
    );
  }

  final conventional = _collectionGroup(collection.name);
  if (conventional != null) {
    return FloatDisambiguationResult(
      group: conventional,
      confidence: .collection,
      evidence: collection.name,
    );
  }

  final configured =
      config.floatGroupsByVariable[variable.id] ??
      config.floatGroupsByVariable[variable.name] ??
      config.floatGroupsByCollection[collection.id] ??
      config.floatGroupsByCollection[collection.name];
  if (configured != null) {
    return FloatDisambiguationResult(
      group: configured,
      confidence: .config,
      evidence: 'mix_figma config override',
    );
  }

  return FloatDisambiguationResult(
    group: .doubles,
    confidence: .fallback,
    evidence: 'No stamp, compatible scope, convention, or override.',
    diagnostics: [
      MixFigmaDiagnostic(
        code: 'ambiguous_float_variable',
        severity: .warning,
        path: '/variables/${variable.id}',
        message:
            'FLOAT variable "${variable.name}" defaulted to doubles because '
            'its token group is ambiguous.',
      ),
    ],
  );
}

MixFigmaFloatGroup? _stampedGroup(Iterable<String> syntaxValues) {
  final pattern = RegExp(r'^mix://(spaces|doubles|radii|fontWeights)(?:/|$)');
  for (final value in syntaxValues) {
    final match = pattern.firstMatch(value);
    if (match == null) continue;

    return MixFigmaFloatGroup.values.byName(match.group(1)!);
  }

  return null;
}

MixFigmaFloatGroup? _scopeGroup(Iterable<String> scopes) {
  final normalized = scopes.map((scope) => scope.toUpperCase()).toSet();
  if (normalized.contains('CORNER_RADIUS')) return .radii;
  if (normalized.contains('FONT_WEIGHT')) {
    return .fontWeights;
  }
  if (normalized.contains('GAP') || normalized.contains('WIDTH_HEIGHT')) {
    return .spaces;
  }

  return null;
}

MixFigmaFloatGroup? _collectionGroup(String name) {
  final normalized = name.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
  if (normalized.contains('radius') || normalized.contains('radii')) {
    return .radii;
  }
  if (normalized.contains('fontweight') || normalized == 'weights') {
    return .fontWeights;
  }
  if (normalized.contains('space') ||
      normalized.contains('spacing') ||
      normalized.contains('dimension')) {
    return .spaces;
  }
  if (normalized.contains('double') ||
      normalized.contains('number') ||
      normalized.contains('opacity')) {
    return .doubles;
  }

  return null;
}
