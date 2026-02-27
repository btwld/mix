/// Trust levels for schema rendering.
///
/// Trust gates:
/// - Allowed components
/// - Allowed actions/events
/// - Transforms
/// - Animation complexity
/// - Depth/node limits
///
/// See freeze §7.2 for the full trust enforcement contract.
enum SchemaTrust {
  /// Safest — limited depth, count, actions.
  minimal,

  /// Default — balanced safety/capability.
  standard,

  /// Full capability — requires explicit opt-in.
  elevated,
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
}
