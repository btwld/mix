import 'package:flutter/material.dart';

import '../../variants/context_variant.dart';

/// Creates a [ContextVariant] that negates the condition of another [ContextVariant].
///
/// This function returns a new [ContextVariant] that applies when the specified
/// [variant]'s condition does not hold true. It is useful for defining styles or
/// behaviors that should apply in the opposite condition of the provided variant.
///
/// [variant] - The [ContextVariant] whose condition is to be negated.
ContextVariant onNot(ContextVariant variant) {
  return ContextVariant(
    'not(${variant.name})',
    when: (BuildContext context) => !variant.when(context),
  );
}
