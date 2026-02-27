import '../ast/ui_schema_root.dart';
import '../trust/capability_matrix.dart';
import '../validate/diagnostics.dart';

/// Context provided to adapters during adaptation.
final class AdaptContext {
  final SchemaTrust trust;
  final String? sourceVersion; // wire protocol version from payload

  const AdaptContext({required this.trust, this.sourceVersion});
}

/// Result of adapting a wire payload.
final class AdaptResult {
  final UiSchemaRoot? root;
  final List<SchemaDiagnostic> diagnostics;

  const AdaptResult({this.root, this.diagnostics = const []});

  bool get hasErrors =>
      diagnostics.any((d) => d.severity == DiagnosticSeverity.error);
}
