import 'package:flutter/material.dart';

import 'mix_token.dart';

@immutable
class SpaceTokenUtil {
  final xsmall = SpaceToken.xsmall();
  final small = SpaceToken.small();
  final medium = SpaceToken.medium();
  final large = SpaceToken.large();
  final xlarge = SpaceToken.xlarge();
  final xxlarge = SpaceToken.xxlarge();
  SpaceTokenUtil();
}

typedef SpaceTokenRef = double;

/// A class representing a space token, which extends `MixToken` class
/// and uses the `SizeTokenMixin` mixin.
///
/// A space token defines a value for controlling the
/// size of UI elements.
@immutable
class SpaceToken extends MixToken<SpaceTokenRef> with TokenValueReference {
  static const xsmall = SpaceToken('--mix-space-xsmall');
  static const small = SpaceToken('--mix-space-small');
  static const medium = SpaceToken('--mix-space-medium');
  static const large = SpaceToken('--mix-space-large');
  static const xlarge = SpaceToken('--mix-space-xlarge');
  static const xxlarge = SpaceToken('--mix-space-xxlarge');

  /// A constant constructor that accepts a `String` argument named [name].
  /// Name needs to be unique per token
  ///
  /// [name] is used to initialize the superclass `MixToken`.
  const SpaceToken(super.name);

  @override
  double call() => hashCode * -1.0;
}

// Helper class to wrap functions that can return
// Space tokens in their methods
@immutable
class UtilityWithSpaceTokens<T> {
  final T Function(double value) _fn;

  const UtilityWithSpaceTokens(T Function(double value) fn) : _fn = fn;

  T get xsmall => call(SpaceToken.xsmall());

  T get small => call(SpaceToken.small());

  T get medium => call(SpaceToken.medium());

  T get large => call(SpaceToken.large());

  T get xlarge => call(SpaceToken.xlarge());

  T get xxlarge => call(SpaceToken.xxlarge());

  T call(double value) => _fn(value);
}
