import '../json_map.dart';
import 'mix_figma_diagnostic.dart';

/// Whether a source entry was mapped without a known unsupported feature.
enum MixFigmaCoverageStatus { supported, unsupported }

/// Fidelity of one source value in the native target and on a bridge round trip.
enum MixFigmaFidelity {
  exact,
  normalized,
  metadataOnly,
  lossy,
  unsupported,
  error,
}

/// Coverage evidence for one Figma variable, style, node, or component.
final class MixFigmaCoverageItem {
  final String id;

  final String kind;
  final MixFigmaCoverageStatus status;
  final MixFigmaFidelity nativeFidelity;
  final MixFigmaFidelity roundTripFidelity;
  final List<MixFigmaDiagnostic> diagnostics;
  MixFigmaCoverageItem({
    required this.id,
    required this.kind,
    required this.status,
    MixFigmaFidelity? nativeFidelity,
    MixFigmaFidelity? roundTripFidelity,
    List<MixFigmaDiagnostic> diagnostics = const [],
  }) : nativeFidelity =
           nativeFidelity ?? (status == .supported ? .exact : .unsupported),
       roundTripFidelity =
           roundTripFidelity ?? (status == .supported ? .exact : .unsupported),
       diagnostics = List.unmodifiable(diagnostics);

  JsonMap toJson() => {
    'id': id,
    'kind': kind,
    'status': status.name,
    'nativeFidelity': nativeFidelity.name,
    'roundTripFidelity': roundTripFidelity.name,
    'diagnostics': diagnostics.map((item) => item.toJson()).toList(),
  };
}

/// Deterministic coverage report for one bridge operation.
final class MixFigmaCoverageReport {
  final List<MixFigmaCoverageItem> items;

  MixFigmaCoverageReport({required Iterable<MixFigmaCoverageItem> items})
    : items = List.unmodifiable(items);

  int get supportedCount =>
      items.where((item) => item.status == .supported).length;

  int get unsupportedCount => items.length - supportedCount;

  JsonMap toJson() => {
    'schema': 'mix_figma/coverage/v2',
    'supported': supportedCount,
    'unsupported': unsupportedCount,
    'fidelity': {
      'native': _fidelityCounts(items.map((item) => item.nativeFidelity)),
      'roundTrip': _fidelityCounts(items.map((item) => item.roundTripFidelity)),
    },
    'items': items.map((item) => item.toJson()).toList(),
  };
}

JsonMap _fidelityCounts(Iterable<MixFigmaFidelity> values) {
  final counts = <String, Object?>{};
  for (final value in values) {
    counts[value.name] = ((counts[value.name] as int?) ?? 0) + 1;
  }

  return counts;
}
