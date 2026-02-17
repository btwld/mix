import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'tw_config.dart';

/// Token used by [TwScope] for the resolved Tailwind default text style.
const twPreflightTextStyleToken = TextStyleToken('tw.preflight.text');

/// Root scope that aligns Tailwind defaults with Mix and Flutter text rendering.
///
/// Combines:
/// - [TwConfigProvider] for utility scale/config resolution
/// - [MixScope] for tokenized default typography
/// - [TextScope] to apply default text style to descendants
///
/// This avoids relying on `ThemeData.textTheme` for parity.
class TwScope extends StatelessWidget {
  const TwScope({
    super.key,
    required this.child,
    this.config,
    this.tokens,
    this.orderOfModifiers,
    this.preflightTextToken = twPreflightTextStyleToken,
  });

  /// Child widget subtree.
  final Widget child;

  /// Tailwind utility configuration.
  final TwConfig? config;

  /// Optional Mix tokens to merge into the scope.
  final Map<MixToken, Object>? tokens;

  /// Optional Mix modifier ordering to apply in this scope.
  final List<Type>? orderOfModifiers;

  /// Token key used to expose the preflight text style in [MixScope].
  final TextStyleToken preflightTextToken;

  @override
  Widget build(BuildContext context) {
    final resolvedConfig = config ?? TwConfig.standard();
    final mergedTokens = <MixToken, Object>{
      preflightTextToken: resolvedConfig.textDefaults.toTextStyle(),
      ...?tokens,
    };

    return TwConfigProvider(
      config: resolvedConfig,
      child: MixScope(
        tokens: mergedTokens,
        orderOfModifiers: orderOfModifiers,
        child: TextScope(
          text: TextStyler().style(preflightTextToken.mix()),
          child: child,
        ),
      ),
    );
  }
}
