import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../internal/diagnostic_properties_builder_ext.dart';
import '../mix/mix_theme.dart';
import 'mix_token.dart';

/// A token representing a radius value in the Mix theme.
///
class RadiusToken extends MixToken<Radius> with MixTokenCallable<Radius> {
  const RadiusToken(super.name);

  @override
  RadiusRef call() => RadiusRef(this);

  @override
  Radius resolve(BuildContext context) {
    final themeValue = MixTheme.of(context).radii[this];
    assert(
      themeValue != null,
      'RadiusToken $name is not defined in the theme and has no default value',
    );

    final resolvedValue =
        themeValue is RadiusResolver ? themeValue.resolve(context) : themeValue;

    return resolvedValue ?? const Radius.circular(0);
  }
}

/// {@macro mix.token.resolver}
@immutable
class RadiusResolver extends Radius with WithTokenResolver<Radius> {
  @override
  final BuildContextResolver<Radius> resolve;

  /// {@macro mix.token.resolver}
  const RadiusResolver(this.resolve) : super.circular(0);
}

@immutable
class RadiusRef extends Radius with TokenRef<RadiusToken>, Diagnosticable {
  @override
  final RadiusToken token;

  const RadiusRef(this.token) : super.circular(0);

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RadiusRef && other.token == token;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.addUsingDefault('token', token.name);
  }

  @override
  int get hashCode => token.hashCode;
}

// Helper class to wrap functions that can return
// a Radius token that resmebles the WithSpaceToken
@immutable
class UtilityWithRadiusTokens<T> {
  final T Function(Radius value) _fn;

  const UtilityWithRadiusTokens(T Function(Radius value) fn) : _fn = fn;

  factory UtilityWithRadiusTokens.shorthand(
    T Function(Radius p1, [Radius? p2, Radius? p3, Radius? p4]) fn,
  ) {
    // Need to accept a type with positional params, and convert it into a function that accepts a double and returns T
    return UtilityWithRadiusTokens((Radius value) => fn(value));
  }

  T call(Radius value) => _fn(value);
}
