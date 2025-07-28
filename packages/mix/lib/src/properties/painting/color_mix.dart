import 'package:flutter/widgets.dart';

import '../../core/directive.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import '../../theme/tokens/mix_token.dart';

class ColorMix extends Mix<Color> {
  final Prop<Color> value;
  ColorMix(Color value) : this.raw(Prop(value));

  const ColorMix.raw(this.value);

  factory ColorMix.token(MixToken<Color> token) {
    return ColorMix.raw(Prop.token(token));
  }

  factory ColorMix.directive(MixDirective<Color> directive) {
    return ColorMix.raw(Prop.directives([directive]));
  }

  factory ColorMix.withOpacity(double opacity) {
    return ColorMix.raw(Prop.directives([OpacityColorDirective(opacity)]));
  }

  factory ColorMix.withAlpha(int alpha) {
    return ColorMix.raw(Prop.directives([AlphaColorDirective(alpha)]));
  }

  factory ColorMix.darken(int amount) {
    return ColorMix.raw(Prop.directives([DarkenColorDirective(amount)]));
  }

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

  ColorMix token(MixToken<Color> token) {
    return merge(ColorMix.token(token));
  }

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
