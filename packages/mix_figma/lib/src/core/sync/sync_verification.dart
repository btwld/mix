import '../diagnostics/mix_figma_diagnostic.dart';
import '../json_map.dart';
import 'sync_plan.dart';

enum MixFigmaSyncVerificationStatus {
  verified,
  verifiedWithRetainedItems,
  failed,
}

/// Semantic read-back result recorded after a sync apply.
final class MixFigmaSyncVerificationReport {
  final String planId;
  final MixFigmaSyncDirection direction;
  final MixFigmaSyncResource resource;
  final MixFigmaSyncVerificationStatus status;
  final int remainingMutations;
  final int pendingDeletes;
  final List<MixFigmaDiagnostic> diagnostics;
  MixFigmaSyncVerificationReport({
    required this.planId,
    required this.direction,
    required this.resource,
    required this.status,
    required this.remainingMutations,
    required this.pendingDeletes,
    required Iterable<MixFigmaDiagnostic> diagnostics,
  }) : diagnostics = List.unmodifiable(diagnostics);

  bool get isVerified => status != .failed;

  JsonMap toJson() => {
    'schema': 'mix_figma/sync-report/v1',
    'version': 1,
    'planId': planId,
    'direction': direction.name,
    'resource': resource.name,
    'status': status.name,
    'remainingMutations': remainingMutations,
    'pendingDeletes': pendingDeletes,
    'diagnostics': diagnostics.map((item) => item.toJson()).toList(),
  };
}

MixFigmaSyncVerificationReport verifyMixFigmaSync({
  required MixFigmaSyncPlan approvedPlan,
  required MixFigmaSyncPlan observedPlan,
  required bool allowDeletes,
  Iterable<MixFigmaDiagnostic> additionalDiagnostics = const [],
}) {
  final diagnostics = <MixFigmaDiagnostic>[
    ...observedPlan.diagnostics,
    for (final operation in observedPlan.operations) ...operation.diagnostics,
    ...additionalDiagnostics,
  ];
  var remainingMutations = observedPlan.operations.where((item) {
    return switch (item.action) {
      .create || .update || .rename => true,
      .delete => allowDeletes,
      .unchanged || .skip => false,
    };
  }).length;
  final pendingDeletes = allowDeletes
      ? 0
      : observedPlan.operations.where((item) => item.action == .delete).length;
  if (approvedPlan.direction != observedPlan.direction ||
      approvedPlan.resource != observedPlan.resource ||
      approvedPlan.desiredFingerprint != observedPlan.desiredFingerprint) {
    remainingMutations += 1;
    diagnostics.add(
      const MixFigmaDiagnostic(
        code: 'sync_desired_state_changed',
        severity: .error,
        path: '',
        message: 'The desired Mix state changed after the sync was approved.',
      ),
    );
  }
  final uniqueDiagnostics = _deduplicateDiagnostics(diagnostics);
  final hasErrors = uniqueDiagnostics.any((item) => item.severity == .error);
  final hasRetainedItems =
      pendingDeletes > 0 ||
      observedPlan.operations.any((item) => item.action == .skip);
  final status = remainingMutations > 0 || hasErrors
      ? MixFigmaSyncVerificationStatus.failed
      : (hasRetainedItems
            ? MixFigmaSyncVerificationStatus.verifiedWithRetainedItems
            : MixFigmaSyncVerificationStatus.verified);

  return MixFigmaSyncVerificationReport(
    planId: approvedPlan.id,
    direction: approvedPlan.direction,
    resource: approvedPlan.resource,
    status: status,
    remainingMutations: remainingMutations,
    pendingDeletes: pendingDeletes,
    diagnostics: uniqueDiagnostics,
  );
}

List<MixFigmaDiagnostic> _deduplicateDiagnostics(
  Iterable<MixFigmaDiagnostic> diagnostics,
) {
  final seen = <(MixFigmaDiagnosticSeverity, String, String, String)>{};

  return [
    for (final diagnostic in diagnostics)
      if (seen.add((
        diagnostic.severity,
        diagnostic.code,
        diagnostic.path,
        diagnostic.message,
      )))
        diagnostic,
  ];
}
