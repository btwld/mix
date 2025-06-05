import 'package:flutter/widgets.dart';

import '../mix/mix_theme.dart';
import 'mix_token.dart';

const _breakpointXsmall = BreakpointToken('mix.breakpoint.xsmall');
const _breakpointSmall = BreakpointToken('mix.breakpoint.small');
const _breakpointMedium = BreakpointToken('mix.breakpoint.medium');
const _breakpointLarge = BreakpointToken('mix.breakpoint.large');

/// Represents a breakpoint with minimum and maximum widths.
///
/// A breakpoint is considered a match when the given size falls within its
/// minimum and maximum width range.
class Breakpoint {
  /// The minimum width for this breakpoint.
  final double minWidth;

  /// The maximum width for this breakpoint.
  final double maxWidth;

  /// Creates a new breakpoint with the given [minWidth] and [maxWidth].
  ///
  /// Default values are 0 for [minWidth] and [double.infinity] for [maxWidth].
  const Breakpoint({this.minWidth = 0, this.maxWidth = double.infinity});

  /// Checks whether the given [size] matches this breakpoint.
  ///
  /// Returns true if the width of the [size] is between [minWidth] and
  /// [maxWidth], inclusive.
  bool matches(Size size) {
    return size.width >= minWidth && size.width <= maxWidth;
  }

  @override
  String toString() => 'breakpoint_${minWidth}_$maxWidth)';
}

/// A token representing a breakpoint.
///
/// Use the predefined constants for common breakpoints:
/// - [BreakpointToken.xsmall]
/// - [BreakpointToken.small]
/// - [BreakpointToken.medium]
/// - [BreakpointToken.large]
@immutable
class BreakpointToken extends MixToken<Breakpoint> with MixTokenCallable<Breakpoint> {
  /// The extra-small breakpoint token.
  static const xsmall = _breakpointXsmall;

  /// The small breakpoint token.
  static const small = _breakpointSmall;

  /// The medium breakpoint token.
  static const medium = _breakpointMedium;

  /// The large breakpoint token.
  static const large = _breakpointLarge;

  /// Creates a new breakpoint token with the given [name].
  const BreakpointToken(super.name);

  @override
  Breakpoint call() => BreakpointRef(this);

  @override
  Breakpoint resolve(BuildContext context) {
    final themeValue = MixTheme.of(context).breakpoints[this];
    assert(
      themeValue != null,
      'BreakpointToken $name is not defined in the theme',
    );

    return themeValue is BreakpointResolver
        ? themeValue.resolve(context)
        : (themeValue ?? const Breakpoint());
  }
}

/// {@macro mix.token.resolver}
@immutable
class BreakpointResolver extends Breakpoint with WithTokenResolver<Breakpoint> {
  @override
  final BuildContextResolver<Breakpoint> resolve;

  /// {@macro mix.token.resolver}
  const BreakpointResolver(this.resolve);
}

/// A reference to a breakpoint token.
@immutable
class BreakpointRef extends Breakpoint with TokenRef<BreakpointToken> {
  @override
  final BreakpointToken token;

  /// Creates a new breakpoint reference with the given [token].
  const BreakpointRef(this.token);
}

class BreakpointTokenUtil {
  final xsmall = BreakpointToken.xsmall;
  final small = BreakpointToken.small;
  final medium = BreakpointToken.medium;
  final large = BreakpointToken.large;
  const BreakpointTokenUtil();
}
