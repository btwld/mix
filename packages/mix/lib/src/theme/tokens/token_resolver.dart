import 'package:flutter/widgets.dart';

import 'breakpoints_token.dart';
import 'color_token.dart';
import 'mix_token.dart';
import 'radius_token.dart';
import 'space_token.dart';
import 'text_style_token.dart';

class MixTokenResolver {
  final BuildContext _context;

  const MixTokenResolver(this._context);

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
