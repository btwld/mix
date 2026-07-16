/// Severity of a conversion diagnostic.
enum MixFigmaSeverity { warning, error }

/// A conversion problem tied to a token path in the source document.
///
/// Conversions never silently drop data: every token or field that cannot be
/// represented in a `mix_protocol` document produces a diagnostic.
final class MixFigmaDiagnostic {
  const MixFigmaDiagnostic({
    required this.path,
    required this.message,
    this.severity = MixFigmaSeverity.warning,
  });

  /// Dot-separated token path in the source document (e.g. `color.primary`).
  final String path;

  /// Human-readable description of what was skipped or adjusted and why.
  final String message;

  final MixFigmaSeverity severity;

  @override
  String toString() => '[${severity.name}] $path: $message';
}
