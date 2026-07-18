import '../diagnostics/mix_figma_diagnostic.dart';

/// A mapped value and all structured diagnostics produced while mapping it.
final class MixFigmaMappingResult<T> {
  final T value;

  final List<MixFigmaDiagnostic> diagnostics;
  MixFigmaMappingResult({
    required this.value,
    List<MixFigmaDiagnostic> diagnostics = const [],
  }) : diagnostics = List.unmodifiable(diagnostics);

  bool get hasErrors =>
      diagnostics.any((diagnostic) => diagnostic.severity == .error);
}
