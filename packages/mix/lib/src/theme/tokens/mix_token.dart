import 'package:flutter/material.dart';

import 'token_refs.dart';
import '../mix_theme.dart';


/// A design token that resolves to a value within a Mix theme.
///
/// Identifies semantic values in your design system. Provide concrete
/// values in a `MixScope`, then call or resolve to get the value.
@immutable
abstract class MixToken<T> {
  final String name;
  const MixToken(this.name);

  /// Returns a reference value for Mix utilities.
  T call() {
    return getReferenceValue(this);
  }

  /// Resolves this token to a concrete value.
  T resolve(BuildContext context) {
    return MixScope.tokenOf(this, context);
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    if (runtimeType != other.runtimeType) return false;

    return other is MixToken && other.name == name;
  }

  @override
  String toString() => 'MixToken<$T>($name)';

  @override
  int get hashCode => Object.hash(name, T);
}
