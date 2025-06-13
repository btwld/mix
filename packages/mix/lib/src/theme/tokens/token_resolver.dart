import 'package:collection/collection.dart';
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

  /// Type-safe token resolution using MixToken<T> objects as keys.
  ///
  /// This is the primary method for resolving tokens in the unified system.
  /// Uses the MixToken object directly as a map key for type safety.
  ///
  /// Throws [StateError] if the token is not found or resolves to an
  /// unexpected type.
  T resolveToken<T>(MixToken<T> token) {
    final theme = MixTheme.of(_context);
    
    // Check unified token storage first
    if (theme.tokens != null) {
      final resolver = theme.tokens![token];
      if (resolver != null) {
        final resolved = resolver.resolve(_context);
        if (resolved is T) {
          return resolved;
        }
        throw StateError(
          'Token "${token.name}" resolved to ${resolved.runtimeType}, expected $T'
        );
      }
    }
    
    throw StateError('Token "${token.name}" not found in theme');
  }
  
  /// Legacy string-based resolution for backwards compatibility.
  /// 
  /// @deprecated Use resolveToken(MixToken<T>) instead
  @Deprecated('Use resolveToken(MixToken<T>) instead')
  T resolveTokenByName<T>(String tokenName) {
    final theme = MixTheme.of(_context);
    
    // Find token by name in the map - less efficient but backwards compatible
    if (theme.tokens == null) {
      throw StateError('Token "$tokenName" not found in theme');
    }
    
    final tokenEntry = theme.tokens!.entries
        .where((entry) => entry.key.name == tokenName)
        .firstOrNull;
    
    if (tokenEntry == null) {
      throw StateError('Token "$tokenName" not found in theme');
    }
    
    // Cast the token to the expected type and resolve
    final typedToken = tokenEntry.key as MixToken<T>;
    return resolveToken<T>(typedToken);
  }

  Color colorToken(MixToken<Color> token) {
    return resolveToken<Color>(token);
  }

  Color colorRef(ColorRef ref) => colorToken(ref.token);

  Radius radiiToken(MixToken<Radius> token) {
    return resolveToken<Radius>(token);
  }

  Radius radiiRef(RadiusRef ref) => radiiToken(ref.token);

  TextStyle textStyleToken(MixToken<TextStyle> token) {
    return resolveToken<TextStyle>(token);
  }

  TextStyle textStyleRef(TextStyleRef ref) => textStyleToken(ref.token);

  double spaceToken(MixToken<double> token) {
    return resolveToken<double>(token);
  }

  double spaceTokenRef(SpaceRef spaceRef) {
    return spaceRef < 0 ? spaceRef.resolve(_context) : spaceRef;
  }

  Breakpoint breakpointToken(BreakpointToken token) => token.resolve(_context);
}
