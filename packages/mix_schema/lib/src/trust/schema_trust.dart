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
