import '../json_map.dart';
import 'mix_figma_diagnostic.dart';

/// Whether a source entry was mapped without a known unsupported feature.
enum MixFigmaCoverageStatus { supported, unsupported }

/// Coverage evidence for one Figma variable, style, node, or component.
final class MixFigmaCoverageItem {
  final String id;

  final String kind;
  final MixFigmaCoverageStatus status;
  final List<MixFigmaDiagnostic> diagnostics;
  MixFigmaCoverageItem({
    required this.id,
    required this.kind,
    required this.status,
    List<MixFigmaDiagnostic> diagnostics = const [],
  }) : diagnostics = List.unmodifiable(diagnostics);

  JsonMap toJson() => {
    'id': id,
    'kind': kind,
    'status': status.name,
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
    'schema': 'mix_figma/coverage/v1',
    'supported': supportedCount,
    'unsupported': unsupportedCount,
    'items': items.map((item) => item.toJson()).toList(),
  };
}
