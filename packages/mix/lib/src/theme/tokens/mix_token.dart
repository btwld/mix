import 'package:flutter/material.dart';

import '../../core/prop_refs.dart';
import '../mix_theme.dart';

typedef ValueBuilder<T> = T Function(BuildContext context);

/// Associates a [MixToken] with its concrete value.
///
/// This class binds a token to its resolved value directly.
class TokenDefinition<T> {
  final MixToken<T> token;
  final T value;

  const TokenDefinition(this.token, this.value);

  // Internal conversion for existing resolution system
  ValueBuilder<T> get resolver =>
      (_) => value;
}

/// A design token that can be resolved to a value within a Mix theme.
///
/// Tokens provide a way to reference theme values indirectly, allowing for
/// dynamic theming and consistent design system implementation.
@immutable
class MixToken<T> {
  final String name;
  const MixToken(this.name);

  /// Resolves this token to its value using the reference system.
  T call() {
    return getReferenceValue(this);
  }

  /// Resolves this token to its value within the given context.
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
