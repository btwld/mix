import 'package:flutter/material.dart';

import '../../core/prop_refs.dart';
import '../mix_theme.dart';

typedef ValueBuilder<T> = T Function(BuildContext context);

/// Associates a [MixToken] with its resolver function.
///
/// This class binds a token to a function that can resolve its value
/// based on the current build context.
class TokenDefinition<T> {
  final MixToken<T> token;
  final ValueBuilder<T> resolver;

  const TokenDefinition(this.token, this.resolver);
}

/// A token definition that automatically switches between light and dark values
/// based on the current theme brightness.
class BrightnessTokenDefinition<T> extends TokenDefinition<T> {
  /// The resolver for light theme values
  final ValueBuilder<T> lightResolver;

  /// The resolver for dark theme values
  final ValueBuilder<T> darkResolver;

  /// Creates a brightness-aware token definition that automatically switches
  /// between light and dark resolvers based on theme brightness.
  BrightnessTokenDefinition(
    MixToken<T> token, {
    required this.lightResolver,
    required this.darkResolver,
  }) : super(token, (context) {
         final brightness = Theme.of(context).brightness;

         return brightness == Brightness.light
             ? lightResolver(context)
             : darkResolver(context);
       });

  /// Creates a brightness-aware token definition with static values.
  BrightnessTokenDefinition.values(
    MixToken<T> token, {
    required T lightValue,
    required T darkValue,
  }) : this(
         token,
         lightResolver: (_) => lightValue,
         darkResolver: (_) => darkValue,
       );
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

  /// Creates a token definition with a static value.
  TokenDefinition<T> defineValue(T value) {
    return TokenDefinition(this, (_) => value);
  }

  /// Creates a token definition with a context-dependent resolver.
  TokenDefinition<T> defineBuilder(ValueBuilder<T> resolver) {
    return TokenDefinition(this, resolver);
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

/// Extension methods for MixToken to easily create brightness-aware tokens.
extension MixTokenBrightnessExt<T> on MixToken<T> {
  /// Creates a token definition that automatically adapts between light and dark values.
  ///
  /// Example:
  /// ```dart
  /// final primaryColor = MixToken<Color>('primary');
  /// final definition = primaryColor.defineAdaptive(
  ///   light: Colors.blue,
  ///   dark: Colors.lightBlue,
  /// );
  /// ```
  TokenDefinition<T> defineAdaptive({required T light, required T dark}) {
    return BrightnessTokenDefinition.values(
      this,
      lightValue: light,
      darkValue: dark,
    );
  }

  /// Creates a token definition that automatically adapts between light and dark builders.
  ///
  /// Example:
  /// ```dart
  /// final primaryColor = MixToken<Color>('primary');
  /// final definition = primaryColor.defineAdaptiveBuilder(
  ///   light: (context) => Theme.of(context).primaryColor,
  ///   dark: (context) => Theme.of(context).primaryColorDark,
  /// );
  /// ```
  TokenDefinition<T> defineAdaptiveBuilder({
    required ValueBuilder<T> light,
    required ValueBuilder<T> dark,
  }) {
    return BrightnessTokenDefinition(
      this,
      lightResolver: light,
      darkResolver: dark,
    );
  }
}
