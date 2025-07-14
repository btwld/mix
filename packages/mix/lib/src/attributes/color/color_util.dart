import 'package:flutter/material.dart';

import '../../core/mix_element.dart';
import '../../core/prop.dart';
import '../../core/utility.dart';
import '../../theme/tokens/mix_token.dart';
import 'color_extensions.dart';
import 'material_colors_util.dart';

/// Mixin that provides color directive methods
base mixin ColorDirectiveMixin<T extends StyleElement>
    on MixUtility<T, Prop<Color>> {
  // All directive methods return Prop.directives([MixDirective<Color>(...)])
  T withOpacity(double opacity) => builder(Prop.directives([
    MixDirective(
      (color) => color.withValues(alpha: opacity),
      debugLabel: 'opacity($opacity)',
    ),
  ]));

  T withAlpha(int alpha) => builder(Prop.directives([
    MixDirective(
      (color) => color.withAlpha(alpha),
      debugLabel: 'alpha($alpha)',
    ),
  ]));

  T darken(int amount) => builder(Prop.directives([
    MixDirective(
      (color) => color.darken(amount),
      debugLabel: 'darken($amount)',
    ),
  ]));

  T lighten(int amount) => builder(Prop.directives([
    MixDirective(
      (color) => color.lighten(amount),
      debugLabel: 'lighten($amount)',
    ),
  ]));

  T saturate(int amount) => builder(Prop.directives([
    MixDirective(
      (color) => color.saturate(amount),
      debugLabel: 'saturate($amount)',
    ),
  ]));

  T desaturate(int amount) => builder(Prop.directives([
    MixDirective(
      (color) => color.desaturate(amount),
      debugLabel: 'desaturate($amount)',
    ),
  ]));

  T tint(int amount) => builder(Prop.directives([
    MixDirective((color) => color.tint(amount), debugLabel: 'tint($amount)'),
  ]));

  T shade(int amount) => builder(Prop.directives([
    MixDirective(
      (color) => color.shade(amount),
      debugLabel: 'shade($amount)',
    ),
  ]));

  T brighten(int amount) => builder(Prop.directives([
    MixDirective(
      (color) => color.brighten(amount),
      debugLabel: 'brighten($amount)',
    ),
  ]));
}

/// Utility for predefined colors (e.g., Colors.red)
@immutable
base class FoundationColorUtility<T extends StyleElement>
    extends MixUtility<T, Prop<Color>>
    with ColorDirectiveMixin<T> {
  final Color color;
  const FoundationColorUtility(super.builder, this.color);

  T call([Color? value]) => builder(Prop.value(value ?? color));
}

/// Simplified ColorUtility following the DoubleUtility pattern
@immutable
final class ColorUtility<T extends StyleElement>
    extends MixUtility<T, Prop<Color>>
    with ColorDirectiveMixin<T>, MaterialColorsMixin<T>, BasicColorsMixin<T> {
  ColorUtility(super.builder);

  /// Main call method - accepts raw Color (like DoubleUtility)
  T call(Color value) => builder(Prop.value(value));

  /// Token support - explicit method for design tokens  
  T token(MixableToken<Color> token) => builder(Prop.token(token));

  T directive(MixDirective<Color> directive) => builder(Prop.directives([directive]));

  /// @deprecated Use [token] instead
  @Deprecated('Use token() instead. Will be removed in a future version.')
  T ref(MixableToken<Color> ref) => token(ref);
}

base mixin BasicColorsMixin<T extends StyleElement>
    on MixUtility<T, Prop<Color>> {
  late final transparent = FoundationColorUtility(
    builder,
    Colors.transparent,
  );

  late final black = FoundationColorUtility(builder, Colors.black);

  late final black87 = FoundationColorUtility(builder, Colors.black87);

  late final black54 = FoundationColorUtility(builder, Colors.black54);

  late final black45 = FoundationColorUtility(builder, Colors.black45);

  late final black38 = FoundationColorUtility(builder, Colors.black38);

  late final black26 = FoundationColorUtility(builder, Colors.black26);

  late final black12 = FoundationColorUtility(builder, Colors.black12);

  late final white = FoundationColorUtility(builder, Colors.white);

  late final white70 = FoundationColorUtility(builder, Colors.white70);

  late final white60 = FoundationColorUtility(builder, Colors.white60);

  late final white54 = FoundationColorUtility(builder, Colors.white54);

  late final white38 = FoundationColorUtility(builder, Colors.white38);

  late final white30 = FoundationColorUtility(builder, Colors.white30);

  late final white24 = FoundationColorUtility(builder, Colors.white24);

  late final white12 = FoundationColorUtility(builder, Colors.white12);

  late final white10 = FoundationColorUtility(builder, Colors.white10);
}
