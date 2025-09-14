/// Consolidated design tokens for various value types in the Mix theme.
library;
import 'package:flutter/material.dart';

import '../../core/breakpoint.dart';
import '../../core/prop.dart';
import '../../core/prop_refs.dart';
import 'mix_token.dart';
import 'token_refs.dart';

/// A token that represents a [Color] value.
///
/// - Call operator returns a [ColorRef] reference suitable for Mix utilities.
/// - Use `resolve(context)` to obtain a concrete [Color] at runtime.
class ColorToken extends MixToken<Color> {
  const ColorToken(super.name);

  @override
  ColorRef call() => ColorRef(Prop.token(this));
}

/// A token that represents a [Radius] value.
///
/// - Call operator returns a [RadiusRef] reference suitable for Mix utilities.
/// - Use `resolve(context)` to obtain a concrete [Radius] at runtime.
class RadiusToken extends MixToken<Radius> {
  const RadiusToken(super.name);

  @override
  RadiusRef call() => RadiusRef(Prop.token(this));
}

/// A token that represents spacing values as [double].
///
/// Prefer [SpaceToken] for spacing and layout semantics instead of
/// [DoubleToken].
class SpaceToken extends MixToken<double> {
  const SpaceToken(super.name);

  @override
  double call() => DoubleRef.token(this);
}

/// A token that represents general numeric [double] values.
///
/// Use for values that are not specifically spacing-related. For spacing and
/// layout semantics, prefer [SpaceToken].
class DoubleToken extends MixToken<double> {
  const DoubleToken(super.name);

  @override
  double call() => DoubleRef.token(this);
}

/// A token that represents responsive [Breakpoint] values.
///
/// Used to drive responsive behavior across the UI.
class BreakpointToken extends MixToken<Breakpoint> {
  const BreakpointToken(super.name);

  @override
  BreakpointRef call() => BreakpointRef(Prop.token(this));
}

/// A token that represents a [TextStyle] value.
///
/// - Call operator returns a [TextStyleRef] reference suitable for Mix
///   typography utilities.
/// - Use `resolve(context)` to obtain a concrete [TextStyle] at runtime.
class TextStyleToken extends MixToken<TextStyle> {
  const TextStyleToken(super.name);

  /// Returns a Mix framework compatible reference for use with Mix styling utilities.
  TextStyleMixRef mix() => TextStyleMixRef(Prop.token(this));

  @override
  TextStyleRef call() => TextStyleRef(Prop.token(this));
}


/// Design token for [BorderSide] values.
class BorderSideToken extends MixToken<BorderSide> {
  const BorderSideToken(super.name);

  @override
  BorderSideRef call() => BorderSideRef(Prop.token(this));
}

/// A token that represents a list of text/paint [Shadow] values.
///
/// Shadows are list-based in Mix for predictable merging behavior. Use this
/// token when the target API expects `List<Shadow>`.
class ShadowToken extends MixToken<List<Shadow>> {
  const ShadowToken(super.name);

  /// Returns a Mix framework compatible reference for use with Mix styling utilities.
  ShadowListMixRef mix() => ShadowListMixRef(Prop.token(this));

  @override
  ShadowListRef call() => ShadowListRef(Prop.token(this));
}

/// A token that represents a list of [BoxShadow] values.
///
/// Box shadows are list-based in Mix for predictable merging behavior. Use this
/// token when the target API expects `List<BoxShadow>`.
class BoxShadowToken extends MixToken<List<BoxShadow>> {
  const BoxShadowToken(super.name);

  /// Returns a Mix framework compatible reference for use with Mix styling utilities.
  BoxShadowListMixRef mix() => BoxShadowListMixRef(Prop.token(this));

  @override
  BoxShadowListRef call() => BoxShadowListRef(Prop.token(this));
}

/// A token that represents a [FontWeight] value.
///
/// Useful for typography systems where weight is controlled independently from
/// full [TextStyle] definitions.
class FontWeightToken extends MixToken<FontWeight> {
  const FontWeightToken(super.name);

  @override
  FontWeightRef call() => FontWeightRef(Prop.token(this));
}

/// A token that represents a [Duration] value.
///
/// Use for animation timings, delays, and similar time-based configuration.
class DurationToken extends MixToken<Duration> {
  const DurationToken(super.name);

  @override
  DurationRef call() => DurationRef(Prop.token(this));
}
