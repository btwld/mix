/// Consolidated design tokens for various value types in the Mix theme.
library;

import 'package:flutter/material.dart';

import '../../core/breakpoint.dart';
import '../../core/prop.dart';
import '../../core/prop_refs.dart';
import 'mix_token.dart';
import 'token_refs.dart';

/// Design token for [Color] values.
class ColorToken extends MixToken<Color> {
  const ColorToken(super.name);

  @override
  ColorRef call() => .new(Prop.token(this));
}

/// Design token for [Radius] values.
class RadiusToken extends MixToken<Radius> {
  const RadiusToken(super.name);

  @override
  RadiusRef call() => .new(Prop.token(this));
}

/// Design token for spacing values.
class SpaceToken extends MixToken<double> {
  const SpaceToken(super.name);

  @override
  double call() => DoubleRef.token(this);
}

/// Design token for general [double] values.
class DoubleToken extends MixToken<double> {
  const DoubleToken(super.name);

  @override
  double call() => DoubleRef.token(this);
}

/// Design token for [Breakpoint] values.
class BreakpointToken extends MixToken<Breakpoint> {
  static const mobile = BreakpointToken('mix.breakpoint.mobile');
  static const tablet = BreakpointToken('mix.breakpoint.tablet');
  static const desktop = BreakpointToken('mix.breakpoint.desktop');

  const BreakpointToken(super.name);

  @override
  BreakpointRef call() => .new(this);

  @override
  Breakpoint resolve(BuildContext context) {
    try {
      return super.resolve(context);
    } catch (e) {
      switch (this) {
        case mobile:
          return Breakpoint.maxWidth(767);
        case tablet:
          return Breakpoint.widthRange(768, 1023);
        case desktop:
          return Breakpoint.minWidth(1024);
        default:
          rethrow;
      }
    }
  }
}

/// Design token for [TextStyle] values.
class TextStyleToken extends MixToken<TextStyle> {
  const TextStyleToken(super.name);

  /// Returns a Mix framework compatible reference for use with Mix styling utilities.
  TextStyleMixRef mix() => .new(Prop.token(this));

  @override
  TextStyleRef call() => .new(Prop.token(this));
}

/// Design token for [BorderSide] values.
class BorderSideToken extends MixToken<BorderSide> {
  const BorderSideToken(super.name);

  @override
  BorderSideRef call() => .new(Prop.token(this));
}

/// Design token for shadow lists.
class ShadowToken extends MixToken<List<Shadow>> {
  const ShadowToken(super.name);

  /// Returns a Mix framework compatible reference for use with Mix styling utilities.
  ShadowListMixRef mix() => .new(Prop.token(this));

  @override
  ShadowListRef call() => .new(Prop.token(this));
}

/// Design token for box shadow lists.
class BoxShadowToken extends MixToken<List<BoxShadow>> {
  const BoxShadowToken(super.name);

  /// Returns a Mix framework compatible reference for use with Mix styling utilities.
  BoxShadowListMixRef mix() => .new(Prop.token(this));

  @override
  BoxShadowListRef call() => .new(Prop.token(this));
}

/// Design token for [FontWeight] values.
class FontWeightToken extends MixToken<FontWeight> {
  const FontWeightToken(super.name);

  @override
  FontWeightRef call() => .new(Prop.token(this));
}

/// Design token for [Duration] values.
class DurationToken extends MixToken<Duration> {
  const DurationToken(super.name);

  @override
  DurationRef call() => .new(Prop.token(this));
}
