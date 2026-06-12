import 'package:flutter/material.dart';

import '../mix_theme.dart';
import 'token_refs.dart';

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

/// A token that computes its value from [BuildContext].
///
/// Unlike scope-provided tokens, a [ContextToken] does not require a
/// [MixScope] entry: [resolver] runs at resolution time against the
/// consuming widget's context. Providing a value for this token in a
/// [MixScope] overrides the resolver, making the resolver a
/// context-derived default.
///
/// Values flow through the standard token reference pipeline, so they keep
/// exact fluent-chain ordering like any other value:
///
/// ```dart
/// final primary = ContextToken<Color>(
///   (context) => Theme.of(context).colorScheme.primary,
/// );
///
/// BoxStyler().color(primary()).color(Colors.red); // red wins
/// BoxStyler().color(Colors.red).color(primary()); // primary wins
/// ```
///
/// Equality is based on [T] and resolver identity. Reusing the same top-level
/// or static function resolver creates matching tokens, while same-looking
/// inline closures create distinct tokens. Prefer declaring context tokens as
/// top-level or static finals unless you intentionally want a new token.
///
/// Calling a token, such as `primary()`, uses the same token-reference support
/// as other [MixToken]s. If [T] is not one of the supported reference types,
/// use [resolve] with a [BuildContext] instead.
class ContextToken<T> extends MixToken<T> {
  /// Computes the token's value from the given context.
  final T Function(BuildContext context) resolver;

  const ContextToken(this.resolver) : super('context');

  @override
  T resolve(BuildContext context) {
    final scope = MixScope.maybeOf(context, 'tokens');
    if (scope != null && (scope.tokens?.containsKey(this) ?? false)) {
      return scope.getToken(this, context);
    }

    return resolver(context);
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContextToken<T> && other.resolver == resolver;
  }

  @override
  String toString() => 'ContextToken<$T>(${resolver.toString()})';

  @override
  int get hashCode => Object.hash(T, resolver);
}
