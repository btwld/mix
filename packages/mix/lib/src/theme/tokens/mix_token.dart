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
/// Declare context tokens as top-level or static finals: equality is based
/// on resolver identity, so a closure created inline produces a new token
/// on every rebuild.
class ContextToken<T> extends MixToken<T> {
  /// Computes the token's value from the given context.
  final T Function(BuildContext context) resolver;

  const ContextToken(this.resolver, [String name = 'context']) : super(name);

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

    return other is ContextToken<T> &&
        other.resolver == resolver &&
        other.name == name;
  }

  @override
  String toString() => 'ContextToken<$T>($name)';

  @override
  int get hashCode => Object.hash(name, T, resolver);
}
