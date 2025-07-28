// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// A Mix-compatible wrapper for Color values that provides a fluent API
/// for color transformations and token resolution.
///
/// ColorMix allows you to work with colors in the Mix framework while
/// maintaining support for tokens, directives, and merging operations.
class ColorMix extends Mix<Color> {
  final Prop<Color> value;
  ColorMix(Color value) : this.raw(Prop(value));

  const ColorMix.raw(this.value);

  /// Creates a ColorMix from a color token.
  factory ColorMix.token(MixToken<Color> token) {
    return ColorMix.raw(Prop.token(token));
  }

  /// Creates a ColorMix with a color directive applied.
  factory ColorMix.directive(MixDirective<Color> directive) {
    return ColorMix.raw(Prop.directives([directive]));
  }

  /// Creates a ColorMix with an opacity directive.
  factory ColorMix.withOpacity(double opacity) {
    return ColorMix.raw(Prop.directives([OpacityColorDirective(opacity)]));
  }

  /// Creates a ColorMix with an alpha directive.
  factory ColorMix.withAlpha(int alpha) {
    return ColorMix.raw(Prop.directives([AlphaColorDirective(alpha)]));
  }

  /// Creates a ColorMix with a darken directive.
  factory ColorMix.darken(int amount) {
    return ColorMix.raw(Prop.directives([DarkenColorDirective(amount)]));
  }

  /// Creates a ColorMix with a lighten directive.
  factory ColorMix.lighten(int amount) {
    return ColorMix.raw(Prop.directives([LightenColorDirective(amount)]));
  }

  factory ColorMix.saturate(int amount) {
    return ColorMix.raw(Prop.directives([SaturateColorDirective(amount)]));
  }

  factory ColorMix.desaturate(int amount) {
    return ColorMix.raw(Prop.directives([DesaturateColorDirective(amount)]));
  }

  factory ColorMix.tint(int amount) {
    return ColorMix.raw(Prop.directives([TintColorDirective(amount)]));
  }

  factory ColorMix.shade(int amount) {
    return ColorMix.raw(Prop.directives([ShadeColorDirective(amount)]));
  }

  /// Merges this ColorMix with a color token.
  ColorMix token(MixToken<Color> token) {
    return merge(ColorMix.token(token));
  }

  /// Merges this ColorMix with a color directive.
  ColorMix directive(MixDirective<Color> directive) {
    return merge(ColorMix.directive(directive));
  }

  ColorMix withOpacity(double opacity) {
    return merge(ColorMix.withOpacity(opacity));
  }

  ColorMix withAlpha(int alpha) {
    return merge(ColorMix.withAlpha(alpha));
  }

  ColorMix darken(int amount) {
    return merge(ColorMix.darken(amount));
  }

  ColorMix lighten(int amount) {
    return merge(ColorMix.lighten(amount));
  }

  ColorMix saturate(int amount) {
    return merge(ColorMix.saturate(amount));
  }

  ColorMix desaturate(int amount) {
    return merge(ColorMix.desaturate(amount));
  }

  ColorMix tint(int amount) {
    return merge(ColorMix.tint(amount));
  }

  ColorMix shade(int amount) {
    return merge(ColorMix.shade(amount));
  }

  @override
  Color resolve(BuildContext context) {
    return value.resolve(context);
  }

  @override
  ColorMix merge(ColorMix? other) {
    if (other == null) return this;

    return ColorMix.raw(value.merge(other.value));
  }

  @override
  List<Object> get props => [value];
}
