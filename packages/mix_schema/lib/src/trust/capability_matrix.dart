import '../events/schema_action.dart';
import 'schema_trust.dart';

/// How an action is handled given trust level + risk.
enum ActionPolicy {
  /// Execute the action immediately.
  execute,

  /// Present to user for approval before executing.
  proposeBeforeExecute,

  /// Block the action entirely.
  block,
}

/// Trust-level capability limits.
///
/// See freeze §7.2 and executable plan §12 for exact values.
class TrustCapabilities {
  final int maxDepth;
  final int maxNodeCount;
  final int maxAnimatedNodes;

  const TrustCapabilities({
    required this.maxDepth,
    required this.maxNodeCount,
    required this.maxAnimatedNodes,
  });

  static const minimal = TrustCapabilities(
    maxDepth: 5,
    maxNodeCount: 50,
    maxAnimatedNodes: 5,
  );

  static const standard = TrustCapabilities(
    maxDepth: 10,
    maxNodeCount: 200,
    maxAnimatedNodes: 20,
  );

  static const elevated = TrustCapabilities(
    maxDepth: 20,
    maxNodeCount: 1000,
    maxAnimatedNodes: 50,
  );

  /// Get capabilities for a given trust level.
  static TrustCapabilities forTrust(SchemaTrust trust) => switch (trust) {
        SchemaTrust.minimal => minimal,
        SchemaTrust.standard => standard,
        SchemaTrust.elevated => elevated,
      };

  /// Determines how an action at a given risk level should be handled.
  ///
  /// Matches the §9.3 Trust → Action Gating table exactly:
  /// | Trust     | Low     | Medium              | High                |
  /// |-----------|---------|---------------------|---------------------|
  /// | minimal   | Execute | Block               | Block               |
  /// | standard  | Execute | Propose-before-exec | Block               |
  /// | elevated  | Execute | Execute             | Propose-before-exec |
  static ActionPolicy policyFor(SchemaTrust trust, ActionRisk risk) {
    return switch ((trust, risk)) {
      // minimal: only low risk executes
      (SchemaTrust.minimal, ActionRisk.low) => ActionPolicy.execute,
      (SchemaTrust.minimal, ActionRisk.medium) => ActionPolicy.block,
      (SchemaTrust.minimal, ActionRisk.high) => ActionPolicy.block,

      // standard: low executes, medium proposes, high blocks
      (SchemaTrust.standard, ActionRisk.low) => ActionPolicy.execute,
      (SchemaTrust.standard, ActionRisk.medium) =>
        ActionPolicy.proposeBeforeExecute,
      (SchemaTrust.standard, ActionRisk.high) => ActionPolicy.block,

      // elevated: low+medium execute, high proposes
      (SchemaTrust.elevated, ActionRisk.low) => ActionPolicy.execute,
      (SchemaTrust.elevated, ActionRisk.medium) => ActionPolicy.execute,
      (SchemaTrust.elevated, ActionRisk.high) =>
        ActionPolicy.proposeBeforeExecute,
    };
  }
}
