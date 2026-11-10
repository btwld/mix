// The token-map algebra extracted from package:mix's `MixScope`: an
// immutable token table whose entries are either a value or a
// `T Function(C)` resolver, plus last-wins merging. The ambient lookup
// mechanism (InheritedModel in Flutter, a threaded context elsewhere) stays
// platform-side.

import 'package:meta/meta.dart';

import 'token.dart';

/// An immutable table of design-token values for context type [C].
///
/// An entry may hold the value itself or a `T Function(C)` resolver, which
/// is invoked with the context at resolution time.
@immutable
class TokenStore<C> {
  final Map<MixToken<C, Object?>, Object>? tokens;

  const TokenStore(this.tokens);

  /// Whether [token] has an entry in this store.
  bool contains(MixToken<C, Object?> token) =>
      tokens?.containsKey(token) ?? false;

  /// Resolves [token] to its concrete value.
  ///
  /// Throws [StateError] when the token has no entry or the entry's type
  /// does not match [T].
  T getToken<T>(MixToken<C, T> token, C context) =>
      resolve(tokens, token, context);

  /// Resolves [token] against a raw [tokens] table, without a [TokenStore].
  ///
  /// The lookup behind [getToken], for callers that hold the table but cannot
  /// hold a store (for example a `const`-constructed scope widget).
  ///
  /// Throws [StateError] when the token has no entry or the entry's type
  /// does not match [T].
  static T resolve<C, T>(
    Map<MixToken<C, Object?>, Object>? tokens,
    MixToken<C, T> token,
    C context,
  ) {
    final value = tokens?[token];
    if (value == null) {
      throw StateError('Token "${token.name}" not found in scope');
    }

    if (value is T Function(C)) {
      return value(context);
    }

    if (value is T) {
      // Not redundant: `T`'s bound is `Object?`, so `Object` does not promote
      // to `T` and the analyzer rejects a bare `return value`.
      return value as T;
    }

    throw StateError(
      'Token "${token.name}" resolved to ${value.runtimeType}, expected $T',
    );
  }

  /// Returns a new store combining this one with [other]; entries in
  /// [other] take precedence.
  TokenStore<C> merge(TokenStore<C>? other) {
    if (other == null) return this;

    final merged = tokens != null || other.tokens != null
        ? <MixToken<C, Object?>, Object>{...?tokens, ...?other.tokens}
        : null;

    return TokenStore(merged);
  }
}
