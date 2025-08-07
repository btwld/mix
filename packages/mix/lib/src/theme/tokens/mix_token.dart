import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../core/prop_refs.dart';

typedef ValueBuilder<T> = T Function(BuildContext context);

class TokenDefinition<T> {
  final MixToken<T> token;
  final ValueBuilder<T> resolver;

  const TokenDefinition(this.token, this.resolver);
}

/// A design token that can be resolved to a value within a Mix theme.
///
/// Tokens provide a way to reference theme values indirectly, allowing for
/// dynamic theming and consistent design system implementation.
@immutable
class MixToken<T> {
  final String name;
  const MixToken(this.name);

  T call() {
    return getReferenceValue(this);
  }

  TokenDefinition<T> defineValue(T value) {
    return TokenDefinition(this, (_) => value);
  }

  TokenDefinition<T> defineBuilder(ValueBuilder<T> resolver) {
    return TokenDefinition(this, resolver);
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
