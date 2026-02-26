import '../ast/ui_schema_root.dart';
import '../trust/schema_trust.dart';
import '../validate/diagnostics.dart';

/// Interface for wire protocol adapters.
///
/// Each adapter translates a specific wire format (e.g., A2UI v0.9) into
/// the canonical AST. Adapters are responsible for:
/// - Parsing wire format
/// - Normalizing shorthand values (e.g., token string → explicit token object)
/// - Mapping protocol-specific shapes into canonical AST
/// - Emitting structured diagnostics on lossy/unsupported mappings
///
/// Adapters are NOT responsible for: rendering, trust policy, token resolution.
abstract class WireAdapter {
  /// Unique identifier, e.g. "a2ui_v0_9_draft_latest"
  String get id;

  /// Supported wire protocol versions.
  List<String> get supportedVersions;

  /// Adapt a wire payload into canonical AST.
  ///
  /// Returns root + diagnostics (may succeed with warnings).
  AdaptResult adapt(Object wirePayload, AdaptContext context);
}

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
