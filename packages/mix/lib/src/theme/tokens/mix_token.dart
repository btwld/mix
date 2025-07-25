import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../internal/internal_extensions.dart';

/// A design token that can be resolved to a value within a Mix theme.
///
/// Tokens provide a way to reference theme values indirectly, allowing for
/// dynamic theming and consistent design system implementation.
@immutable
class MixToken<T> {
  final String name;
  const MixToken(this.name);

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

/// Mixin that provides call() and resolve() methods for MixToken implementations
mixin MixTokenCallable<T> on MixToken<T> {
  T call();
  T resolve(BuildContext context);
}

/// Mixin for classes that reference a Mix token.
mixin TokenRef<T extends MixToken> {
  /// The referenced token.
  T get token;
}

/// Mixin for classes that provide token resolution capabilities.
mixin WithTokenResolver<V> {
  /// The resolver function for converting context to values.
  BuildContextResolver<V> get resolve;
}

typedef BuildContextResolver<T> = T Function(BuildContext context);

class StyledTokens<T extends MixToken<V>, V> {
  final Map<T, V> _map;

  const StyledTokens(this._map);

  //  empty
  const StyledTokens.empty() : this(const {});

  V? operator [](T token) => _map[token];

  // Looks for the token the value set within the MixToken
  // TODO: Needs to be optimized, but this is a temporary solution
  T? findByRef(V value) {
    return _map.keys.firstWhereOrNull((token) {
      if (token is MixTokenCallable<V>) {
        return token() == value;
      }

      return false;
    });
  }

  StyledTokens<T, V> merge(StyledTokens<T, V> other) {
    final newMap = Map<T, V>.of(_map);

    newMap.addAll(other._map);

    return StyledTokens(newMap);
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StyledTokens && mapEquals(other._map, _map);
  }

  @override
  int get hashCode => _map.hashCode;
}
