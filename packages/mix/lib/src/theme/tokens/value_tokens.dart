/// Consolidated design tokens for various value types in the Mix theme.
library;
import 'package:flutter/material.dart';

import '../../core/breakpoint.dart';
import '../../core/prop.dart';
import '../../core/prop_refs.dart';
import 'token_refs.dart';
import 'mix_token.dart';

/// Design token for [Color] values.
class ColorToken extends MixToken<Color> {
  const ColorToken(super.name);

  @override
  ColorRef call() => ColorRef(Prop.token(this));
}

/// Design token for [Radius] values.
class RadiusToken extends MixToken<Radius> {
  const RadiusToken(super.name);

  @override
  RadiusRef call() => RadiusRef(Prop.token(this));
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
  const BreakpointToken(super.name);

  @override
  BreakpointRef call() => BreakpointRef(Prop.token(this));
}

/// Design token for [TextStyle] values.
class TextStyleToken extends MixToken<TextStyle> {
  const TextStyleToken(super.name);

  @override
  TextStyleRef call() => TextStyleRef(Prop.token(this));
}

/// Design token for [BoxShadow] values.
class BoxShadowToken extends MixToken<BoxShadow> {
  const BoxShadowToken(super.name);

  @override
  BoxShadowRef call() => BoxShadowRef(Prop.token(this));
}

/// Design token for [Shadow] values.
class ShadowToken extends MixToken<Shadow> {
  const ShadowToken(super.name);

  @override
  ShadowRef call() => ShadowRef(Prop.token(this));
}

/// Design token for [BorderSide] values.
class BorderSideToken extends MixToken<BorderSide> {
  const BorderSideToken(super.name);

  @override
  BorderSideRef call() => BorderSideRef(Prop.token(this));
}

/// Design token for shadow lists.
class ShadowListToken extends MixToken<List<Shadow>> {
  const ShadowListToken(super.name);

  @override
  ShadowListRef call() => ShadowListRef(Prop.token(this));
}

/// Design token for box shadow lists.
class BoxShadowListToken extends MixToken<List<BoxShadow>> {
  const BoxShadowListToken(super.name);

  @override
  BoxShadowListRef call() => BoxShadowListRef(Prop.token(this));
}

/// Design token for [FontWeight] values.
class FontWeightToken extends MixToken<FontWeight> {
  const FontWeightToken(super.name);

  @override
  FontWeightRef call() => FontWeightRef(Prop.token(this));
}
