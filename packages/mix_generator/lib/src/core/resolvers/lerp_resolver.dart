/// Interpolation strategy selection for Spec fields.
///
/// Maps field metadata to `MixOps.lerp`, `MixOps.lerpSnap`, or delegation.
library;

import '../models/field_model.dart';

/// Lerp strategy for a field.
enum LerpStrategy {
  /// Use `MixOps.lerp` for interpolatable types.
  interpolate,

  /// Use `MixOps.lerpSnap` for discrete types.
  snap,

  /// Delegate to the nested spec's `lerp` method.
  delegateToSpec,
}

bool _isStyleSpecField(String typeName) {
  return typeName.startsWith('StyleSpec<');
}

/// Resolves the lerp strategy for a field.
LerpStrategy resolveLerpStrategy(FieldModel field) {
  // Composite `StyleSpec<T>` fields delegate interpolation to the nested spec.
  if (_isStyleSpecField(field.typeName)) {
    return .delegateToSpec;
  }

  if (field.isLerpable) {
    return .interpolate;
  }

  return .snap;
}

/// Generates the lerp code for a field.
String generateLerpCode(FieldModel field) {
  final strategy = resolveLerpStrategy(field);
  final name = field.name;
  final isNullable = field.effectiveSpecType.endsWith('?');

  return switch (strategy) {
    .interpolate => 'MixOps.lerp($name, other?.$name, t)',
    .snap => 'MixOps.lerpSnap($name, other?.$name, t)',
    // Use `?.` for nullable fields and `.` for non-nullable fields.
    .delegateToSpec =>
      isNullable
          ? '$name?.lerp(other?.$name, t)'
          : '$name.lerp(other?.$name, t)',
  };
}
