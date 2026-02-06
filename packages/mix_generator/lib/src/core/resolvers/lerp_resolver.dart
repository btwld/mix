/// Lerp resolver for determining interpolation strategy.
///
/// Maps DartType → lerp strategy (MixOps.lerp vs MixOps.lerpSnap).
library;

import '../models/field_model.dart';

/// Lerp strategy for a field.
enum LerpStrategy {
  /// Use MixOps.lerp for interpolatable types.
  interpolate,

  /// Use MixOps.lerpSnap for discrete types.
  snap,

  /// Delegate to nested spec's lerp method.
  delegateToSpec,
}

/// Generates lerp code for a field.
class LerpResolver {
  const LerpResolver();

  bool _isStyleSpecField(String typeName) {
    return typeName.startsWith('StyleSpec<');
  }

  /// Resolves the lerp strategy for a field.
  LerpStrategy resolveStrategy(FieldModel field) {
    // Check if it's a StyleSpec<T> field (composite specs)
    if (_isStyleSpecField(field.typeName)) {
      return .delegateToSpec;
    }

    // Check annotation override (isLerpable: false)
    // Note: In v1, we don't have annotation checking yet
    // This would be: if (field.annotation?.isLerpable == false) return LerpStrategy.snap;

    // Use field's computed lerpable value
    if (field.isLerpable) {
      return .interpolate;
    }

    return .snap;
  }

  /// Generates the lerp code for a field.
  String generateLerpCode(FieldModel field) {
    final strategy = resolveStrategy(field);
    final name = field.name;
    final isNullable = field.isNullable;

    return switch (strategy) {
      .interpolate => 'MixOps.lerp($name, other?.$name, t)',
      .snap => 'MixOps.lerpSnap($name, other?.$name, t)',
      // Use ?. for nullable fields, . for non-nullable fields
      .delegateToSpec =>
        isNullable
            ? '$name?.lerp(other?.$name, t)'
            : '$name.lerp(other?.$name, t)',
    };
  }
}

/// Default lerp resolver instance.
const lerpResolver = LerpResolver();
