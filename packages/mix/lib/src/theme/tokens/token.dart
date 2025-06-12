// ignore_for_file: avoid-object-hashcode

import 'package:flutter/material.dart';

import 'mix_token.dart';
import 'token_resolver.dart';

/// A generic token that represents a value of type [T] in the Mix theme system.
///
/// This class serves as a unified token system, replacing the need for separate
/// token classes for each type (ColorToken, SpaceToken, etc).
///
/// Example:
/// ```dart
/// const primaryColor = Token<Color>('primary');
/// const largePadding = Token<double>('large-padding');
/// ```
@immutable
class Token<T> extends MixToken<T> {
  /// Creates a token with the given [name].
  const Token(super.name);

  /// Resolves this token to its value using the given [context].
  T resolve(BuildContext context) {
    final resolver = MixTokenResolver(context);

    return resolver.resolveToken(name);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Token<T> && other.name == name);

  @override
  String toString() => 'Token<$T>($name)';

  @override
  int get hashCode => Object.hash(name, T);
}
