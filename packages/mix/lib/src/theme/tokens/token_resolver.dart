import 'package:flutter/widgets.dart';

import '../mix/mix_theme.dart';
import 'breakpoints_token.dart';
import 'color_token.dart';
import 'mix_token.dart';
import 'radius_token.dart';
import 'space_token.dart';
import 'text_style_token.dart';

class MixTokenResolver {
  final BuildContext _context;

  const MixTokenResolver(this._context);

  /// Fallback resolution for legacy token storage during migration.
  T _fallbackResolve<T>(String tokenName) {
    throw StateError(
        'Token "$tokenName" not found in unified tokens map and legacy fallback not implemented yet');
  }

  /// Resolves a token by name to the specified type.
  ///
  /// First checks the unified token storage, then falls back to legacy
  /// resolution for backwards compatibility.
  ///
  /// Throws [StateError] if the token is not found or resolves to an
  /// unexpected type.
  T resolveToken<T>(String tokenName) {
    final theme = MixTheme.of(_context);

    // Check unified token storage first
    if (theme.tokens != null) {
      final resolver = theme.tokens![tokenName];
      if (resolver != null) {
        final resolved = resolver.resolve(_context);
        if (resolved is T) {
          return resolved;
        }
        throw StateError(
            'Token "$tokenName" resolved to ${resolved.runtimeType}, expected $T');
      }
    }

    // Fallback to legacy resolution for backwards compatibility
    return _fallbackResolve(tokenName);
  }

  Color colorToken(MixToken<Color> token) {
    if (token is MixTokenCallable<Color>) {
      return token.resolve(_context);
    }
    throw StateError('Token does not implement MixTokenCallable');
  }

  Color colorRef(ColorRef ref) => colorToken(ref.token);

  Radius radiiToken(MixToken<Radius> token) {
    if (token is MixTokenCallable<Radius>) {
      return token.resolve(_context);
    }
    throw StateError('Token does not implement MixTokenCallable');
  }

  Radius radiiRef(RadiusRef ref) => radiiToken(ref.token);

  TextStyle textStyleToken(MixToken<TextStyle> token) {
    if (token is MixTokenCallable<TextStyle>) {
      return token.resolve(_context);
    }
    throw StateError('Token does not implement MixTokenCallable');
  }

  TextStyle textStyleRef(TextStyleRef ref) => textStyleToken(ref.token);

  double spaceToken(MixToken<double> token) {
    if (token is MixTokenCallable<double>) {
      return token.resolve(_context);
    }
    throw StateError('Token does not implement MixTokenCallable');
  }

  double spaceTokenRef(SpaceRef spaceRef) {
    return spaceRef < 0 ? spaceRef.resolve(_context) : spaceRef;
  }

  Breakpoint breakpointToken(BreakpointToken token) => token.resolve(_context);
}
