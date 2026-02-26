import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../ast/schema_values.dart';

/// Interface for resolving token references to concrete values.
abstract class SchemaTokenResolver {
  /// Resolve a token reference to a concrete value.
  /// Returns null if the token is not found (caller emits diagnostic).
  T? resolve<T>(TokenRef ref, BuildContext context);
}

/// Default implementation: delegates to MixScope token resolution.
final class MixScopeTokenResolver implements SchemaTokenResolver {
  const MixScopeTokenResolver();

  @override
  T? resolve<T>(TokenRef ref, BuildContext context) {
    final mixToken = _createMixToken<T>(ref);
    if (mixToken == null) return null;

    try {
      return mixToken.resolve(context);
    } catch (_) {
      return null; // token not found — caller emits diagnostic
    }
  }

  MixToken<T>? _createMixToken<T>(TokenRef ref) {
    return switch (ref.type) {
      'color' => ColorToken(ref.tokenName) as MixToken<T>,
      'space' => SpaceToken(ref.tokenName) as MixToken<T>,
      'radius' => RadiusToken(ref.tokenName) as MixToken<T>,
      'textStyle' => TextStyleToken(ref.tokenName) as MixToken<T>,
      'borderSide' => BorderSideToken(ref.tokenName) as MixToken<T>,
      'shadow' => ShadowToken(ref.tokenName) as MixToken<T>,
      'boxShadow' => BoxShadowToken(ref.tokenName) as MixToken<T>,
      'fontWeight' => FontWeightToken(ref.tokenName) as MixToken<T>,
      'duration' => DurationToken(ref.tokenName) as MixToken<T>,
      'breakpoint' => BreakpointToken(ref.tokenName) as MixToken<T>,
      'double' => DoubleToken(ref.tokenName) as MixToken<T>,
      _ => null, // unknown type — caller emits diagnostic
    };
  }
}
