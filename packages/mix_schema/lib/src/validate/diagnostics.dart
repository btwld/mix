/// Severity levels for schema diagnostics.
enum DiagnosticSeverity { error, warning, info }

/// Stable codes for machine-readable diagnostics.
///
/// Grouped by category: structural, trust, semantic/a11y, and adaptation.
enum DiagnosticCode {
  // Structural
  unknownNodeType,
  missingRequiredField,
  invalidChildStructure, // e.g., children on a wrapper node
  invalidValueType,

  // Trust
  depthLimitExceeded,
  nodeCountExceeded,
  actionNotAllowedAtTrustLevel,
  animationComplexityExceeded,

  // Semantic / a11y
  interactiveNodeMissingRole,
  pressableMissingLabel,
  imageMissingAlt,
  liveRegionMissingMode,

  // Adaptation
  lossyAdaptation, // wire feature has no AST equivalent
  unknownTokenType,
  unknownTransformKey,
  unsupportedWireVersion,
}

/// A single diagnostic emitted during adaptation, validation, or rendering.
final class SchemaDiagnostic {
  final DiagnosticCode code;
  final DiagnosticSeverity severity;
  final String? nodeId;
  final String? path; // dot-path in the AST
  final String message;
  final String? suggestion;

  const SchemaDiagnostic({
    required this.code,
    required this.severity,
    this.nodeId,
    this.path,
    required this.message,
    this.suggestion,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchemaDiagnostic &&
          code == other.code &&
          severity == other.severity &&
          nodeId == other.nodeId &&
          path == other.path &&
          message == other.message;

  @override
  int get hashCode => Object.hash(code, severity, nodeId, path, message);

  @override
  String toString() =>
      'SchemaDiagnostic(${severity.name}: ${code.name} at $path — $message)';
}
