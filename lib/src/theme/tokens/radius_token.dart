import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'mix_token.dart';

const _small = RadiusToken('mix.radii.small', Radius.circular(4));
const _medium = RadiusToken('mix.radii.medium', Radius.circular(8));
const _large = RadiusToken('mix.radii.large', Radius.circular(16));

class RadiusToken extends MixToken<Radius> {
  static const small = _small;
  static const medium = _medium;
  static const large = _large;

  const RadiusToken(super.name, super.value);

  const RadiusToken.name(String name) : this(name, Radius.zero);

  factory RadiusToken.resolvable(String name, TokenResolver<Radius> resolver) {
    return RadiusToken(name, RadiusRef(name, resolver));
  }
}

@immutable
class RadiusRef extends Radius with ValueRef<Radius> {
  @override
  final String tokenName;

  @override
  final TokenResolver<Radius> resolve;

  const RadiusRef(this.tokenName, this.resolve) : super.circular(0);

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RadiusRef && other.tokenName == tokenName;
  }

  @override
  int get hashCode => tokenName.hashCode;
}

// // Helper class to wrap functions that can return
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

  T small() => call(RadiusToken.small());

  T medium() => call(RadiusToken.medium());

  T large() => call(RadiusToken.large());

  T call(Radius value) => _fn(value);
}
