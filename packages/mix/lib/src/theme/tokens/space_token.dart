import 'package:flutter/widgets.dart';

import '../mix/mix_theme.dart';
import 'mix_token.dart';

//TODO: Explore 'type extension' and then check if we can use it here
typedef SpaceRef = double;

extension SpaceRefExt on SpaceRef {
  double resolve(BuildContext context) {
    final token = MixTheme.of(context).spaces.findByRef(this);

    assert(
      token != null,
      'SpaceRef $this is not defined in the theme',
    );

    return token?.resolve(context) ?? 0.0;
  }
}

/// A class representing a space token, which extends `MixToken` class
/// and uses the `SizeTokenMixin` mixin.
///
/// A space token defines a value for controlling the
/// size of UI elements.
///
@immutable
class SpaceToken extends MixToken<double> with MixTokenCallable<double> {
  /// A constant constructor that accepts a `String` argument named [name].
  /// Name needs to be unique per token
  ///
  /// [name] is used to initialize the superclass `MixToken`.
  const SpaceToken(super.name);

  @override
  double call() => hashCode * -1.0;

  @override
  double resolve(BuildContext context) {
    final themeValue = MixTheme.of(context).spaces[this];
    assert(
      themeValue != null,
      'SpaceToken $name is not defined in the theme',
    );

    return themeValue!;
  }
}
