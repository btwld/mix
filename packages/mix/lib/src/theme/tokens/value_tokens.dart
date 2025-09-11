// ABOUTME: Consolidated design tokens for various value types in the Mix theme.
// ABOUTME: Contains color, radius, space, breakpoint, and text style token definitions.
import 'package:flutter/material.dart';

import '../../core/breakpoint.dart';
import '../../core/prop.dart';
import '../../core/prop_refs.dart';
import 'token_refs.dart';
import 'mix_token.dart';

/// A token representing a color value in the Mix theme.
class ColorToken extends MixToken<Color> {
  const ColorToken(super.name);

  @override
  ColorRef call() => ColorRef(Prop.token(this));
}

/// A token representing a radius value in the Mix theme.
class RadiusToken extends MixToken<Radius> {
  const RadiusToken(super.name);

  @override
  RadiusRef call() => RadiusRef(Prop.token(this));
}

/// A token representing a space (double) value in the Mix theme.
class SpaceToken extends MixToken<double> {
  const SpaceToken(super.name);

  @override
  double call() => SpaceRef.token(this);
}

/// A token representing a breakpoint value in the Mix theme.
class BreakpointToken extends MixToken<Breakpoint> {
  const BreakpointToken(super.name);

  @override
  BreakpointRef call() => BreakpointRef(Prop.token(this));
}

/// A token representing a text style value in the Mix theme.
class TextStyleToken extends MixToken<TextStyle> {
  const TextStyleToken(super.name);

  @override
  TextStyleRef call() => TextStyleRef(Prop.token(this));
}

/// A token representing a box shadow value in the Mix theme.
class BoxShadowToken extends MixToken<BoxShadow> {
  const BoxShadowToken(super.name);

  @override
  BoxShadowRef call() => BoxShadowRef(Prop.token(this));
}

/// A token representing a list of shadow values in the Mix theme.
class ShadowToken extends MixToken<Shadow> {
  const ShadowToken(super.name);

  @override
  ShadowRef call() => ShadowRef(Prop.token(this));
}

/// A token representing a border side value in the Mix theme.
class BorderSideToken extends MixToken<BorderSide> {
  const BorderSideToken(super.name);

  @override
  BorderSideRef call() => BorderSideRef(Prop.token(this));
}
